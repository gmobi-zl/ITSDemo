//
//  DataService.h
//  PoPoNews
//
//  Created by apple on 15/4/17.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#ifndef PoPoNews_DataService_h
#define PoPoNews_DataService_h

#import <Foundation/Foundation.h>

#import "ITSAppConst.h"
#import "NewsCategory.h"
#import "PoPoNewsItem.h"
#import "PopoNewsData.h"


#import "Go2Reach/GRServices.h"
#import "Go2Reach/GRNativeAd.h"
#import "Go2Reach/GRBannerAd.h"
#import "Go2Reach/GRInterstitialAd.h"
#import "AdItem.h"
#import "NativeAdItem.h"

#import "PNNativeAdItem.h"
#import "PopoUser.h"
//#import "CommentItem.h"
//#import "CommentCellFrame.h"
//#import "MyCommentCellFrame.h"
//#import "MyCommentItem.h"
@interface BaiduPlusUser : NSObject

@property (copy) NSString* uId;
@property (copy) NSString* name;
@property (copy) NSString* link;
@property (assign) BOOL isChecked;
@property (retain) NSMutableArray* data;

@end

@interface PoPoBDuser : NSObject
@property (retain) NSMutableArray *users;
@end

@interface WeiboUsers : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *uId;
@property (nonatomic, copy) NSString *followers_count;
@property (assign) BOOL checked;
@property (retain) NSMutableArray* data;
@end

@interface PoPoWEuser : NSObject
@property (retain) NSMutableArray *friends;
@end

@interface TwitterUser : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *uId;
@property (nonatomic, copy) NSString *followers_count;
@property (assign) BOOL checked;
@property (retain) NSMutableArray* data;
@end

@interface PopoTWuser : NSObject
@property (retain) NSMutableArray* friends;

@end

@interface GoolgePlusUser : NSObject

@property (copy) NSString* uId;
@property (copy) NSString* name;
@property (copy) NSString* link;
@property (retain) NSMutableArray* links;
@property (assign) BOOL isChecked;
@property (retain) NSMutableArray* data;

@end

@interface PopoGPUser: NSObject

@property (retain) NSMutableArray* users;

@end

@interface FBPaging : NSObject

@property (copy) NSString* previous;
@property (copy) NSString* next;

@end

@interface FBUser : NSObject

@property (copy) NSString* uId;
@property (copy) NSString* name;
@property (assign) int type;
@property (retain) FBPaging* dataPaging;
@property (assign) BOOL checked;

@property (nonatomic) NSMutableArray* data;

@end

@interface PopoFBUser : NSObject

@property (retain) FBPaging* likePaging;

@property (assign) int friendTotalCount;
@property (assign) int friendCurrentCount;
@property (retain) FBPaging* friendPaging;

@property (retain) NSMutableArray* users;

@end

@interface PopoSocialNewItem : NSObject

@property (copy) NSString* nId;
@property (assign) int type;
@property (retain) id data;
@property (assign) UInt64 ts;

@end

@interface PopoSocialDataItem : NSObject

@property (assign) int type;
@property (assign) BOOL isOpen;
@property (retain) id socialData;

@end


@interface OfflineCategoryItem : NSObject

@property (assign) BOOL checked;            // 是否被选中
@property (retain) NewsCategory* category;  // 目录
@property (assign) int progress;        // 下载进度
@property (assign) int downloadStatus;  // 下载状态
@property (retain) NSMutableArray* newsList;  // 离线新闻列表
@property (retain) NSMutableArray* downloadList;  // 下载项列表
@property (assign) BOOL isNewsSync; // 是否同步到阅读列表中
@property (assign) BOOL isHideen;
@end

@interface FavourNewsItem : NSObject

@property (assign) BOOL checked;
@property (retain) PoPoNewsItem* data;

@end

@interface ReadedNewsItem : NSObject

@property (copy) NSString* nId;
@property (copy) NSString* cId;

@end

typedef enum{
    SettingTypeButton = 1,
    SettingTypeDetail = 2,
    SettingTypeSwitch = 3,
}SettingItemType;

@interface SettingItem: NSObject

@property (copy) NSString* iconName;
@property (copy) NSString* settingName;
@property (assign) int type;
@property (assign) int actionType;
@property (assign) BOOL isSwitch;


@end

@interface LeftMenuItem: NSObject

@property (copy) NSString* iconName;
@property (copy) NSString* actionName;

@end

@interface loginOutMenuItem : NSObject
@property (copy) NSString* iconName;
@property (copy) NSString* actionName;
@property (assign) BOOL isLogin;
@end

@interface PopoNewsChannelInfo : NSObject

@property (copy) NSString* country;
@property (copy) NSString* lang;
@property (copy) NSString* ch;

