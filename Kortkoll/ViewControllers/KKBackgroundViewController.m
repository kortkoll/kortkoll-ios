//
//  KKBackgroundViewController.m
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-05-11.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

#import "KKBackgroundViewController.h"
#import "KKTownScrollView.h"
#import "KKConditionalRunner.h"
#import "MAKVONotificationCenter.h"

#import "KKHUD.h"
#import "KKWelcomeHUDView.h"

#import "KKLoginViewController.h"
#import "KKCardsViewController.h"

@interface KKBackgroundViewController ()
@property (nonatomic, strong) UINavigationBar *statusBarBackgroundView;

@property (nonatomic, strong) KKTownScrollView *scrollView;
@end

@implementation KKBackgroundViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.view addSubview:self.scrollView];
  [self.view addSubview:self.statusBarBackgroundView];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  [self.scrollView setAnimating:YES];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(_applicationDidBecomeActiveNotification:)
                                               name:UIApplicationDidBecomeActiveNotification
                                             object:nil];
  
  [KKConditionalRunner runIfIdentifier:@"info" notSet:^{
    KKWelcomeHUDView *view = [KKWelcomeHUDView new];
    [view addObserver:self keyPath:@"presented" options:(NSKeyValueObservingOptionNew) block:^(MAKVONotification *notification) {
      if ([notification.newValue isEqual:@NO]) {
        [self _presentViewController:self];
      }
    }];
    
    [[KKHUD HUD] showHUDItem:view];
  } set:^{
      [self _presentViewController:self];
  }];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  
  [self.scrollView setAnimating:NO];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UIApplicationDidBecomeActiveNotification
                                                object:nil];
}

#pragma mark - Properties

- (KKTownScrollView *)scrollView {
  if (!_scrollView) {
    _scrollView = [[KKTownScrollView alloc] initWithFrame:self.view.bounds];
  }
  return _scrollView;
}

#pragma mark - Private

- (void)_presentViewController:(id)sender {
  if ([KKApp password].length > 0 && [KKApp userName].length > 0) {
    KKCardsViewController *cardsViewController = [KKCardsViewController new];
    
    [cardsViewController setTransitioningDelegate:cardsViewController];
    [cardsViewController setModalPresentationStyle:UIModalPresentationCustom];
    
    [self presentViewController:cardsViewController animated:YES completion:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_presentViewController:) name:KKUserDidLogoutNotification object:cardsViewController];
  } else {
    KKLoginViewController *loginViewController = [KKLoginViewController new];

    [loginViewController setTransitioningDelegate:loginViewController];
    [loginViewController setModalPresentationStyle:UIModalPresentationCustom];
    
    [self presentViewController:loginViewController animated:YES completion:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_presentViewController:) name:KKUserDidLoginNotification object:loginViewController];
  }
}

- (void)_applicationDidBecomeActiveNotification:(NSNotification *)notification {
  [self.scrollView setAnimating:YES];
}

@end
