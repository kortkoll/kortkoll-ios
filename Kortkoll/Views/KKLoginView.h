//
//  KKLoginView.h
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-05-11.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

@import UIKit;

typedef NS_ENUM(NSUInteger, KKLoginViewState) {
  KKLoginViewStateDefault,
  KKLoginViewStateLoading,
  KKLoginViewStateError,
  KKLoginViewStateDone,
};

@class KKLoginTextField, KKSpinnerLayer;

@interface KKLoginView : UIView
@property (nonatomic, strong) KKLoginTextField *userNameTextField;
@property (nonatomic, strong) KKLoginTextField *passwordTextField;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIView *inputAccessoryView;

@property (nonatomic, assign) KKLoginViewState state;

- (void)clearForm;

- (void)setState:(KKLoginViewState)state withButtonTitle:(NSString *)title;
- (void)setErrorStateWithTitle:(NSString *)title nextState:(KKLoginViewState)nextState nextTitle:(NSString *)nextTitle;
@end
