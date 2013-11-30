//
//  KKSpinnerLayer.m
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-05-12.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

#import "KKSpinnerLayer.h"
#import "CAAnimation+SBExtras.h"

@interface KKSpinnerLayer ()
@property (nonatomic, strong) CALayer *spinnerLayer;
@end

@implementation KKSpinnerLayer

@synthesize spinnerLayerStyle = _spinnerLayerStyle;

- (id)init {
  if (self = [super init]) {
    [self setBounds:CGRectMake(0.f, 0.f, 24.f, 24.f)];
    [self addSublayer:self.spinnerLayer];
    [self setOpacity:0.];
  }
  return self;
}

#pragma mark - Properties

- (void)setSpinnerLayerStyle:(KKSpinnerLayerStyle)spinnerLayerStyle {
  _spinnerLayerStyle = spinnerLayerStyle;
  
  UIImage *image;
  if (spinnerLayerStyle == KKSpinnerLayerStyleLoading) {
    image = [UIImage imageNamed:@"spinner"];
    
    CABasicAnimation *spinnerAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    [spinnerAnimation setFromValue:@(0)];
    [spinnerAnimation setToValue:@(2*M_PI)];
    [spinnerAnimation setDuration:1.];
    [spinnerAnimation setRepeatCount:INFINITY];
    
    [self.spinnerLayer addAnimation:spinnerAnimation forKey:@"spinner"];
    [self.spinnerLayer setOpacity:1.];
    
  } else if (spinnerLayerStyle == KKSpinnerLayerStyleError)
    image = [UIImage imageNamed:@"spinnerno"];
  else if (spinnerLayerStyle == KKSpinnerLayerStyleDone)
    image = [UIImage imageNamed:@"spinneryes"];
  
  if (spinnerLayerStyle != KKSpinnerLayerStyleLoading) {
    [self.spinnerLayer setOpacity:0.];
    
    CATransition *transition = [CATransition animation];
    [transition setAnimationDidStop:^(BOOL stop) {
      [self.spinnerLayer removeAnimationForKey:@"spinner"];
    }];
    
    [self.spinnerLayer addAnimation:transition forKey:nil];
  }

  [self setOpacity:(spinnerLayerStyle == KKSpinnerLayerStyleHidden)?0.:1.];
  
  [self setContents:(id)image.CGImage];
}

- (CALayer *)spinnerLayer {
  if (!_spinnerLayer) {
    _spinnerLayer = [CALayer layer];
    [_spinnerLayer setFrame:self.bounds];
    [_spinnerLayer setContents:(id)[UIImage imageNamed:@"spinnderring"].CGImage];
  }
  return _spinnerLayer;
}

@end

