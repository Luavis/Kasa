//
//  NSAppleEventDescriptor+Number.m
//
//  Created by dmaclach on 6/6/07.
//  Copyright 2007 Google Inc. All rights reserved.
//

#import "NSAppleEventDescriptor+Number.h"

@implementation NSAppleEventDescriptor(StatzAppleEventDescriptorNumberAdditions)
+ (NSAppleEventDescriptor*)descriptorWithDouble:(double)real {
  return [NSAppleEventDescriptor descriptorWithDescriptorType:typeIEEE64BitFloatingPoint
                                                        bytes:&real 
                                                       length:sizeof(real)];
}

- (double)doubleValue {
  double value = NAN;
  NSNumber *number = [self numberValue];
  if (number) {
    value = [number doubleValue];
  }
  return value;
}

- (NSNumber*)numberValue {
  NSNumber* value = nil;
  NSAppleEventDescriptor *desc = nil;
  // typeBoolean cannot be converted directly to typeIEEE64BitFloatingPoint.
  if ([self descriptorType] == typeBoolean) {
    value = [NSNumber numberWithBool:[self booleanValue]];
  } else {
    desc = [self coerceToDescriptorType:typeIEEE64BitFloatingPoint];
  }
  if (!value && desc) {
    NSData *descData = [desc data];
    const void *bytes = [descData bytes];
    if (bytes) {
      value = [NSNumber numberWithDouble:*(double*)bytes];
    }
  }
  return value;
}
@end

@implementation NSNumber(StatzAppleEventDescriptorObjectAdditions)

+ (void)load {
  DescType types[] = { 
    typeBoolean,
    typeSInt16,
    typeSInt32,
    typeUInt32,
    typeSInt64,
    typeIEEE32BitFloatingPoint,
    typeIEEE64BitFloatingPoint };
  
  [NSAppleEventDescriptor registerSelector:@selector(numberValue)
                                  forTypes:types
                                     count:sizeof(types)/sizeof(DescType)];
}

- (NSAppleEventDescriptor*)appleEventDescriptor {
  const char *type = [self objCType];
  if (!type || strlen(type) != 1) return nil;
  
  DescType desiredType = typeNull;
  NSAppleEventDescriptor *desc = nil;
  switch (type[0]) {
    case 'B':
      desc = [NSAppleEventDescriptor descriptorWithBoolean:[self boolValue]];
      break;
      
    case 'c':
    case 'C':
    case 's':
    case 'S':
      desiredType = typeSInt16;
      break;
      
    case 'i':
    case 'l':
      desiredType = typeSInt32;
      break;
      
    case 'I':
    case 'L':
      desiredType = typeUInt32;
      break;
      
    case 'q':
    case 'Q':
      desiredType = typeSInt64;
      break;
      
    case 'f':
      desiredType = typeIEEE32BitFloatingPoint;
      break;
      
    case 'd':
    default:
      desiredType = typeIEEE64BitFloatingPoint;
      break;
  }
  
  if (!desc) {
    desc = [NSAppleEventDescriptor descriptorWithDouble:[self doubleValue]];
    if (desc && desiredType != typeIEEE64BitFloatingPoint) {
        desc = [desc coerceToDescriptorType:desiredType];
    }
  }
  return desc;  
}
@end

