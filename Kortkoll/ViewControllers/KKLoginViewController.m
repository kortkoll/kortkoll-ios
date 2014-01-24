//
//  KKLoginViewController.m
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-11-24.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

#import "KKLoginViewController.h"
#import "KKCardsView.h"
#import "KKLoginView.h"
#import "KKLoginTextField.h"
#import "SKBounceAnimation.h"
#import "KKAPISessionManager.h"
#import "KKSpinnerLayer.h"
#import "KKLibrary.h"
#import "LocalyticsSession.h"
#import "CAAnimation+SBExtras.h"
@import Darwin.C.tgmath;

@interface KKLoginViewController () <UITextFieldDelegate, UIViewControllerAnimatedTransitioning>
@property (nonatomic, strong) KKCardsView *cardsView;
@property (nonatomic, strong) KKLoginView *loginView;

@property (nonatomic, strong) UIPanGestureRecognizer *loginViewRecognizer;
@property (nonatomic) CGFloat loginStartTop;

@property (nonatomic) BOOL presenting;
@end

@implementation KKLoginViewController

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(_keyboardNotification:)
                                               name:UIKeyboardWillShowNotification
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(_keyboardNotification:)
                                               name:UIKeyboardWillHideNotification
                                             object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UIKeyboardWillShowNotification
                                                object:nil];
  
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UIKeyboardWillHideNotification
                                                object:nil];
}

#pragma mark - Properties

- (KKCardsView *)cardsView {
  if (!_cardsView) {
    _cardsView = [[KKCardsView alloc] initWithFrame:CGRectZero];
    [_cardsView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin)];
  }
  return _cardsView;
}

- (KKLoginView *)loginView {
  if (!_loginView) {
    _loginView = [[KKLoginView alloc] initWithFrame:CGRectZero];
    [_loginView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin];

    [_loginView setState:KKLoginViewStateDefault withButtonTitle:@"Logga in"];
    
    [_loginView.userNameTextField setDelegate:self];
    [_loginView.passwordTextField setDelegate:self];
    
    [_loginView.loginButton addTarget:self action:@selector(_login:) forControlEvents:UIControlEventTouchUpInside];
  }
  return _loginView;
}

- (UIPanGestureRecognizer *)loginViewRecognizer {
  if (!_loginViewRecognizer) {
    _loginViewRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_loginViewPanAction:)];
  }
  return _loginViewRecognizer;
}

#pragma mark - Private

- (void)_keyboardNotification:(NSNotification *)notification {
  CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
  
  // No need to convert when we use full screen VCs
  CGRect intersecton = CGRectIntersection(self.view.frame, keyboardFrame);
  
  BOOL show = (notification.name == UIKeyboardWillShowNotification);
  
  if (!show)
    intersecton = CGRectZero;
  
  SKBounceAnimation *loginAnimation = [SKBounceAnimation animationWithKeyPath:@"position.y"];
  [loginAnimation setFromValue:@(self.loginView.layer.position.y)];
  [loginAnimation setToValue:@(CGRectGetHeight(self.view.bounds)-CGRectGetHeight(self.loginView.bounds)-CGRectGetHeight(intersecton)+CGRectGetHeight(self.loginView.bounds)/2)];
  [loginAnimation setDuration:.8];
  [loginAnimation setNumberOfBounces:4];
  
  [self.loginView.layer addAnimation:loginAnimation forKey:@"lol"];
  [self.loginView.layer setValue:loginAnimation.toValue forKeyPath:loginAnimation.keyPath];
}

- (void)_login:(id)sender {
  [self.loginView endEditing:YES];
  
  if (self.loginView.userNameTextField.text.length < 1 ||
      self.loginView.passwordTextField.text.length < 1) {
    [self.loginView setErrorStateWithTitle:@"Skriv något sa jag!" nextState:KKLoginViewStateDefault nextTitle:@"Logga in"];
    
    return;
  }
  
  if (self.loginView.state != KKLoginViewStateDefault)
    return;
  
  [self.loginView setState:KKLoginViewStateLoading withButtonTitle:@"Loggar in…"];
  
  [[KKAPISessionManager client] POST:@"session"
                          parameters:@{@"username":self.loginView.userNameTextField.text, @"password":self.loginView.passwordTextField.text}
                             success:^(NSURLSessionDataTask *task, id responseObject) {
                               
                               [KKApp setUsername:self.loginView.userNameTextField.text];
                               [KKApp setPassword:self.loginView.passwordTextField.text];
                               
                               [[KKAPISessionManager client] GET:@"cards"
                                                      parameters:nil
                                                         success:^(NSURLSessionDataTask *task, id responseObject) {
                                                           
                                                           [self.loginView setState:KKLoginViewStateDone withButtonTitle:@"Inloggad"];
                                                           [self.loginView clearForm];
                                                           
                                                           [KKLibrary.library setUnparsedCards:responseObject];
                                                           
                                                           [[LocalyticsSession shared] tagEvent:@"Logged In"];
                                                           
                                                           [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:KKMinimumBackgroundFetchInterval];
                                                           
                                                           [self dismissViewControllerAnimated:YES completion:^{
                                                             [[NSNotificationCenter defaultCenter] postNotificationName:KKUserDidLoginNotification object:self];
                                                           }];
                                                           
                                                         } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                           [self.loginView setErrorStateWithTitle:@"Fejl!" nextState:KKLoginViewStateDefault nextTitle:@"Logga in"];
                                                         }];
                               
                             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                               [self.loginView setErrorStateWithTitle:@"Fel anv./lösn." nextState:KKLoginViewStateDefault nextTitle:@"Logga in"];
                             }];
}

