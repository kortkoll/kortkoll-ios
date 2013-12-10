//
//  KKSettingsCell.m
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-06-30.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

#import "KKSettingsCell.h"
#import "KKSettingsButtonCell.h"
#import "KKSettingsInfoCell.h"
#import "KKCollectionViewSettingsLayout.h"
#import "KKAppDelegate.h"
#import "KKBackgroundViewController.h"
#import "KKLibrary.h"

@interface KKSettingsCell () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) KKCollectionViewSettingsLayout *layout;

@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation KKSettingsCell

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self addSubview:self.scrollView];
  }
  return self;
}

#pragma mark - Properties

- (UICollectionView *)collectionView {
  if (!_collectionView) {
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.layout];
    [_collectionView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
    [_collectionView setAlwaysBounceVertical:YES];
    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    [_collectionView setContentInset:UIEdgeInsetsMake(0.f, 0.f, 48.f, 0.f)];
    
    [_collectionView registerClass:KKSettingsButtonCell.class forCellWithReuseIdentifier:NSStringFromClass(KKSettingsButtonCell.class)];
  }
  return _collectionView;
}

- (KKCollectionViewSettingsLayout *)layout {
  if (!_layout) {
    _layout = [[KKCollectionViewSettingsLayout alloc] init];
  }
  return _layout;
}

#warning Temporary, we should be using the collection view here instead with a nice layout.
- (UIScrollView *)scrollView {
  if (!_scrollView) {
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [_scrollView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
    [_scrollView setContentSize:self.bounds.size];
    [_scrollView setAlwaysBounceVertical:YES];
    
    KKSettingsButtonCell *cell = [[KKSettingsButtonCell alloc] initWithFrame:CGRectMake(0.f, CGRectGetHeight(self.bounds)-[KKSettingsButtonCell height]-48.f, CGRectGetWidth(self.bounds), [KKSettingsButtonCell height])];
    [cell.button setTitle:@"Logga ut" forState:UIControlStateNormal];
 
    [cell.button addTarget:self action:@selector(_logout:) forControlEvents:UIControlEventTouchUpInside];
    
    [_scrollView addSubview:cell];
    
    KKSettingsInfoCell *cell2 = [[KKSettingsInfoCell alloc] initWithFrame:CGRectMake(0.f, CGRectGetMinY(cell.frame)-[KKSettingsInfoCell height], CGRectGetWidth(self.bounds), [KKSettingsInfoCell height])];
    
    [_scrollView addSubview:cell2];
    
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0.f, CGRectGetMinY(cell2.frame)-1.f, CGRectGetWidth(self.bounds), 1.f)];
    [separator setBackgroundColor:[UIColor colorWithWhite:0.f alpha:.2f]];
    
    [_scrollView addSubview:separator];
  }
  return _scrollView;
}

#pragma mark - Private (TEMP)

- (void)_logout:(id)sender {
  [KKApp setUserName:nil];
  [KKApp setPassword:nil];
  [[KKLibrary library] setCards:nil];
  
  [self.viewController dismissViewControllerAnimated:YES completion:^{
    [[NSNotificationCenter defaultCenter] postNotificationName:KKUserDidLogoutNotification object:self.viewController];
  }];
}

#pragma mark - UICollectionViewFlowLayout

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath {
  return [KKSettingsButtonCell height];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  KKSettingsButtonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(KKSettingsButtonCell.class) forIndexPath:indexPath];
  [cell.button setTitle:@"Logga ut" forState:UIControlStateNormal];
  return cell;
}

@end

