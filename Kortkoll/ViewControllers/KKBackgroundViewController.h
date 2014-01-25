//
//  KKBackgroundViewController.h
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-05-11.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

#import "KKViewController.h"

@class KKCardsViewController;
@class KKLoginViewController;

@interface KKBackgroundViewController : KKViewController
@property (nonatomic, strong) KKCardsViewController *cardsViewController;
@property (nonatomic, strong) KKLoginViewController *loginViewController;
@end
