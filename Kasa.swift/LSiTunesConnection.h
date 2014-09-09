//
//  LSITunesConnection.h
//  Kasa
//
//  Created by Luavis on 12. 10. 31..
//  Copyright (c) 2012년 Luavis. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PLAYING @"Playing"
#define PAUSE @"Paused"
#define APPLESCRIPT_GET_NOW_PLAYING @"tell application \"iTunes\" to if running then\ntell current track to return &location\nend if"

@class LSiTunesConnection;

@protocol LSiTunesConnectionDelegate <NSObject>
- (void)musicChanged:(NSString *)location;
@end

@interface LSiTunesConnection : NSObject
@property (nonatomic, unsafe_unretained) id<LSiTunesConnectionDelegate> delegate;

+ (LSiTunesConnection *)instance;
- (void)startListening;

@end
