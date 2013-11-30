//
//  NSObject+SBExtras.h
//  SBFoundation
//
//  Copyright (c) 2012 Simon Blommegård. All rights reserved.
//

@import Foundation;

@interface NSObject (SBExtras)

// Associated Object
- (void)associateValue:(id)value withKey:(void *)key;
- (void)associateCopyOfValue:(id)value withKey:(void *)key;
- (void)weaklyAssociateValue:(id)value withKey:(void *)key;
- (id)associatedValueForKey:(void *)key;

- (NSString*)className;

@end
