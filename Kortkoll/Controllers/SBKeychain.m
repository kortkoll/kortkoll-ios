//
//  SBKeychain.m
//  SBFoundation
//
//  Copyright (c) 2012 Simon Blommegård. All rights reserved.
//

#import "SBKeychain.h"
@import Security;

@implementation SBKeychain

+ (NSString*)serviceName {
	return [[NSBundle mainBundle] bundleIdentifier];
}

+ (id)dataForKey:(NSString *)key class:(Class)outpucClass {
  if (!key)
    return nil;
  
	NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:
                         (id)kCFBooleanTrue, kSecReturnData,
                         kSecClassGenericPassword, kSecClass,
                         key, kSecAttrAccount,
                         [self serviceName], kSecAttrService, nil];
	
	CFDataRef keychainData = NULL;
	OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef*)&keychainData);
	if(status) return nil;
	
  id data = nil;
  
  if (!outpucClass || outpucClass == [NSData class])
    data = (__bridge id)keychainData;
  
  else if ([outpucClass conformsToProtocol:@protocol(NSCoding)])
    data = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge id)keychainData];
  else
    [NSException raise:NSInternalInconsistencyException
                format:@"Class %@ does not conforms to NSCoding", NSStringFromClass(outpucClass)];
  
	CFRelease(keychainData);
	return data;
}


+ (BOOL)setData:(id)data forKey:(NSString *)key {
  if (!key)
    return NO;
  
	NSData *keychainData = nil;
  
  
  if (data && [data isKindOfClass:[NSData class]])
    keychainData = data;
  
  else if (data && [data conformsToProtocol:@protocol(NSCoding)])
    keychainData = [NSKeyedArchiver archivedDataWithRootObject:data];
  else if (data)
    [NSException raise:NSInternalInconsistencyException
                format:@"Class %@ does not conforms to NSCoding", NSStringFromClass([data class])];
  
	NSDictionary *spec = [NSDictionary dictionaryWithObjectsAndKeys:
                        (__bridge id)kSecClassGenericPassword, kSecClass,
                        key, kSecAttrAccount,
                        [self serviceName], kSecAttrService, nil];
	
  
	if(!data) {
		return !SecItemDelete((__bridge CFDictionaryRef)spec);
	}
  else if([self dataForKey:key class:[data class]]) {
		NSDictionary *update = [NSDictionary dictionaryWithObject:keychainData forKey:(__bridge id)kSecValueData];
		return !SecItemUpdate((__bridge CFDictionaryRef)spec, (__bridge CFDictionaryRef)update);
	}
  else{
		NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:spec];
		[data setObject:keychainData forKey:(__bridge id)kSecValueData];
		return !SecItemAdd((__bridge CFDictionaryRef)data, NULL);
	}
}

@end
