//
//  Md5.m
//  response
//
//  Created by Luavis on 11. 6. 22..
//  Copyright 2011 한국디지털미디어고등학교. All rights reserved.
//

#import "Md5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation Md5

+ (NSString*)md5:(NSString*)srcStr
{
    return [self md5WithCString:[srcStr UTF8String] withLen:[srcStr length]];
}

+ (NSString*)md5WithCString:(const char *)srcStr withLen:(NSUInteger)len
{
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(srcStr, (unsigned int)len, result);
    
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X", result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
}

@end
