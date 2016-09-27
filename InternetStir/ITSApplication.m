//
//  ITSApplication.m
//  InternetStir
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITSApplication.h"
#import "ConfigService.h"
#import "MMSystemHelper.h"
#import "SettingService.h"
#import "MMEventService.h"
#import "NewsService.h"
#import "ITSAppConst.h"
#import "MMLogger.h"

#define IOS_LOCAL_STRING 1

ITSApplication* internetStirAppInstance = nil;
NSString* customerLocal = nil;

@implementation ITSApplication


+(void) start{
    @synchronized(self){
        if (internetStirAppInstance == nil){
            internetStirAppInstance = [ITSApplication alloc];
            
            [internetStirAppInstance initServices];
        }
    }
}

+(ITSApplication*) get{
    @synchronized(self){
        if (internetStirAppInstance == nil){
            [self start];
        }
    }
    return internetStirAppInstance;
}

+(void) stop{
    @synchronized(self){
        if (internetStirAppInstance != nil){
            [internetStirAppInstance stopServices];
        }
    }
}

-(void) initServices {
    [MMLogger openLog:@"Celeb" logLevel:MM_LOG_I_LEVEL_DEBUG maxLogCount:5];
    
    //self.remoteSvr = [RemoteService alloc];
    self.dataSvr = [DataService alloc];
    
    self.reportSvr = [ReportService alloc];

    self.fbSvr = [FacebookService alloc];
    self.tw = [TwitterService alloc];
    self.isUserOpen = NO;
    [self.reportSvr initService];
    
    self.cbUserSvr = [CBUserService alloc];
    [self.cbUserSvr initUser];
    
    
    [[ConfigService get] initLocaleConfig];
    [[NewsService get] initLoadSavedData];
    
    [MMSystemHelper startCheckNetworkType];
    
    SettingService* ss = [SettingService get];
    if (ss != nil){
        customerLocal = [ss getStringValue:CUSTOMER_LOCAL_LANGUAGE_TYPE defValue:nil];
    }
    
    if (customerLocal == nil)
        self.isFirstOpen = YES;
    
    self.baseUrl = [MMSystemHelper getAppInfoPlistData:@"CelebrityBaseUrl" defValue:@"http://test.poponews.net/"];
    //self.group = [MMSystemHelper getAppInfoPlistData:@"PoPoNewsChannelGroup" defValue:@"test"];
    
    //[self.dataSvr initPushNewsList];
    //[self.dataSvr initUnLikeNewsList];
}

-(void) stopServices {
    [MMSystemHelper stopCheckNetworkType];
}

-(void) connect{
//    if (internetStirAppInstance == nil)
//        return;
//    
//    [internetStirAppInstance.dataSvr refreshCacheDataSize];
//    
//    BOOL isHadNetwork = [MMSystemHelper isConnectedToNetwork];
//    if (isHadNetwork == NO){
//        SettingService* ss = [SettingService get];
//        NSDictionary* savedConnect = [ss getDictoryValue:CONFIG_LAST_CONNECT_INFO defValue:nil];
//        if (savedConnect != nil){
//            [internetStirAppInstance.dataSvr setConnectRespData:savedConnect];
//            
//            MMEventService *es = [MMEventService getInstance];
//            [es send:EVENT_CONNECT_ID eventData:EVENT_CONNECT_SUCCESS];
//            return;
//        }
//    }
//    
//    [self.remoteSvr doConnect];
}

-(void) refreshChannels{
//    if (self.remoteSvr != nil)
//        [self.remoteSvr getChannelsList];
}

-(void) setCustomerLanguage: (NSString*) lang{
    customerLocal = lang;
}

+(NSString*) getLocalString: (NSString*) key
                     defVal: (NSString*) def{
    if (key == nil) return def;
    NSString* ret = nil;
    
#ifdef IOS_LOCAL_STRING
    ret = NSLocalizedStringFromTable(key, @"AssignLocal", def);
#else
    
    if (customerLocal != nil){
        if ([customerLocal isEqualToString:CUSTOMER_LOCAL_LANGUAGE_TYPE_EN]){
            ret = NSLocalizedStringFromTable(key, @"PopoLocalEN", def);
        } else if ([customerLocal isEqualToString:CUSTOMER_LOCAL_LANGUAGE_TYPE_CN]){
            ret = NSLocalizedStringFromTable(key, @"PopoLocalCN", def);
        } else if ([customerLocal isEqualToString:CUSTOMER_LOCAL_LANGUAGE_TYPE_TW]){
            ret = NSLocalizedStringFromTable(key, @"PopoLocalTW", def);
        } else if ([customerLocal isEqualToString:CUSTOMER_LOCAL_LANGUAGE_TYPE_RU]){
            ret = NSLocalizedStringFromTable(key, @"PopoLocalRU", def);
        } else if ([customerLocal isEqualToString:CUSTOMER_LOCAL_LANGUAGE_TYPE_INDONESIAN]){
            ret = NSLocalizedStringFromTable(key, @"PopoLocalIndonesian", def);
        }else if ([customerLocal isEqualToString:CUSTOMER_LOCAL_LANGUAGE_TYPE_TH]){
            ret = NSLocalizedStringFromTable(key, @"PopoLocalTH", def);
        }else if ([customerLocal isEqualToString:CUSTOMER_LOCAL_LANGUAGE_TYPE_MY]){
            ret = NSLocalizedStringFromTable(key, @"PopoLocalMalay", def);
        }else {
            ret = NSLocalizedString(key, def);
        }
    } else {
        ret = NSLocalizedString(key, def);
    }
#endif
    
    if (ret == nil)
        ret = def;
    
    return ret;
}

@end