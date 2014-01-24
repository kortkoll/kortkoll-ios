//
//  KKCustomizationController.m
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-11-24.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

#import "KKCustomizationController.h"
#import "KKCardGradientDecorationView.h"

@implementation KKCustomizationController

+ (void)customize {
  UIWindow *statusBarWindow = [[UIApplication sharedApplication] valueForKey:[NSString stringWithFormat:@"%@Window", @"statusBar"]];
  
  if (statusBarWindow && [statusBarWindow isKindOfClass:[UIWindow class]]) {
    KKCardGradientDecorationView *statusBarBackgroundView = [[KKCardGradientDecorationView alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetWidth(statusBarWindow.bounds), 20.f)];
    [statusBarBackgroundView setColors:@[[UIColor colorWithWhite:1 alpha:.9], [UIColor colorWithWhite:1 alpha:.6]]];
    
    [statusBarWindow insertSubview:statusBarBackgroundView atIndex:0];
  }
}

@end
