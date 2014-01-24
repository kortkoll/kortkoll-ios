//
//  KKCollectionViewSettingsLayout.m
//  Kortkoll
//
//  Created by Simon Blommegård on 2014-01-24.
//  Copyright (c) 2014 Kortkoll. All rights reserved.
//

#import "KKCollectionViewSettingsLayout.h"
#import "KKSettingsSeparatorDecorationView.h"

@implementation KKCollectionViewSettingsLayout

- (id)init {
  if (self = [super init]) {
    [self registerClass:KKSettingsSeparatorDecorationView.class forDecorationViewOfKind:NSStringFromClass(KKSettingsSeparatorDecorationView.class)];
  }
  return self;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
  NSMutableArray *attributes = [NSMutableArray new];

  // Add items
  for (NSInteger i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++) {
    [attributes addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]]];
  }

  // Add top separator
  [attributes addObject:[self layoutAttributesForDecorationViewOfKind:NSStringFromClass(KKSettingsSeparatorDecorationView.class)
                                                          atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]]];
  
  return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
  
  CGSize contentSize = [self collectionViewContentSize];
  CGSize boundsSize = self.collectionView.bounds.size;
  
  CGRect frame = attributes.frame;
  frame.origin.y += (boundsSize.height - contentSize.height - self.bottomPadding);
  [attributes setFrame:frame];
  
  return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:NSStringFromClass(KKSettingsSeparatorDecorationView.class)
                                                                                                             withIndexPath:indexPath];
  
  CGRect frame = [self layoutAttributesForItemAtIndexPath:indexPath].frame;
  frame.size.height = 1;
  frame.origin.y = frame.origin.y - 1;
  
  [attributes setFrame:frame];
  
  return attributes;
}

@end
