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
  [query setSynchronizable:SSKeychainQuerySynchronizableAny];
  [query fetch:NULL];
  return (NSString *)query.passwordObject; // We use this for legacy.
}

+ (void)kk_setPassword:(NSString *)password forAccount:(NSString *)account {
  SSKeychainQuery *query = [SSKeychainQuery new];
  [query setService:[[NSBundle mainBundle] bundleIdentifier]];
  [query setAccount:account];
  [query setSynchronizable:SSKeychainQuerySynchronizableAny];
  [query setPasswordObject:password]; // We use this for legacy.
  
  if (!password)
    [query deleteItem:NULL];
  else
    [query save:NULL];
}

@end
