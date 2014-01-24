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
@end

@implementation KKSettingsCell

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self addSubview:self.collectionView];
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
    [_collectionView setContentInset:UIEdgeInsetsMake(0, 0, self.layout.bottomPadding, 0)];
    
    [_collectionView registerClass:KKSettingsInfoCell.class forCellWithReuseIdentifier:NSStringFromClass(KKSettingsInfoCell.class)];
    [_collectionView registerClass:KKSettingsButtonCell.class forCellWithReuseIdentifier:NSStringFromClass(KKSettingsButtonCell.class)];
  }
  return _collectionView;
}

- (KKCollectionViewSettingsLayout *)layout {
  if (!_layout) {
    _layout = [[KKCollectionViewSettingsLayout alloc] init];
    [_layout setMinimumInteritemSpacing:0];
    [_layout setMinimumLineSpacing:0];
    [_layout setBottomPadding:48];
  }
  return _layout;
}

#pragma mark - Private (TEMP)

- (void)_logout:(id)sender {
  [KKApp setUsername:nil];
  [KKApp setPassword:nil];
  [[KKLibrary library] setCards:nil];
  
  [self.viewController dismissViewControllerAnimated:YES completion:^{
    [[NSNotificationCenter defaultCenter] postNotificationName:KKUserDidLogoutNotification object:self.viewController];
  }];
}

#pragma mark - UICollectionViewFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  CGFloat height = 0;
  
  if (indexPath.item == 0) height = [KKSettingsInfoCell height];
  else if (indexPath.item == 1) height = [KKSettingsButtonCell height];
  
  return CGSizeMake(CGRectGetWidth(collectionView.bounds), height);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.item == 0) {
    return [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(KKSettingsInfoCell.class) forIndexPath:indexPath];
  }
  else if (indexPath.item == 1) {
    KKSettingsButtonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(KKSettingsButtonCell.class) forIndexPath:indexPath];
    [cell.button setTitle:@"Logga ut" forState:UIControlStateNormal];
    [cell.button addTarget:self action:@selector(_logout:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
  }
  
  return nil;
}

@end

