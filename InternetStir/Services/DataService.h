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
#import "CelebComment.h"
#import "FansComment.h"

//#import "CommentItem.h"
//#import "CommentCellFrame.h"
//#import "MyCommentCellFrame.h"
//#import "MyCommentItem.h"




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
@property (assign) BOOL isSelect;

@end

@interface WriteArticleMenuItem: NSObject

@property (copy) NSString* iconName;
@property (copy) NSString* actionName;
@property (copy) NSString* photo;
@end

@interface loginOutMenuItem : NSObject
@property (copy) NSString* iconName;
@property (copy) NSString* actionName;
@property (assign) BOOL isLogin;
@end

@interface CBChannelInfo : NSObject

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

@interface CBChannel : NSObject

@property (copy) NSString* country;
@property (copy) NSString* lang;
@property (copy) NSString* icon;
@property (copy) NSString* chId;
@property (copy) NSString* name;

@property (assign) BOOL isChecked;

@end

@interface CelebInfo : NSObject

@property (copy) NSString* name;
@property (copy) NSString* avator;
@property (copy) NSString* title;
@property (copy) NSString* lanuchPage;

@end


@interface DataService : NSObject
@property (assign) int comment_count;
@property (assign) int lastCount;
@property (assign) BOOL isAdd;
@property (retain) NSMutableArray* newsList;
@property (retain) NSMutableArray* categoryList;
@property (copy) NSString* fileBaseUrl;
@property (copy) NSString* connectRspCh;
@property (retain) CBChannelInfo* minikitCh;
@property (retain) NSMutableArray* popoNewChannelList;
@property (copy) NSString* did;
@property (copy) NSString* connectRspGroup;
@property (assign) int update;
@property (retain) id currentDetailNews;
@property (retain) NSMutableArray* writeArticleMenuList;
@property (retain) NSMutableArray* leftMenuList;
@property (retain) NSMutableArray* showCategoryList;
@property (retain) NSMutableArray* settingList;
@property (retain) NSMutableArray* poponewsList;
@property (retain) NSMutableArray* loginOutList;
@property (assign) long cacheDataSize;

@property (retain) NSMutableArray* readNewsList; // 已读新闻
@property (retain) NSMutableArray* favourNewsList; // 收藏列表
@property (retain) NSMutableArray* pushNewsList; // 推送新闻列表
@property (retain) NSMutableArray* commentList;//评论列表
@property (retain) NSMutableArray* hotCommentList;//热门评论
@property (retain) NSMutableArray* myCommentList;
@property (retain) NSMutableArray* detailHotCommentList;
@property (retain) NSMutableArray* myCommentNewsList;
@property (retain) NSMutableArray* unLikeNewsList;

@property (retain) NSMutableArray* celebComments;
@property (retain) CelebComment* currentCelebComment;
@property (retain) NSMutableArray* userTrackComments;
@property (retain) CelebInfo* celebInfo;

//@property (retain) NativeAdItem *fbAdData;
//@property (retain) NativeAdItem *gmobiAdData;
@property (retain) NSMutableArray *fbAd;
@property (retain) NSMutableArray *gmobiAd;
@property (retain) PNNativeAdItem *gmobiDetailAdItem;

@property (retain) PopoNewsData* itemData ;
@property (retain) NewsCategory* socialCategory;

@property (retain) NSString* offPushNewsId;
@property (retain) PoPoNewsItem* pushNews;

@property (copy) NSString* selectUploadFile;
@property (retain) CelebComment* selectUpdateComment;

//@property (retain) CelebUser *user;

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

-(NSMutableArray*) getWriteArticleMenuList;
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



//unlike
-(void) initUnLikeNewsList;
-(NSMutableArray*) getUnLikeNewsList;
-(BOOL) insert2UnLikeNewsList: (PoPoNewsItem*) item
                   saveFlag: (BOOL) saved;


// celeb comments list
-(void) setCurrentCelebComment: (CelebComment*) item;
-(CelebComment*) getCurrentCelebComment;
-(void) refreshCelebComments: (int) type;
-(void) setRefreshCelebComments: (NSArray*) dicData
                    isClearData: (BOOL) clear
                           type: (int) type;
-(BOOL) insertCelebCommentItem: (CelebComment*) item;
-(void) removeCelebCommentItem: (NSString*) fid;
-(void) updateCelebCommentItem: (NSString*) fid
                       context: (NSString*) context
                   attachments: (NSMutableArray*) attachments;


-(void) refreshUserTrackComments: (int) type;
-(void) setRefreshUserTrackComments: (NSArray*) dicData
                    isClearData: (BOOL) clear
                           type: (int) type;

-(void) refreshReplyComments: (int) type
                        fid: (NSString*) fid;
-(void) setRefreshReplyComments: (NSArray*) dicData
                           fid: (NSString*) fid
                   isClearData: (BOOL) clear
                          type: (int) type;
-(BOOL) insertCurrentReplyCommentItem: (FansComment*) item;
-(BOOL) userInsertCurrentReplyCommentItem: (FansComment*) item;

@end

#endif
