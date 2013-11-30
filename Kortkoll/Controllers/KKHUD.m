//
//  KKHUD.m
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-07-23.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

#import "KKHUD.h"

@interface KKHUDViewController : UIViewController
@end

@interface KKHUD ()
@property (nonatomic, strong) UIWindow *HUDWindow;
@property (nonatomic, strong) UIWindow *backgroundWindow;
@property (nonatomic, strong) UIWindow *keyWindow;
@property (nonatomic, strong) KKHUDViewController *viewController;
@property (nonatomic, strong) KKHUDViewController *backgroundViewController;
@property (nonatomic, strong) NSMutableArray *queue;
@end

@implementation KKHUD

- (id)init {
  if (self = [super init]) {
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate respondsToSelector:@selector(window)])
      [self setKeyWindow:[delegate performSelector:@selector(window)]];
    else
      [self setKeyWindow:[[UIApplication sharedApplication] keyWindow]];
    
    [self setQueue:[NSMutableArray new]];
  }
  return self;
}

#pragma mark - Properties

- (UIWindow *)HUDWindow {
  if (!_HUDWindow) {
    _HUDWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_HUDWindow setWindowLevel:UIWindowLevelAlert];
    [_HUDWindow setBackgroundColor:[UIColor clearColor]];
    
    [_HUDWindow setRootViewController:self.viewController];
  }
  return _HUDWindow;
}

- (UIWindow *)backgroundWindow {
  if (!_backgroundWindow) {
    _backgroundWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_backgroundWindow setWindowLevel:UIWindowLevelNormal];
    [_backgroundWindow setBackgroundColor:[UIColor clearColor]];
    
    [_backgroundWindow setRootViewController:self.backgroundViewController];
  }
  return _backgroundWindow;
}

- (KKHUDViewController *)viewController {
  if (!_viewController) {
    _viewController = [KKHUDViewController new];
  }
  return _viewController;
}

- (KKHUDViewController *)backgroundViewController {
  if (!_backgroundViewController) {
    _backgroundViewController = [KKHUDViewController new];
  }
  return _backgroundViewController;
}

#pragma mark - Public

+ (instancetype)HUD {
  static KKHUD *HUD;
  static dispatch_once_t onceToken;
  
  dispatch_once(&onceToken, ^{
    HUD = [KKHUD new];
  });
  
  return HUD;
}

- (void)showHUDItem:(id <KKHUDItem>)item {
  [self.queue addObject:item];
  
  if (self.queue.count == 1) {
    [self _willShowFirstHUDItem];
    [self _showHUDItem:self.queue[0]];
  }
}

- (void)hideHUDItem:(id <KKHUDItem>)item {
  [self _hideHUDItem:item completion:^{
    [self.queue removeObject:item];
    
    if (self.queue.count > 0)
      [self _showHUDItem:self.queue[0]];
    else
      [self _didHideLastHUDItem];
  }];
}

#pragma mark - Private

- (void)_showHUDItem:(id <KKHUDItem>)item {
  if (!item.presented)
    [item showInView:self.viewController.view backgroundView:self.backgroundViewController.view completion:^{
      [item setPresented:YES];
    }];
}

- (void)_hideHUDItem:(id <KKHUDItem>)item completion:(void(^)())completion {
  if (item.presented)
    [item hideBackgroundView:self.backgroundViewController.view completion:^{
      completion();
      [item setPresented:NO];
    }];
}

- (void)_willShowFirstHUDItem {
  [self.backgroundWindow makeKeyAndVisible];
  [self.HUDWindow makeKeyAndVisible];
}

- (void)_didHideLastHUDItem {
  [self.HUDWindow removeFromSuperview];
  [self.backgroundWindow removeFromSuperview];
  
  [self.keyWindow makeKeyAndVisible];
  
  [self setHUDWindow:nil];
  [self setBackgroundWindow:nil];
}

@end

@implementation KKHUDViewController

- (BOOL)wantsFullScreenLayout {
  return YES;
}

// Keep the rotate-stuff as our main UI, yeah, I know we should find the presented one…
- (BOOL)shouldAutorotate {
  return KKHUD.HUD.keyWindow.rootViewController.shouldAutorotate;
}

- (NSUInteger)supportedInterfaceOrientations {
  return KKHUD.HUD.keyWindow.rootViewController.supportedInterfaceOrientations;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

@end
