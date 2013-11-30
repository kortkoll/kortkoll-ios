//
//  KKProduct.m
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-05-11.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

#import "KKProduct.h"

@implementation KKProduct

#pragma mark - Public

+ (instancetype)mock {
  return [self modelWithDictionary:
          @{
            @"active":@YES,
            @"endDate":[NSDate dateWithTimeInterval:2505600. sinceDate:[NSDate date]],
            @"startDate":[NSDate dateWithTimeInterval:-172800. sinceDate:[NSDate date]],
            @"identifier":@"14",
            @"price":@(790),
            @"type":@"30-dagarsbiljett Helt"
          }
                             error:NULL];
}

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{
           @"endDate":@"end_date",
           @"startDate":@"start_date",
           @"identifier":@"id"
           };
}

+ (NSValueTransformer *)endDateJSONTransformer {
  return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSString *str) {
    return [NSDateFormatter kk_dateFromString:str];
  } reverseBlock:^id(NSDate *date) {
    return nil;
  }];
}

+ (NSValueTransformer *)startDateJSONTransformer {
  return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSString *str) {
    return [NSDateFormatter kk_dateFromString:str];
  } reverseBlock:^id(NSDate *date) {
    return nil;
  }];
}

@end
