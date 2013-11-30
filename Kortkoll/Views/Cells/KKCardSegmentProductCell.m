//
//  KKCardSegmentProductCell.m
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-05-15.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

#import "KKCardSegmentProductCell.h"
#import "KKProduct.h"
#import "KKCard.h"
#import "NSDate+KKExtras.h"
#import "KKNumberLabel.h"

@implementation KKCardSegmentProductCell

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self addSubview:self.numberLabel];
    [self addSubview:self.detailsLabel];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  [self.numberLabel setFrame:CGRectMake(0.f, 5.f, CGRectGetWidth(self.bounds), 50.f)];
  
  CGSize size = [self.detailsLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.bounds), 0.f)];
  [self.detailsLabel setFrame:CGRectMake(round((CGRectGetWidth(self.bounds)-size.width)/2), 70.f, size.width, size.height)];
}

#pragma mark - Properties

- (KKNumberLabel *)numberLabel {
  if (!_numberLabel) {
    _numberLabel = [[KKNumberLabel alloc] initWithFrame:CGRectZero];
  }
  return _numberLabel;
}

- (UILabel *)detailsLabel {
  if (!_detailsLabel) {
    _detailsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  }
  return _detailsLabel;
}

@end

@implementation KKCardSegmentProductCell (KKCard)

- (void)setProduct:(KKProduct *)product {
  [self.numberLabel setNumber:@([[NSDate date] kk_daysToDate:product.endDate]) withFormatter:nil];
  
  NSString *dateRange = [NSString stringWithFormat:@"%@ – %@",
                         [[NSDateFormatter kk_displayDateFormatter] stringFromDate:product.startDate],
                         [[NSDateFormatter kk_displayDateFormatter] stringFromDate:product.endDate]];

  NSMutableAttributedString *string = [self _atteributedStringFromString:[NSString stringWithFormat:@"DAGAR KVAR\n%@\n\n%@", product.type, dateRange]];
  [string addAttribute:NSFontAttributeName value:[UIFont kk_regularFontWithSize:13.f] range:[string.string rangeOfString:dateRange]];

  [self.detailsLabel setNumberOfLines:4];
  [self.detailsLabel setAttributedText:string];
  
  [self setNeedsLayout];
}

// Todo: dynamic height calculations
+ (CGFloat)heightForProduct:(KKProduct *)product {
  return 144.f;
}

- (NSMutableAttributedString *)_atteributedStringFromString:(NSString *)string {
  NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
  
  NSShadow *shadow = [NSShadow new];
  [shadow setShadowOffset:CGSizeMake(0.f, 1.f/[UIScreen mainScreen].scale)];
  [shadow setShadowColor:[UIColor kk_lightTextShadowColor]];
  
  NSMutableParagraphStyle *paragraph = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
  [paragraph setAlignment:NSTextAlignmentCenter];
  
  [text addAttributes:@{
                        NSFontAttributeName:[UIFont kk_regularFontWithSize:12.f],
                        NSForegroundColorAttributeName:[UIColor whiteColor],
                        NSShadowAttributeName:shadow,
                        NSParagraphStyleAttributeName:paragraph,
                        }
                range:NSMakeRange(0, text.string.length)];
  
  
  return text;
}

@end

@implementation KKCardSegmentProductCell (KKProduct)

- (void)setCard:(KKCard *)card {
  [self.numberLabel setNumber:card.purse withFormatter:nil];

  NSMutableAttributedString *string = [self _atteributedStringFromString:@"KRONOR\nReskassa"];
  
  [self.detailsLabel setNumberOfLines:2];
  [self.detailsLabel setAttributedText:string];
  
  [self setNeedsLayout];
}

+ (CGFloat)heightForCard:(KKCard *)card {
  return 105.f;
}

@end
