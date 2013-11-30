//
//  NSDate+KKExtras.m
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-05-15.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

#import "NSDate+KKExtras.h"

@implementation NSDate (KKExtras)

- (NSInteger)kk_daysToDate:(NSDate *)date {
  NSDate *fromDate, *toDate;
  
  NSCalendar *calendar = [NSCalendar currentCalendar];

  [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate interval:NULL forDate:self];
  [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate interval:NULL forDate:date];
  
  NSDateComponents *difference = [calendar components:NSDayCalendarUnit fromDate:fromDate toDate:toDate options:0];
  
  return difference.day;
}

@end
