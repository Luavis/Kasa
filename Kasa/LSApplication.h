//
//  LSAppDelegate.h
//  Kasa
//
//  Created by Luavis on 12. 10. 30..
//  Copyright (c) 2012년 Luavis. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LSLyricTextField.h"

@interface LSApplication : NSObject

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet LSLyricTextField *lyricView;
@property (assign) IBOutlet NSTextField *informationLabel;
@end
