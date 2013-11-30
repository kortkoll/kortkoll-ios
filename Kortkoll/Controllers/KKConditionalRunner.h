//
//  KKConditionalRunner.h
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-07-28.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

@import Foundation;

@interface KKConditionalRunner : NSObject

+ (void)runIfIdentifier:(NSString *)identifier
                 notSet:(void(^)())notSet
                    set:(void(^)())set;

@end
