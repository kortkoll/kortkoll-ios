//
//  KKCard.m
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-05-11.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

#import "KKCard.h"
#import "KKProduct.h"

@implementation KKCard

#pragma mark - Public

+ (instancetype)mock {
  return [self modelWithDictionary:
          @{
            @"name":@"Blåa kortet",
            @"owner":@"Ture Sventon",
            @"purse":@(325.),
            @"products":@[[KKProduct mock]]
          }
                             error:NULL];
}

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{};
}

+ (NSValueTransformer *)productsJSONTransformer {
  return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:KKProduct.class];
}

@end
