//
//  Md5.h
//  response
//
//  Created by Luavis on 11. 6. 22..
//  Copyright 2011 한국디지털미디어고등학교. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Md5 : NSObject {
    
}
+ (NSString*)md5:(NSString*)srcStr;
+ (NSString*)md5WithCString:(const char *)srcStr withLen:(NSUInteger)len;
@end
