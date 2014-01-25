//
//  KKHUDView.m
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-07-23.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

#import "KKWelcomeHUDView.h"
#import "SKBounceAnimation.h"
#import "TTTAttributedLabel.h"
#import "KKText.h"
#import "CAAnimation+SBExtras.h"

@interface KKWelcomeHUDView ()
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIImageView *infoImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) TTTAttributedLabel *infoLabel;
@property (nonatomic, strong) KKText *text;
@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UIView *dimView;

@property (nonatomic, assign) CGFloat panStartTop;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@end

@implementation KKWelcomeHUDView

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:CGRectMake(0.f, 0.f, 280.f, 250.f)]) {
    [self.layer setCornerRadius:8.f];
    [self.layer setShadowOffset:CGSizeMake(0.f, 0.f)];
    [self.layer setShadowOpacity:.5];
    [self.layer setShouldRasterize:YES];
    [self.layer setRasterizationScale:[UIScreen mainScreen].scale];
    
    [self addSubview:self.contentView];
    
    [self setInfoImageView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"info"]]];

    [self.contentView addSubview:self.infoImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.infoLabel];
    [self.contentView addSubview:self.button];
    
    [self.contentView addGestureRecognizer:self.panRecognizer];
  }
  return self;
}

- (void)layoutSubviews {
  [self.infoImageView setFrame:CGRectMake(10.f, 10.f, CGRectGetWidth(self.infoImageView.bounds), CGRectGetHeight(self.infoImageView.bounds))];
  [self.titleLabel setFrame:CGRectMake(50.f, 18.f, 0.f, 0.f)];
  [self.titleLabel sizeToFit];
  
  CGSize s = [_infoLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.bounds)-24.f, CGFLOAT_MAX)];
  [self.infoLabel setFrame:CGRectMake(12.f, 15.f+CGRectGetHeight(self.infoImageView.bounds), s.width, s.height)];
  
  [self.button setFrame:CGRectMake(0.f, CGRectGetHeight(self.bounds)-57.f, CGRectGetWidth(self.bounds), 57.f)];
}

#pragma mark - Properties

- (UIView *)contentView {
  if (!_contentView) {
    _contentView = [[UIView alloc] initWithFrame:self.bounds];
    [_contentView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth)];
    [_contentView setBackgroundColor:[UIColor whiteColor]];

    [_contentView.layer setCornerRadius:8.f];
    [_contentView.layer setMasksToBounds:YES];
  }
  return _contentView;
}

- (UILabel *)titleLabel {
  if (!_titleLabel) {
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_titleLabel setFont:[UIFont kk_semiboldFontWithSize:18.f]];
    [_titleLabel setTextColor:[UIColor kk_headerColor]];
    [_titleLabel setText:@"Kortkoll"];
  }
  return _titleLabel;
}

- (TTTAttributedLabel *)infoLabel {
  if (!_infoLabel) {
    _infoLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    [_infoLabel setNumberOfLines:0];
    
    KKText *text = [KKText intoText];
    [self setText:text];
    
    [_infoLabel setDelegate:text];
    [_infoLabel setAttributedText:text.attributedString];
    [_infoLabel setLinkAttributes:text.linkAttributes];
    [_infoLabel setActiveLinkAttributes:text.activeLinkAttributes];
    
    [text.links enumerateKeysAndObjectsUsingBlock:^(NSValue *key, NSURL *obj, BOOL *stop) {
      [self.infoLabel addLinkToURL:obj withRange:key.rangeValue];
    }];
  }
  return _infoLabel;
}

- (UIButton *)button {
  if (!_button) {
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button.titleLabel setFont:[UIFont kk_boldFontWithSize:18.f]];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button setBackgroundImage:[UIImage imageNamed:@"buttonblue"] forState:UIControlStateNormal];
    [_button setBackgroundImage:[UIImage imageNamed:@"buttonbluetap"] forState:UIControlStateHighlighted];
    [_button setTitleEdgeInsets:UIEdgeInsetsMake(6.f, 0.f, 0.f, 0.f)];
    [_button setTitle:@"Låt mig få koll!" forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(_closeAction:) forControlEvents:UIControlEventTouchUpInside];
  }
  return _button;
}

