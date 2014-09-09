//
//  NSAppleEventDescriptor+Number.h
//
//  Created by dmaclach on 6/6/07.
//  Copyright 2007 Google Inc. All rights reserved.
//

#import "NSAppleEventDescriptor+Object.h"
/// A category for dealing with NSAppleEventDescriptors and NSNumber.
//
/// Will convert an AEDesc<->NSNumber.
@interface NSAppleEventDescriptor(StatzAppleEventDescriptorNumberAdditions)
/// Return a NSAppleEventDescriptor for a double value.
+ (NSAppleEventDescriptor*)descriptorWithDouble:(double)real;
/// Attempt to extract a double value. Returns NAN on error.
- (double)doubleValue;
/// Attempt to extract a NSNumber. Returns nil on error.
- (NSNumber*)numberValue;
@end
