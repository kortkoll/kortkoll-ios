//
//  KKAppDelegate.m
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-05-06.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

#import "KKAppDelegate.h"
#import <Crashlytics/Crashlytics.h>
#import "LocalyticsSession.h"
#import "KKCustomizationController.h"
#import "KKMigrationController.h"
#import "KKCardsViewController.h"
#import "KKBackgroundViewController.h"

@implementation KKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#ifdef LIVE
  [Crashlytics startWithAPIKey:KKCrashlyticsAPIKey];
  [[LocalyticsSession shared] startSession:KKLocalyticsAppKey];
#endif

  [KKCustomizationController customize];
  [KKMigrationController migrate];
  
  return YES;
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
  KKBackgroundViewController *backgroundViewController = (KKBackgroundViewController *)self.window.rootViewController;
  [backgroundViewController.cardsViewController performFetchWithCompletionHandler:completionHandler];
}

#ifdef LIVE
- (void)applicationWillResignActive:(UIApplication *)application {
  [[LocalyticsSession shared] close];
  [[LocalyticsSession shared] upload];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  [[LocalyticsSession shared] resume];
  [[LocalyticsSession shared] upload];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  [[LocalyticsSession shared] close];
  [[LocalyticsSession shared] upload];
}

- (void)applicationWillTerminate:(UIApplication *)application {
  [[LocalyticsSession shared] close];
  [[LocalyticsSession shared] upload];
}
#endif

@end