- (void)_loginViewPanAction:(UIPanGestureRecognizer *)sender {
  CGFloat translation = [sender translationInView:self.view].y;
  if (sender.state == UIGestureRecognizerStateBegan) {
    _loginStartTop = CGRectGetMinY(self.loginView.frame);
  } else if (sender.state == UIGestureRecognizerStateChanged) {
    [self.loginView.layer removeAnimationForKey:@"lol"];
    [self.loginView setFrame:CGRectMake(CGRectGetMinX(self.loginView.frame),
                                        _loginStartTop+translation,
                                        CGRectGetWidth(self.loginView.bounds),
                                        CGRectGetHeight(self.loginView.bounds))];
  } else {
    if (translation > 0.f && self.loginView.inputAccessoryView.superview)
      [self.loginView endEditing:YES];
    else {
      SKBounceAnimation *loginAnimation = [SKBounceAnimation animationWithKeyPath:@"position.y"];
      [loginAnimation setFromValue:@(self.loginView.layer.position.y)];
      [loginAnimation setToValue:@(CGRectGetHeight(self.view.bounds)-round(CGRectGetHeight(self.loginView.bounds)/2))];
      [loginAnimation setDuration:.8];
      [loginAnimation setNumberOfBounces:4];
      
      [self.loginView.layer addAnimation:loginAnimation forKey:@"lol"];
      [self.loginView.layer setValue:loginAnimation.toValue forKeyPath:loginAnimation.keyPath];
    }
  }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
  return (self.loginView.state == KKLoginViewStateDefault);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  if (textField == self.loginView.userNameTextField)
    [self.loginView.passwordTextField becomeFirstResponder];
  else
    [self _login:textField];
  
  return YES;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
  _presenting = YES;
  return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
  _presenting = NO;
  return self;
}

// Skip interactive for now
- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
  return nil;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
  return nil;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
  return _presenting?.5f:.3f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
  UIView *contentView = [transitionContext containerView];
  
  BOOL isPhone568 = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height > 567.f); // 568
  
  /*
   - (CGRect)initialFrameForViewController:(UIViewController *)vc;
   - (CGRect)finalFrameForViewController:(UIViewController *)vc;
   */
  
  if (_presenting) {
    // Preparation
    [contentView addSubview:self.view];
    
    CGRect frame = self.cardsView.frame;
    frame.origin.x = round((CGRectGetWidth(contentView.bounds)-CGRectGetWidth(self.cardsView.bounds))/2);
    frame.origin.y = -CGRectGetHeight(frame);
    [self.cardsView setFrame:frame];

    [self.view addSubview:self.cardsView];
    
    frame = self.loginView.frame;
    frame.origin.y = CGRectGetHeight(contentView.frame);
    [self.loginView setFrame:frame];

    [self.view addSubview:self.loginView];
    
    SKBounceAnimation *animation = [SKBounceAnimation animationWithKeyPath:@"position.y"];
    
    [animation setFromValue:@(self.cardsView.layer.position.y)];
    [animation setToValue:isPhone568?@(140.f):@(115.f)];
    [animation setDuration:1.];
    [animation setNumberOfBounces:6];
    [animation setAnimationDidStop:^(BOOL stop) {
      [self.cardsView setState:KKCardsViewStateUnfolded animated:YES completion:^{
        [transitionContext completeTransition:YES];
      }];
    }];
    
    [self.cardsView.layer addAnimation:animation forKey:nil];
    [self.cardsView.layer setValue:animation.toValue forKeyPath:animation.keyPath];
    
    animation = [SKBounceAnimation animationWithKeyPath:@"position.y"];
    [animation setFromValue:@(self.loginView.layer.position.y)];
    [animation setToValue:@(self.loginView.layer.position.y-CGRectGetHeight(self.loginView.bounds))];
    [animation setDuration:1.];
    [animation setNumberOfBounces:6];
    [animation setAnimationDidStop:^(BOOL stop) {
      [self.loginView addGestureRecognizer:self.loginViewRecognizer];
    }];
    
    [self.loginView.layer addAnimation:animation forKey:nil];
    [self.loginView.layer setValue:animation.toValue forKeyPath:animation.keyPath];
  } else {
    __weak typeof(self) weakSelf = self;
    [self.cardsView setState:KKCardsViewStateFolded animated:YES completion:^{
      [UIView animateWithDuration:.25
                            delay:0.
           usingSpringWithDamping:1.f
            initialSpringVelocity:0.f
                          options:0
                       animations:^{
                         CGRect frame = weakSelf.cardsView.frame;
                         frame.origin.y = -CGRectGetHeight(frame);
                         [weakSelf.cardsView setFrame:frame];
                         
                         frame = weakSelf.loginView.frame;
                         frame.origin.y = CGRectGetHeight(contentView.frame);
                         [weakSelf.loginView setFrame:frame];
                       } completion:^(BOOL finished) {
                         [weakSelf.view removeFromSuperview];
                         [transitionContext completeTransition:finished];
                       }];
    }];
  }
}

@end
