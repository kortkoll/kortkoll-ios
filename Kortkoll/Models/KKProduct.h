//
//  KKProduct.h
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-05-11.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

#import "Mantle.h"

@interface KKProduct : MTLModel <MTLJSONSerializing>

@property (nonatomic) BOOL active;
@property (nonatomic, copy) NSDate *endDate;
@property (nonatomic, copy) NSDate *startDate;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSNumber *price;
@property (nonatomic, copy) NSString *type;

@property (nonatomic, readonly) BOOL valid;

+ (instancetype)mock;

@end
