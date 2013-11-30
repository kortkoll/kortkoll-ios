//
//  KKCardFlowLayout.m
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-11-29.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

#import "KKCardFlowLayout.h"
#import "KKCardSeparatorDecorationView.h"
@import Darwin.C.tgmath;

@implementation KKCardFlowLayout

- (id)init {
  if (self = [super init]) {
    [self registerClass:KKCardSeparatorDecorationView.class forDecorationViewOfKind:NSStringFromClass(KKCardSeparatorDecorationView.class)];
    [self setMinimumInteritemSpacing:0.f];
    [self setMinimumLineSpacing:30.f];
  }
  return self;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
  NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
  NSMutableArray *decorationViewAttributes = [NSMutableArray new];
  
  for (UICollectionViewLayoutAttributes *attribute in attributes) {
    // Dont add a separator in the bottom
    if (attribute.representedElementCategory == UICollectionElementCategoryCell && (attribute.indexPath.item + 1) != [self.collectionView numberOfItemsInSection:attribute.indexPath.section])
      [decorationViewAttributes addObject:[self layoutAttributesForDecorationViewOfKind:NSStringFromClass(KKCardSeparatorDecorationView.class) atIndexPath:attribute.indexPath]];
  }
  
  return [attributes arrayByAddingObjectsFromArray:decorationViewAttributes];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)decorationViewKind atIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:NSStringFromClass(KKCardSeparatorDecorationView.class)
                                                                                                             withIndexPath:indexPath];
  
  CGRect frame = [self layoutAttributesForItemAtIndexPath:indexPath].frame;
  
  CGSize size = CGSizeMake(46.f, 6.f);
  [attributes setFrame:CGRectMake(round((CGRectGetWidth(frame)-size.width)/2), CGRectGetMaxY(frame)+round((self.minimumLineSpacing-size.height)/2), size.width, size.height)];
  
  return attributes;
}

@end
