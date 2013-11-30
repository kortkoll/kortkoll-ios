//
//  KKLoginView.m
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-05-11.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

#import "KKLoginView.h"
#import "KKLoginTextField.h"
#import "KKSpinnerLayer.h"
@import AVFoundation;
@import AudioToolbox;
#import "KKWelcomeHUDView.h"
#import "SBDrawingHelpers.h"

@interface KKLoginView ()
@property (nonatomic, strong) KKSpinnerLayer *spinnerLayer;
@property (nonatomic, strong) UILongPressGestureRecognizer *fillCridentialsRecognizer;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, assign) SystemSoundID sound;

@property (nonatomic, strong) UIButton *infoButton;
@end

@implementation KKLoginView

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), 320.f, 230.f)]) {
    [self setBackgroundColor:[UIColor colorWithWhite:1 alpha:.96]];
    
    [self addSubview:self.userNameTextField];
    [self addSubview:self.passwordTextField];
    [self addSubview:self.loginButton];
    
    [self.layer addSublayer:self.spinnerLayer];
    
    [self addSubview:self.infoButton];
    
#ifdef DEBUG
    [self addGestureRecognizer:self.fillCridentialsRecognizer];
#endif
    
    [self player]; // Prepare to play
  }
  return self;
}

- (void)drawRect:(CGRect)rect {
  [[UIColor colorWithWhite:0.f alpha:.2f] set];
  SBDrawLine(CGPointMake(0.f, .5f), CGPointMake(CGRectGetWidth(self.bounds), .5f), 2.f);

  [[UIImage imageNamed:@"mittsl"] drawAtPoint:CGPointMake(10.f, 13.f)];
  [@"Mitt SL – inloggning" drawWithRect:CGRectMake(50.f, 35.f, CGRectGetWidth(self.bounds)-60.f, 50.f)
                                options:0
                             attributes:@{
                                          NSFontAttributeName:[UIFont kk_semiboldFontWithSize:17.f],
                                          NSForegroundColorAttributeName:[UIColor kk_headerColor]
                                          }
                                context:nil];

  [[UIColor colorWithWhite:0.f alpha:.06f] set];
  SBDrawLine(CGPointMake(0.f, 58.5f), CGPointMake(CGRectGetWidth(self.bounds), 58.5f), 2.f);
  [[UIImage imageNamed:@"usericon"] drawAtPoint:CGPointMake(10.f, 74.f)];
  
  SBDrawLine(CGPointMake(0.f, 116.5f), CGPointMake(CGRectGetWidth(self.bounds), 116.5f), 2.f);
  [[UIImage imageNamed:@"passwordicon"] drawAtPoint:CGPointMake(10.f, 132.f)];
}
       
#pragma mark - Properties

- (KKLoginTextField *)userNameTextField {
  if (!_userNameTextField) {
    _userNameTextField = [[KKLoginTextField alloc] initWithFrame:CGRectMake(50.f, 70.f, CGRectGetWidth(self.bounds)-60.f, 40.f)];
    [_userNameTextField setPlaceholder:@"Användarnamn"];
    [_userNameTextField setReturnKeyType:UIReturnKeyNext];
    [_userNameTextField setInputAccessoryView:self.inputAccessoryView];
  }
  return _userNameTextField;
}

- (KKLoginTextField *)passwordTextField {
  if (!_passwordTextField) {
    _passwordTextField = [[KKLoginTextField alloc] initWithFrame:CGRectMake(50.f, 128.f, CGRectGetWidth(self.bounds)-60.f, 40.f)];
    [_passwordTextField setPlaceholder:@"Lösenord"];
    [_passwordTextField setSecureTextEntry:YES];
    [_passwordTextField setReturnKeyType:UIReturnKeyGo];
    [_passwordTextField setInputAccessoryView:self.inputAccessoryView];
  }
  return _passwordTextField;
}

- (UIButton *)loginButton {
  if (!_loginButton) {
    _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginButton setFrame:CGRectMake(0.f, 174.f, CGRectGetWidth(self.bounds), 56.f)];
    [_loginButton.titleLabel setFont:[UIFont kk_boldFontWithSize:18.f]];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginButton setBackgroundImage:[UIImage imageNamed:@"buttonblue"] forState:UIControlStateNormal];
    [_loginButton setBackgroundImage:[UIImage imageNamed:@"buttonbluetap"] forState:UIControlStateHighlighted];
    [_loginButton setTitleEdgeInsets:UIEdgeInsetsMake(6.f, 0.f, 0.f, 0.f)];
    [_loginButton addTarget:self action:@selector(_playAction:) forControlEvents:UIControlEventTouchDown];
  }
  return _loginButton;
}

