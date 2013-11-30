//
//  KKAPIClient.h
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-05-11.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

#import "AFNetworking.h"

@interface KKAPISessionManager : AFHTTPSessionManager

+ (instancetype)client;

@end
