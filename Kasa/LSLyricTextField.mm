//
//  LSLyricShow.m
//  Kasa
//
//  Created by Luavis on 12. 10. 31..
//  Copyright (c) 2012년 Luavis. All rights reserved.
//

#import "LSLyricTextField.h"
#import "LSKasaGetter.h"
#include <pthread.h>
#include <string>

void reGen(id target, SEL sel ,LRCArray * arr, int serial);

@implementation LSLyricTextField

- (BOOL)drawsBackground
{
    return NO;
}

- (void)awakeFromNib
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        height = self.frame.size.height;
        
        t_font = [self font];
        t_width = self.frame.size.width;
        t_size = NSMakeSize(t_width, FLT_MAX);
        t_range = NSMakeRange(0, 0);
        t_textContainer = [[NSTextContainer alloc] initWithContainerSize:t_size];
        t_layoutManager = [[NSLayoutManager alloc] init];
        [t_textContainer setLineFragmentPadding:0.0];
        [t_layoutManager addTextContainer:t_textContainer];
    });
}

- (BOOL)locationCheck:(NSString *)location
{
    if(!location)
    {
        [self refresh:@"노래의 경로가 확실하지 않습니다."];
        return NO;
    }
    
    //when music is stop.
    if(location == (NSString *)[NSNull null])
    {
//        dispatch_sync(dispatch_get_main_queue(), ^
//                      {
                          [self refresh:@""];
//                      });
        return NO;
    }
    
    return YES;
}

- (void)modeChange
{
    flag++;
}

- (void)musicChanged:(NSString *)location
{
    [self modeChange];
    
    if(![self locationCheck:location])
        return;
    
    dispatch_queue_t qu = dispatch_queue_create("com.Luavis.Kasa.KasaDownloader", NULL);
    dispatch_async(qu, ^
    {
        NSDictionary * dict = [LSKasaGetter synchronizedDownloadWithURL:location];
        
        if(!dict)
        {
            dispatch_sync(dispatch_get_main_queue(), ^
            {
                [self refresh:@"인터넷 연결을 확인 해주세요"];
                
                int64_t delayInSeconds = 5.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                {
                    [self musicChanged:location];
                });
            });
            
            return;
        }
        
        NSString * lyric = [dict objectForKey:strLyric];
        if([lyric isEqualToString:@""])
        {
            dispatch_sync(dispatch_get_main_queue(), ^
            {
                [self refresh:@"가사가 없습니다."];
            });
            
            return;
        }
        
        LRCArray * lrca = [LSLRCDecoder decode:lyric];
        
        
        
        [[NSRunLoop currentRunLoop] ]
        //initialize lyric view
        dispatch_sync(dispatch_get_main_queue(), ^
        {
            [self refresh:@""];
        });
        
        dispatch_queue_t rQu = dispatch_queue_create("com.Luavis.Kasa.Shower", NULL);
        dispatch_async(rQu, ^
        {
            reGen(self, @selector(refresh:), lrca , flag);
        });
        dispatch_release(rQu);
        
    });
    
    dispatch_release(qu);
}

- (void)refresh:(NSString *)st
{
    if(!st || ![st isKindOfClass:[NSString class]])
        return;
    
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithString:st];;
    
    [t_layoutManager replaceTextStorage:textStorage];
    [textStorage addLayoutManager:t_layoutManager];
    t_range.length = [textStorage length];
    
    [textStorage addAttribute:NSFontAttributeName value:t_font range:t_range];
    [t_layoutManager glyphRangeForTextContainer:t_textContainer];
    
    float h = [t_layoutManager usedRectForTextContainer:t_textContainer].size.height;
    if(h != height)
    {
        float delta = height - h;
        height = h;
        CGRect windowFrame = _window.frame;
        
        windowFrame.size.height -= delta;
        [[self window] setFrame:windowFrame display:YES animate:YES];
    }
    
    [textStorage release];
    self.stringValue = st;
}

@end

typedef struct _timerParameter
{
    id target;
    SEL sel;
    LRCArray * arr;
    int serial;
    double position = 0;
    IMP draw;
    IMP get;
    int isNeedInitialize;
    CFAbsoluteTime startTime;
    double gap;
} TimerParameter;

static SEL getSEL = @selector(get:);
static NSAppleScript* theScript = [[NSAppleScript alloc] initWithSource:@"tell application \"iTunes\" to if running then\nreturn player position\nend if"];

void timerCallBack(CFRunLoopTimerRef timer, void *info)
{
    static NSNull * null = [NSNull null];
    TimerParameter * param = (TimerParameter *)info;
    LRCArray * arr = param->arr;
    id target = param->target;
    SEL sel = param->sel;
    int serial = param->serial;
    NSDictionary *errorDict;
    id com = nil;
    double gap = 0.0f;
    
    if(serial != ((LSLyricTextField *)target)->flag)
    {
        //            free(param); I thimk it should be but if free() added it become error
        CFRunLoopStop(CFRunLoopGetCurrent());
    }
    if(param->isNeedInitialize > 1000)
    {
        param->position = [[theScript executeAndReturnError:&errorDict] int32Value];
        param->startTime = CFAbsoluteTimeGetCurrent();
        param->isNeedInitialize = 0;
    }
    
    gap = CFAbsoluteTimeGetCurrent() - param->startTime;
    com = param->get(arr, getSEL, param->position + gap);
    
    param->isNeedInitialize++;
    
    if(com ==  null|| !(com))
        return;
    
    dispatch_sync(dispatch_get_main_queue(), ^{param->draw(target, sel, com);});
}


