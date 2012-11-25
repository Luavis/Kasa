//
//  LSLyricsCache.h
//  Kasa
//
//  Created by Luavis on 12. 11. 15..
//  Copyright (c) 2012년 Luavis. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DATE_CAHCE @"Date"

@interface LSLyricsCache : NSObject

@property (nonatomic, retain) NSString * cachePath;
@property (nonatomic, retain, readonly) NSFileManager * fm;

+ (LSLyricsCache *)instance;
- (BOOL)downloadFromMD5Hash:(NSString *)md5 withDictionaryOutput:(NSDictionary **)ret;
- (BOOL)saveCacheWithDictionary:(NSDictionary *)dict withMD5Hash:(NSString *)md5;

@end
