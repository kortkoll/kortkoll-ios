//
//  CAAnimation+SBExtras.h
//  SBFoundation
//
//  Copyright (c) 2012 Simon Blommegård. All rights reserved.
//

@import QuartzCore.QuartzCore;

@interface CAAnimation (SBExtras)
@property (nonatomic, copy) void (^animationDidStop)(BOOL flag);
@property (nonatomic, copy) void (^animationDidStart)();
@end
