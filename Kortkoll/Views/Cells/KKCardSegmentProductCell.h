//
//  KKCardSegmentProductCell.h
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-05-15.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

@import UIKit;

@class KKNumberLabel, KKCard, KKProduct;

@interface KKCardSegmentProductCell : UICollectionViewCell
@property (nonatomic, strong) KKNumberLabel *numberLabel;
@property (nonatomic, strong) UILabel *detailsLabel;
@end

@interface KKCardSegmentProductCell (KKCard)
- (void)setProduct:(KKProduct *)product;
+ (CGFloat)heightForProduct:(KKProduct *)product;
@end

@interface KKCardSegmentProductCell (KKProduct)
- (void)setCard:(KKCard *)card;
+ (CGFloat)heightForCard:(KKCard *)card;
@end
