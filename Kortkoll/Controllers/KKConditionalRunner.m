//
//  KKConditionalRunner.m
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-07-28.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

#import "KKConditionalRunner.h"

@implementation KKConditionalRunner

+ (void)runIfIdentifier:(NSString *)identifier
                 notSet:(void(^)())notSet
                    set:(void(^)())set {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

  if ([defaults boolForKey:identifier])
    set();
  else {
    notSet();
    [defaults setBool:YES forKey:identifier];
    [defaults synchronize];
  }
}


@end
