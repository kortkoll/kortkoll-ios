//
//  KKText.h
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-07-30.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

@import Foundation;
#import "TTTAttributedLabel.h"

@interface KKText : NSObject <TTTAttributedLabelDelegate>
@property (nonatomic, strong) NSAttributedString *attributedString;
@property (nonatomic, strong) NSDictionary *links; //@{NSValue:NSURL}
@property (nonatomic, strong) NSDictionary *linkAttributes;
@property (nonatomic, strong) NSDictionary *activeLinkAttributes;

+ (KKText *)intoText;
+ (KKText *)infoText;

@end
