//
//  KKHUDView.h
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-07-23.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

@import UIKit;
#import "KKHUD.h"

@interface KKWelcomeHUDView : UIView <KKHUDItem>
@property (nonatomic) BOOL presented; // KVO this
@property (nonatomic) BOOL dimBackground;
@end
