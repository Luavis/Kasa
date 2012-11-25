//
//  LSLyricShow.h
//  Kasa
//
//  Created by Luavis on 12. 10. 31..
//  Copyright (c) 2012년 Luavis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSiTunesConnection.h"


@interface LSLyricTextField : NSTextField <LSiTunesConnectionDelegate>
{
@public
    int flag;
@private
    float height;
    NSFont * t_font;
    CGFloat t_width;
    NSSize t_size;
    NSTextContainer * t_textContainer;
    NSLayoutManager * t_layoutManager;
    NSRange t_range;
}

@end