//
//  KKApp.h
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-05-11.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

@import UIKit;
#import "KKAppPrivate.h"

#define SBRadiansToDregrees(RADIANS) ((RADIANS) * (180.0 / M_PI))
#define SBDegreesToRadians(DEGREES) ((DEGREES) / 180.0 * M_PI)

#define SBReturnStatic(THING) \
static id thing = nil; \
if (!thing) \
thing = THING; \
return thing

#define SBDefineStaticVoid(NAME) static void * NAME = &NAME

extern NSString * const KKAppBaseURL;

extern NSString * const KKUserDidLoginNotification; // Posted when the dismiss of login notification is done.
extern NSString * const KKUserDidLogoutNotification;

extern NSString * const KKAppUsernameKey; // Used in the migration.
extern NSString * const KKAppPasswordKey;

@interface KKApp : NSObject
+ (NSString *)username;
+ (void)setUsername:(NSString *)username;
+ (NSString *)password;
+ (void)setPassword:(NSString *)password;
@end

@interface NSDateFormatter (KKExtras)
+ (NSDate *)kk_dateFromString:(NSString *)string;
+ (NSDateFormatter *)kk_displayDateFormatter;
@end

@interface NSNumberFormatter (KKExtras)
+ (NSNumberFormatter *)kk_currencyFormatter;
@end

@interface UIFont (KKExtras)
+ (UIFont *)kk_semiboldFontWithSize:(CGFloat)size;
+ (UIFont *)kk_boldFontWithSize:(CGFloat)size;
+ (UIFont *)kk_extraBoldFontWithSize:(CGFloat)size;
+ (UIFont *)kk_regularFontWithSize:(CGFloat)size;
@end

@interface UIColor (KKExtras)
+ (UIColor *)kk_darkTextColor;
+ (UIColor *)kk_lightTextShadowColor;

+ (UIColor *)kk_headerColor;

+ (UIColor *)kk_linkColor;
+ (UIColor *)kk_activeLinkColor;
+ (UIColor *)kk_activeLinkBackgroundColor;
@end

