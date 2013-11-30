//
//  KKCardGradientDecorationView.m
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-11-29.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

#import "KKCardGradientDecorationView.h"
#import "SBDrawingHelpers.h"

@interface KKCardGradientDecorationView ()
@property (nonatomic) CGGradientRef gradiet;
@end

@implementation KKCardGradientDecorationView

- (void)dealloc {
  [self setGradiet:nil];
}

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self setBackgroundColor:[UIColor clearColor]];
    [self setContentMode:UIViewContentModeRedraw];
  }
  return self;
}

#pragma mark - Properties

- (void)setColors:(NSArray *)colors {
  _colors = [colors copy];
  
  [self setGradiet:SBCreateGradientWithColors(colors)];
  
  [self setNeedsDisplay];
}

- (void)setGradiet:(CGGradientRef)gradiet {
  if (_gradiet)
    CGGradientRelease(_gradiet);
  
  _gradiet = gradiet;
}

- (void)drawRect:(CGRect)rect {
  SBDrawGradientInRect(self.gradiet, self.bounds, 0);
}

@end
