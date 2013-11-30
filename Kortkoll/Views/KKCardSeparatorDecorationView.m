//
//  KKCardSeparatorDecorationView.m
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-11-29.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

#import "KKCardSeparatorDecorationView.h"

@implementation KKCardSeparatorDecorationView

- (id)initWithFrame:(CGRect)frame {
  if ([super initWithFrame:frame]) {
    [self.layer setContents:(id)[UIImage imageNamed:@"Dots"].CGImage];
  }
  return self;
}

@end
