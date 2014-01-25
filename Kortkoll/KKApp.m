//
//  KKApp.m
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-05-11.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

#import "KKApp.h"
#import "SSKeychain+KKExtras.h"

NSString * const KKAppBaseURL = @"https://www.kortkoll.nu/api/";

NSString * const KKUserDidLoginNotification = @"KKUserDidLoginNotification";
NSString * const KKUserDidLogoutNotification = @"KKUserDidLogoutNotification";

NSString * const KKAppUsernameKey = @"KKAppUsernameKey";
NSString * const KKAppPasswordKey = @"KKAppPasswordKey";

const NSTimeInterval KKRefreshDelta = 10.;
const NSTimeInterval KKMinimumBackgroundFetchInterval = 60.*60.*2;

@implementation KKApp

+ (NSString *)username {
  return [SSKeychain kk_passwordForAccount:KKAppUsernameKey];
}

+ (void)setUsername:(NSString *)username {
  [SSKeychain kk_setPassword:username forAccount:KKAppUsernameKey];
}

+ (NSString *)password {
  return [SSKeychain kk_passwordForAccount:KKAppPasswordKey];
}

+ (void)setPassword:(NSString *)password {
  [SSKeychain kk_setPassword:password forAccount:KKAppPasswordKey];
}

@end

@implementation NSDateFormatter (KKExtras)

+ (NSDate *)kk_dateFromString:(NSString *)string {
  static NSDateFormatter *parsingFormatter;
  static dispatch_queue_t parsingQueue;
  static dispatch_once_t onceToken;
  
  dispatch_once(&onceToken, ^{
    parsingFormatter = [[NSDateFormatter alloc] init];
    [parsingFormatter setDateFormat:@"yyyy-MM-dd"];
    parsingQueue = dispatch_queue_create("nu.kortkoll.ios.NSDateFormatter", DISPATCH_QUEUE_SERIAL);
  });
  
  __block NSDate *date;
  dispatch_sync(parsingQueue, ^{
    date = [parsingFormatter dateFromString:string];
  });
  
  return date;
}

// TODO: Set to sv_SE locale?
+ (NSDateFormatter *)kk_displayDateFormatter {
  static NSDateFormatter *formatter = nil;
  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
  });

  return formatter;
}

+ (NSDateFormatter *)kk_displayDateTimeFormatter {
  static NSDateFormatter *formatter = nil;
  static dispatch_once_t onceToken;
  
  dispatch_once(&onceToken, ^{
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
  });
  
  return formatter;
}

@end

@implementation NSNumberFormatter (KKExtras)

+ (NSNumberFormatter *)kk_currencyFormatter {
  static NSNumberFormatter *formatter = nil;
  static dispatch_once_t onceToken;
  
  dispatch_once(&onceToken, ^{
    formatter = [[NSNumberFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"sv_SE"]];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setMaximumFractionDigits:0]; // No ören, fuck those.
  });
  
  return formatter;
}

@end

@implementation UIFont (KKExtras)

+ (UIFont *)kk_semiboldFontWithSize:(CGFloat)size {
  return [UIFont fontWithName:@"OpenSans-Semibold" size:size];
}

+ (UIFont *)kk_boldFontWithSize:(CGFloat)size {
  return [UIFont fontWithName:@"OpenSans-Bold" size:size];
}

+ (UIFont *)kk_extraBoldFontWithSize:(CGFloat)size {
  return [UIFont fontWithName:@"OpenSans-Extrabold" size:size];
}

+ (UIFont *)kk_regularFontWithSize:(CGFloat)size {
  return [UIFont fontWithName:@"OpenSans" size:size];
}

@end

@implementation UIColor (KKExtras)

+ (UIColor *)kk_darkTextColor {
  SBReturnStatic([UIColor colorWithRed:0.424 green:0.467 blue:0.502 alpha:1.000]);
}

+ (UIColor *)kk_lightTextShadowColor {
  SBReturnStatic([UIColor colorWithRed:0.071 green:0.333 blue:0.427 alpha:1.000]);
}

+ (UIColor *)kk_headerColor {
  SBReturnStatic([UIColor colorWithRed:0.525 green:0.427 blue:0.471 alpha:1.000]);
}

+ (UIColor *)kk_linkColor {
  SBReturnStatic([UIColor colorWithRed:0.169 green:0.592 blue:0.871 alpha:1.000]);
}

+ (UIColor *)kk_activeLinkColor {
  SBReturnStatic([UIColor colorWithRed:0.404 green:0.749 blue:0.949 alpha:1.000]);
}

+ (UIColor *)kk_activeLinkBackgroundColor {
  SBReturnStatic([UIColor colorWithRed:0.859 green:0.937 blue:0.984 alpha:1.000]);
}

@end
