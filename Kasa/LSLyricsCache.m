//
//  LSLyricsCache.m
//  Kasa
//
//  Created by Luavis on 12. 11. 15..
//  Copyright (c) 2012년 Luavis. All rights reserved.
//

#import "LSLyricsCache.h"

@implementation LSLyricsCache

+ (LSLyricsCache *)instance
{
    static LSLyricsCache * cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        cache = [[LSLyricsCache alloc] init];
    });
    
    return cache;
}


- (id)init
{
    self = [super init];
    if (self)
    {
        _fm = [NSFileManager defaultManager];
        self.cachePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Contents/Cache"];
        
        if(![self.fm fileExistsAtPath:self.cachePath])
        {
            [self.fm createDirectoryAtPath:self.cachePath withIntermediateDirectories:YES attributes:@{} error:nil];
            NSLog(@"New Create");
        }
    }
    
    return self;
}

- (BOOL)downloadFromMD5Hash:(NSString *)md5 withDictionaryOutput:(NSDictionary **)ret
{
    NSString * path = [self.cachePath stringByAppendingPathComponent:md5];
    
    if([self.fm fileExistsAtPath:path])
    {
        (*ret) = [[[NSDictionary alloc] initWithContentsOfFile:path] autorelease];
        
        CFAbsoluteTime currentTime = CFAbsoluteTimeGetCurrent();
        CFAbsoluteTime cacheTime = (CFAbsoluteTime)[(NSNumber *)[*ret objectForKey:DATE_CAHCE] doubleValue];
        
        if(currentTime - cacheTime > [[LSApplicationData instance] cacheVolatileTime])
        {
            return NO;
        }
        
        return YES;
    }
    
    return NO;
}

- (BOOL)saveCacheWithDictionary:(NSDictionary *)dict withMD5Hash:(NSString *)md5
{
    NSString * path = [self.cachePath stringByAppendingPathComponent:md5];
    NSMutableDictionary * write = [[NSMutableDictionary alloc] initWithDictionary:dict];
    
    if(![self.fm fileExistsAtPath:path])
    {
        [write setObject:@(CFAbsoluteTimeGetCurrent()) forKey:DATE_CAHCE];
        [write writeToFile:path atomically:YES];
        [write release];
    }
    else
    {
        NSError * err;
        [self.fm removeItemAtPath:path error:&err];
        [write setObject:@(CFAbsoluteTimeGetCurrent()) forKey:DATE_CAHCE];
        [write writeToFile:path atomically:YES];
        [write release];
    }
    
    return YES;
}

@end