- (UIView *)inputAccessoryView {
  if (!_inputAccessoryView) {
    _inputAccessoryView = [UIView new];
  }
  return _inputAccessoryView;
}

- (KKSpinnerLayer *)spinnerLayer {
  if (!_spinnerLayer) {
    _spinnerLayer = [KKSpinnerLayer layer];
    [_spinnerLayer setFrame:CGRectMake(20.f, 191.f, _spinnerLayer.bounds.size.width, _spinnerLayer.bounds.size.height)];
  }
  return _spinnerLayer;
}

- (UILongPressGestureRecognizer *)fillCridentialsRecognizer {
  if (!_fillCridentialsRecognizer) {
    _fillCridentialsRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(_fillCridentials:)];
  }
  return _fillCridentialsRecognizer;
}

- (AVAudioPlayer *)player {
  if (!_player) {
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:NULL];
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[[NSBundle mainBundle] URLForResource:@"blip" withExtension:@"wav"], &_sound);
    /*
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL: error:NULL];
    [_player setVolume:.2];
    [_player prepareToPlay];
     */
  }
  return _player;
}

- (UIButton *)infoButton {
  if (!_infoButton) {
    _infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *image = [UIImage imageNamed:@"infobuttonopacity"];
    [_infoButton setBackgroundImage:image forState:UIControlStateNormal];
    [_infoButton setBackgroundImage:[UIImage imageNamed:@"infobutton"] forState:UIControlStateHighlighted];
    [_infoButton setFrame:CGRectMake(CGRectGetWidth(self.bounds)-image.size.width-10.f, 13.f, image.size.width, image.size.height)];
    
    [_infoButton addTarget:self action:@selector(_infoAction:) forControlEvents:UIControlEventTouchUpInside];
  }
  return _infoButton;
}

#pragma mark - Private

- (void)_playAction:(id)sender {
//  AudioServicesPlaySystemSound(_sound);
}

- (void)_fillCridentials:(id)sender {
#ifdef DEBUG  
  [self.userNameTextField setText:KKTestUserName];
  [self.passwordTextField setText:KKTestPassword];
#endif
}

- (void)_infoAction:(id)sender {
  KKWelcomeHUDView *view = [KKWelcomeHUDView new];
  [view setDimBackground:YES];
  [[KKHUD HUD] showHUDItem:view];
}

#pragma mark - Public

- (void)clearForm {
  [self.userNameTextField setText:nil];
  [self.passwordTextField setText:nil];
}

- (void)setState:(KKLoginViewState)state withButtonTitle:(NSString *)title {
  KKLoginViewState oldState = _state;

  _state = state;
  
  [self.loginButton setTitle:title forState:UIControlStateNormal];
  
  [self.loginButton.titleLabel.layer addAnimation:[CATransition animation] forKey:nil];
  
  [self.spinnerLayer setSpinnerLayerStyle:(KKSpinnerLayerStyle)state];
  
  if (oldState == KKLoginViewStateError || _state == KKLoginViewStateError) {
    [self.loginButton setBackgroundImage:[UIImage imageNamed:(state == KKLoginViewStateError)?@"buttonred":@"buttonblue"] forState:UIControlStateNormal];
    [self.loginButton setBackgroundImage:[UIImage imageNamed:(state == KKLoginViewStateError)?@"buttonred":@"buttonbluetap"] forState:UIControlStateHighlighted];
    
    [self.loginButton.layer addAnimation:[CATransition animation] forKey:nil];
  }
  
  [self.userNameTextField setUserInteractionEnabled:(state != KKLoginViewStateLoading)];
  [self.passwordTextField setUserInteractionEnabled:(state != KKLoginViewStateLoading)];
}

- (void)setErrorStateWithTitle:(NSString *)title nextState:(KKLoginViewState)nextState nextTitle:(NSString *)nextTitle {
  [self setState:KKLoginViewStateError withButtonTitle:title];
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
    [self setState:nextState withButtonTitle:nextTitle];
  });
}

@end
