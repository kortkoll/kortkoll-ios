//
//  KKHUD.h
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-07-23.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

@import UIKit;

@protocol KKHUDItem <NSObject>
@property (nonatomic, assign) BOOL presented;

- (void)showInView:(UIView *)view backgroundView:(UIView *)backgroundView completion:(void(^)())completion; // Add the view
- (void)hideBackgroundView:(UIView *)backgroundView completion:(void(^)())completion; // Remove the view
@end

// This is nice and all but… I need more time.
@protocol KKHUDBackgroundTransitioning <NSObject>
- (NSTimeInterval)delayForShowingFirstItem:(id <KKHUDItem>)item withBackgroundWindow:(UIWindow *)backgroundWindow;
- (void)hideCompletion:(void(^)())completion;
@end

@interface KKHUD : NSObject

+ (instancetype)HUD;

// Just for enqueue/dequeue, the delegate methods take care of actual anomation and add/remove the view
- (void)showHUDItem:(id <KKHUDItem>)item;
- (void)hideHUDItem:(id <KKHUDItem>)item;

@end