@property (retain) BannerAd *bannerAd;//ad3
@property (retain) NativeAd *nativeAd;//ad1
@property (retain) InterstitialAd *InterstitialAd;//ad2
@property (retain) Interstitial *ad; //ad4
@property (retain) DetailAd *detailAd; // ad5
@property (retain) NSMutableArray *threeLogin;
@property (retain) NSMutableArray *shareItem;
@end

@interface PopoNewsChannel : NSObject

@property (copy) NSString* country;
@property (copy) NSString* lang;
@property (copy) NSString* icon;
@property (copy) NSString* chId;
@property (copy) NSString* name;

@property (assign) BOOL isChecked;

@end

@interface StorageUserCategory : NSObject

@property (retain) NSString* cid;
@property (assign) BOOL hidden;

-(StorageUserCategory*) initWithDict: (NSDictionary*) dict;
-(NSDictionary*) toDict;

@end


@interface DataService : NSObject
@property (assign) int comment_count;
@property (assign) int lastCount;
@property (assign) BOOL isAdd;
@property (retain) NSMutableArray* newsList;
@property (retain) NSMutableArray* categoryList;
@property (copy) NSString* fileBaseUrl;
@property (copy) NSString* connectRspCh;
@property (retain) PopoNewsChannelInfo* minikitCh;
@property (retain) NSMutableArray* popoNewChannelList;
@property (copy) NSString* did;
@property (copy) NSString* connectRspGroup;
@property (assign) int update;
@property (retain) id currentDetailNews;
@property (retain) NSMutableArray* leftMenuList;
@property (retain) NSMutableArray* showCategoryList;
@property (retain) NSMutableArray* settingList;
@property (retain) NSMutableArray* poponewsList;
@property (retain) NSMutableArray* loginOutList;
@property (assign) long cacheDataSize;

@property (retain) NSMutableArray* readNewsList; // 已读新闻
@property (retain) NSMutableArray* favourNewsList; // 收藏列表
@property (retain) NSMutableArray* downLoadList;// 下载列表
@property (retain) NSMutableArray* pushNewsList; // 推送新闻列表
@property (retain) NSMutableArray* commentList;//评论列表
@property (retain) NSMutableArray* hotCommentList;//热门评论
@property (retain) NSMutableArray* myCommentList;
@property (retain) NSMutableArray* detailHotCommentList;
@property (retain) NSMutableArray* myCommentNewsList;
@property (retain) NSMutableArray* unLikeNewsList;

//@property (retain) PopoFBUser* popFBUsers;
@property (retain) PopoSocialDataItem* popoFBData;
@property (retain) PopoSocialDataItem* popoGPData;
@property (retain) PopoSocialDataItem* popoTWData;
@property (retain) PopoSocialDataItem* popoWEData;
@property (retain) PopoSocialDataItem* popoBDData;

//@property (retain) NativeAdItem *fbAdData;
//@property (retain) NativeAdItem *gmobiAdData;
@property (retain) NSMutableArray *fbAd;
@property (retain) NSMutableArray *gmobiAd;
@property (retain) PNNativeAdItem *gmobiDetailAdItem;

@property (retain) PopoNewsData* itemData ;
@property (retain) NewsCategory* socialCategory;

@property (retain) NSString* offPushNewsId;
@property (retain) PoPoNewsItem* pushNews;

@property (retain) PopoUser *user;

-(NSString*) getServerDeviceId;

-(void) setConnectRespData: (NSDictionary*) dicData;
-(void) setRefreshCategoryNews: (NSString*) cid
                      newsList: (NSArray*) dicData
                   isClearData: (BOOL) clear
                          type: (int)type;
-(void) setRefreshCategoryNewsByStroage: (NSString*) cid
                               newsList: (NSMutableArray*) newsData;

-(void) refreshCategoryNews: (NSString*) cid
                refreshType: (int) typoe;

-(int) getCategoryListActiveCount;
-(int) getCategoryNewsCount: (NSString*) cid;
-(int) getGridCategoryNewsCount: (NSString*) cid;
-(NewsCategory*) getCategoryByIndex: (int) index;
-(NewsCategory*) getCategoryByID: (NSString*) cid;
-(id) getNewsItem: (NSString*) cid
                   index: (int) idx ;
-(void) removeNewsItem: (NSString *)nid;
-(id) getCategoryShowItem: (NSString*) layout
                  cid: (NSString*) cid
                index: (int) idx;

-(PoPoNewsItem*) getNewsItemByNid: (NSString*) cid
                       newsId: (NSString*) nid;

-(id) getCurrentDetailNewsItem;
-(void) setCurrentDetailNewsItem: (id) item;

//AD
-(NSString*) getNativedAdPlacement: (NSString*) cid;
-(GRBannerAd*) getBannerAd :(NSString*)publisher;
-(GRInterstitialAd*) getInterstitialAd: (NSString*)publisher;
-(NativeAdItem*)getNativeAdItem:(NSString*)cid;
- (void)getNewsNewsListWithAdList:(NSString* )cid :(int)type;

