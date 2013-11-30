//
//  CAAnimation+SBExtras.m
//  SBFoundation
//
//  Copyright (c) 2012 Simon Blommegård. All rights reserved.
//

#import "CAAnimation+SBExtras.h"
#import "NSObject+SBExtras.h"

SBDefineStaticVoid(kCAAnimationSBExtrasAnimationDelegateKey);

@interface SBAnimationDelegate : NSObject
@property (nonatomic, copy) void (^animationDidStop)(BOOL flag);
@property (nonatomic, copy) void (^animationDidStart)();
@end

@implementation SBAnimationDelegate

#pragma mark - CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim {
  if (self.animationDidStart)
    self.animationDidStart();
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
  if (self.animationDidStop)
    self.animationDidStop(flag);
}

@end

@interface CAAnimation (SBExtrasPrivate)
@property (nonatomic, strong) SBAnimationDelegate *animationDelegate;
@end

@implementation CAAnimation (SBExtras)
@dynamic animationDidStop, animationDidStart;

#pragma mark - Properties

- (void)setAnimationDidStart:(void (^)())animationDidStart {
  [self setDelegate:self.animationDelegate];
  [self.animationDelegate setAnimationDidStart:animationDidStart];
}

- (void (^)())animationDidStart {
  return self.animationDelegate.animationDidStart;
}

- (void)setAnimationDidStop:(void (^)(BOOL))animationDidStop {
  [self setDelegate:self.animationDelegate];
  [self.animationDelegate setAnimationDidStop:animationDidStop];
}

- (void (^)(BOOL))animationDidStop {
  return self.animationDelegate.animationDidStop;
}

- (SBAnimationDelegate *)animationDelegate {
  SBAnimationDelegate *delegate = [self associatedValueForKey:kCAAnimationSBExtrasAnimationDelegateKey];
  
  if (!delegate) {
    delegate = [SBAnimationDelegate new];
    [self associateValue:delegate withKey:kCAAnimationSBExtrasAnimationDelegateKey];
  }
  
  return delegate;
}

@end
