//
//  LSApplicationData.m
//  Kasa
//
//  Created by Luavis on 12. 10. 31..
//  Copyright (c) 2012년 Luavis. All rights reserved.
//

#import "LSApplicationData.h"

@implementation LSApplicationData

static LSApplicationData * LSApplicationData_instance = nil;

+ (LSApplicationData *)instance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{});
    
    return LSApplicationData_instance;
}

- (void)awakeFromNib
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
//        _null = [NSNull null];
        self.exitAlpha = @1.0;
        self.enterAlpha = @1.0;
        self.isAlpha = YES;
        self.cacheVolatileTime = 60 * 60 * 24;
    });
    
    LSApplicationData_instance = self;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

@end
