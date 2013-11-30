//
//  KKNumberLabel.h
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-05-21.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

@import UIKit;

@interface KKNumberLabel : UILabel

- (void)setNumber:(NSNumber *)number withFormatter:(NSNumberFormatter *)formatter;

@end
