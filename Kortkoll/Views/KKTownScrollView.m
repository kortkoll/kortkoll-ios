//
//  KKTownScrollView.m
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-05-15.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

#import "KKTownScrollView.h"
#import "KKTownView.h"
@import Darwin.C.tgmath;

@interface KKTownScrollView ()
@property (nonatomic, strong) KKTownView *townView;
@end

@implementation KKTownScrollView

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
    [self setContentSize:self.bounds.size];
    
    [self setAlwaysBounceHorizontal:YES];
    [self setOpaque:YES];
    
    _townView = [KKTownView new];
    [_townView setFrame:CGRectMake(-round((CGRectGetWidth(_townView.bounds)-CGRectGetWidth(self.bounds))/2),
                                   -(CGRectGetHeight(_townView.bounds)-CGRectGetHeight(self.bounds)),
                                   CGRectGetWidth(_townView.bounds),
                                   CGRectGetHeight(_townView.bounds))];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      UIImage *townImage = [UIImage imageNamed:@"stad"];
      
      UIGraphicsBeginImageContextWithOptions(CGSizeMake(1.f, townImage.size.height), YES, townImage.scale);
      [townImage drawAtPoint:CGPointZero];
      UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
      UIGraphicsEndImageContext();
      
      dispatch_async(dispatch_get_main_queue(), ^{
        [self setBackgroundColor:[UIColor colorWithPatternImage:image]];
      });
    });
    
    [self addSubview:_townView];
  }
  return self;
}

#pragma mark - Properties

- (BOOL)animating {
  return self.townView.animating;
}

- (void)setAnimating:(BOOL)animating {
  [self.townView setAnimating:animating];
}

@end
