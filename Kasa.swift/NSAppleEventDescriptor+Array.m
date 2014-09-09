//
//  NSAppleEventDescriptor+Array.m
//
//  Created by dmaclach on 6/6/07.
//  Copyright 2007 Google Inc. All rights reserved.
//

#import "NSAppleEventDescriptor+Array.h"

@implementation NSAppleEventDescriptor(StatzAppleEventDescriptorArrayAdditions)
- (NSArray*)arrayValue {
  NSInteger count = [self numberOfItems];
  NSAppleEventDescriptor *workingDesc = self;
  if (count == 0) {
    // Create a list to work with.
    workingDesc = [self coerceToDescriptorType:typeAEList];
    count = [workingDesc numberOfItems];
  }
  NSMutableArray *items = [NSMutableArray array];
  for (int i = 1; i <= count; ++i) {
    NSAppleEventDescriptor *desc = [workingDesc descriptorAtIndex:i];
    id value = [desc objectValue];
    if (!value) {
      NSLog(@"Unknown type of descriptor %@", [desc description]);
      return nil;
    }
    [items addObject:value];
  }
  return items;
}  
@end

@implementation NSArray(StatzAppleEventDescriptorObjectAdditions)

+ (void)load {
  DescType types[] = { 
    typeAEList,
  };
  
  [NSAppleEventDescriptor registerSelector:@selector(arrayValue)
                                  forTypes:types
                                     count:sizeof(types)/sizeof(DescType)];
}

- (NSAppleEventDescriptor*)appleEventDescriptor {
  NSAppleEventDescriptor *desc = [NSAppleEventDescriptor listDescriptor];
  NSInteger count = [self count];
  for (unsigned i = 1; i <= count; ++i) {
    id item = [self objectAtIndex:i-1];
    NSAppleEventDescriptor *itemDesc = [item appleEventDescriptor];
    if (!itemDesc) {
      NSLog(@"Unable to create Apple Event Descriptor for %@", [self description]);
      return nil;
    }
    [desc insertDescriptor:itemDesc atIndex:i];
  }
  return desc;
}
@end
