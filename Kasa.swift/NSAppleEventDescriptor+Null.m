//
//  NSAppleEventDescriptor+Null.m
//
//  Created by dmaclach on 6/6/07.
//  Copyright 2007 Google Inc. All rights reserved.
//

#import "NSAppleEventDescriptor+Null.h"

@implementation NSAppleEventDescriptor(StatzAppleEventDescriptorNullAdditions)
- (NSNull*)nullValue {
  return [NSNull null];
}
@end

@implementation NSNull(StatzAppleEventDescriptorObjectAdditions)
+ (void)load {
  DescType types[] = { 
    typeNull
  };
  
  [NSAppleEventDescriptor registerSelector:@selector(nullValue)
                                  forTypes:types
                                     count:sizeof(types)/sizeof(DescType)];
}

- (NSAppleEventDescriptor*)appleEventDescriptor {
  return [NSAppleEventDescriptor nullDescriptor];
}
@end

