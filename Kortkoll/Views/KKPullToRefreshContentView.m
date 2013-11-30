//
//  KKPullToRefreshContentView.m
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-11-28.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

#import "KKPullToRefreshContentView.h"

@interface KKPullToRefreshContentView ()
@property (nonatomic, strong) CALayer *l;
@end

@implementation KKPullToRefreshContentView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
      CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
      
      NSMutableArray *frames = [NSMutableArray new];
      for (NSInteger i = 0; i<=40; i++)
        [frames addObject:(id)[UIImage imageNamed:[NSString stringWithFormat:@"Logo Animation %ld", (long)i]].CGImage];
      
      [animation setCalculationMode:kCAAnimationLinear];
      [animation setValues:frames];
      [animation setDuration:1.];
      
      _l = [CALayer layer];
      [_l setSpeed:0.];
      [_l setContentsScale:[UIScreen mainScreen].scale];
      [_l setFrame:CGRectMake(0.f, -10.f, 68.f, 68.f)];
      [self.layer addSublayer:_l];
      [_l addAnimation:animation forKey:@"asd"];
      
    }
    return self;
}

- (void)setState:(SSPullToRefreshViewState)state withPullToRefreshView:(SSPullToRefreshView *)view {
  
}

- (void)setPullProgress:(CGFloat)pullProgress {
  NSLog(@"%@", @(pullProgress));
  [_l setTimeOffset:pullProgress];
}

@end
