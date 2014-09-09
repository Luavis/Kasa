//
//  LSKasaGetter.m
//  Kasa
//
//  Created by Luavis on 12. 10. 30..
//  Copyright (c) 2012년 Luavis. All rights reserved.
//

#import "LSKasaGetter.h"
#import "LSLyricsCache.h"
#import "Md5.h"
//ALSong Lyrics URL
#define URL @"http://lyrics.alsong.co.kr/ALSongWebService/Service1.asmx"
//ALSong HTTP Body frame
#define HTTP_BODY @"<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\"><s:Body><GetLyric8 xmlns=\"ALSongWebServer\" xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\"><encData></encData><stQuery><strChecksum>%@</strChecksum><strVersion>1.0</strVersion><strMACAddress></strMACAddress><strIPAddress>127.0.0.1</strIPAddress></stQuery></GetLyric8></s:Body></s:Envelope>"

@implementation LSKasaGetter

+ (NSURLRequest *)makeURLRequestWithMD5Hash:(NSString *)md5
{
    NSMutableURLRequest * req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL] cachePolicy:NSURLCacheStorageAllowed timeoutInterval:30.0];
    
    NSData * combind = [[NSString stringWithFormat:HTTP_BODY,md5] dataUsingEncoding:NSUTF8StringEncoding];
    
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:combind];
    [req setValue:@"\"ALSongWebServer/GetLyric8\"" forHTTPHeaderField:@"SOAPAction"];
    [req setValue:@"100-continue" forHTTPHeaderField:@"Expect"];
    [req setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    [req setValue:[NSString stringWithFormat:@"%li",[combind length]] forHTTPHeaderField:@"Content-Length"];
    
    return req;
}

+ (NSString *)makeALSongMD5HASHWithURL:(NSString *)url
{
    NSInputStream * iStream = [[NSInputStream alloc] initWithURL:[NSURL URLWithString:url]];
    [iStream open];
    int Start = 0;
    
    while ([iStream hasBytesAvailable])
    {
        uint8_t buf[255];
        NSInteger readLength = [iStream read:buf maxLength:3];
        
        if(readLength <3)
            break;
        if(buf[0] == 'I' && buf[1] == 'D' && buf[2] == '3')
        {
            [iStream read:buf maxLength:7];
#define ID3_TAGSIZE(x) ((*(x) << 21) | (*((x) + 1) << 14) | (*((x) + 2) << 7) | *((x) + 3))
            Start += ID3_TAGSIZE(buf + 3) + 10;
#undef ID3_TAGSIZE
        }
        else
            break;
    }
    
    [iStream setProperty:@(Start) forKey:NSStreamFileCurrentOffsetKey];
    
    while ([iStream hasBytesAvailable])
    {
        for(;;Start ++)
        {
            uint8_t temp;
            [iStream read:&temp maxLength:1];
            
            if(temp == 0xFF)
            {
                break;
            }
        }
        
        break;
    }
    
    [iStream setProperty:@(Start) forKey:NSStreamFileCurrentOffsetKey];
    
    NSString * ret = nil;
    
    if ([iStream hasBytesAvailable])
    {
        uint8_t * temp = (uint8_t * )malloc(163840);
        [iStream read:temp maxLength:163840];
        ret = [Md5 md5WithCString:(const char *)temp withLen:163840];
        free(temp);
    }
    
    [iStream close];
    [iStream release];
    return ret;
}

#define KASA_DATA_KEY   @"data"
#define KASA_REP_KEY    @"rep"
#define KASA_ERROR_KEY  @"err"

+ (NSDictionary *)download:(NSURLRequest *)req
{
    id err = nil;
    NSURLResponse * rep = nil;
    
    NSData * ret = [NSURLConnection sendSynchronousRequest:req returningResponse:&rep error:&err];
    NSNull * null = [NSNull null];
    
    if(!err)
    {
        return @{KASA_DATA_KEY : ret, KASA_REP_KEY : rep, KASA_ERROR_KEY : null};
    }
    else
    {
        return @{KASA_DATA_KEY : null, KASA_REP_KEY : null, KASA_ERROR_KEY : err};
    }
}

