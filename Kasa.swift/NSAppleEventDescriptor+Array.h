//
//  NSAppleEventDescriptor+Array.h
//
//  Created by dmaclach on 6/6/07.
//  Copyright 2007 Google Inc. All rights reserved.
//

#import "NSAppleEventDescriptor+Object.h"

/// A category for dealing with NSAppleEventDescriptors and NSArrays.
@interface NSAppleEventDescriptor(StatzAppleEventDescriptorArrayAdditions)

/// Return an NSArray for an AEList
// Returns nil on failure.
- (NSArray*)arrayValue;
@end
