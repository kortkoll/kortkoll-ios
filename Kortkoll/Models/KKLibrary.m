//
//  KKLibrary.m
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-05-11.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

#import "KKLibrary.h"
#import "KKCard.h"

@interface KKLibrary ()
@property (nonatomic, copy) NSString *dir;
@end

@implementation KKLibrary

- (id)init {
  if (self = [super init]) {
    [self setDir:[NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
    [[NSFileManager defaultManager] createDirectoryAtPath:self.dir withIntermediateDirectories:YES attributes:nil error:NULL];
    
    NSData *encodedCards = [NSData dataWithContentsOfFile:[self.dir stringByAppendingPathComponent:@"Cards"]];
    NSData *encodedDate = [NSData dataWithContentsOfFile:[self.dir stringByAppendingPathComponent:@"RefreshDate"]];
    
    if (encodedCards)
      [self setCards:[NSKeyedUnarchiver unarchiveObjectWithData:encodedCards]];
    
    if (encodedDate)
      [self setRefreshDate:[NSKeyedUnarchiver unarchiveObjectWithData:encodedDate]];
  }
  return self;
}

- (void)setUnparsedCards:(NSArray *)cards {
  NSMutableArray *array = [NSMutableArray new];
  for (NSDictionary *cardDict in cards)
    [array addObject:[MTLJSONAdapter modelOfClass:KKCard.class fromJSONDictionary:cardDict error:NULL]];
  
  [self setCards:array];
  [self setRefreshDate:[NSDate date]];
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
      NSString *cardsPath = [self.dir stringByAppendingPathComponent:@"Cards"];
      NSString *datePath = [self.dir stringByAppendingPathComponent:@"RefreshDate"];
    
    if (self.cards.count) {
      NSData *encodedCards = [NSKeyedArchiver archivedDataWithRootObject:self.cards];
      [encodedCards writeToFile:cardsPath options:0 error:NULL];
      
      NSData *encodedDate = [NSKeyedArchiver archivedDataWithRootObject:self.refreshDate];
      [encodedDate writeToFile:datePath options:0 error:NULL];
    } else {
      [[NSFileManager defaultManager] removeItemAtPath:cardsPath error:NULL];
      [[NSFileManager defaultManager] removeItemAtPath:datePath error:NULL];
    }
  });
}

+ (instancetype)library {
  static dispatch_once_t onceToken;
  static KKLibrary *lib = nil;
  
  dispatch_once(&onceToken, ^{
    lib = [[KKLibrary alloc] init];
  });
  
  return lib;
}

@end
