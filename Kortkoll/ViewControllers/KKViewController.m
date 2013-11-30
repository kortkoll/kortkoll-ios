//
//  KKViewController.m
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-05-11.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

#import "KKViewController.h"
#import "LocalyticsSession.h"

@interface KKViewController ()

@end

@implementation KKViewController

#ifdef LIVE
- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  NSString *screen = NSStringFromClass(self.class);

  NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:@"^KK(.+)ViewController$" options:0 error:NULL];
  NSTextCheckingResult *result = [expression firstMatchInString:screen options:0 range:NSMakeRange(0, screen.length)];
  
  if (result.numberOfRanges > 1)
    [[LocalyticsSession shared] tagScreen:[screen substringWithRange:[result rangeAtIndex:1]]];
}
#endif

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

- (BOOL)shouldAutorotate {
  return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
  return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
  return UIInterfaceOrientationPortrait;
}

@end
