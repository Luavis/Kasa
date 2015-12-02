//
//  NSAppleEventDescriptor+Object.h
//
//  Created by dmaclach on 6/6/07.
//  Copyright 2007 Google Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Categories for flexibly working with NSAppleEventDescriptors.
@interface NSAppleEventDescriptor(StatzAppleEventDescriptorObjectValueAdditions)
/// Used to register the types you know how to convert into 
/// NSAppleEventDescriptors.
// See examples in NSAppleEventDescriptor+String, NSAppleEventDescriptor+Number
// etc.
// Args:
//  selector - selector to call for any of the types in |types|
//  types - an std c array of types of length |count|
//  count - number of types in |types|
+ (void)registerSelector:(SEL)selector forTypes:(DescType*)types count:(int)count;

/// Returns an NSObject for any NSAppleEventDescriptor
// Uses types registerd by registerSelector:forTypes:count: to determine
// what type of object to create. If it doesn't know a type, it attempts
// to return [self stringValue].
- (id)objectValue;
@end

@interface NSObject(StatzAppleEventDescriptorObjectAdditions)
// A informal protocol that objects can override to return appleEventDescriptors
// for their type. The default is to return [self description] rolled up
// in an NSAppleEventDescriptor.
- (NSAppleEventDescriptor*)appleEventDescriptor;
@end


