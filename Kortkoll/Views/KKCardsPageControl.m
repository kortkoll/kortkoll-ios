//
//  KKCardsPageControl.m
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-05-27.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

#import "KKCardsPageControl.h"
@import QuartzCore.QuartzCore;
#import "SKBounceAnimation.h"

const CGSize imageSize = {28.f, 28.f};
const CGFloat downScale = .75f;
const CGFloat downOpacity = .6f;

@interface KKCardsPageControl ()
@property (nonatomic, copy) NSArray *images;
@property (nonatomic, strong) UITapGestureRecognizer *recognizer;

- (void)_recognizerAction:(UITapGestureRecognizer *)sender;
@end

@implementation KKCardsPageControl

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self addGestureRecognizer:self.recognizer];
  }
  return self;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
  [super layoutSublayersOfLayer:layer];
  
  CGSize size = [self sizeThatFits:self.bounds.size];
  CGSize padding = CGSizeMake((CGRectGetWidth(self.bounds)-size.width)/2, (CGRectGetHeight(self.bounds)-size.height)/2);
  
  if (padding.width < 0.f)
    padding.width = 0.f;
  if (padding.height < 0.f)
    padding.height = 0.f;
  
  [self.images enumerateObjectsUsingBlock:^(CALayer *obj, NSUInteger idx, BOOL *stop) {
    [obj setFrame:CGRectMake(idx*imageSize.width+padding.width, padding.height, imageSize.width, imageSize.height)];
  }];
}

- (CGSize)sizeThatFits:(CGSize)size {
  return CGSizeMake(imageSize.height*self.images.count, imageSize.height);
}

#pragma mark - Properties

- (UITapGestureRecognizer *)recognizer {
  if (!_recognizer) {
    _recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_recognizerAction:)];
  }
  return _recognizer;
}

- (void)setNumberOfPages:(NSInteger)numberOfPages {
  if (numberOfPages == _numberOfPages)
    return;
  
  _numberOfPages = numberOfPages;
  NSMutableArray *array = [NSMutableArray new];
  
  CALayer *layer;
  for (int i = 0; i < numberOfPages; i++) {
    layer = [CALayer layer];
    [layer setContents:(id)[UIImage imageNamed:i==0?@"settingsindicator":@"pageindicator"].CGImage];

    if (i != _currentPage) {
      [layer setValue:@(downScale) forKeyPath:@"transform.scale"];
      [layer setOpacity:downOpacity];
    }

    if (_hidesForSinglePage && _numberOfPages == 1)
      [layer setHidden:YES];
    
    [self.layer addSublayer:layer];
    [array addObject:layer];
  }
  
  [self.images makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
  [self setImages:array];
  
  [self setNeedsLayout];
}

- (void)setCurrentPage:(NSInteger)currentPage {
  if (currentPage < 0 || currentPage >= self.images.count || currentPage == _currentPage)
    return;
  
  NSInteger old = _currentPage;
  _currentPage = currentPage;

  CALayer *layer;
  SKBounceAnimation *scaleAnimation, *opacityAnimation;
  NSInteger bounces = 3;
  CFTimeInterval duration = .3;
  
  // Old value
  if (old >= 0 && old < self.images.count) {
    layer = self.images[old];
    
    scaleAnimation = [SKBounceAnimation animationWithKeyPath:@"transform.scale"];
    [scaleAnimation setFromValue:[layer valueForKeyPath:@"transform.scale"]];
    [scaleAnimation setToValue:@(downScale)];
    [scaleAnimation setNumberOfBounces:bounces];
    [scaleAnimation setDuration:duration];
    
    [layer setValue:scaleAnimation.toValue forKeyPath:scaleAnimation.keyPath];
    [layer addAnimation:scaleAnimation forKey:nil];
    
    opacityAnimation = [SKBounceAnimation animationWithKeyPath:@"opacity"];
    [opacityAnimation setFromValue:@(layer.opacity)];
    [opacityAnimation setToValue:@(downOpacity)];
    [opacityAnimation setNumberOfBounces:bounces];
    [opacityAnimation setDuration:duration];
    
    [layer setValue:opacityAnimation.toValue forKeyPath:opacityAnimation.keyPath];
    [layer addAnimation:opacityAnimation forKey:nil];
  }
  
  // New value
  layer = self.images[_currentPage];
  
  scaleAnimation = [SKBounceAnimation animationWithKeyPath:@"transform.scale"];
  [scaleAnimation setFromValue:[layer valueForKeyPath:@"transform.scale"]];
  [scaleAnimation setToValue:@(1.f)];
  [scaleAnimation setNumberOfBounces:bounces];
  [scaleAnimation setDuration:duration];
  
  [layer setValue:scaleAnimation.toValue forKeyPath:scaleAnimation.keyPath];
  [layer addAnimation:scaleAnimation forKey:nil];
  
  opacityAnimation = [SKBounceAnimation animationWithKeyPath:@"opacity"];
  [opacityAnimation setFromValue:@(layer.opacity)];
  [opacityAnimation setToValue:@(1.f)];
  [opacityAnimation setNumberOfBounces:bounces];
  [opacityAnimation setDuration:duration];
  
  [layer setValue:opacityAnimation.toValue forKeyPath:opacityAnimation.keyPath];
  [layer addAnimation:opacityAnimation forKey:nil];
}

- (void)setHidesForSinglePage:(BOOL)hidesForSinglePage {
  if (hidesForSinglePage == _hidesForSinglePage)
    return;
  
  _hidesForSinglePage = hidesForSinglePage;
  
  if (self.images.count == 1)
    [[self.images[0] layer] setHidden:_hidesForSinglePage];
}

#pragma mark - Private

- (void)_recognizerAction:(UITapGestureRecognizer *)sender {
  NSInteger newPage = _currentPage + (([sender locationInView:self].x < CGRectGetWidth(self.bounds)/2)?-1:1);
  
  [self setCurrentPage:newPage];
  
  if (_currentPage == newPage)
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end
