//
//  KKListCardsBottomView.m
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-09-15.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

#import "KKListCardsBottomView.h"
#import "KKCardsPageControl.h"
#import "SKBounceAnimation.h"

CGFloat kKKListCardsBottomViewHeight = 48.f;

@implementation KKListCardsBottomView

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), kKKListCardsBottomViewHeight)]) {
    [self addSubview:self.pageControl];
    [self addSubview:self.updateButton];
  }
  return self;
}

#pragma mark - Properties

- (KKCardsPageControl *)pageControl {
  if (!_pageControl) {
    _pageControl = [[KKCardsPageControl alloc] initWithFrame:self.bounds];
    [_pageControl setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth];
    [_pageControl setHidesForSinglePage:NO];
  }
  return _pageControl;
}

- (UIButton *)updateButton {
  if (!_updateButton) {
    _updateButton = [UIButton buttonWithType:UIButtonTypeCustom];

    [_updateButton setImage:[UIImage imageNamed:@"updateiconopacity"] forState:UIControlStateNormal];
    [_updateButton setImage:[UIImage imageNamed:@"updateicon"] forState:UIControlStateHighlighted];
    [_updateButton setFrame:CGRectMake(CGRectGetWidth(self.bounds)-CGRectGetHeight(self.bounds), 0.f, CGRectGetHeight(self.bounds), CGRectGetHeight(self.bounds))];
  }
  return _updateButton;
}

- (void)setState:(KKListCardsBottomViewState)state {
  [self setState:state animated:NO];
}

#pragma mark - Public

- (void)setState:(KKListCardsBottomViewState)state animated:(BOOL)animated {
  if (_state == state)
    return;
  
  _state = state;
  
  [self.updateButton setUserInteractionEnabled:!(state == KKListCardsBottomViewStateLoading)];
  
  /*
  [self.loginView.layer addAnimation:loginAnimation forKey:@"lol"];
  [self.loginView.layer setValue:loginAnimation.toValue forKeyPath:loginAnimation.keyPath];
  */
  NSNumber *toValue = @(2*M_PI);
  
  if (state == KKListCardsBottomViewStateLoading) {
    CABasicAnimation *arrowAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    [arrowAnimation setFromValue:@(0)];
    [arrowAnimation setToValue:@(2*M_PI)];
    [arrowAnimation setDuration:1.];
    [arrowAnimation setRepeatCount:INFINITY];
    
    [self.updateButton.layer addAnimation:arrowAnimation forKey:@"arrow"];
  } else {
    [self.updateButton.layer removeAnimationForKey:@"arrow"];
    
    NSNumber *fromValue = [self.updateButton.layer.presentationLayer valueForKeyPath:@"transform.rotation.z"];
    
    SKBounceAnimation *arrowAnimation = [SKBounceAnimation animationWithKeyPath:@"transform.rotation.z"];
    [arrowAnimation setFromValue:fromValue];
    [arrowAnimation setToValue:@(2*M_PI)];
    [arrowAnimation setNumberOfBounces:2];
    [arrowAnimation setDuration:1*((toValue.doubleValue-fromValue.doubleValue)/toValue.doubleValue)]; // Calculate remaining time.
    
    [self.updateButton.layer addAnimation:arrowAnimation forKey:nil];
  }
}

@end
