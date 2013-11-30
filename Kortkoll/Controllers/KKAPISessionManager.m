//
//  KKAPIClient.m
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-05-11.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

#import "KKAPISessionManager.h"
#import "AFNetworkActivityIndicatorManager.h"

@implementation KKAPISessionManager

+ (instancetype)client {
  static dispatch_once_t onceToken;
  static KKAPISessionManager *manager = nil;
  
  dispatch_once(&onceToken, ^{
    manager = [[KKAPISessionManager alloc] initWithBaseURL:[NSURL URLWithString:KKAppBaseURL]];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializerWithWritingOptions:0]];
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
  });
  
  return manager;
}

@end
