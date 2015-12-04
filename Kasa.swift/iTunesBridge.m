//
//  iTunesBridge.m
//  Kasa.swift
//
//  Created by Luavis Kang on 12/4/15.
//  Copyright © 2015 Luavis. All rights reserved.
//

#import "iTunesBridge.h"
#import <ScriptingBridge/ScriptingBridge.h>
#import "iTunes.h"


iTunesApplication *application;

@implementation iTunesBridge

+ (void)initialize {
    application = (iTunesApplication *)[[SBApplication alloc] initWithBundleIdentifier:@"com.apple.iTunes"];
}

- (double)playerPosition {
    return application.playerPosition;
}

@end
