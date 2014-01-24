//
//  KKMigrationController.m
//  Kortkoll
//
//  Created by Simon Blommegård on 2014-01-23.
//  Copyright (c) 2014 Kortkoll. All rights reserved.
//

#import "KKMigrationController.h"
#import "MTMigration.h"

@implementation KKMigrationController

+ (void)migrate {
  // Resave kechain items to make them icloud synchronizable.
  [MTMigration migrateToVersion:@"1.1" block:^{
    NSString *username = [KKApp username];
    NSString *password = [KKApp password];
    
    if (username && password) {
      [KKApp setUsername:username];
      [KKApp setPassword:password];
    }
  }];
}

@end
