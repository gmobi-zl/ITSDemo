//
//  ITSApplication.h
//  InternetStir
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#ifndef ITSApplication_h
#define ITSApplication_h

#import <Foundation/Foundation.h>
//#import "RemoteService.h"
#import "DataService.h"
#import "MMLogger.h"
#import "ReportService.h"

#define ITS_NSLocalizedString(key, comment) \
    [ITSApplication getLocalString:(key) defVal:comment]

@interface ITSApplication : NSObject

//@property RemoteService* remoteSvr;
@property DataService* dataSvr;
@property ReportService* reportSvr;

@property NSString* baseUrl;
//@property NSString* group;
@property BOOL isFirstOpen;
@property BOOL isUserOpen;


+(void) start;
+(void) stop;
+(ITSApplication*) get;
-(void) initServices;

+(NSString*) getLocalString: (NSString*) key
                     defVal: (NSString*) def;

-(void) connect;
-(void) refreshChannels;
-(void) setCustomerLanguage: (NSString*) lang;

@end

#endif /* ITSApplication_h */
