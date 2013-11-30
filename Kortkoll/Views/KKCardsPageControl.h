//
//  KKCardsPageControl.h
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-05-27.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

@import UIKit;

@interface KKCardsPageControl : UIControl
@property (nonatomic, assign) NSInteger numberOfPages; // The left most is settings.
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL hidesForSinglePage; // Defaults to NO.
@end
