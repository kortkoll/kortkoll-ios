//
//  KKNumberLabel.m
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-05-21.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

#import "KKNumberLabel.h"

@interface KKNumberLabel ()
@property (nonatomic, strong) NSNumber *number;
@property (nonatomic, strong) NSNumberFormatter *formatter;

@property (nonatomic, strong) CADisplayLink *link;

@property (nonatomic, assign) NSInteger currentTickNumber;
@property (nonatomic, assign) NSInteger tickStep;
@end

@implementation KKNumberLabel

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self setLineBreakMode:NSLineBreakByTruncatingTail];
    [self setTextAlignment:NSTextAlignmentCenter];
    [self setMinimumScaleFactor:.8f];
    [self setBackgroundColor:[UIColor clearColor]];
  }
  return self;
}

#pragma mark - Properties

- (CADisplayLink *)link {
  if (!_link) {
    _link = [[UIScreen mainScreen] displayLinkWithTarget:self selector:@selector(_tick:)];
    [_link setFrameInterval:2];
  }
  return _link;
}

#pragma mark - Public

- (void)setNumber:(NSNumber *)number withFormatter:(NSNumberFormatter *)formatter {
  [self setNumber:number];
  [self setFormatter:formatter];
  
  // We want to run for ≈ 22 ticks
  _tickStep = MAX(number.integerValue/22, 1);
  _currentTickNumber = 0;
  
  [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

#pragma mark - Private

- (NSAttributedString *)_attributedStringFromNumber:(NSNumber *)number {
  
  NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.formatter?
                                       [self.formatter stringFromNumber:number]:
                                       [NSString stringWithFormat:@"%@", number]];
  
  NSShadow *shadow = [NSShadow new];
  [shadow setShadowOffset:CGSizeMake(0.f, 1.f)];
  [shadow setShadowColor:[UIColor kk_lightTextShadowColor]];
  
  [string addAttribute:NSShadowAttributeName
                 value:shadow
                 range:NSMakeRange(0, string.length)];
  
  [string addAttribute:NSForegroundColorAttributeName
                 value:[UIColor whiteColor]
                 range:NSMakeRange(0, string.length)];
  
  [string addAttribute:NSFontAttributeName
                 value:[UIFont kk_boldFontWithSize:60.f]
                 range:NSMakeRange(0, string.length)];
  
  if (self.formatter)
    [string addAttribute:NSFontAttributeName
                   value:[UIFont kk_extraBoldFontWithSize:45.f]
                   range:[string.string rangeOfString:[self.formatter currencySymbol]]];
  
  return string;
}

- (void)_tick:(CADisplayLink *)link {
  
  if ((_currentTickNumber + _tickStep) > self.number.integerValue) {
    [self.link invalidate];
    [self setLink:nil];
    [self setAttributedText:[self _attributedStringFromNumber:self.number]];
  }
  else
    [self setAttributedText:[self _attributedStringFromNumber:@(_currentTickNumber)]];
    

  _currentTickNumber += _tickStep;
}

@end
