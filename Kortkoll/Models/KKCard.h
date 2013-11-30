//
//  KKCard.h
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-05-11.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

#import "Mantle.h"

@interface KKCard : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *owner;
@property (nonatomic, copy) NSNumber *purse;
@property (nonatomic, copy) NSArray *products;

+ (instancetype)mock;

@end