+ (NSDictionary *)analyzeWithDictionary:(NSDictionary *)dict
{
    NSXMLDocument * doc = [[NSXMLDocument alloc] initWithData:[dict objectForKey:KASA_DATA_KEY] options:0 error:nil];
    NSError * err = nil;
    
    NSXMLElement * node = [[[[[[doc nodesForXPath:@"/soap:Envelope/soap:Body" error:&err] objectAtIndex:0] elementsForName:@"GetLyric8Response"] objectAtIndex:0] elementsForName:@"GetLyric8Result"] objectAtIndex:0];
    
    NSMutableDictionary * ret = [[NSMutableDictionary alloc] init];
    @try {
        [ret setObject:[[[node elementsForName:strStatusID] objectAtIndex:0] stringValue] forKey:strStatusID];
        [ret setObject:[[[node elementsForName:strInfoID] objectAtIndex:0] stringValue] forKey:strInfoID];
        [ret setObject:[[[node elementsForName:strRegistDate] objectAtIndex:0] stringValue] forKey:strRegistDate];
        [ret setObject:[[[node elementsForName:strTitle] objectAtIndex:0] stringValue] forKey:strTitle];
        [ret setObject:[[[node elementsForName:strArtist] objectAtIndex:0] stringValue] forKey:strArtist];
        [ret setObject:[[[node elementsForName:strAlbum] objectAtIndex:0] stringValue] forKey:strAlbum];
        [ret setObject:[[[node elementsForName:strCountGood] objectAtIndex:0] stringValue] forKey:strCountGood];
        [ret setObject:[[[node elementsForName:strCountBad] objectAtIndex:0] stringValue] forKey:strCountBad];
        [ret setObject:[[[node elementsForName:strLyric] objectAtIndex:0] stringValue] forKey:strLyric];
        [ret setObject:[[[node elementsForName:strRegisterFirstName] objectAtIndex:0] stringValue] forKey:strRegisterFirstName];
        [ret setObject:[[[node elementsForName:strRegisterFirstEMail] objectAtIndex:0] stringValue] forKey:strRegisterFirstEMail];
        [ret setObject:[[[node elementsForName:strRegisterFirstURL] objectAtIndex:0] stringValue] forKey:strRegisterFirstURL];
        [ret setObject:[[[node elementsForName:strRegisterFirstPhone] objectAtIndex:0] stringValue] forKey:strRegisterFirstPhone];
        [ret setObject:[[[node elementsForName:strRegisterFirstComment] objectAtIndex:0] stringValue] forKey:strRegisterFirstComment];
        [ret setObject:[[[node elementsForName:strRegisterName] objectAtIndex:0] stringValue] forKey:strRegisterName];
        [ret setObject:[[[node elementsForName:strRegisterEMail] objectAtIndex:0] stringValue] forKey:strRegisterEMail];
        [ret setObject:[[[node elementsForName:strRegisterURL] objectAtIndex:0] stringValue] forKey:strRegisterURL];
        [ret setObject:[[[node elementsForName:strRegisterPhone] objectAtIndex:0] stringValue] forKey:strRegisterPhone];
        [ret setObject:[[[node elementsForName:strRegisterComment] objectAtIndex:0] stringValue] forKey:strRegisterComment];
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@", exception);
        [doc release];
        return nil;
    }
    
    [doc release];
    
    return [ret autorelease];
}

+ (NSDictionary *)synchronizedDownloadWithURL:(NSString *)url
{
    NSString * hash = [self makeALSongMD5HASHWithURL:url];
    
    LSLyricsCache * cache = [LSLyricsCache instance];
    
    NSDictionary * dtc = nil;
    BOOL flag = [cache downloadFromMD5Hash:hash withDictionaryOutput:&dtc];
    
    if(flag)
    {
        return dtc;
    }
    else
    {
        NSDictionary * new = [self download:[self makeURLRequestWithMD5Hash:hash]];
        if([new objectForKey:KASA_ERROR_KEY] != [NSNull null])
        {
            return dtc;
        }
        else
        {
            NSDictionary * ret = [self analyzeWithDictionary:new];
            [cache saveCacheWithDictionary:ret withMD5Hash:hash];
            
            return ret;
        }
    }
}

@end
