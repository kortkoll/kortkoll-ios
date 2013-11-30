//
//  KKCardsView.m
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-05-11.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

#import "KKCardsView.h"
#import "SKBounceAnimation.h"
#import "CAAnimation+SBExtras.h"
@import Darwin.C.tgmath;

@interface KKCardsView ()
@property (nonatomic, strong) CALayer *card1Layer;
@property (nonatomic, strong) CALayer *card2Layer;
@property (nonatomic, strong) CALayer *card3Layer;

@property (nonatomic, strong) CALayer *card1ShadowLayer;
@property (nonatomic, strong) CALayer *card2ShadowLayer;
@property (nonatomic, strong) CALayer *card3ShadowLayer;

@property (nonatomic, strong) CALayer *logoLayer;

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

- (CALayer *)_cardLayerWithImageName:(NSString *)name shadow:(BOOL)shadow;
- (void)_toggleFold:(id)sender;
@end

@implementation KKCardsView

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), 196.f, 138.f)]) {
    [self setCard1Layer:[self _cardLayerWithImageName:@"card3" shadow:NO]];
    [self setCard2Layer:[self _cardLayerWithImageName:@"card2" shadow:NO]];
    [self setCard3Layer:[self _cardLayerWithImageName:@"card1" shadow:NO]];

//    [self setCard1ShadowLayer:[self _cardLayerWithImageName:@"cardshadow" shadow:YES]];
//    [self setCard2ShadowLayer:[self _cardLayerWithImageName:@"cardshadow" shadow:YES]];
    [self setCard3ShadowLayer:[self _cardLayerWithImageName:@"cardshadow" shadow:YES]];

    [self.layer addSublayer:self.card1ShadowLayer];
    [self.layer addSublayer:self.card1Layer];
    [self.layer addSublayer:self.card2ShadowLayer];
    [self.layer addSublayer:self.card2Layer];
    [self.layer addSublayer:self.card3ShadowLayer];
    [self.layer addSublayer:self.card3Layer];
    [self.layer addSublayer:self.logoLayer];

    [self addSubview:self.textLabel];
    
    [self addGestureRecognizer:self.tapGestureRecognizer];
    
    UIInterpolatingMotionEffect *effect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"layer.position.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    [effect setMinimumRelativeValue:@-10.f];
    [effect setMaximumRelativeValue:@10.f];
    [self addMotionEffect:effect];
    
    effect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"layer.position.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    [effect setMinimumRelativeValue:@-10.f];
    [effect setMaximumRelativeValue:@10.f];
    [self addMotionEffect:effect];
  }
  return self;
}

#pragma mark - Public

