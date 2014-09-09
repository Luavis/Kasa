//
//  LSITunesConnection.m
//  Kasa
//
//  Created by Luavis on 12. 10. 31..
//  Copyright (c) 2012년 Luavis. All rights reserved.
//

#import "LSiTunesConnection.h"

@implementation LSiTunesConnection

+ (LSiTunesConnection *)instance
{
    static dispatch_once_t onceToken;
    static LSiTunesConnection * instance = nil;
    dispatch_once(&onceToken, ^
    {
        instance = [[LSiTunesConnection alloc] init];
    });
    
    return instance;
}

- (void)startListening
{
    if(self.delegate)
    {
        //set iTunes Distributed Notification Center
        NSDistributedNotificationCenter *dnc = [NSDistributedNotificationCenter defaultCenter];
        [dnc addObserver:self selector:@selector(updateTrackInfo:) name:@"com.apple.iTunes.playerInfo" object:nil];
        
        //Get Now Time Music Information
        NSAppleScript* theScript = [[NSAppleScript alloc] initWithSource:APPLESCRIPT_GET_NOW_PLAYING];
        NSDictionary *errorDict;
        NSAppleEventDescriptor *resultDescriptor = [theScript executeAndReturnError:&errorDict];
        [theScript release];
        
        NSString * re = [resultDescriptor stringValue];
        if(errorDict || !re)
            return;
        NSString * loc = [@"file://Volumes" stringByAppendingString:[[re stringByReplacingOccurrencesOfString:@":" withString:@"/"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        [self.delegate musicChanged:loc];
    }
}

- (void)updateTrackInfo:(NSNotification *)notification
{
    if(self.delegate)
    {
        NSDictionary *information = [notification userInfo];
        NSString * location = [information objectForKey:@"Location"];
        NSString * state = [information objectForKey:@"Player State"];
        
        if([state isEqualToString:PLAYING])
            [self.delegate musicChanged:location];
        else
            [self.delegate musicChanged:(NSString *)[NSNull null]];
    }
}

@end
