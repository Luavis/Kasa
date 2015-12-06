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

@implementation iTunesTrackInformation

- (instancetype)initWithTitle:(NSString *)title artist:(NSString *)artist {

    self = [super init];
    if(self) {
        _title = title;
        _artist = artist;
    }

    return self;
}

- (nonnull NSString *)description {
    return [NSString stringWithFormat:@"[iTunesInform] Title: %@, Artist: %@", self.title, self.artist];
}

@end

@implementation iTunesBridge

+ (void)initialize {
    application = (iTunesApplication *)[[SBApplication alloc] initWithBundleIdentifier:@"com.apple.iTunes"];
}

- (double)playerPosition {
    return application.playerPosition;
}

- (iTunesTrackInformation *)currentTrack {
    iTunesTrack *track = application.currentTrack;

    iTunesTrackInformation *information = [[iTunesTrackInformation alloc] initWithTitle:track.name artist:track.artist];

    return information;
}

@end
