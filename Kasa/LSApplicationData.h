//
//  LSApplicationData.h
//  Kasa
//
//  Created by Luavis on 12. 10. 31..
//  Copyright (c) 2012년 Luavis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSLyricTextField.h"
#import "LSLRCDecoder.h"

@interface LSApplicationData : NSObject
@property(nonatomic, assign) IBOutlet LSLyricTextField  * lyricView;
@property(nonatomic, retain) NSNumber * enterAlpha;
@property(nonatomic, retain) NSNumber * exitAlpha;
@property(nonatomic) BOOL isAlpha;
@property(nonatomic) double cacheVolatileTime;
//@property(nonatomic, weak, readonly)NSNull * null;
+ (LSApplicationData *)instance;
@end


