//
//  SSKeychain+KKExtras.m
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-12-10.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

#import "SSKeychain+KKExtras.h"

@implementation SSKeychain (KKExtras)

+ (NSString *)kk_passwordForAccount:(NSString *)account {
  SSKeychainQuery *query = [SSKeychainQuery new];
  [query setService:[[NSBundle mainBundle] bundleIdentifier]];
  [query setAccount:account];
  [query setSynchronizationMode:SSKeychainQuerySynchronizationModeAny];
  [query fetch:NULL];
  return query.password;
}

+ (void)kk_setPassword:(NSString *)password forAccount:(NSString *)account {
  SSKeychainQuery *query = [SSKeychainQuery new];
  [query setService:[[NSBundle mainBundle] bundleIdentifier]];
  [query setAccount:account];
  [query setSynchronizationMode:SSKeychainQuerySynchronizationModeYes];
  [query setPassword:password];
  
  if (!password)
    [query deleteItem:NULL];
  else
    [query save:NULL];
}

@end