- (UIPanGestureRecognizer *)panRecognizer {
  if (!_panRecognizer) {
    _panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_panAction:)];
  }
  return _panRecognizer;
}

#pragma mark - KKHUDPresenting

- (void)showInView:(UIView *)view backgroundView:(UIView *)backgroundView completion:(void (^)())completion {
  [self setFrame:CGRectMake(roundf((CGRectGetWidth(view.bounds)-CGRectGetWidth(self.bounds))/2), -CGRectGetHeight(self.bounds),CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
  
  SKBounceAnimation *showAnimation = [self _bounceAnimation];
  [showAnimation setFromValue:@(self.layer.position.y)];
  [showAnimation setToValue:@(CGRectGetHeight(view.bounds)/2)];
  [showAnimation setAnimationDidStop:^(BOOL stop) {
    completion();
  }];

  _dimView = [[UIView alloc] initWithFrame:backgroundView.bounds];
  [_dimView setBackgroundColor:[UIColor colorWithWhite:1.f alpha:.5f]];
  [_dimView setAlpha:0.f];
  
  [backgroundView addSubview:_dimView];
  
  [UIView animateWithDuration:self.dimBackground?showAnimation.duration/2:0. animations:^{
    if (self.dimBackground)
      [self.dimView setAlpha:1.f];
  } completion:nil];
  
  [view addSubview:self];
  [view setClipsToBounds:YES];
  
  [self.layer addAnimation:showAnimation forKey:nil];
  [self.layer setValue:showAnimation.toValue forKeyPath:showAnimation.keyPath];
}

- (void)hideBackgroundView:(UIView *)backgroundView completion:(void(^)())completion  {
  [UIView animateWithDuration:.25
                        delay:0.
       usingSpringWithDamping:1.f
        initialSpringVelocity:0.f
                      options:0
                   animations:^{
    CGRect frame = self.frame;
    frame.origin.y = CGRectGetHeight(self.superview.bounds);
    [self setFrame:frame];
  } completion:^(BOOL finished) {
    [self removeFromSuperview];
    completion();
  }];
  
  [UIView animateWithDuration:self.dimBackground?.4:0. animations:^{
    [self.dimView setAlpha:0.f];
  } completion:^(BOOL finished) {
    [self.dimView removeFromSuperview];
    [self setDimView:nil];
  }];
}

#pragma mark - Private

- (void)_closeAction:(id)sender {
  [[KKHUD HUD] hideHUDItem:self];
}

- (void)_panAction:(UIPanGestureRecognizer *)sender {
  CGFloat translation = [sender translationInView:self.superview].y;
  if (sender.state == UIGestureRecognizerStateBegan) {
    _panStartTop = CGRectGetMinY(self.frame);
  } else if (sender.state == UIGestureRecognizerStateChanged) {
    [self.layer removeAnimationForKey:@"panning"];
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame), _panStartTop+translation, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
  } else {
      SKBounceAnimation *panAnimation = [self _bounceAnimation];
      [panAnimation setFromValue:@(self.layer.position.y)];
      [panAnimation setToValue:@(_panStartTop+CGRectGetHeight(self.bounds)/2)];
      
      [self.layer addAnimation:panAnimation forKey:@"panning"];
      [self.layer setValue:panAnimation.toValue forKeyPath:panAnimation.keyPath];
  }
}

- (SKBounceAnimation *)_bounceAnimation {
  SKBounceAnimation *animation = [SKBounceAnimation animationWithKeyPath:@"position.y"];
  [animation setDuration:.8];
  [animation setNumberOfBounces:4];
  return animation;
}

@end