void reGen(id target, SEL sel ,LRCArray * arr, int serial)
{
    if(arr == nil || target == nil)
        return;
    
    CFRunLoopRef ref = CFRunLoopGetCurrent();
    TimerParameter * param = new TimerParameter();
    NSDictionary *errorDict;
    
    param->arr = arr;
    param->target = target;
    param->sel = sel;
    param->serial = serial;
    param->draw = [target methodForSelector:sel];
    param->get = [LRCArray instanceMethodForSelector:getSEL];
    param->isNeedInitialize = 0;
    
    CFRunLoopTimerContext context = {0, param, NULL, NULL, NULL};
    CFRunLoopTimerRef timer = CFRunLoopTimerCreate(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent(), 0.03, 0, 0, timerCallBack, &context);
    CFRunLoopAddTimer(ref, timer, kCFRunLoopCommonModes);
    param->startTime = CFAbsoluteTimeGetCurrent();
    param->position = [[theScript executeAndReturnError:&errorDict] int32Value];
    CFRunLoopRun();
}



/*
//Past reGen source : we do not use this because it make program crazy(CPU 89%~90%)
void reGen(id target, SEL sel ,LRCArray * arr, int serial)
{
#ifdef PAST
    static NSAppleScript* theScript = [[NSAppleScript alloc] initWithSource:@"tell application \"iTunes\" to if running then\nreturn player position\nend if"];
    
    if(arr == nil || target == nil)
        return;
    
    NSDictionary *errorDict;
    id com = @"";
    NSNull * null = [NSNull null];
    CFAbsoluteTime past;
    CFAbsoluteTime present;
    
    while (com)
    {
        past = CFAbsoluteTimeGetCurrent();
        
        if(serial != [target flag])
            return;
        
        NSAppleEventDescriptor * resultDescriptor = [theScript executeAndReturnError:&errorDict];
        SInt32 position = [resultDescriptor int32Value];
        
        com = [arr get:position];
        
        if([com isEqual:null] || !(com))
            continue;
        
        NSLog(@"%@",com);
        
        dispatch_sync(dispatch_get_main_queue(), ^
                      {
                          [target performSelector:sel withObject:(com)];
                      });
        
        present = CFAbsoluteTimeGetCurrent();
        NSLog(@"%f",present - past);
        
        [NSThread sleepForTimeInterval:0.01];
    }
#elif !defined(NEW_WAY)
    static NSAppleScript* theScript = [[NSAppleScript alloc] initWithSource:@"tell application \"iTunes\" to if running then\nreturn player position\nend if"];
    static SEL getSEL = @selector(get:);
    static SEL setValueSEL = @selector(int32Value);
    static SEL scriptExcuteSEL = @selector(executeAndReturnError:);
    
    if(arr == nil || target == nil)
        return;
    
    NSDictionary *errorDict;
    id com = @"";
    
    NSAppleEventDescriptor * resultDescriptor;
    SInt32 position = 0;
    
    IMP get = [LRCArray instanceMethodForSelector:getSEL];
    IMP draw = [target methodForSelector:sel];
    
    IMP scriptExcute = [NSAppleScript instanceMethodForSelector:scriptExcuteSEL];
    typedef SInt32(*newIMP)(id target, SEL cmd, ...);
    newIMP setValue = (newIMP)[NSAppleEventDescriptor instanceMethodForSelector:setValueSEL];
    
    while (com)
    {
//        NSLog(@"My serial is %i Object Serial is %i",serial, ((LSLyricTextField *)target).flag);
        if(serial != ((LSLyricTextField *)target)->flag)
            return;
        
        resultDescriptor = scriptExcute(theScript, scriptExcuteSEL, &errorDict);
        position = setValue(resultDescriptor, setValueSEL);
        
        com = get(arr, getSEL, position);
        
        if(com == [NSNull null] || !(com))
            continue;
        
        dispatch_sync(dispatch_get_main_queue(), ^
                      {
                          draw(target, sel, com);
                      });
        [NSThread sleepForTimeInterval:0.005];
    }
#else
    if(arr == nil || target == nil)
        return;
    
    static NSAppleScript* theScript = [[NSAppleScript alloc] initWithSource:@"tell application \"iTunes\" to if running then\nreturn player position\nend if"];
    static SEL getSEL = @selector(get:);
    static NSNull * null = [NSNull null];
    
    
    
    NSDictionary *errorDict;
    id com = nil;
    double position = 0;
    IMP draw = [target methodForSelector:sel];
    typedef SInt32(*newIMP)(id target, SEL cmd, ...);
    IMP get = [LRCArray instanceMethodForSelector:getSEL];
    int isNeedInitialize = 0;
    CFAbsoluteTime newTime = 0;
    CFAbsoluteTime startTime = -1;
    double gap = 0.0f;
    position = [[theScript executeAndReturnError:&errorDict] int32Value];
    startTime = CFAbsoluteTimeGetCurrent();
    
    while (1)
    {
        if(serial != ((LSLyricTextField *)target)->flag)
            return;
        if(isNeedInitialize > 1000)
        {
            position = [[theScript executeAndReturnError:&errorDict] int32Value];
            startTime = CFAbsoluteTimeGetCurrent();
            isNeedInitialize = 0;
        }
        
        newTime = CFAbsoluteTimeGetCurrent();
        gap = newTime - startTime;
        com = get(arr, getSEL, position + gap);
        
        isNeedInitialize++;
        
        if(com ==  null|| !(com))
            continue;
        
        dispatch_sync(dispatch_get_main_queue(), ^{draw(target, sel, com);});
        usleep(80000);
    }
#endif
}
*/