-(NSMutableArray*) getLoginOutList;
-(NSMutableArray*) getLeftMenuList;
-(NSMutableArray*) getNewsCategoryList;
-(NSMutableArray*) getShowCategoryList;
-(int) getShowCategoryListActiveCount;
-(NewsCategory*) getShowCategoryByIndex: (NSInteger) index;
-(void) refreshShowCategoryList;
-(void) saveShowCategoryList;

//comment
-(NSMutableArray*) getDetailHotCommentList;
-(NSMutableArray*) getHotCommentList;
-(NSMutableArray *) getMyCommentList;
-(NSMutableArray*) getCommentList;
-(NSMutableArray*) getSettingList;
-(NSMutableArray*) getDownLoadList;
-(NSMutableArray*) getMyCommentNewsList;
-(void) setPoDetailHotCommentList:(NSMutableArray*)data;
-(void) setPoHotComentList:(NSMutableArray*)data;
-(void) refreshDetailHotCommentList:(NSDictionary *)dic;
-(void) refreshHotCommentList:(NSDictionary *)dic;
-(void) setPoCommentList:(NSDictionary*)data;
-(void) setPoMyCommentList:(NSMutableArray*)data;
-(void) refreshCommentList:(NSDictionary *)dic;
-(void) getCommentList:(NSDictionary *)dic;
-(void) getMyCommentList:(NSDictionary *)dic;
-(NSString *)getCommentPath:(int *)index :(NSInteger)section;
-(NSString *)getCommentRpath:(NSInteger *)index :(NSInteger)section :(NSInteger)row;
-(void) clearDownloadChecked;
-(NSMutableArray*) getPoNewsChannelList;
-(void) setPoNewsChannelList: (NSArray*) array;

-(NSMutableArray*) getSocialUserList: (int) type;
-(NSInteger) getSocialUserCount: (int) type;
-(void) setSocialSwitchStatus: (int) type
                       status: (BOOL) status;

-(void) clearCategoryData;

-(void) refreshCacheDataSize;
-(long) getCacheFolderSize;
-(void) setCacheFolderSize: (long) size;
-(void) clearCacheFolder;

// read news
-(void) insert2ReadNewsList: (NSString*) nId
                 categoryId: (NSString*) cId;
-(NSMutableArray*) getReadNewsList;

//myComment news
-(PoPoNewsItem*) getTapMyCommentNews:(NSString *)nid;
-(void) insert2MyCommentNewsList:(PoPoNewsItem*) item;

// favour news
-(void) insert2FavourList: (PoPoNewsItem*) item
                 saveFlag: (BOOL) saved
               isPushNews: (BOOL) isPushNews;
-(void) removeFavourById: (PoPoNewsItem*) item;
-(NSMutableArray*) getFavourList;
-(void) removeAllSelFavour;
-(void) clearFavourAllSel;

// offline news
-(void) setOfflineNews: (NSString*) cid
               newsList: (NSArray*) dicData;


// FB news
-(void) setFBSocial: (NSDictionary*) dic
          isServer: (BOOL) isServer;
-(void) setFBSocialNews: (NSDictionary*) dic
          resetPaging: (BOOL) flag
             isAddTop: (BOOL) addType;
-(NSString*) getFBCategoryId;
-(void) clearFBSocialNews;

// Google plus news
-(void) initGPSocial;
//-(void) insertGPNewsData: (int) index
//                  gpNews: (PopoGPNewItem*) news;


// Twitter news
-(void) setTWSocial: (NSDictionary*) dic
          isServer: (BOOL) isServer;
-(void) setTWSocialNews: (NSMutableArray*) arr
          resetPaging: (BOOL) flag
             isAddTop: (BOOL) addType;
-(NSString*) getTWCategoryId;
-(void) clearTWSocialNews;



// social news refresh
-(void) refreshSocialNewsList;

// category layout type
-(void) updateCategoryShowType: (NSString*) cId
                          type: (NSString*) type;
-(void) initNativeAds;


// push message news
-(BOOL) checkPushNewsId: (NSString*) nid;
-(BOOL) insert2PushNewsList: (PoPoNewsItem*) item
                   saveFlag: (BOOL) saved;
-(void) initPushNewsList;
-(NSMutableArray*) getPushNewsList;
-(void) getPushNewsDetail: (NSString*) nId
         isShowDetailPage: (BOOL) isShowDetailPage;
-(void) updatePushNewsToStorage: (PoPoNewsItem*) item;

//user
-(void) initUser;

//unlike
-(void) initUnLikeNewsList;
-(NSMutableArray*) getUnLikeNewsList;
-(BOOL) insert2UnLikeNewsList: (PoPoNewsItem*) item
                   saveFlag: (BOOL) saved;

@end

#endif
