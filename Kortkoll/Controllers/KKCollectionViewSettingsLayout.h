//
//  KKCollectionViewSettingsLayout.h
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-07-03.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

@import UIKit;

@protocol KKCollectionViewDelegateSettingsLayout <UICollectionViewDelegate>
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface KKCollectionViewSettingsLayout : UICollectionViewLayout
@end
