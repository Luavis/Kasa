//
//  NSAppleScript+Handler.h
//
//  Created by dmaclach on 6/6/07.
//  Copyright 2007 Google Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
/// A category for calling handlers in NSAppleScript
@interface NSAppleScript(StatzAppleScriptHandlerAdditions)
/// This method allows us to call a specific handler in an AppleScript.
/// parameters are passed in left-right order 0-n.
///
/// Args:
///   handler - name of the handler to call in the Applescript
///   params - the parameters to pass to the handler
///   error - in non-nil returns any error that may have occurred.
///
/// Returns:
///   The result of the handler being called. nil on failure.
- (NSAppleEventDescriptor*)executeHandler:(NSString*)handler 
                               parameters:(NSArray*)params 
                                    error:(NSDictionary**)error;
@end
