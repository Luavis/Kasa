//
//  LSKasaGetter.h
//  Kasa
//
//  Created by Luavis on 12. 10. 30..
//  Copyright (c) 2012년 Luavis. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KASA_DOWNLOAD_ERROR @"error"

#define strStatusID                 @"strStatusID"
#define strInfoID                   @"strInfoID"
#define strRegistDate               @"strRegistDate"
#define strTitle                    @"strTitle"
#define strArtist                   @"strArtist"
#define strAlbum                    @"strAlbum"
#define strCountGood                @"strCountGood"
#define strCountBad                 @"strCountBad"
#define strLyric                    @"strLyric"
#define strRegisterFirstName        @"strRegisterFirstName"
#define strRegisterFirstEMail       @"strRegisterFirstEMail"
#define strRegisterFirstURL         @"strRegisterFirstURL"
#define strRegisterFirstPhone       @"strRegisterFirstPhone"
#define strRegisterFirstComment     @"strRegisterFirstComment"
#define strRegisterName             @"strRegisterName"
#define strRegisterEMail            @"strRegisterEMail"
#define strRegisterURL              @"strRegisterURL"
#define strRegisterPhone            @"strRegisterPhone"
#define strRegisterComment          @"strRegisterComment"

@interface LSKasaGetter : NSObject
+ (NSDictionary *)synchronizedDownloadWithURL:(NSString *)url;
@end
