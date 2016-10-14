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

#define BEFORE_TEMPLATE_URL @"v0/forums/%@?before=%@&size=%d"
#define AFTER_TEMPLATE_URL @"v0/forums/%@?after=%@&size=%d"

#define BEFORE_CBREPLY_TEMPLATE_URL @"v0/forums/%@/%@/comments?before=%@&size=%d"
#define AFTER_CBREPLY_TEMPLATE_URL @"v0/forums/%@/%@/comments?after=%@&size=%d"

#define BEFORE_USERC_TEMPLATE_URL @"v0/users/%@/comments/%@?before=%@&size=%d"
#define AFTER_USERC_TEMPLATE_URL @"v0/users/%@/comments/%@?after=%@&size=%d"

#define CONNECT_PATH @"v0/connector"

typedef void (^RemoteCallback)(int status, int code, NSDictionary* resultData);

@interface RemoteService : NSObject

-(NSString*) getBaseUrl;
-(NSString*) getBaseFileUrl;

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

-(void) doLogin: (NSString*) email
            uid: (NSString*) uid
           name: (NSString*) name
         avator: (NSString*) avator
    accessToken: (NSString*) accessToken
           type: (int) type
       callback: (RemoteCallback) callback;
-(void) doLogout: (RemoteCallback) callback;

-(void) getCelebCommentListData: (NSString*) utc_time
                       timeType: (int) type;

-(void) replayCelebComment: (NSString*) fid
                   comment: (NSString*) comment
                  callback: (RemoteCallback) callback;

-(void) replayFansComment: (NSString*) fid
          replayCommendId: (NSString*) replayCommendId
                  comment: (NSString*) comment
                 callback: (RemoteCallback) callback;

-(void) userLike: (NSString*) fid;
-(void) userUnlike: (NSString*) fid;

-(void) getFavoriteNews;
-(void) add2FavoriteNews: (NSString*) uid
                     fid: (NSString*) fid;
-(void) del4FavoriteNews: (NSString*) fid;
-(void) delAllFavoriteNews;


-(void) getUserCommentListData: (NSString*) utc_time
                       timeType: (int) type;
-(void) getUserCommentById: (NSString*) cid
                  callback: (RemoteCallback) callback;


-(void) getCelebReplyCommentListData: (NSString*) utc_time
                            timeType: (int) type
                                 fid: (NSString*) fid;

-(void) uploadFileToServer: (NSString*) fileName;

-(void) celebSendComment: (NSString*) context
              attachment: (NSArray*) attachment;

-(void) celebUpdateComment: (NSString*) fid
                   context: (NSString*) context
                attachment: (NSArray*) attachment;

-(void) celebRemoveComment: (NSString*) fid;

@end

#endif
