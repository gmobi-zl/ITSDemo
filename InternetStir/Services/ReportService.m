//
//  ReportService.m
//  PoPoNews
//
//  Created by apple on 15/6/17.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReportService.h"
#import "MMJsonDatabase.h"
//#import "DataService.h"
#import "ConfigService.h"
#import "ITSAppConst.h"
#import "MMSystemHelper.h"
#import "MMEventService.h"
#import "MMLogger.h"
//#import "AppsFlyerTracker.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "ITSApplication.h"

@import FirebaseAnalytics;

#define REPROT_COL_NAME  @"report_database"

#define KEY_EMO @"mood"
#define KEY_FAV @"fav"
#define KEY_FEEDBACK @"feedback"
#define KEY_CRASH @"crash"
#define KEY_ACTION @"action"

#define KEY_NEWS_ID @"nid"
#define KEY_ID @"id"
#define KEY_DATA @"data"
#define KEY_TYPE @"type"
#define KEY_THREAD @"thread"
#define KEY_STACK @"stack"
#define KEY_DEVICE @"device"
#define KEY_GROUP @"group"
#define KEY_CHANNEL @"channel"
#define KEY_TYPE_PV @"pv"
#define KEY_TYPE_LIST @"list"
#define KEY_TYPE_PUSH_RECEIVED @"push_received"
#define KEY_TYPE_PUSH_CLICKED @"push_clicked"

#define DEFAULT_SERVER @"defSvr"
#define RECORD_TYPE_ARRAY @"ar"
#define RECORD_TYPE_OBJECT @"ob"

#define RECORD_KEY_ID @"did"
#define RECORD_KEY_DATA @"dt"
#define RECORD_KEY_TYPE @"tp"
#define RECORD_KEY_SERVER @"svr"
#define RECORD_KEY_DATA_NAME @"dk"

#define KEY_RECORD_ID @"did"
#define KEY_RECORD_TIME @"at"
#define KEY_RECORD_ROOT @"$"

@implementation ReportService

-(void) initService{
    MMJsonDatabase* jdb = [MMJsonDatabase get];
    _reportCol = [jdb getCollection:REPROT_COL_NAME];
}

-(void) startReportService{
    if (self.reportService == nil) {
        self.isSending = NO;
        
        MMEventService *es = [MMEventService getInstance];
        [es send:EVENT_REPORT_SEND_RESULT  eventData:DATA_SEND_SUCCESS];
        [es addEventHandler:self eventName:EVENT_REPORT_SEND_RESULT selector:@selector(reportSendListener:)];
        
        self.reportService = [[NSThread alloc] initWithTarget:self
                                                      selector:@selector(runReportService)
                                                        object:nil];
        [self.reportService start];
    }
}

-(void) reportSendListener: (id) data{
    NSString* resultStatus = data;
    if (resultStatus != nil && [resultStatus compare:DATA_SEND_SUCCESS] == NSOrderedSame){
        [self delSendedCollectData];
        self.isSending = NO;
    } else {
        [self.sendingDataIds removeAllObjects];
        self.isSending = NO;
    }
}

-(void) runReportService{
    
    while (YES) {
        if (self.isSending == NO){
            BOOL isHadNetwork = [MMSystemHelper isConnectedToNetwork];
            
//            ITSApplication* app = [ITSApplication get];
            NSString* did = @"";//[app.dataSvr getServerDeviceId];
            
            if (did != nil && isHadNetwork == YES) {
                NSMutableDictionary* reportData = [self genCollectData];
                
                if (reportData != nil && self.sendingDataIds != nil && [self.sendingDataIds count] > 0){
                    //[app.remoteSvr doReportData:reportData];
                    self.isSending = YES;
                }
            }
        }
        
        [NSThread sleepForTimeInterval:10];
    }
}

