//
//  KKCollectionViewSettingsLayout.m
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-07-03.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

#import "KKCollectionViewSettingsLayout.h"

@interface KKCollectionViewSettingsLayout ()
@property (nonatomic, copy) NSArray *allAttributes;
@property (nonatomic, assign) CGFloat height;

@end

@implementation KKCollectionViewSettingsLayout


- (void)prepareLayout {
  [super prepareLayout];

  _height = 0.f;
  CGFloat height = 0.f;
  CGFloat heights = 0.f;
  [self.collectionView setClipsToBounds:NO];
  NSMutableArray *array = [NSMutableArray new];
  
  for (NSInteger i = 0; i<[self.collectionView numberOfItemsInSection:0]; i++) {
    id <KKCollectionViewDelegateSettingsLayout> delegate = (id <KKCollectionViewDelegateSettingsLayout>)self.collectionView.delegate;
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
    
    height = [delegate collectionView:self.collectionView layout:self heightForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
    
    [attributes setFrame:CGRectMake(0.f, heights, CGRectGetWidth(self.collectionView.bounds), height)];
    
    heights += height;
    
    [array addObject:attributes];
  }
  
  _height = heights;
  [self setAllAttributes:array];
  
  
  if (heights < CGRectGetHeight(self.collectionView.bounds)) {
    for (UICollectionViewLayoutAttributes *attributes in array) {
      CGRect frame = attributes.frame;
      frame.origin.y += 200.f;
      [attributes setFrame:frame];
    }
  }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
  
  NSMutableArray *array = [NSMutableArray new];
  
  for (UICollectionViewLayoutAttributes *attributes in self.allAttributes) {
    if (CGRectIntersectsRect(rect, attributes.frame))
      [array addObject:attributes];
  }
  
  return array;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
  return self.allAttributes[indexPath.item];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
  return NO;
}

- (CGSize)collectionViewContentSize {
  return CGSizeMake(CGRectGetWidth(self.collectionView.bounds), _height);
}

@end
