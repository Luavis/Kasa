//
//  LSLRCDecoder.m
//  Kasa
//
//  Created by Luavis on 12. 10. 31..
//  Copyright (c) 2012년 Luavis. All rights reserved.
//

#import "LSLRCDecoder.h"
#include <vector>

@implementation LSLRCDecoder

+ (LRCArray *)decode:(NSString *)lrc
{
    NSArray * segs = [lrc componentsSeparatedByString:LRC_DECODE_SEPERATER];
    size_t s = [segs count];
    std::vector<LRCComponent> * arr = new std::vector<LRCComponent>;
    
    for(int i = 0; i < s; i++)
    {
        NSString * comp = [segs objectAtIndex:i];
        NSError *error   = nil;
        NSRegularExpression *regexp =
        [NSRegularExpression regularExpressionWithPattern:LRC_DECODE_REGURAL
                                                  options:0
                                                    error:&error];
        if (error != nil)
        {
            NSLog(@"%@", error);
        }
        else
        {
            NSTextCheckingResult *match = [regexp firstMatchInString:comp options:0 range:NSMakeRange(0, comp.length)];
            LRCComponent l = new _LRCComponent();
            l->sec = [[comp substringWithRange:[match rangeAtIndex:1]] intValue] * 60 + [[comp substringWithRange:[match rangeAtIndex:2]] floatValue] - LRC_SEC_DELAY_TIME;
            NSString * lyric = [comp substringWithRange:[match rangeAtIndex:3]];
            l->lyrics = [lyric retain];
            arr->push_back(l);
            l = NULL;
            
            [lyric release];
        }
    }
    LRCArray * ret = [[LRCArray alloc] initWithLRCTS:(void *)(arr) withSize:s];
    delete arr;
    
    return [ret autorelease];
}

@end

@implementation LRCArray

- (id)initWithLRCTS:(void *)_lrcs withSize:(size_t)_size
{
    self = [super init];
    if(self)
    {
        std::vector<LRCComponent> *lrcs = (std::vector<LRCComponent> *)_lrcs;
        
        arr = new std::vector<LRCComponent>;
        
        for(int i = 0; i < _size - 1;)
        {
            NSString * append_lyric = (NSString *)((lrcs->operator[](i))->lyrics);
            
            int j;
            
            for(j = 1; i + j < _size; j++)
            {
                if((((lrcs->operator[](i))->sec == 0.0f)) || [append_lyric isEqualToString:@""])
                {
                    break;
                }
                if((lrcs->operator[](i))->sec == (lrcs->operator[](i+j))->sec)
                {
                    append_lyric = [append_lyric stringByAppendingFormat:@"\n%@",(lrcs->operator[](i+j))->lyrics];
                }
                else
                {
                    (lrcs->operator[](i))->lyrics = [append_lyric retain];
                    ((std::vector<LRCComponent> *) arr)->push_back(lrcs->operator[](i));
                    [append_lyric release];
                    break;
                }
            }
            
            i += j;
        }
        
        size = ((std::vector<LRCComponent> *) arr)->size();
        secTable = (double *)malloc(sizeof(double) * size);
        
        for(int i = 0; i < size; i++)
        {
            secTable[i] = ((std::vector<LRCComponent> *) arr)->operator[](i)->sec;
        }
        
        recentIndexFirst = 0;
        recentIndexSecond = 0;
    }
    
    return self;
}



- (id)get:(double)time
{
    static NSNull * null = [NSNull null];
    
    if(!arr || !secTable)
        return nil;
    
    if(time >= secTable[recentIndexSecond])
    {
        for(int i = recentIndexSecond; i < size; i++)
        {
            if(secTable[i] >= time)
            {
                if(i < 1)
                    return null;
                
                recentIndexFirst = i - 1;
                recentIndexSecond = i;
                LRCComponent com = ((std::vector<LRCComponent> *) arr)->operator[](i-1);
                
                if(!com)
                    return nil;
                NSString * l = com->lyrics;
                
                if(l)
                    return l;
                else
                    return nil;
                
            }
        }
    }
    else if(time < secTable[recentIndexFirst])
    {
        for(int i = recentIndexFirst-1; i > 0; i--)
        {
            if(secTable[i] > time)
            {
                if(i < 1)
                    return null;
                
                recentIndexFirst = i - 1;
                recentIndexSecond = i;
                LRCComponent com = ((std::vector<LRCComponent> *) arr)->operator[](i-1);
                if(!com)
                    return nil;
                NSString * l = com->lyrics;
                
                if(l)
                    return l;
                else
                    return nil;
            }
        }
    }
    else
    {
        return null;
    }
    
    //May be...?
    return nil;
}

- (NSUInteger)count
{
    return size;
}

- (void)dealloc
{
    if(secTable)
    {
        free(secTable);
        secTable = NULL;
    }

    if(arr)
    {
        for(int i = 0; i < size; i++)
            delete (((std::vector<LRCComponent> *)arr)->operator[](i));
        delete (std::vector<LRCComponent> *)arr;
        arr = NULL;
    }

    [super dealloc];
}

@end
