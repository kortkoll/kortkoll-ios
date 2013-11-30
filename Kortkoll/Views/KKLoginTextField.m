//
//  KKLoginTextField.m
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-05-12.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

#import "KKLoginTextField.h"

@implementation KKLoginTextField

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self setTextColor:[UIColor kk_darkTextColor]];
    [self setFont:[UIFont kk_semiboldFontWithSize:15.f]];
    [self setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self setClearButtonMode:UITextFieldViewModeWhileEditing];
  }
  return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
  return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(6.f, 0.f, 10.f, 0.f));
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
  return [self textRectForBounds:bounds];
}

@end
