//
//  KKBackgroundViewController.m
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-05-11.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

#import "KKBackgroundViewController.h"
#import "KKTownScrollView.h"
#import "KKConditionalRunner.h"
#import "MAKVONotificationCenter.h"

#import "KKHUD.h"
#import "KKWelcomeHUDView.h"

#import "KKLoginViewController.h"
#import "KKCardsViewController.h"

@interface KKBackgroundViewController ()

@property (nonatomic, strong) KKTownScrollView *scrollView;
@end

@implementation KKBackgroundViewController

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.view addSubview:self.scrollView];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_presentViewController:)
                                               name:KKUserDidLogoutNotification
                                             object:self.cardsViewController];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(_presentViewController:)
                                               name:KKUserDidLoginNotification
                                             object:self.loginViewController];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(_applicationDidBecomeActiveNotification:)
                                               name:UIApplicationDidBecomeActiveNotification
                                             object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  [self.scrollView setAnimating:YES];
  
  [KKConditionalRunner runIfIdentifier:@"info" notSet:^{
    KKWelcomeHUDView *view = [KKWelcomeHUDView new];
    [view addObserver:self keyPath:@"presented" options:(NSKeyValueObservingOptionNew) block:^(MAKVONotification *notification) {
      if ([notification.newValue isEqual:@NO]) {
        [self _presentViewController:self];
      }
    }];
    
    [[KKHUD HUD] showHUDItem:view];
  } set:^{
      [self _presentViewController:self];
  }];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  
  [self.scrollView setAnimating:NO];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UIApplicationDidBecomeActiveNotification
                                                object:nil];
}

#pragma mark - Properties

- (KKTownScrollView *)scrollView {
  if (!_scrollView) {
    _scrollView = [[KKTownScrollView alloc] initWithFrame:self.view.bounds];
  }
  return _scrollView;
}

- (KKCardsViewController *)cardsViewController {
  if (!_cardsViewController) {
    _cardsViewController = [KKCardsViewController new];
    
    [_cardsViewController setTransitioningDelegate:_cardsViewController];
    [_cardsViewController setModalPresentationStyle:UIModalPresentationCustom];
  }
  return _cardsViewController;
}

- (KKLoginViewController *)loginViewController {
  if (!_loginViewController) {
    _loginViewController = [KKLoginViewController new];
    
    [_loginViewController setTransitioningDelegate:_loginViewController];
    [_loginViewController setModalPresentationStyle:UIModalPresentationCustom];
  }
  return _loginViewController;
}

#pragma mark - Private

- (void)_presentViewController:(id)sender {
  if ([KKApp password].length > 0 && [KKApp username].length > 0) {
    [self presentViewController:self.cardsViewController animated:YES completion:nil];
  } else {
    [self presentViewController:self.loginViewController animated:YES completion:nil];
  }
}

- (void)_applicationDidBecomeActiveNotification:(NSNotification *)notification {
  [self.scrollView setAnimating:YES];
}

@end
