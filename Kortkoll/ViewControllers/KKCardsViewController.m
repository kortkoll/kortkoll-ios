//
//  KKCardsViewController.m
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-11-24.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

#import "KKCardsViewController.h"
#import "KKListCardsBottomView.h"
#import "KKLibrary.h"
#import "KKCardsPageControl.h"
#import "MAKVONotificationCenter.h"
#import "KKAPISessionManager.h"

#import "KKCardCell.h"
#import "KKSettingsCell.h"

#import "KKCard.h"

@interface KKCardsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIViewControllerAnimatedTransitioning>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) KKListCardsBottomView *bottomView;
@end

@implementation KKCardsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.view addSubview:self.backgroundView];
  [self.view addSubview:self.collectionView];
  [self.view addSubview:self.bottomView];
  
  [KKLibrary.library addObserver:self keyPath:@"cards" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial block:^(MAKVONotification *notification) {
    [self.bottomView.pageControl setNumberOfPages:KKLibrary.library.cards.count+1];
    [self.collectionView reloadData];
  }];
  
  // Scroll to first card
  if (KKLibrary.library.cards.count > 0) {
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionLeft
                                        animated:NO];
    [self.bottomView.pageControl setCurrentPage:1];
  }
  
  [self _updateAction:self];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_updateAction:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

#pragma mark - Properties

- (UICollectionView *)collectionView {
  if (!_collectionView) {
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.layout];
    [_collectionView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth)];
    [_collectionView setPagingEnabled:YES];
    [_collectionView setAlwaysBounceHorizontal:YES];
    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    [_collectionView setShowsHorizontalScrollIndicator:NO];
    [_collectionView setClipsToBounds:NO];
    
    [_collectionView registerClass:KKCardCell.class forCellWithReuseIdentifier:NSStringFromClass(KKCardCell.class)];
    [_collectionView registerClass:KKSettingsCell.class forCellWithReuseIdentifier:NSStringFromClass(KKSettingsCell.class)];
  }
  return _collectionView;
}

- (UICollectionViewFlowLayout *)layout {
  if (!_layout) {
    _layout = [[UICollectionViewFlowLayout alloc] init];
    [_layout setItemSize:self.view.bounds.size];
    [_layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [_layout setMinimumInteritemSpacing:0.f];
    [_layout setMinimumLineSpacing:0.f];
    [_layout setSectionInset:UIEdgeInsetsZero];
  }
  return _layout;
}

- (KKListCardsBottomView *)bottomView {
  if (!_bottomView) {
    _bottomView = [[KKListCardsBottomView alloc] initWithFrame:CGRectMake(0.f,
                                                                          CGRectGetHeight(self.view.bounds)-kKKListCardsBottomViewHeight,
                                                                          CGRectGetWidth(self.view.bounds),
                                                                          kKKListCardsBottomViewHeight)];
    [_bottomView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth];
    
    [_bottomView.pageControl addTarget:self action:@selector(_pageControlAction:) forControlEvents:UIControlEventValueChanged];
    [_bottomView.updateButton addTarget:self action:@selector(_updateAction:) forControlEvents:UIControlEventTouchUpInside];
  }
  return _bottomView;
}

- (UIView *)backgroundView {
  if (!_backgroundView) {
    _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.f,
                                                               20.f,
                                                               CGRectGetWidth(self.view.bounds),
                                                               CGRectGetHeight(self.view.bounds)-20.f)];
    [_backgroundView setBackgroundColor:[UIColor colorWithWhite:1.f alpha:.6f]];
  }
  return _backgroundView;
}

#pragma mark - Private

- (void)_pageControlAction:(KKCardsPageControl *)pageControl {
  [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:pageControl.currentPage inSection:0]
                              atScrollPosition:UICollectionViewScrollPositionLeft
                                      animated:YES];
}

- (void)_updateAction:(id)sender {
  if ([KKApp username] && [KKApp password] && self.bottomView.state != KKListCardsBottomViewStateLoading) {
    [self.bottomView setState:KKListCardsBottomViewStateLoading];
    [[KKAPISessionManager client] POST:@"session"
                            parameters:@{@"username":[KKApp username], @"password":[KKApp password]}
                               success:^(NSURLSessionDataTask *task, id responseObject) {
                                 [[KKAPISessionManager client] GET:@"cards"
                                                        parameters:nil
                                                           success:^(NSURLSessionDataTask *task, id responseObject) {
                                                             [self.bottomView setState:KKListCardsBottomViewStateDefault];
                                                             
                                                             [KKLibrary.library setUnparsedCards:responseObject];
                                                           } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                             [self.bottomView setState:KKListCardsBottomViewStateDefault];
                                                           }];
                               } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                 [self.bottomView setState:KKListCardsBottomViewStateDefault];
                               }];
  }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return KKLibrary.library.cards.count+1; // Settings
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.item == 0) {
    KKSettingsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(KKSettingsCell.class) forIndexPath:indexPath];
    [cell setViewController:self];
    return cell;
  }
  else {
    KKCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(KKCardCell.class) forIndexPath:indexPath];
    [cell setCard:KKLibrary.library.cards[indexPath.item-1]];
    
    return cell;
  }
  
  return nil;
}

#pragma mark - UICollectionViewDelegate

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  
  // Background alpha
  CGFloat max = .6f;
  CGFloat lol = 0.f;
  
  if (scrollView.contentOffset.x < 0.f)
    lol = -scrollView.contentOffset.x;
  if (scrollView.contentOffset.x > scrollView.contentSize.width-CGRectGetWidth(scrollView.bounds))
    lol = -(scrollView.contentSize.width-CGRectGetWidth(scrollView.bounds)-scrollView.contentOffset.x);
  
  if (lol > 0.f) {
    CGFloat alpha = max * (80.f-lol)/80.f;
    [self.backgroundView setBackgroundColor:[UIColor colorWithWhite:1.f alpha:(scrollView.contentSize.width > 0.f)?alpha:max]]; // Ugly check.
  }
  
  // Page control
  [self.bottomView.pageControl setCurrentPage:roundf(scrollView.contentOffset.x/CGRectGetWidth(scrollView.bounds))];
}

#pragma mark - UIViewControllerTransitioningDelegate

#pragma mark - UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
  return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
  return self;
}

// Skip interactive for now
- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
  return nil;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
  return nil;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
  return .4f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
  UIView *contentView = [transitionContext containerView];
  
  BOOL presenting = ([transitionContext viewControllerForKey:UITransitionContextToViewControllerKey] == self);
  
  /*
   - (CGRect)initialFrameForViewController:(UIViewController *)vc;
   - (CGRect)finalFrameForViewController:(UIViewController *)vc;
   */
  
  if (presenting) {
    // Preparation
    [self.view setAlpha:0.f];
    [contentView addSubview:self.view];
  }
  
  [UIView animateWithDuration:[self transitionDuration:transitionContext]
                   animations:^{
                     [self.view setAlpha:presenting?1.f:0.f];
                   } completion:^(BOOL finished) {
                     if (!presenting)
                       [self.view removeFromSuperview];
                     
                     [transitionContext completeTransition:finished];
                   }];
}


@end