-(NSMutableDictionary*) genCollectData {
    if (_reportCol == nil)
        return nil;
    
    NSMutableArray* list = [_reportCol list];
    if (list == nil || [list count] <= 0)
        return nil;
    
    NSMutableDictionary* retDic = [NSMutableDictionary dictionaryWithCapacity:1];
    for (Document* doc in list) {
        if (doc != nil){
            NSMutableDictionary* obj = [doc getData];
            NSString* objId = [doc getId];
            
            NSString* requestType = [obj objectForKey:RECORD_KEY_TYPE];
            NSString* requestName = [obj objectForKey:RECORD_KEY_DATA_NAME];
            
            id reqData = [retDic objectForKey:requestName];
            if([requestType compare:RECORD_TYPE_OBJECT] == NSOrderedSame && reqData == nil){
                NSMutableDictionary* dataDic = [obj objectForKey:RECORD_KEY_DATA];
                [retDic setObject:dataDic forKey:requestName];
            } else if ([requestType compare:RECORD_TYPE_ARRAY] == NSOrderedSame) {
                NSMutableArray* dataArray = nil;
                if (reqData == nil){
                    dataArray = [NSMutableArray arrayWithCapacity:1];
                    [retDic setObject:dataArray forKey:requestName];
                } else {
                    dataArray = (NSMutableArray*)reqData;
                }
                
                NSMutableDictionary* dataDic = [obj objectForKey:RECORD_KEY_DATA];
                [dataArray addObject:dataDic];
            } else {
                continue;
            }
            MMLogDebug(@"Report msg id = %@", objId);
            if (self.sendingDataIds == nil){
                self.sendingDataIds = [NSMutableArray arrayWithCapacity:1];
            }
            
            [self.sendingDataIds addObject:objId];
        }
    }
    
    ITSApplication* app = [ITSApplication get];
    NSString* did = @"";//[app.dataSvr getServerDeviceId];
    
    if (did != nil && self.sendingDataIds != nil && [self.sendingDataIds count] > 0) {
        NSMutableDictionary* joc = [NSMutableDictionary dictionaryWithCapacity:2];
        NSString* timestamp = [MMSystemHelper getTimeStamp];
        [joc setObject:did forKey:KEY_RECORD_ID];
        [joc setObject:timestamp forKey:KEY_RECORD_TIME];
        
        [retDic setObject:joc forKey:KEY_RECORD_ROOT];
    }
    
    return retDic;
}

-(void) delSendedCollectData{
    if (self.sendingDataIds != nil && _reportCol != nil){
        for (NSString* iid in self.sendingDataIds) {
            MMLogDebug(@"Remove Report msg id = %@", iid);
            if (iid != nil)
                [_reportCol set:iid setData:nil];
        }
        [self.sendingDataIds removeAllObjects];
    }
}

-(void) saveData: (NSString*) server
        dataType: (NSString*) type
         dataKey: (NSString*) key
      dataObject: (id) data{
    
    ITSApplication* app = [ITSApplication get];
    NSString* did = @"";//[app.dataSvr getServerDeviceId];
    
    if (did == nil || server == nil || type == nil || key == nil || data == nil){
        return;
    }
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithCapacity:5];
    [dic setObject:did forKey:RECORD_KEY_ID];
    [dic setObject:data forKey:RECORD_KEY_DATA];
    [dic setObject:type forKey:RECORD_KEY_TYPE];
    [dic setObject:server forKey:RECORD_KEY_SERVER];
    [dic setObject:key forKey:RECORD_KEY_DATA_NAME];
    
    if (_reportCol != nil)
        [_reportCol set:nil setData:dic];
}

-(void) saveObjectData: (NSString*) type
            dataObject: (id) jo{
    [self saveData:DEFAULT_SERVER dataType:RECORD_TYPE_OBJECT dataKey:type dataObject:jo];
}

-(void) saveArrayData: (NSString*) type
           dataObject: (id) jo{
    [self saveData:DEFAULT_SERVER dataType:RECORD_TYPE_ARRAY dataKey:type dataObject:jo];
}

-(void) recordEmo: (NSString*) nId
          emoType: (NSString*) emo{
    if (nId == nil || emo == nil)
        return;
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithCapacity:2];
    [dic setObject:nId forKey:KEY_NEWS_ID];
    [dic setObject:emo forKey:KEY_DATA];
    
    [self saveArrayData:KEY_EMO dataObject:dic];
}

