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
    
    if (encodedCards)
      [self setCards:[NSKeyedUnarchiver unarchiveObjectWithData:encodedCards]];
  }
  return self;
}

- (void)setCards:(NSArray *)cards {
  _cards = [cards copy];
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    NSString *path = [self.dir stringByAppendingPathComponent:@"Cards"];
    
    if (self.cards) {
      NSData *encodedStations = [NSKeyedArchiver archivedDataWithRootObject:self.cards];
      [encodedStations writeToFile:path options:0 error:NULL];
    } else {
      [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
    }
  });
}

- (void)setUnparsedCards:(NSArray *)cards {
  NSMutableArray *array = [NSMutableArray new];
  for (NSDictionary *cardDict in cards)
    [array addObject:[MTLJSONAdapter modelOfClass:KKCard.class fromJSONDictionary:cardDict error:NULL]];
  
  [self setCards:array];
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
