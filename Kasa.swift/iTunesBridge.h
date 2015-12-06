//
//  iTunesBridge.h
//  Kasa.swift
//
//  Created by Luavis Kang on 12/4/15.
//  Copyright © 2015 Luavis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iTunesTrackInformation: NSObject
@property (nonatomic, nonnull, readonly) NSString *title;
@property (nonatomic, nonnull, readonly) NSString *artist;

- (nonnull instancetype)initWithTitle:(nonnull NSString *)title artist:(nonnull NSString *)artist;
- (nonnull NSString *)description;
@end


@interface iTunesBridge : NSObject
- (double)playerPosition;
- (nonnull iTunesTrackInformation *)currentTrack;

@end
