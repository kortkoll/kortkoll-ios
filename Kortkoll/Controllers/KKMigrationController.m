//
//  KKMigrationController.m
//  Kortkoll
//
//  Created by Simon Blommegård on 2014-01-23.
//  Copyright (c) 2014 Kortkoll. All rights reserved.
//

#import "KKMigrationController.h"
#import "MTMigration.h"
#import "SSKeychain.h"

@implementation KKMigrationController

+ (void)migrate {
  [MTMigration migrateToVersion:@"1.2" block:^{
    
    // Resave kechain items to make them icloud synchronizable.
    NSString * (^passwordForAccount)(NSString *) = ^NSString * (NSString *account) {
      SSKeychainQuery *query = [SSKeychainQuery new];
      [query setService:[[NSBundle mainBundle] bundleIdentifier]];
      [query setAccount:account];
      [query fetch:NULL];
      
      NSString *password = (NSString *)query.passwordObject;
      
      [query deleteItem:NULL];
      
      return password;
    };
    
    NSString *username = passwordForAccount(KKAppUsernameKey);
    NSString *password = passwordForAccount(KKAppPasswordKey);
    
    if (username.length > 0 && password.length > 0) {
      [KKApp setUsername:username];
      [KKApp setPassword:password];
    }
    
    // Register for background fetch.
    if (username.length > 0 && password.length > 0) {
      [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:KKMinimumBackgroundFetchInterval];
    }
  }];
}

@end
