//
//  KKCollectionViewCardLayout.m
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-11-29.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

#import "KKCollectionViewCardLayout.h"
#import "KKCardSeparatorDecorationView.h"
@import Darwin.C.tgmath;

@implementation KKCollectionViewCardLayout

- (id)init {
  if (self = [super init]) {
    [self registerClass:KKCardSeparatorDecorationView.class forDecorationViewOfKind:NSStringFromClass(KKCardSeparatorDecorationView.class)];
    [self setMinimumInteritemSpacing:0.f];
    [self setMinimumLineSpacing:30.f];
  }
  return self;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
  NSMutableArray *attributes = [NSMutableArray new];
  
  // Add items
  for (NSInteger i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++) {
    UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
    [attributes addObject:attribute];
    
    // …and separators
    if (attribute.representedElementCategory == UICollectionElementCategoryCell && (attribute.indexPath.item + 1) != [self.collectionView numberOfItemsInSection:attribute.indexPath.section])
      [attributes addObject:[self layoutAttributesForDecorationViewOfKind:NSStringFromClass(KKCardSeparatorDecorationView.class) atIndexPath:attribute.indexPath]];
  }
  
  return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
  
  CGSize contentSize = [self collectionViewContentSize];
  CGSize boundsSize = self.collectionView.bounds.size;
  
  CGRect frame = attributes.frame;
  frame.origin.y += MAX(0, ((boundsSize.height - contentSize.height)/2));
  [attributes setFrame:frame];
  
  return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)decorationViewKind atIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:NSStringFromClass(KKCardSeparatorDecorationView.class)
                                                                                                             withIndexPath:indexPath];
  
  CGRect frame = [self layoutAttributesForItemAtIndexPath:indexPath].frame;

  CGSize size = CGSizeMake(46, 6);
  [attributes setFrame:CGRectMake(round((CGRectGetWidth(frame)-size.width)/2), CGRectGetMaxY(frame)+round((self.minimumLineSpacing-size.height)/2), size.width, size.height)];
  
  return attributes;
}

@end
