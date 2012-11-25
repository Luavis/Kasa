//
//  NSColor+CGColor.h
//  Kasa
//
//  Created by Luavis on 12. 11. 5..
//  Copyright (c) 2012년 Luavis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSColor (CGColor)

//
// The Quartz color reference that corresponds to the receiver's color.
//
@property (nonatomic, readonly) CGColorRef CGColor;

//
// Converts a Quartz color reference to its NSColor equivalent.
//
+ (NSColor *)colorWithCGColor:(CGColorRef)color;

@end