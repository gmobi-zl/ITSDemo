//
//  RemoteService.h
//  PoPoNews
//
//  Created by apple on 15/4/17.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#ifndef PoPoNews_RemoteService_h
#define PoPoNews_RemoteService_h

#import <Foundation/Foundation.h>

#define CACHE_CATEGORY @"cache.category"
#define CACHE_NEWS_LIST_PREFIX @"cache.newslist."
#define CACHE_NEWS_DATA_PREFIX @"cache.newsdata."

#define EARLY_TIME 0
#define LATER_TIME 1

#define TAG_DID @"did"
#define TAG_BASEURL @"baseUrl"
#define TAG_UPDATE @"update"
#define TAG_VERSION @"lastVersion"
#define TAG_UPDATE_FILE @"update_file"
#define TAG_UPDATE_RN @"rn"
#define TAG_EDITION_CHANNEL @"channel"
#define TAG_EDITION_INFO @"channelInfo"
#define TAG_EDITION_LANG @"lang"
#define TAG_EDITION_COUNTRY @"country"
#define TAG_EDITION_AS_CHANNEL @"minikit"

#define BEFORE_TEMPLATE_URL @"api/news/list?cid=%@&before=%@&count=%d&did=%@"
#define AFTER_TEMPLATE_URL @"api/news/list?cid=%@&after=%@&count=%d&did=%@"

#define CONNECT_PATH @"api/news/connect"

typedef void (^RemoteCallback)(int status, int code, NSDictionary* resultData);

@interface RemoteService : NSObject 

-(NSString*) getConnectUrl;
-(NSString*) getDefaultReportUrl;

-(NSString*) getLatesNewsListUrl: (NSString*) cid
                            time: (NSString*) utc_time;

-(NSString*) getEarlyNewsListUrl: (NSString*) cid
                            time: (NSString*) utc_time;

-(NSString*) getContentUrl: (NSString*) nid;
-(NSString*) getBodyUrl: (NSString*) body;

-(void) doConnect;
-(void) getNewsListData: (NSString*) cid
                   time: (NSString*) utc_time
               timeType: (int) type;

-(void) getOfflineNewsByCategoryId: (NSString*) cid;

-(void) getChannelsList;

-(void) doReportData: (NSMutableDictionary*) reqBody;  //发送报告数据

-(void) getNewsById: (NSString*) nid
   isShowDetailPage: (BOOL) isShowDetailPage;

-(void) getDetailNewsById: (NSString*) nid
         isShowDetailPage: (BOOL) isShowDetailPage;
//comment
-(void) getMyComment: (NSDictionary *) param;
-(void) getHotCommnet: (NSDictionary *) param;
-(void) getComment: (NSDictionary *) param;
-(void) doFavourData: (NSString *)id;
-(void) postNewsComment: (NSDictionary *)param;
@end

#endif
