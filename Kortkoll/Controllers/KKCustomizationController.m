//
//  KKCustomizationController.m
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-11-24.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

#import "KKCustomizationController.h"

@implementation KKCustomizationController

+ (void)customize {
  UIWindow *statusBarWindow = [[UIApplication sharedApplication] valueForKey:[NSString stringWithFormat:@"%@Window", @"statusBar"]];
  
  if (statusBarWindow && [statusBarWindow isKindOfClass:[UIWindow class]]) {
    UINavigationBar *statusBarBackgroundView = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetWidth(statusBarWindow.bounds), 20.f)];
    [statusBarBackgroundView setTranslucent:YES];
    [statusBarBackgroundView setBarStyle:UIBarStyleBlack];
    [statusBarBackgroundView setBarTintColor:[[UIColor kk_darkTextColor] colorWithAlphaComponent:.5f]];
    
    [statusBarWindow insertSubview:statusBarBackgroundView atIndex:0];
  }
}

@end
