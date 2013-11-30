//
//  SBDrawingHelpers.m
//  SBFoundation
//
//  Copyright (c) 2012 Simon Blommegård. All rights reserved.
//

#import "SBDrawingHelpers.h"

CGRect CGRectSetX(CGRect rect, CGFloat x) {
	return CGRectMake(x, rect.origin.y, rect.size.width, rect.size.height);
}


CGRect CGRectSetY(CGRect rect, CGFloat y) {
	return CGRectMake(rect.origin.x, y, rect.size.width, rect.size.height);
}


CGRect CGRectSetWidth(CGRect rect, CGFloat width) {
	return CGRectMake(rect.origin.x, rect.origin.y, width, rect.size.height);
}


CGRect CGRectSetHeight(CGRect rect, CGFloat height) {
	return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, height);
}


CGRect CGRectSetOrigin(CGRect rect, CGPoint origin) {
	return CGRectMake(origin.x, origin.y, rect.size.width, rect.size.height);
}


CGRect CGRectSetSize(CGRect rect, CGSize size) {
	return CGRectMake(rect.origin.x, rect.origin.y, size.width, size.height);
}


CGRect CGRectSetZeroOrigin(CGRect rect) {
	return CGRectMake(0, 0, rect.size.width, rect.size.height);
}


CGRect CGRectSetZeroSize(CGRect rect) {
	return CGRectMake(rect.origin.x, rect.origin.y, 0, 0);
}

CGSize CGSizeAspectScaleToSize(CGSize size, CGSize toSize) {
	CGFloat aspect = 1.;
	
	if (size.width > toSize.width)
		aspect = toSize.width / size.width;
	
	if (size.height > toSize.height)
		aspect = fminf(toSize.height / size.height, aspect);
	
	return CGSizeMake(size.width * aspect, size.height * aspect);
}


CGRect CGRectMovePoint(CGRect rect, CGPoint delta) {
	return CGRectMake(rect.origin.x + delta.x, rect.origin.y + delta.y, rect.size.width, rect.size.height);
}

CGRect CGRectContract(CGRect rect, CGFloat dx, CGFloat dy) {
	return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width - dx, rect.size.height - dy);
}


CGGradientRef SBCreateGradientWithColors(NSArray *colors) {
	return SBCreateGradientWithColorsAndLocations(colors, nil, NULL);
}

CGGradientRef SBCreateGradientWithColorsAndLocations(NSArray *colors, NSArray *locations, CGColorSpaceRef colorSpace) {
	NSUInteger colorsCount = [colors count];
	if (colorsCount < 2)
		return NULL;
    
    if (colorSpace == NULL)
        colorSpace = CGColorGetColorSpace([[colors objectAtIndex:0] CGColor]);
    
	
	CGFloat *gradientLocations = NULL;
	NSUInteger locationsCount = [locations count];
	if (locationsCount == colorsCount) {
		gradientLocations = (CGFloat *)malloc(sizeof(CGFloat) * locationsCount);
		for (NSUInteger i = 0; i < locationsCount; i++)
			gradientLocations[i] = [[locations objectAtIndex:i] floatValue];
	}
	
	NSMutableArray *gradientColors = [[NSMutableArray alloc] initWithCapacity:colorsCount];
	[colors enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
		[gradientColors addObject:(__bridge id)[(UIColor *)object CGColor]];
	}];
	
	CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
	
	if (gradientLocations)
		free(gradientLocations);
	
	return gradient;
}

void SBAddRoundedRect(CGRect rect, UIRectCorner corners, CGSize cornerRadii) {
	UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect
                                               byRoundingCorners:corners
                                                     cornerRadii:cornerRadii];
	
	[path addClip];
}

void SBDrawLine(CGPoint start, CGPoint stop, CGFloat lineWidth) {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSaveGState(context);
	CGContextSetLineWidth(context, lineWidth);
	CGContextMoveToPoint(context, start.x, start.y);
	CGContextAddLineToPoint(context, stop.x, stop.y);
	CGContextStrokePath(context);
	CGContextRestoreGState(context);
}

void SBDrawGradientInRect(CGGradientRef gradient, CGRect rect, CGGradientDrawingOptions options) {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSaveGState(context);
	CGContextClipToRect(context, rect);
	CGPoint start = CGPointMake(rect.origin.x, rect.origin.y);
	CGPoint end = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height);
	CGContextDrawLinearGradient(context, gradient, start, end, options);
	CGContextRestoreGState(context);
}