//
//  KKListCardsBottomView.h
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-09-15.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

@import UIKit;

extern CGFloat kKKListCardsBottomViewHeight;

typedef NS_ENUM(NSUInteger, KKListCardsBottomViewState) {
  KKListCardsBottomViewStateDefault,
  KKListCardsBottomViewStateHide,
  KKListCardsBottomViewStateReadyforLoading,
  KKListCardsBottomViewStateLoading,
};

@class KKCardsPageControl;

@interface KKListCardsBottomView : UIView
@property (nonatomic, strong) KKCardsPageControl *pageControl;
@property (nonatomic, strong) UIButton *updateButton;
@property (nonatomic, strong) UILabel *updateLabel;

@property (nonatomic) KKListCardsBottomViewState state;

- (void)setState:(KKListCardsBottomViewState)state animated:(BOOL)animated;
@end