- (void)setState:(KKCardsViewState)state animated:(BOOL)animated completion:(void (^)(void))completion {
  if (_state == state) {
    if (completion)
      completion();
    return;
  }
  
  _state = state;
  
  NSString *keyPath = @"transform.rotation.z";
  CFTimeInterval duration = .3f;
  
  if (!animated) {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
  }
  
  // Card 1
  id toValue = @(SBDegreesToRadians((state == KKCardsViewStateFolded)?0.:10.));
  id fromValue = @(SBDegreesToRadians((state == KKCardsViewStateFolded)?10.:0.));
  
  [self.card1Layer setValue:toValue forKeyPath:keyPath];
  [self.card1ShadowLayer setValue:toValue forKey:keyPath];

  if (animated) {
    CABasicAnimation *rotation1Animation = [CABasicAnimation animationWithKeyPath:keyPath];
    [rotation1Animation setFromValue:fromValue];
    [rotation1Animation setToValue:toValue];
    [rotation1Animation setDuration:duration];
    
    [self.card1Layer addAnimation:rotation1Animation forKey:nil];
    [self.card1ShadowLayer addAnimation:rotation1Animation forKey:nil];
  }
  
  // Card 2
  toValue = @(SBDegreesToRadians((state == KKCardsViewStateFolded)?0.:-15.));
  fromValue = @(SBDegreesToRadians((state == KKCardsViewStateFolded)?-15.:0.));
  [self.card2Layer setValue:toValue forKeyPath:keyPath];
  [self.card2ShadowLayer setValue:toValue forKey:keyPath];
  
  if (animated) {
    CABasicAnimation *rotation2Animation = [CABasicAnimation animationWithKeyPath:keyPath];
    [rotation2Animation setFromValue:fromValue];
    [rotation2Animation setToValue:toValue];
    [rotation2Animation setDuration:duration];
    
    [self.card2Layer addAnimation:rotation2Animation forKey:nil];
    [self.card2ShadowLayer addAnimation:rotation2Animation forKey:nil];
  }
  
  // Logo
  [self.logoLayer setContents:(id)[UIImage imageNamed:(state == KKCardsViewStateUnfolded)?@"Logo Animation 40":@"Logo Animation 0"].CGImage];
  
  if (animated) {
    NSMutableArray *frames = [NSMutableArray new];
    for (NSInteger i = (state == KKCardsViewStateUnfolded)?0:40;
         (state == KKCardsViewStateUnfolded)?(i<=40):(i>=0);
         (state == KKCardsViewStateUnfolded)?i++:i--) {
      [frames addObject:(id)[UIImage imageNamed:[NSString stringWithFormat:@"Logo Animation %ld", (long)i]].CGImage];
    }

    CAKeyframeAnimation *logoAnimation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    [logoAnimation setValues:frames];
    [logoAnimation setDuration:duration];
//    [logoAnimation setCalculationMode:kCAAnimationDiscrete];
    [logoAnimation setAnimationDidStop:^(BOOL stop) {
      if (completion)
        completion();
    }];
    
    [self.logoLayer addAnimation:logoAnimation forKey:nil];
  } else if (completion)
    completion();
  
  // Commit
  if (!animated)
    [CATransaction commit];
}

#pragma mark - Private


- (CALayer *)_cardLayerWithImageName:(NSString *)name shadow:(BOOL)shadow {
  CALayer *layer = [CALayer layer];
  UIImage *image = [UIImage imageNamed:name];
  [layer setFrame:(CGRect){shadow?CGPointMake(0.f, 2.f):CGPointZero, image.size}];
  [layer setContents:(id)image.CGImage];
  
  return layer;
}

- (void)_toggleFold:(id)sender {
  [self setState:(_state == KKCardsViewStateFolded)?KKCardsViewStateUnfolded:KKCardsViewStateFolded animated:YES completion:nil];
}

#pragma mark - Properties

- (void)setState:(KKCardsViewState)state {
  [self setState:state animated:NO completion:nil];
}

- (CALayer *)logoLayer {
  if (!_logoLayer) {
    _logoLayer = [CALayer layer];
    UIImage *image = [UIImage imageNamed:@"Logo Animation 0"];
    [_logoLayer setFrame:CGRectMake(roundf((self.card1Layer.bounds.size.width-image.size.width)/2),
                                    20.f,
                                    image.size.width, image.size.height)];
    
    [_logoLayer setContents:(id)image.CGImage];
  }
  return _logoLayer;
}

- (UILabel *)textLabel {
  if (!_textLabel) {
    _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_textLabel setFont:[UIFont kk_extraBoldFontWithSize:18.f]];
    [_textLabel setTextColor:[UIColor whiteColor]];
    [_textLabel setTextAlignment:NSTextAlignmentCenter];
    [_textLabel setText:@"KORTKOLL"];
    [_textLabel sizeToFit];
    [_textLabel setFrame:CGRectMake(round((CGRectGetWidth(self.bounds)-CGRectGetWidth(_textLabel.bounds))/2),
                                    90.f,
                                    CGRectGetWidth(_textLabel.bounds),
                                    CGRectGetHeight(_textLabel.bounds))];
  }
  return _textLabel;
}

- (UITapGestureRecognizer *)tapGestureRecognizer {
  if (!_tapGestureRecognizer) {
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_toggleFold:)];
  }
  return _tapGestureRecognizer;
}


@end
