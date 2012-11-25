//
//  LSAppDelegate.m
//  Kasa
//
//  Created by Luavis on 12. 10. 30..
//  Copyright (c) 2012년 Luavis. All rights reserved.
//

#import "LSApplication.h"
#import <Quartz/Quartz.h>
#import "LSITunesConnection.h"

@implementation LSApplication

- (void)bindingObjects
{
    [[LSiTunesConnection instance] setDelegate:self.lyricView];
    [[LSiTunesConnection instance] startListening];
}

- (void)applicationMainWindowModeInitialize
{
    [self.window setBackgroundColor:[[NSColor blackColor] colorWithAlphaComponent:0.08f]];
    NSUInteger collectionBehavior = [self.window collectionBehavior];
    collectionBehavior |= NSWindowCollectionBehaviorCanJoinAllSpaces;
    [self.window setCollectionBehavior:collectionBehavior];
    
    int64_t delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context)
                        {
                            [[self.informationLabel animator] setAlphaValue:0.0];
                        } completionHandler:^
                        {
                            [NSObject cancelPreviousPerformRequestsWithTarget:self];
                            [self.informationLabel setHidden:YES];
                        }];
                   });
}

- (void)applicationMainWindowLabelInitialize
{
    [self.lyricView setWantsLayer:YES];
    self.lyricView.layer.backgroundColor = [[NSColor clearColor] CGColor];
    self.lyricView.layer.shadowColor = [[NSColor blackColor] CGColor];
    self.lyricView.layer.shadowOffset = CGSizeMake(6.0f, 6.0f);
    self.lyricView.layer.shadowOpacity = 5.0f;
    self.lyricView.layer.shadowRadius = 30.0;
    
    [self.informationLabel setWantsLayer:YES];
    self.informationLabel.layer.backgroundColor = [[NSColor clearColor] CGColor];
    self.informationLabel.layer.shadowColor = [[NSColor blackColor] CGColor];
    self.informationLabel.layer.shadowOffset = CGSizeMake(6.0f, 6.0f);
    self.informationLabel.layer.shadowOpacity = 5.0f;
    self.informationLabel.layer.shadowRadius = 30.0;
}

- (void)applicationContextInitialize
{
    [self applicationMainWindowLabelInitialize];
    [self applicationMainWindowModeInitialize];
    [self bindingObjects];
}

- (void)awakeFromNib
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        [self applicationContextInitialize];
    });
}

@end
