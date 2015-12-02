//
//  NSAppleScript+Handler.m
//
//  Created by dmaclach on 6/6/07.
//  Copyright 2007 Google Inc. All rights reserved.
//

#import <Carbon/Carbon.h>
#import "NSAppleScript+Handler.h"
#import "NSAppleEventDescriptor+Array.h"

@implementation NSAppleScript(StatzAppleScriptHandlerAdditions)

- (NSAppleEventDescriptor*)executeHandler:(NSString*)handler 
                               parameters:(NSArray*)params 
                                    error:(NSDictionary**)error {
  // create and populate the list of parameters
  NSAppleEventDescriptor *parameters = [params appleEventDescriptor];
  // create the AppleEvent target
  ProcessSerialNumber psn = { 0, kCurrentProcess };
  NSAppleEventDescriptor *target = [NSAppleEventDescriptor descriptorWithDescriptorType:typeProcessSerialNumber
                                                                                  bytes:&psn
                                                                                 length:sizeof(ProcessSerialNumber)];
  // create an NSAppleEventDescriptor with the method name
  // note that the name must be lowercase (even if it is uppercase in AppleScript)
  NSAppleEventDescriptor *handlerDesc = [NSAppleEventDescriptor descriptorWithString:[handler lowercaseString]];
  // last but not least, create the event for an AppleScript subroutine
  // set the method name and the list of parameters
  NSAppleEventDescriptor *event = [NSAppleEventDescriptor appleEventWithEventClass:kASAppleScriptSuite
                                                                           eventID:kASSubroutineEvent
                                                                  targetDescriptor:target
                                                                          returnID:kAutoGenerateReturnID
                                                                     transactionID:kAnyTransactionID];
  [event setParamDescriptor:handlerDesc forKeyword:keyASSubroutineName];
  if (parameters) {
    [event setParamDescriptor:parameters forKeyword:keyDirectObject];
  }
  // at last, call the event in the AppleScript's context
  return [self executeAppleEvent:event error:error];
}  
@end
