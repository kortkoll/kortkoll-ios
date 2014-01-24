//
//  KKSettingsButtonCell.m
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-07-01.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

#import "KKSettingsButtonCell.h"

@implementation KKSettingsButtonCell

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self.contentView addSubview:self.button];
  }
  return self;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  [self.button.allTargets enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
    [self.button removeTarget:obj action:NULL forControlEvents:UIControlEventAllEvents];
  }];
}

- (UIButton *)button {
  if (!_button) {
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button setFrame:self.bounds];
    [_button setAutoresizingMask:(UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth)];
    [_button.titleLabel setFont:[UIFont kk_boldFontWithSize:18.f]];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button setBackgroundImage:[UIImage imageNamed:@"buttonblue"] forState:UIControlStateNormal];
    [_button setBackgroundImage:[UIImage imageNamed:@"buttonbluetap"] forState:UIControlStateHighlighted];
    [_button setTitleEdgeInsets:UIEdgeInsetsMake(6.f, 0.f, 0.f, 0.f)];
  }
  return _button;
}

+ (CGFloat)height {
  return 56.f;
}

@end
