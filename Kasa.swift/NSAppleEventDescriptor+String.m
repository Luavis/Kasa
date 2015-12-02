//
//  NSAppleEventDescriptor+String.m
//
//  Created by dmaclach on 6/6/07.
//  Copyright 2007 Google Inc. All rights reserved.
//

#import "NSAppleEventDescriptor+String.h"

@implementation NSString(StatzAppleEventDescriptorObjectAdditions)

// There's no need to registerSelectors for string types as
// object value falls through to attempting to call stringValue on any
// type that it doesn't know about. But if we were to implement it, this
// is what it would look like.

//+ (void)load {
//  DescType types[] = { 
//    typeUTF16ExternalRepresentation,
//    typeUnicodeText,
//    typeUTF8Text,
//    typeCString,
//    typePString,
//    typeChar,
//    typeIntlText };
//  
//  [NSAppleEventDescriptor registerSelector:@selector(stringValue)
//                                  forTypes:types
//                                     count:sizeof(types)/sizeof(DescType)];
//}

- (NSAppleEventDescriptor*)appleEventDescriptor {
  return [NSAppleEventDescriptor descriptorWithString:self];
}
@end

