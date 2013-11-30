//
//  KKCardsView.h
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-05-11.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

@import UIKit;

typedef NS_ENUM(NSUInteger, KKCardsViewState) {
  KKCardsViewStateFolded,
  KKCardsViewStateUnfolded
};

@interface KKCardsView : UIView
@property (nonatomic, assign) KKCardsViewState state;

- (void)setState:(KKCardsViewState)state animated:(BOOL)animated completion:(void (^)(void))completion;

@end
