//
//  SSKeychain+KKExtras.h
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-12-10.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

#import "SSKeychain.h"

@interface SSKeychain (KKExtras)
+ (NSString *)kk_passwordForAccount:(NSString *)account;
+ (void)kk_setPassword:(NSString *)password forAccount:(NSString *)account;
@end
