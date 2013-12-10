//
//  KKProduct.h
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-05-11.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

#import "Mantle.h"

@interface KKProduct : MTLModel <MTLJSONSerializing>

@property (nonatomic, assign) BOOL active;
@property (nonatomic, copy) NSDate *endDate;
@property (nonatomic, copy) NSDate *startDate;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSNumber *price;
@property (nonatomic, copy) NSString *type;

+ (instancetype)mock;
- (BOOL)isValid;

@end