-(void) recordFav: (NSString*) nId
              fav: (int) favData{
    if (nId == nil)
        return;
    
    NSNumber* number = [NSNumber numberWithInt:favData];
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithCapacity:2];
    [dic setObject:nId forKey:KEY_NEWS_ID];
    [dic setObject:number forKey:KEY_DATA];
    
    [self saveArrayData:KEY_FAV dataObject:dic];
}

-(void) recordFeedback: (NSString*) msg {
    if (msg == nil)
        return;
    
    ConfigService* cs = [ConfigService get];
    NSString* ch = [cs getChannel];
    
    if (ch == nil)
        return;
    ITSApplication* app = [ITSApplication get];
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithCapacity:3];
    //[dic setObject:app.group forKey:KEY_GROUP];
    [dic setObject:ch forKey:KEY_CHANNEL];
    [dic setObject:msg forKey:KEY_DATA];
    
    [self saveObjectData:KEY_FEEDBACK dataObject:dic];
}

-(void) recordCrash: (NSString*) stack
                msg: (NSString*) errMsg
             device: (NSString*) deviceInfo{
    if (stack == nil || errMsg == nil || deviceInfo == nil)
        return;
    
    ConfigService* cs = [ConfigService get];
    NSString* ch = [cs getChannel];
    
    if (ch == nil)
        return;
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithCapacity:3];
    ITSApplication* app = [ITSApplication get];
    //[dic setObject:app.group forKey:KEY_GROUP];
    [dic setObject:ch forKey:KEY_CHANNEL];
    
    NSMutableDictionary* crashInfo = [NSMutableDictionary dictionaryWithCapacity:3];
    [crashInfo setObject:stack forKey:KEY_THREAD];
    [crashInfo setObject:errMsg forKey:KEY_STACK];
    [crashInfo setObject:deviceInfo forKey:KEY_DEVICE];
    
    [dic setObject:crashInfo forKey:KEY_DATA];

    [self saveObjectData:KEY_CRASH dataObject:dic];
}

-(void) recordPV: (NSString*) nId{
    if (nId == nil)
        return;
    
    NSNumber* number = [NSNumber numberWithInt:1];
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithCapacity:3];
    [dic setObject:nId forKey:KEY_ID];
    [dic setObject:number forKey:KEY_DATA];
    [dic setObject:KEY_TYPE_PV forKey:KEY_TYPE];
    
    [self saveArrayData:KEY_ACTION dataObject:dic];
}

-(void) recordPushMsgReceived: (NSString*) nId{
    if (nId == nil)
        return;
    
    NSNumber* number = [NSNumber numberWithInt:1];
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithCapacity:3];
    [dic setObject:nId forKey:KEY_ID];
    [dic setObject:number forKey:KEY_DATA];
    [dic setObject:KEY_TYPE_PUSH_RECEIVED forKey:KEY_TYPE];
    
    [self saveArrayData:KEY_ACTION dataObject:dic];
}

-(void) recordPushMsgClicked: (NSString*) nId{
    if (nId == nil)
        return;
    
    NSNumber* number = [NSNumber numberWithInt:1];
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithCapacity:3];
    [dic setObject:nId forKey:KEY_ID];
    [dic setObject:number forKey:KEY_DATA];
    [dic setObject:KEY_TYPE_PUSH_CLICKED forKey:KEY_TYPE];
    
    [self saveArrayData:KEY_ACTION dataObject:dic];
}

-(void) recordCategory: (NSString*) cId{
    if (cId == nil)
        return;
    
    NSNumber* number = [NSNumber numberWithInt:1];
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithCapacity:3];
    [dic setObject:cId forKey:KEY_ID];
    [dic setObject:number forKey:KEY_DATA];
    [dic setObject:KEY_TYPE_LIST forKey:KEY_TYPE];
    
    [self saveArrayData:KEY_ACTION dataObject:dic];
}

