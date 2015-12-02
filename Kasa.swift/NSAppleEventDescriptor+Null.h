//
//  NSAppleEventDescriptor+Null.h
//
//  Created by dmaclach on 6/6/07.
//  Copyright 2007 Google Inc. All rights reserved.
//

#import "NSAppleEventDescriptor+Object.h"

/// A category for dealing with NSAppleEventDescriptors and NSNulls.
@interface NSAppleEventDescriptor(StatzAppleEventDescriptorNullAdditions)

/// Return an NSNull for a desc of typeNull
// Returns nil on failure.
- (NSNull*)nullValue;
@end
