//
//  KKLibrary.h
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-05-11.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

@import Foundation;

@interface KKLibrary : NSObject
@property (nonatomic, copy) NSArray *cards;

+ (instancetype)library;

- (void)setUnparsedCards:(NSArray *)cards;

@end
