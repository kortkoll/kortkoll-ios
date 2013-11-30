//
//  KKSpinnerLayer.h
//  Kortkoll
//
//  Created by Simon Blommegård on 2013-05-12.
//  Copyright (c) 2013 Kortkoll. All rights reserved.
//

@import UIKit;

typedef NS_ENUM(NSUInteger, KKSpinnerLayerStyle) {
  KKSpinnerLayerStyleHidden,
  KKSpinnerLayerStyleLoading,
  KKSpinnerLayerStyleError,
  KKSpinnerLayerStyleDone,
};

@interface KKSpinnerLayer : CALayer
@property (nonatomic, assign) KKSpinnerLayerStyle spinnerLayerStyle;
@end
