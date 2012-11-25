//
//  NSColor+CGColor.m
//  Kasa
//
//  Created by Luavis on 12. 11. 5..
//  Copyright (c) 2012년 Luavis. All rights reserved.
//

#import "NSColor+CGColor.h"

@implementation NSColor (CGColor)

- (CGColorRef)CGColor
{
    const NSInteger numberOfComponents = [self numberOfComponents];
    CGFloat components[numberOfComponents];
    CGColorSpaceRef colorSpace = [[self colorSpace] CGColorSpace];
    
    [self getComponents:(CGFloat *)&components];
    
    return CGColorCreate(colorSpace, components);
}

+ (NSColor *)colorWithCGColor:(CGColorRef)CGColor
{
    if (CGColor == NULL) return nil;
    return [NSColor colorWithCIColor:[CIColor colorWithCGColor:CGColor]];
}

@end
