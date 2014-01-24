//
//  KKSettingsSeparatorDecorationView.m
//  Kortkoll
//
//  Created by Simon Blommegård on 2014-01-24.
//  Copyright (c) 2014 Kortkoll. All rights reserved.
//

#import "KKSettingsSeparatorDecorationView.h"

@implementation KKSettingsSeparatorDecorationView

- (id)initWithFrame:(CGRect)frame {
  if ([super initWithFrame:frame]) {
    [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:.2]];
  }
  return self;
}

@end
