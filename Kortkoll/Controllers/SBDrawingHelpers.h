//
//  SBDrawingHelpers.h
//  SBFoundation
//
//  Copyright (c) 2012 Simon Blommegård. All rights reserved.
//

@import UIKit;

extern CGRect CGRectSetX(CGRect rect, CGFloat x);
extern CGRect CGRectSetY(CGRect rect, CGFloat y);
extern CGRect CGRectSetWidth(CGRect rect, CGFloat width);
extern CGRect CGRectSetHeight(CGRect rect, CGFloat height);
extern CGRect CGRectSetOrigin(CGRect rect, CGPoint origin);
extern CGRect CGRectSetSize(CGRect rect, CGSize size);
extern CGRect CGRectSetZeroOrigin(CGRect rect);
extern CGRect CGRectSetZeroSize(CGRect rect);
extern CGSize CGSizeAspectScaleToSize(CGSize size, CGSize toSize);
extern CGRect CGRectMovePoint(CGRect rect, CGPoint delta);
extern CGRect CGRectContract(CGRect rect, CGFloat dx, CGFloat dy);
extern CGRect CGRectShift(CGRect rect, CGFloat dx, CGFloat dy);

// Remember to release
extern CGGradientRef SBCreateGradientWithColors(NSArray *colors);
extern CGGradientRef SBCreateGradientWithColorsAndLocations(NSArray *colors, NSArray *locations, CGColorSpaceRef colorSpace);

// Adds rounded rects to current path, use CGContextSaveGState to save state
extern void SBAddRoundedRect(CGRect rect, UIRectCorner corners, CGSize cornerRadii);

// Draws a line between two points, use current stroke color
extern void SBDrawLine(CGPoint start, CGPoint stop, CGFloat lineWidth);

// Draws the gradient in the rect's path
extern void SBDrawGradientInRect(CGGradientRef gradient, CGRect rect, CGGradientDrawingOptions options);