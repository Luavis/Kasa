//
//  NSAppleEventDescriptor+Object.m
//
//  Created by dmaclach on 6/6/07.
//  Copyright 2007 Google Inc. All rights reserved.
//

#import "NSAppleEventDescriptor+Object.h"

// Map of types to selectors.
static NSMutableDictionary *gTypeMap = nil;

@implementation NSAppleEventDescriptor(StatzAppleEventDescriptorObjectValueAdditions)
+ (void)registerSelector:(SEL)selector forTypes:(DescType*)types count:(int)count {
  if (selector && types && count > 0) {
    @synchronized(self) {
      if (!gTypeMap) {
        gTypeMap = [[NSMutableDictionary alloc] init];
      }
      NSString *selString = NSStringFromSelector(selector);
      for (int i = 0; i < count; ++i) {
        NSString *key = [[NSString alloc] initWithBytes:&types[i]
                                                  length:4
                                                encoding:NSMacOSRomanStringEncoding];
        NSString *exists = [gTypeMap objectForKey:key];
        if (exists) {
          NSLog(@"%@ being replace with %@ exists for type: %@", 
                   exists, selString, key);
        }
        [gTypeMap setObject:selString forKey:key];
      }
    }
  }
}

#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
- (id)objectValue {
  id value = nil;
  
  // Check our registered types to see if we have anything
  if (gTypeMap) {
    @synchronized(gTypeMap) {
      DescType type = [self descriptorType];
      NSString *key = [[NSString alloc] initWithBytes:&type
                                               length:4
                                             encoding:NSMacOSRomanStringEncoding];
      if (key) {
        NSString *selectorString = [gTypeMap objectForKey:key];
        if (selectorString) {
          SEL selector = NSSelectorFromString(selectorString);
          value = [self performSelector:selector];
        }
      }
    }
  }
  
  // default to stringValue.
  if (!value) {
    value = [self stringValue];
  }
  return value;
}
@end

@implementation NSObject(StatzAppleEventDescriptorObjectAdditions)
- (NSAppleEventDescriptor*)appleEventDescriptor {
  return [NSAppleEventDescriptor descriptorWithString:[self description]];
}
@end



