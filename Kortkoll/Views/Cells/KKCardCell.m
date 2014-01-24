//
//  KKCardCell.m
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-05-11.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

#import "KKCardCell.h"
#import "KKCard.h"
#import "KKCardSegmentProductCell.h"
#import "KKCardFlowLayout.h"
#import "KKCardGradientDecorationView.h"
@import Darwin.C.tgmath;

@interface KKCardCell () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *cardNameLabel;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) KKCardFlowLayout *layout;

@property (nonatomic, strong) KKCardGradientDecorationView *topGradientView;
@property (nonatomic, strong) KKCardGradientDecorationView *bottomGradientView;
@end

@implementation KKCardCell

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"card"]];
    [_imageView setFrame:CGRectMake(round((CGRectGetWidth(self.bounds)-CGRectGetWidth(_imageView.bounds))/2),
                                    round((CGRectGetHeight(self.bounds)-CGRectGetHeight(_imageView.bounds))/2),
                                    CGRectGetWidth(_imageView.bounds),
                                    CGRectGetHeight(_imageView.bounds))];
    [_imageView setAutoresizingMask:(UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin)];
    [_imageView setUserInteractionEnabled:YES];

    _cardNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_cardNameLabel setFont:[UIFont kk_boldFontWithSize:12.f]];
    [_cardNameLabel setShadowColor:[UIColor kk_lightTextShadowColor]];
    [_cardNameLabel setShadowOffset:CGSizeMake(0.f, 1.f/[UIScreen mainScreen].scale)];
    [_cardNameLabel setTextColor:[UIColor whiteColor]];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_nameLabel setFont:[UIFont kk_regularFontWithSize:12.f]];
    [_nameLabel setShadowColor:[UIColor kk_lightTextShadowColor]];
    [_nameLabel setShadowOffset:CGSizeMake(0.f, 1.f/[UIScreen mainScreen].scale)];
    [_nameLabel setTextColor:[UIColor whiteColor]];
    
    _topGradientView = [[KKCardGradientDecorationView alloc] initWithFrame:CGRectZero];
    [_topGradientView setColors:@[[UIColor colorWithRed:0.180 green:0.639 blue:0.859 alpha:1.000], [UIColor colorWithRed:0.180 green:0.639 blue:0.859 alpha:0.000]]];
    
    _bottomGradientView = [[KKCardGradientDecorationView alloc] initWithFrame:CGRectZero];
    [_bottomGradientView setColors:@[[UIColor colorWithRed:0.157 green:0.624 blue:0.855 alpha:0.f], [UIColor colorWithRed:0.157 green:0.624 blue:0.855 alpha:1.000]]];
    
    [self.contentView addSubview:self.imageView];
    [self.imageView addSubview:self.cardNameLabel];
    [self.imageView addSubview:self.nameLabel];
    
    [self.imageView addSubview:self.collectionView];
    
    [self.imageView addSubview:self.topGradientView];
    [self.imageView addSubview:self.bottomGradientView];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  CGSize size = [self.cardNameLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.imageView.bounds)-2*24.f, 0.f)];
  [self.cardNameLabel setFrame:CGRectMake(round((CGRectGetWidth(self.imageView.bounds)-size.width)/2), 335.f, size.width, size.height)];
  
  size = [self.nameLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.imageView.bounds)-2*24.f, 0.f)];
  [self.nameLabel setFrame:CGRectMake(round((CGRectGetWidth(self.imageView.bounds)-size.width)/2), 352.f, size.width, size.height)];
  
  [self.topGradientView setFrame:CGRectMake(24.f, 20.f, CGRectGetWidth(self.imageView.bounds)-2*24.f, 15.f)];
  [self.bottomGradientView setFrame:CGRectMake(24.f, CGRectGetHeight(self.imageView.bounds)-15.f-70.f, CGRectGetWidth(self.imageView.bounds)-2*24.f, 15.f)];
}

#pragma mark - Properties

- (UICollectionView *)collectionView {
  if (!_collectionView) {
    _collectionView = [[UICollectionView alloc] initWithFrame:UIEdgeInsetsInsetRect(self.imageView.bounds, UIEdgeInsetsMake(20.f, 24.f, 70.f, 24.f))
                                         collectionViewLayout:self.layout];
    [_collectionView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
    [_collectionView setAlwaysBounceVertical:YES];
    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    [_collectionView setContentInset:UIEdgeInsetsMake(10.f, 0.f, 0.f, 0.f)];
    
    [_collectionView registerClass:KKCardSegmentProductCell.class forCellWithReuseIdentifier:NSStringFromClass(KKCardSegmentProductCell.class)];
  }
  return _collectionView;
}

- (KKCardFlowLayout *)layout {
  if (!_layout) {
    _layout = [KKCardFlowLayout new];
  }
  return _layout;
}

- (void)setCard:(KKCard *)card {
  _card = card;
  [self.cardNameLabel setText:card.name];
  [self.nameLabel setText:card.owner];
  
  [self.collectionView reloadData];
  [self setNeedsLayout];
}

#pragma mark - UICollectionViewFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.item+1 == [collectionView numberOfItemsInSection:indexPath.section])
    return CGSizeMake(CGRectGetWidth(collectionView.bounds), [KKCardSegmentProductCell heightForCard:self.card]);
  else
    return CGSizeMake(CGRectGetWidth(collectionView.bounds), [KKCardSegmentProductCell heightForProduct:self.card.products[indexPath.item]]);
}

#pragma mark - UICollectionViewDataSource
  
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.card.products.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  KKCardSegmentProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(KKCardSegmentProductCell.class) forIndexPath:indexPath];
  
  if (indexPath.item+1 == [collectionView numberOfItemsInSection:indexPath.section])
    [cell setCard:self.card];
  else
    [cell setProduct:self.card.products[indexPath.item]];
  
  return cell;
}

@end
