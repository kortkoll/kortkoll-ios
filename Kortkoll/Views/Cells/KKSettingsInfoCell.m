//
//  KKSettingsInfoCell.m
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-07-18.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

#import "KKSettingsInfoCell.h"
#import "TTTAttributedLabel.h"
#import "KKText.h"

@interface KKSettingsInfoCell () <TTTAttributedLabelDelegate>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) TTTAttributedLabel *infoLabel;
@property (nonatomic, strong) UIImageView *infoImageView;
@property (nonatomic, strong) KKText *text;
@end

@implementation KKSettingsInfoCell

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    
    [self setInfoImageView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"info"]]];
    
    [self.contentView addSubview:self.infoImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.infoLabel];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  [self.infoImageView setFrame:CGRectMake(10.f, 10.f, CGRectGetWidth(self.infoImageView.bounds), CGRectGetHeight(self.infoImageView.bounds))];
  [self.titleLabel setFrame:CGRectMake(50.f, 18.f, 0.f, 0.f)];
  [self.titleLabel sizeToFit];
  
  CGSize s = [_infoLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.bounds)-24.f, CGFLOAT_MAX)];
  [self.infoLabel setFrame:CGRectMake(12.f, 15.f+CGRectGetHeight(self.infoImageView.bounds), s.width, s.height)];
}

#pragma mark - Properties

- (UILabel *)titleLabel {
  if (!_titleLabel) {
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_titleLabel setFont:[UIFont kk_semiboldFontWithSize:18.f]];
    [_titleLabel setTextColor:[UIColor kk_headerColor]];
    [_titleLabel setText:@"Kortkoll"];
  }
  return _titleLabel;
}

- (TTTAttributedLabel *)infoLabel {
  if (!_infoLabel) {
    _infoLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    [_infoLabel setNumberOfLines:0];

    KKText *text = [KKText infoText];
    [self setText:text];
    
    [_infoLabel setDelegate:text];
    [_infoLabel setAttributedText:text.attributedString];
    [_infoLabel setLinkAttributes:text.linkAttributes];
    [_infoLabel setActiveLinkAttributes:text.activeLinkAttributes];
    
    [text.links enumerateKeysAndObjectsUsingBlock:^(NSValue *key, NSURL *obj, BOOL *stop) {
      [self.infoLabel addLinkToURL:obj withRange:key.rangeValue];
    }];
  }
  return _infoLabel;
}

#pragma mark - Public

+ (CGFloat)height {
  return 310.f;
}

@end
