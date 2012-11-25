//
//  LSLRCDecoder.h
//  Kasa
//
//  Created by Luavis on 12. 10. 31..
//  Copyright (c) 2012년 Luavis. All rights reserved.
//

#import <Foundation/Foundation.h>
#define LRC_TIME    @"TIME"
#define LRC_LYRIC   @"LYRIC"
#define LRC_DECODE_REGURAL @"\\[([0-9]+):([0-9\\.]+)\\](.*)"
#define LRC_DECODE_SEPERATER @"<br>"
//#define GET_IGNORE_VALUE "-1"
#define LRC_SEC_DELAY_TIME 0.08

typedef struct _LRCComponent
{
    NSString * lyrics;
    double sec;
} * LRCComponent;

@interface LRCArray : NSObject
{
    @private
    double * secTable;
    void * arr;
    int recentIndexFirst;
    int recentIndexSecond;
    long size;
}
//@property (nonatomic, readonly)NSArray * arr;
- (id)initWithLRCTS:(void *)lrcs withSize:(size_t)size;
- (id)get:(double)time;
- (NSUInteger)count;

@end

@interface LSLRCDecoder : NSObject

+ (LRCArray *)decode:(NSString *)lrc;

@end