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
  // Resave kechain items to make them icloud synchronizable.
  [MTMigration migrateToVersion:@"1.2" block:^{
    NSString * (^passwordForAccount)(NSString *) = ^NSString * (NSString *account) {
      SSKeychainQuery *query = [SSKeychainQuery new];
      [query setService:[[NSBundle mainBundle] bundleIdentifier]];
      [query setAccount:account];
      [query fetch:NULL];
      return (NSString *)query.passwordObject;
    };
    
    NSString *username = passwordForAccount(KKAppUsernameKey);
    NSString *password = passwordForAccount(KKAppPasswordKey);
    
    if (username && password) {
      [KKApp setUsername:username];
      [KKApp setPassword:password];
    }
  }];
}

@end
