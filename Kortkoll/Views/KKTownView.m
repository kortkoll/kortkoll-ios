//
//  KKTownView.m
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-05-11.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

#import "KKTownView.h"
@import QuartzCore.QuartzCore;
@import Darwin.C.tgmath;

@interface KKTownView ()
@property (nonatomic, strong) CALayer *subwayLayer;
@property (nonatomic, strong) CALayer *busLayer;
@end

@implementation KKTownView

- (id)init {
  if (self = [super initWithImage:[UIImage imageNamed:@"stad"]]) {
    [self.layer addSublayer:self.subwayLayer];
    [self.layer addSublayer:self.busLayer];
  }
  return self;
}

#pragma mark - Properties

- (BOOL)animating {
  return ([self.busLayer animationForKey:@"moveAnimation"] != nil);
}

- (void)setAnimating:(BOOL)animating {
  if (self.animating == animating)
    return;
  
  if (animating) {
    id fromValue = [self.busLayer valueForKeyPath:@"position.x"];
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    
    [animation setValues:@[
                           fromValue,
                           @(320.f),
                           @(320.f),
                           @(round(-self.busLayer.bounds.size.width/2)),
                           fromValue,
                           fromValue
                           ]];
    
    [animation setKeyTimes:@[
                             @0.,
                             @.5,
                             @.6,
                             @1.,
                             @1.,
                             @1.
                             ]];
    
    [animation setTimingFunctions:@[
                                    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                    ]];
    
    
    [animation setRepeatCount:INFINITY];
    [animation setDuration:12.];
    
    [self.busLayer addAnimation:animation forKey:@"moveAnimation"];
    
    fromValue = [self.subwayLayer valueForKeyPath:@"position.x"];
    animation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    
    [animation setValues:@[
                           fromValue,
                           @(0.f),
                           @(0.f),
                           @(CGRectGetWidth(self.bounds)+round(self.subwayLayer.bounds.size.width/2)),
                           fromValue,
                           fromValue
                           ]];
    
    [animation setKeyTimes:@[
                             @0.,
                             @.3,
                             @.4,
                             @1.,
                             @1.,
                             @1.
                             ]];
    
    [animation setTimingFunctions:@[
                                    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                    ]];
    
    
    [animation setRepeatCount:INFINITY];
    [animation setDuration:9.5];
    
    [self.subwayLayer addAnimation:animation forKey:@"moveAnimation"];
  } else {
    [self.busLayer removeAnimationForKey:@"moveAnimation"];
    [self.subwayLayer removeAnimationForKey:@"moveAnimation"];
  }
}

- (void)startAnimation {
  [self _startBusAnimation];
  [self _startSubwayAnimation];
}

#pragma mark - Private

- (void)_startBusAnimation {

}

- (void)_startSubwayAnimation {

}

#pragma mark - Properties

- (CALayer *)subwayLayer {
  if (!_subwayLayer) {
    _subwayLayer = [CALayer layer];
    UIImage *image = [UIImage imageNamed:@"tbana"];
    [_subwayLayer setFrame:(CGRect){CGPointMake(-image.size.width, 422.f), image.size}];
    [_subwayLayer setContents:(__bridge id)image.CGImage];
  }
  return _subwayLayer;
}

- (CALayer *)busLayer {
  if (!_busLayer) {
    _busLayer = [CALayer layer];
    UIImage *image = [UIImage imageNamed:@"buss"];
    [_busLayer setFrame:(CGRect){CGPointMake(CGRectGetWidth(self.bounds), 264.f), image.size}];
    [_busLayer setContents:(__bridge id)image.CGImage];
  }
  return _busLayer;
}

@end