-(void) recordEvent: (NSString*) eventId
             params: (NSDictionary*) params
      eventCategory:(NSString *)category{
    
    MMLogDebug(@"Report Event : id = %@, params = %@", eventId, params);
    
    if (eventId == nil) return;
    
    //[FIRAnalytics logEventWithName:eventId parameters:params];
    
    // report to flurry
//    if (params != nil){
//        [Flurry logEvent:eventId withParameters:params];
//    }else{
//        [Flurry logEvent:eventId];
//    }
    
    //FB
//    NSString *newsEventId = [category stringByReplacingOccurrencesOfString:@"." withString:@"-"];
//    if (params != nil){
//        
//        [FBSDKAppEvents logEvent:newsEventId parameters:params];
//    } else{
//        [FBSDKAppEvents logEvent:newsEventId];
//    }
    
    // AppsFlyer
//    if (params != nil)
//        [[AppsFlyerTracker sharedTracker] trackEvent:eventId withValues:params];
//    else
//        [[AppsFlyerTracker sharedTracker] trackEvent:eventId withValue:@""];
    
    // report to GA
//    NSString* pLabel = [MMSystemHelper DictTOjsonString:params];
//    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-59522043-8"];
//    GAIDictionaryBuilder* b = [GAIDictionaryBuilder createEventWithCategory:category action:eventId label:pLabel value:nil];
//    //if (params != nil)
//    //    [b set:params forKey:newsEventId];
//    [tracker send:[b build]];
    // report to GA
    NSString* pLabel = [MMSystemHelper DictTOjsonString:params];
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-83420163-6"];
    GAIDictionaryBuilder* b = [GAIDictionaryBuilder createEventWithCategory:category action:eventId label:pLabel value:nil];
    [tracker send:[b build]];

}


-(void) recordEvent: (NSString*) eventId
             params: (NSDictionary*) params
              timed: (BOOL) timed
      eventCategory:(NSString *)category{
    
    MMLogDebug(@"Report Event : id = %@, params = %@, timed = %d", category, params, timed);
    
    if (eventId == nil) return;
    
    /*
    // report to flurry
    if (params != nil){
        [Flurry logEvent:eventId withParameters:params timed:timed];
    } else{
        [Flurry logEvent:eventId timed:timed];
    }
    
    //FB
     NSString *newsEventId = [category stringByReplacingOccurrencesOfString:@"." withString:@"-"];
    if (params != nil){
        [FBSDKAppEvents logEvent:newsEventId parameters:params];
    }else{
        [FBSDKAppEvents logEvent:newsEventId];
    }
    
    // AppsFlyer
    if (params != nil)
        [[AppsFlyerTracker sharedTracker] trackEvent:eventId withValues:params];
    else
        [[AppsFlyerTracker sharedTracker] trackEvent:eventId withValue:@""];

    // report to GA
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-59522043-8"];
    NSString* pLabel = [MMSystemHelper DictTOjsonString:params];
    GAIDictionaryBuilder* b = [GAIDictionaryBuilder createEventWithCategory:category action:eventId label:pLabel value:nil];
    //if (params != nil)
    //    [b set:params forKey:newsEventId];
    [tracker send:[b build]];
     */
}

-(void) recordEndTimedEvent: (NSString*) eventId
                     params: (NSDictionary*) params{
    MMLogDebug(@"Report EndTimed Event : id = %@, params = %@", eventId, params);
    
    if (eventId == nil) return;
    /*
    // report to flurry
    if (params != nil){
        [Flurry endTimedEvent:eventId withParameters:params];
    }else{
        [Flurry endTimedEvent:eventId withParameters:nil];
    }
    //FB
    NSString *newsEventId = [eventId stringByReplacingOccurrencesOfString:@"." withString:@"-"];
    if (params != nil){
        [FBSDKAppEvents logEvent:newsEventId parameters:params];
    } else{
        [FBSDKAppEvents logEvent:newsEventId];
    }
     */
}

-(void) recordAdPurchase: (NSString*) placement
                    type: (NSString*) type{
    if (placement == nil || type == nil) return;
    
    /*
    // AppsFlyer
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:1];
    [params setObject:[[NSNumber alloc] initWithDouble:0.01] forKey:AFEventParamRevenue];
    [params setObject:type forKey:AFEventParamContentType];
    [params setObject:type forKey:AFEventParamContentId];
    [params setObject:@"USD" forKey:AFEventParamCurrency];
    [[AppsFlyerTracker sharedTracker] trackEvent:AFEventPurchase withValues:params];
     */
}

@end