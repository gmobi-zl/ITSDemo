
//
//  DataService.m
//  PoPoNews
//
//  Created by apple on 15/4/17.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataService.h"
#import "ConfigService.h"
#import "ITSApplication.h"
#import "ITSAppConst.h"
#import "MMSystemHelper.h"
#import "MMEventService.h"
#import "NewsService.h"
#import "SettingService.h"
#import "MMDictionaryHelper.h"
#import "CelebComment.h"
#import "FansComment.h"
#import "UserTrackComment.h"
#import "CelebRecommend.h"

//#import "Go2Reach.framework/Headers/GRAdService.h"

#define NATIVE_AD_PLACEMENT_FORMAT @"ch:{ch}/dch:{dch}/list:{cid}";
#define BANNER_AD_PLACEMENT_FORMAT @"ch:{ch}/dch:{dch}/ab:{publisher}";
#define INTERSTITIAL_AD_PLACEMENT_FORMAT @"ch:{ch}/dch:{dch}/ai:{publisher}";
#define CATEGORY_CUSTOM_LAYOUT_PERFIX @"cate_c_layout"

#define SAVED_USER_CATEGORY_LIST @"saved.user.category.data"


@implementation SettingItem

@end

@implementation LeftMenuItem

@end

@implementation WriteArticleMenuItem

@end

@implementation loginOutMenuItem

@end

@implementation CBChannelInfo

@end

@implementation CBChannel

@end

@implementation CelebInfo

@end


@implementation DataService

- (void)clearFBSocialNews{


}
-(void) initPopoNewsListCategory {
    if (self.poponewsList == nil)
        self.poponewsList = [NSMutableArray arrayWithCapacity:3];
    else
        [self.poponewsList removeAllObjects];
    
    if (self.categoryList != nil){
        for(NewsCategory* cate in self.categoryList){
            PopoNewsData* poData = [PopoNewsData alloc];
            poData.category = cate;
            poData.data = nil;
            //poData.gridData = nil;
            poData.nativeAdData = nil;
         //   poData.newsList = nil;
            [self.poponewsList addObject:poData];
        }
    }
    
    if (self.socialCategory != nil){
        PopoNewsData* poData = [PopoNewsData alloc];
        poData.category = self.socialCategory;
        poData.data = nil;
        //poData.gridData = nil;
        poData.nativeAdData = nil;
     //   poData.newsList = nil;
        [self.poponewsList addObject:poData];
    }
}

-(NSString*) getServerDeviceId{
    return self.did;
}

-(NSMutableArray*) getNewsCategoryList{
    return self.categoryList;
}

-(NSMutableArray*) getLoginOutList{
    
    [self refreshloginOut];
    
    return self.loginOutList;
}
- (void)refreshloginOut{
    if (self.loginOutList == nil)
        self.loginOutList = [NSMutableArray arrayWithCapacity:3];
    else
        [self.loginOutList removeAllObjects];
    
    loginOutMenuItem* facebook = [loginOutMenuItem alloc];
    facebook.iconName = @"facebook_1";
    facebook.actionName = @"facebook";
    facebook.isLogin = NO;
    [self.loginOutList addObject:facebook];
    
    loginOutMenuItem* twitter = [loginOutMenuItem alloc];
    twitter.iconName = @"twitter_1";
    twitter.actionName = @"twitter";
    twitter.isLogin = NO;
    [self.loginOutList addObject:twitter];
    //
    loginOutMenuItem* google = [loginOutMenuItem alloc];
    google.iconName = @"google_1";
    google.actionName = @"google";
    google.isLogin = NO;
    [self.loginOutList addObject:google];
    
}
-(NSMutableArray*) getWriteArticleMenuList {
    [self refreshWriteArticle];
    return self.writeArticleMenuList;
}
-(void)refreshWriteArticle {
    if (self.writeArticleMenuList == nil)
        self.writeArticleMenuList = [NSMutableArray arrayWithCapacity:3];
    else
        [self.writeArticleMenuList removeAllObjects];
    
    WriteArticleMenuItem* set = [WriteArticleMenuItem alloc];
    set.iconName = @"location";
    set.actionName = @"新增地點";
    set.photo = @"set_next";
    [self.writeArticleMenuList addObject:set];
    
    WriteArticleMenuItem* settings = [WriteArticleMenuItem alloc];
    settings.iconName = @"tag";
    settings.actionName = @"標註人名";
    settings.photo = @"set_next";
    [self.writeArticleMenuList addObject:settings];
    
    WriteArticleMenuItem* Facebook = [WriteArticleMenuItem alloc];
    Facebook.iconName = @"Fb";
    Facebook.actionName = @"Facebook";
//    Facebook.photo = @"switch_off";
    [self.writeArticleMenuList addObject:Facebook];
    
    WriteArticleMenuItem* Instagram = [WriteArticleMenuItem alloc];
    Instagram.iconName = @"ig";
    Instagram.actionName = @"Instagram";
//    Instagram.photo = @"switch_off";
    [self.writeArticleMenuList addObject:Instagram];
    
    WriteArticleMenuItem* twitter = [WriteArticleMenuItem alloc];
    twitter.iconName = @"twitter";
    twitter.actionName = @"Twitter";
//    twitter.photo = @"switch_off";
    [self.writeArticleMenuList addObject:twitter];
    
    WriteArticleMenuItem* weibo = [WriteArticleMenuItem alloc];
    weibo.iconName = @"weibo";
    weibo.actionName = @"新浪微博";
//    weibo.photo = @"switch_off";
    [self.writeArticleMenuList addObject:weibo];
}
-(NSMutableArray*) getLeftMenuList{

    [self refreshLeftMenu];
    
    return self.leftMenuList;
}

-(NSMutableArray*) getShowCategoryList{
    if (self.showCategoryList == nil)
        [self refreshShowCategoryList];
    
    return self.showCategoryList;
}

-(int) getShowCategoryListActiveCount{
    if (self.showCategoryList == nil)
        [self refreshShowCategoryList];
    
    int count = 0;
    
    if (self.showCategoryList != nil){
        for (NewsCategory* item in self.showCategoryList) {
            if (item != nil){
                if (item.hidden == NO && ![item.type isEqualToString:@"social"])
                    count++;
            }
        }
    }
    
    return count;
}

-(NewsCategory*) getShowCategoryByIndex: (NSInteger) index{
    if (self.showCategoryList == nil)
        [self refreshShowCategoryList];
    
    int showIndex = 0;
    
    if (self.showCategoryList != nil){
        for (NewsCategory* item in self.showCategoryList) {
            if (item != nil){
                if (item.hidden == YES || [item.type isEqualToString:@"social"])
                    continue;
                
                if (index == showIndex)
                    return item;
                    
                if (item.hidden == NO)
                    showIndex++;
            }
        }
    }
    
    return nil;
}


-(void) refreshLeftMenu{
    if (self.leftMenuList == nil)
        self.leftMenuList = [NSMutableArray arrayWithCapacity:3];
    else
        [self.leftMenuList removeAllObjects];
    
    LeftMenuItem* set = [LeftMenuItem alloc];
    set.iconName = @"icon_settings";
    set.actionName = NSLocalizedString(@"set", nil);
    [self.leftMenuList addObject:set];
    
//    LeftMenuItem* fav = [LeftMenuItem alloc];
//    fav.iconName = @"icon_collection";
//    fav.actionName = @"我的收藏";
//    [self.leftMenuList addObject:fav];
    
//    LeftMenuItem* settings = [LeftMenuItem alloc];
//    settings.iconName = @"trophy3";
//    settings.actionName = @"粉絲排行榜";
//    [self.leftMenuList addObject:settings];

    LeftMenuItem* comment = [LeftMenuItem alloc];
    comment.iconName = @"outbox";
    comment.actionName = NSLocalizedString(@"fans_menu_track", nil);
    [self.leftMenuList addObject:comment];
    // fav
//    LeftMenuItem* download = [LeftMenuItem alloc];
//    download.iconName = @"forums";
//    download.actionName = @"獎品中心";
//    [self.leftMenuList addObject:download];
    
//    LeftMenuItem* feed = [LeftMenuItem alloc];
//    feed.iconName = @"purchases";
//    feed.actionName = @"購買紀錄";
//    [self.leftMenuList addObject:feed];
    
//    LeftMenuItem* histroy = [LeftMenuItem alloc];
//    histroy.iconName = @"star60";
//    histroy.actionName = @"其他網紅";
//    [self.leftMenuList addObject:histroy];
    
    LeftMenuItem* menu = [LeftMenuItem alloc];
    menu.iconName = @"like [#1385]";
    menu.actionName = NSLocalizedString(@"own_celeb", nil);
    [self.leftMenuList addObject:menu];
    
    LeftMenuItem* item = [[LeftMenuItem alloc] init];
    [self.leftMenuList addObject:item];
    
    LeftMenuItem* login = [[LeftMenuItem alloc] init];
    [self.leftMenuList addObject:login];
    
    LeftMenuItem* item1 = [[LeftMenuItem alloc] init];
    [self.leftMenuList addObject:item1];

}

-(NSMutableArray*) getSettingList{
    
    if (self.settingList == nil)
        self.settingList = [NSMutableArray arrayWithCapacity:3];
    else
        [self.settingList removeAllObjects];
    
    
    ITSApplication* poApp = [ITSApplication get];
    DataService* ds = poApp.dataSvr;
    
    NSMutableArray* chList = [ds getPoNewsChannelList];
    
//    if (chList != nil && [chList count] > 1){
//        SettingItem* edition = [SettingItem alloc];
//        edition.iconName = @"set_edition";
//        
//        edition.settingName = ITS_NSLocalizedString(@"SettingEdition", nil);
//        edition.type = SettingTypeDetail;
//        edition.actionType = SETTING_ACTION_EDITION;
//        [self.settingList addObject:edition];
//    }
//    SettingItem* edition = [SettingItem alloc];
//    edition.iconName = @"set_edition";
//    
//    edition.settingName = ITS_NSLocalizedString(@"SettingEdition", nil);
//    edition.type = SettingTypeDetail;
//    edition.actionType = SETTING_ACTION_EDITION;
//    [self.settingList addObject:edition];

    SettingItem* video = [[SettingItem alloc] init];
    video.iconName = @"setting_autoplay";
    video.settingName = NSLocalizedString(@"set_push", nil);
    video.type = SettingTypeSwitch;
    video.actionType = SETTING_ACTION_VIDEO;
    video.isSwitch = NO;
    [self.settingList addObject:video];
    
    SettingItem* clearCache = [SettingItem alloc];
    clearCache.iconName = @"set_clean";
    clearCache.settingName = NSLocalizedString(@"set_clean", nil);
    clearCache.type = SettingTypeButton;
    clearCache.actionType = SETTING_ACTION_CLEAN_CACHE;
    [self.settingList addObject:clearCache];
    
    SettingItem* feedBack = [SettingItem alloc];
    feedBack.iconName = @"set_feed";
    feedBack.settingName = NSLocalizedString(@"set_suggest", nil);
    feedBack.type = SettingTypeDetail;
    feedBack.actionType = SETTING_ACTION_FEEDBACK;
    [self.settingList addObject:feedBack];

//    SettingItem* about = [SettingItem alloc];
//    about.iconName = @"set_about";
//    about.settingName = ITS_NSLocalizedString(@"SettingAbout", nil);
//    about.type = SettingTypeDetail;
//    about.actionType = SETTING_ACTION_ABOUT;
//    [self.settingList addObject:about];
    
    return self.settingList;
}

-(void) setConnectRespData: (NSDictionary*) dicData{
    if (dicData != nil){
        
        MMLogDebug(@"Connect Rsp : %@", [MMSystemHelper DictTOjsonString:dicData]);
        
        SettingService* ss = [SettingService get];
        [ss setDictoryValue:CONFIG_LAST_CONNECT_INFO data:dicData];
        
        if (self.celebInfo == nil)
            self.celebInfo = [CelebInfo alloc];
        
        NSString* tmpData = [dicData objectForKey:@"baseUrl"];
        if (tmpData != nil)
            self.fileBaseUrl = tmpData;
        tmpData = [dicData objectForKey:@"launch"];
    
        NSFileManager *fileManager = [NSFileManager defaultManager];
        ITSApplication* itsApp = [ITSApplication get];
        NSString* fileBaseUrl = [itsApp.remoteSvr getBaseFileUrl];
        self.launch = [[NSString alloc] initWithFormat:@"%@/%@", fileBaseUrl,tmpData];
        ConfigService *cs = [ConfigService get];
        NSString* launchFolder = [cs getlaunchFolder];
        NSArray *file = [[[NSFileManager alloc] init] subpathsAtPath:launchFolder];
        if([tmpData isEqual:[NSNull null]]) {
            if (file.count > 0) {
                [fileManager removeItemAtPath:launchFolder error:nil];
            }
        }else {
            
            if (file.count > 0) {
                for (NSString *name in file) {
                    if ([name compare:tmpData] == NSOrderedSame) {
                        continue;
                    }else {
                        [fileManager removeItemAtPath:launchFolder error:nil];
                        [[ITSApplication get].remoteSvr downloadLaunchImage:tmpData];
                    }
                }
            }else {
                [[ITSApplication get].remoteSvr downloadLaunchImage:tmpData];
            }
        }
        tmpData = [dicData objectForKey:@"name"];
        if (tmpData != nil)
            self.celebInfo.name = tmpData;
        
        tmpData = [dicData objectForKey:@"avatar"];
        if (tmpData != nil)
            self.celebInfo.avator = tmpData;
        
        
        NSArray* tmpCateList = [dicData objectForKey:@"categories"];
        if (tmpCateList != nil){
            NSMutableArray* newCateList = [NSMutableArray arrayWithCapacity:1];
            for(NSDictionary* item in tmpCateList){
                if (item != nil){
                    NewsCategory* cate = [[NewsCategory alloc] initWithDictionary:item];
                    //if (cate != nil && [cate.type compare:@"news"] == NSOrderedSame){
                    if (cate != nil){
                        if ([cate.type isEqualToString:@"social"]){
                            self.socialCategory = cate;
                        } else {
                            cate.hidden = NO;
                            [newCateList addObject:cate];
                        }
                        
                        NSString* customCId = [NSString stringWithFormat:@"%@_%@", CATEGORY_CUSTOM_LAYOUT_PERFIX, cate.cId];
                        NSString* customLayout = [ss getStringValue:customCId defValue:nil];
                        if (customLayout != nil)
                            cate.layout = customLayout;
                    }
                }
            }
            self.categoryList = newCateList;
            [self initPopoNewsListCategory];

            //[self initFBUsersData];
           
            //[self initTWUsersData];
            //[app.twSvr initTWNewsData];
            
            //[self initWEUsersData];
            //[app.weSvr initWBNewsData];
            
            //[self initUser];

        }
        
        tmpData = [dicData objectForKey:@"channel"];
        if (tmpData != nil){
            self.connectRspCh = tmpData;
            ConfigService* cs = [ConfigService get];
            [cs setChannel:tmpData];
        }
        
        NSDictionary* tmpChInfoList = [dicData objectForKey:@"channelInfo"];
        if (tmpChInfoList != nil){
            NSString* tmpCountry = [tmpChInfoList objectForKey:@"country"];
            NSString* tmpLang = [tmpChInfoList objectForKey:@"lang"];
            NSString* tmpMiniKit = [tmpChInfoList objectForKey:@"minikit"];
            NSDictionary *natDic = [tmpChInfoList objectForKey:@"ad1"];
            NSDictionary *intDic = [tmpChInfoList objectForKey:@"ad2"];
            NSDictionary *banDic = [tmpChInfoList objectForKey:@"ad3"];
            NSDictionary *ad4 = [tmpChInfoList objectForKey:@"ad4"];
            NSDictionary *ad5 = [tmpChInfoList objectForKey:@"ad5"];
            NSDictionary *extra = [tmpChInfoList objectForKey:@"extra"];
            NSMutableArray *share = [extra objectForKey:@"share"];
            NSMutableArray *login = [tmpChInfoList objectForKey:@"three_login"];
            CBChannelInfo* miniKitCh = [CBChannelInfo alloc];
            miniKitCh.shareItem = [[NSMutableArray alloc] init];
            miniKitCh.threeLogin = [[NSMutableArray alloc] init];
            if (login != nil) {
                miniKitCh.threeLogin = login;
            }

            if (natDic != nil) {
                NativeAd *nativeAd = [NativeAd alloc];
                [nativeAd setValuesForKeysWithDictionary:natDic];
//                nativeAd.count = [natDic objectForKey:@"count"];
//                nativeAd.enabled = [[natDic objectForKey:@"enabled"] boolValue];
                miniKitCh.nativeAd = nativeAd;
            }
            if (intDic != nil) {
                InterstitialAd *interstitalAd = [InterstitialAd alloc];
                [interstitalAd setValuesForKeysWithDictionary:intDic];
//                interstitalAd.enabled = [[intDic objectForKey:@"enabled"] boolValue];
//                interstitalAd.time = [intDic objectForKey:@"time"];
                miniKitCh.InterstitialAd = interstitalAd;
            }
            if (banDic != nil) {
                BannerAd *bannerAd = [BannerAd alloc];
                [bannerAd setValuesForKeysWithDictionary:banDic];
//                bannerAd.enabled = [[banDic objectForKey:@"enabled"] boolValue];
                miniKitCh.bannerAd = bannerAd;
            }
            if (ad4 != nil) {
                Interstitial *ad = [Interstitial alloc];
                [ad setValuesForKeysWithDictionary:ad4];
                miniKitCh.ad = ad;
            }
            if (ad5 != nil){
                DetailAd *dAd = [DetailAd alloc];
                [dAd setValuesForKeysWithDictionary:ad5];
                miniKitCh.detailAd = dAd;
            }
            if (tmpCountry != nil && tmpLang != nil && tmpMiniKit != nil){
               
                miniKitCh.country = tmpCountry;
                miniKitCh.lang = tmpLang;
                miniKitCh.ch = tmpMiniKit;
            }
            self.minikitCh = miniKitCh;
        }
        
        [self initNativeAds];
        //[self initUser];
        [self initDetailNativeAds];
        
        NSArray* tmpRspChList = [dicData objectForKey:@"channels"];
        [self setPoNewsChannelList:tmpRspChList];
        
        tmpData = [dicData objectForKey:@"did"];
        if (tmpData != nil) {
            self.did = tmpData;
            SettingService* ss = [SettingService get];
            [ss setStringValue:POPONEWS_SERVER_DEVICE_ID data:tmpData];
        }
        
        tmpData = [dicData objectForKey:@"group"];
        if (tmpData != nil)
            self.connectRspGroup = tmpData;
        
        NSNumber* tmpUpdate = [dicData objectForKey:@"update"];
        if (tmpUpdate != nil){
            self.update = (int)[tmpUpdate integerValue];
        }
        
        // init last news
        if (self.poponewsList != nil) {
            NewsService* ns = [NewsService get];
            for (int i = 0; i < [self.poponewsList count]; i++) {
                PopoNewsData* item = [self.poponewsList objectAtIndex:i];
                NewsCategory* cate = item.category;
                if (cate != nil){
                    NSMutableArray* storageData = [ns getStorageNewsListByCID:cate.cId];
                    [self setRefreshCategoryNewsByStroage:cate.cId newsList:storageData];
                }
            }
        }
    }
}
-(void) initNativeAds{
    
    BOOL AdIsOpen = self.minikitCh.nativeAd.enabled;
    int count = [self.minikitCh.nativeAd.count intValue];
    self.itemData = [[PopoNewsData alloc] init];
    if (self.itemData.nativeAdData == nil){
        self.itemData.nativeAdData = [NSMutableArray arrayWithCapacity:1];
    }
    if (AdIsOpen == YES) {
        NativeAdItem *item = [[NativeAdItem alloc] init];
        int percent = [self.minikitCh.nativeAd.fb intValue];
        int value = [self getRandomValue];
        if (value <= percent) {
            [item initWithData:FACEBOOK_LIST_PLACEMENT_ID :count :@"fbAd"];
        }else{
            [item initWithData:FACEBOOK_LIST_PLACEMENT_ID :count :@"gmobiAd"];
        }
        [item load];
        [self.itemData.nativeAdData addObject:item];
    }
    if (self.fbAd == nil) {
        self.fbAd = [NSMutableArray arrayWithCapacity:1];
    }
    if (self.gmobiAd == nil) {
        self.gmobiAd = [NSMutableArray arrayWithCapacity:1];
    }
}

-(void) initDetailNativeAds{
    BOOL AdIsOpen = self.minikitCh.detailAd.enabled;
    if (AdIsOpen == YES) {
        
        if (self.minikitCh.detailAd != nil && self.minikitCh.detailAd.enabled == YES){
            self.gmobiDetailAdItem = [[PNNativeAdItem alloc] init];
            
            [self.gmobiDetailAdItem initWithData:@"article_inside" count:20 ];
            [self.gmobiDetailAdItem load];
        }
    }
}


-(int)getRandomValue {
    int value = arc4random()%100 + 1;
    return value;
}

-(NativeAdItem*)getNativeAdItem:(NSString*)cid{

    NativeAdItem *adItem;
    if (self.poponewsList != nil && cid != nil){
        for (PopoNewsData* item in self.poponewsList) {
            if (item != nil){
                if ([item.category.cId compare:cid] == NSOrderedSame){
                    if (item.nativeAdData != nil){
                        adItem = [item.nativeAdData objectAtIndex:0];
                    }
                }
            }
        }
    }
    
    return adItem;
}

-(void) refreshCategoryNews: (NSString*) cid
                refreshType: (int) type {
    BOOL isNetConnect = [MMSystemHelper isConnectedToNetwork];
    if (isNetConnect == NO){
        if (type == NEWS_REFRESH_TYPE_AFTER){
            // do nothing
        } else if (type == NEWS_REFRESH_TYPE_BEFORE){
            // load storage data
            NewsService* ns = [NewsService get];
            NSMutableArray* storageData = [ns getStorageNewsListByCID:cid];
            [self setRefreshCategoryNewsByStroage:cid newsList:storageData];
        }
        MMEventService *es = [MMEventService getInstance];
        [es send:[[NSString alloc] initWithFormat:@"%@_%@", EVENT_NEWS_DATA_REFRESH_PREFIX, cid]  eventData:NEWS_REFRESH_SUCCESS];
    } else {
//        NSMutableArray* datas = [self getCategoryDataByID:cid];
//        NSString* newsTime = nil;    
//        if (datas != nil && [datas count] > 0){
//            PoPoNewsItem* newsItem = nil;
//            if (type == NEWS_REFRESH_TYPE_AFTER){
//                newsItem = [datas objectAtIndex:0];
//                if (newsItem.initType == NEWS_INIT_TYPE_CLIENT)
//                    newsItem = nil;
//            } else if (type == NEWS_REFRESH_TYPE_BEFORE){
//                NSInteger dataCount = [datas count];
//                newsItem = [datas objectAtIndex:dataCount-1];
//                if (newsItem.initType == NEWS_INIT_TYPE_CLIENT){
//                    // load storage data
//                    NewsService* ns = [NewsService get];
//                    NSMutableArray* storageData = [ns getStorageNewsListByCID:cid];
//                    if (storageData != nil){
//                        [self setRefreshCategoryNewsByStroage:cid newsList:storageData];
//                        MMEventService *es = [MMEventService getInstance];
//                        [es send:[[NSString alloc] initWithFormat:@"%@_%@", EVENT_NEWS_DATA_REFRESH_PREFIX, cid]  eventData:NEWS_REFRESH_SUCCESS];
//                        return;
//                    }
//                }
//            }
//            
//            if (newsItem != nil)
//                newsTime = [[NSString alloc] initWithFormat:@"%llu", newsItem.releaseTime];
//        }
        
        NewsCategory *cate = [self getCategoryByID:cid];
        NSString* newsTime = nil;
        if (type == NEWS_REFRESH_TYPE_AFTER) {
            newsTime = [NSString stringWithFormat:@"%llu",cate.afterTime];
        }else{
            newsTime = [NSString stringWithFormat:@"%llu",cate.beforeTime];
        }
        //[[ITSApplication get].remoteSvr getNewsListData:cid time:newsTime timeType:type];
    }
}

-(BOOL) insertNewsItem: (NSMutableArray*) list
                 news: (PoPoNewsItem*) item{
    BOOL same = NO;
    BOOL ret = NO;
    int i = 0;

    if (list == nil || item == nil)
        return ret;
    
    int listCount = (int)[list count];
    for (i = 0; i < listCount; i++) {
       // PoPoNewsItem* newItem = [list objectAtIndex:i];
        id news = [list objectAtIndex:i];
        if ([news isKindOfClass:[PoPoNewsItem class]]) {
            PoPoNewsItem* newItem = news;
            if (newItem != nil){
                if ([newItem.nId compare:item.nId] == NSOrderedSame) {
                    same = YES;
                    
                    if (item.isOfflineDL == YES && newItem.isOfflineDL == NO){
                        newItem.isOfflineDL = YES;
                    }
                    
                    break;
                }
                
                if (newItem.releaseTime < item.releaseTime) {
                    [list insertObject:item atIndex:i];
                    ret = YES;
                    break;
                }
            }
        }
    }
    
    if (same == NO && ret == NO){
        [list addObject:item];
        ret = YES;
    }
    
    return ret;
}
-(void) setRefreshCategoryNew: (NSString*) cid
                      newsList: (NSArray*) dicData
                   isClearData: (BOOL) clear {
    if (cid == nil || dicData == nil || self.poponewsList == nil)
        return;
    
    NewsService* ns = [NewsService get];
    
    for (PopoNewsData* itemData in self.poponewsList){
        NSString* itemCid = itemData.category.cId;
        if (itemData.data == nil)
            itemData.data = [NSMutableArray arrayWithCapacity:1];
        
        if ([itemCid compare:cid] == NSOrderedSame){
            
            NSString* itemLayout = itemData.category.layout ;
            // category layout is "grid"
            
            if (clear == YES){
                [itemData.data removeAllObjects];
            }
            
            for (NSDictionary* newsDataItem in dicData) {
                PoPoNewsItem* tmpItem = [[PoPoNewsItem alloc] initWithDictionary:newsDataItem];
                [tmpItem setNewsInitType:NEWS_INIT_TYPE_SERVER];
                
                if (tmpItem != nil) {
                    
                    // init mood data
                    if (ns != nil){
                        NSDictionary* savedData = [ns getPopoNewsItem:tmpItem.nId];
                        PoPoNewsItem* savedNew = [[PoPoNewsItem alloc] initWithDictionary:savedData];
                        if (savedNew != nil){
                            NSString* moodMyType = [savedNew.mood getMyMoodType];
                            if (moodMyType != nil)
                                [tmpItem.mood setMyMoodType:moodMyType];
                            [ns savePopoNewsItem:tmpItem.nId data:[tmpItem toDictionaryData]];
                        } else {
                            [ns savePopoNewsItem:tmpItem.nId data:newsDataItem];
                        }
                    }
                    // check is favour
                    BOOL isFind = [self isInFavourList:tmpItem];
                    if (isFind == YES){
                        tmpItem.isMyFav = YES;
                        tmpItem.didFav = YES;
                        tmpItem.fav++;
                        if (tmpItem.fav > 1) {
                            tmpItem.fav = 1;
                        }
                    }
                    
                    // check read list
                    BOOL isRead = [self isInReadList:tmpItem];
                    if (isRead == YES)
                        tmpItem.isRead = YES;
                    [self insertNewsItem:itemData.data news:tmpItem];

                    
                }
            }
            
            break;
        }
    }
}
-(void) setRefreshCategoryNews: (NSString*) cid
                      newsList: (NSArray*) dicData
                   isClearData: (BOOL) clear type:(int)type{
    if (cid == nil || dicData == nil || self.poponewsList == nil)
        return;
    
    NewsService* ns = [NewsService get];
    NewsCategory *cate = [self getCategoryByID:cid];

    for (PopoNewsData* itemData in self.poponewsList){
        NSString* itemCid = itemData.category.cId;
        if (itemData.data == nil)
            itemData.data = [NSMutableArray arrayWithCapacity:1];
        
        if ([itemCid compare:cid] == NSOrderedSame){
            if (clear == YES){
                [itemData.data removeAllObjects];
            }
            for (NSDictionary* newsDataItem in dicData) {
                PoPoNewsItem* tmpItem = [[PoPoNewsItem alloc] initWithDictionary:newsDataItem];
                [tmpItem setNewsInitType:NEWS_INIT_TYPE_SERVER];
             
                if (cate.afterTime == 0) {
                    cate.afterTime = tmpItem.releaseTime;
                }
                if (cate.beforeTime == 0) {
                    cate.beforeTime = tmpItem.releaseTime;
                }
                if (cate.afterTime < tmpItem.releaseTime ) {
                    cate.afterTime = tmpItem.releaseTime;
                }
                if (cate.beforeTime > tmpItem.releaseTime) {
                    cate.beforeTime = tmpItem.releaseTime;
                }
    
                // 
                {
                    BOOL isUnlike = NO;
                    for (PoPoNewsItem *unLikeNews in self.unLikeNewsList) {
                        if ([unLikeNews.nId compare:tmpItem.nId] == NSOrderedSame) {
                            isUnlike = YES;
                            break;
                        }
                    }
                    if (isUnlike == YES)
                        continue;
                }
                
                if (tmpItem != nil) {
                
                    // init mood data
                    if (ns != nil){
                        NSDictionary* savedData = [ns getPopoNewsItem:tmpItem.nId];
                        PoPoNewsItem* savedNew = [[PoPoNewsItem alloc] initWithDictionary:savedData];
                        if (savedNew != nil){
                            NSString* moodMyType = [savedNew.mood getMyMoodType];
                            if (moodMyType != nil)
                                [tmpItem.mood setMyMoodType:moodMyType];
                            [ns savePopoNewsItem:tmpItem.nId data:[tmpItem toDictionaryData]];
                        } else {
                            [ns savePopoNewsItem:tmpItem.nId data:newsDataItem];
                        }
                    }
                    // check is favour
                    BOOL isFind = [self isInFavourList:tmpItem];
                    if (isFind == YES){
                        tmpItem.isMyFav = YES;
                        tmpItem.didFav = YES;
                        tmpItem.fav++;
//                        if (tmpItem.fav > 1) {
//                            tmpItem.fav = 1;
//                        }
                    }
                    
                    // check read list
                    BOOL isRead = [self isInReadList:tmpItem];
                    if (isRead == YES)
                        tmpItem.isRead = YES;
                    if (itemData != nil && itemData.data != nil){
                        [self insertNewsItem:itemData.data news:tmpItem];
                    }
                }
            }
            
            NSMutableArray* newsGridList = nil;
            NSString* itemLayout = itemData.category.layout;
           
            [self getNewsNewsListWithAdList:cid :type];
            
            NSString *forKey = [NSString stringWithFormat:@"%@",cid];
            int getLastCount = [[[NSUserDefaults standardUserDefaults] objectForKey:forKey] intValue];
            NSInteger count = itemData.data.count - getLastCount;
            int lastCount = (int)itemData.data.count;

            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",lastCount] forKey:forKey];
            // category layout is "grid"
            
            [itemData resetTopPhotoIndex];
            break;
        }
    }
}
//unlike
-(BOOL) insert2UnLikeNewsList: (PoPoNewsItem*) item
                     saveFlag: (BOOL) saved{
    if (item == nil)
        return NO;
    
    BOOL isFind = NO;
    
    if (self.unLikeNewsList == nil){
        self.unLikeNewsList = [NSMutableArray arrayWithCapacity:1];
    }
    
    for (PoPoNewsItem* tmpItem in self.unLikeNewsList) {
        if (tmpItem != nil){
            PoPoNewsItem* newsItem = tmpItem;
            if (newsItem == item || [newsItem.nId compare:item.nId] == NSOrderedSame){
                isFind = YES;
                break;
            }
        }
    }
    
    if (isFind == NO){
        [self.unLikeNewsList insertObject:item atIndex:0];
        
        long listCount = [self.unLikeNewsList count];
        if (listCount > MAX_UNLIKE_NEWS_COUNT){
            [self.unLikeNewsList removeObjectAtIndex:listCount-1];
        }
        
        if (saved == YES){
            // save to db
            NewsService* ns = [NewsService get];
            [ns saveUnLikeNewsItem:item.nId data:[item toDictionaryData]];
        }
        return YES;
    }
    
    return NO;


}
-(void) initUnLikeNewsList{

    NewsService* ns = [NewsService get];
    NSMutableArray* pList = [ns getStorageUnLikeNewsList];
    if (pList != nil){
        if (self.unLikeNewsList != nil){
            [self.unLikeNewsList removeAllObjects];
            self.unLikeNewsList = nil;
        }
        self.unLikeNewsList = [NSMutableArray arrayWithArray:pList];
    }
}
-(NSMutableArray*) getUnLikeNewsList{
    
    return self.unLikeNewsList;
}
-(void) setRefreshCategoryNewsByStroage: (NSString*) cid
                               newsList: (NSMutableArray*) newsData{
    if (cid == nil || newsData == nil || self.poponewsList == nil)
        return;
//    NewsCategory *cate = [self getCategoryByID:cid];

    for (int i = 0; i < [self.poponewsList count]; i++) {
        PopoNewsData* itemData = [self.poponewsList objectAtIndex:i];
        NSString* itemCid = itemData.category.cId;
        if (itemData.data == nil)
            itemData.data = [NSMutableArray arrayWithCapacity:1];
        
        if ([itemCid compare:cid] == NSOrderedSame){
            NSString* itemLayout = itemData.category.layout;
            // category layout is "grid"
            for (int j = 0; j < [newsData count]; j++) {
                PoPoNewsItem* tmpItem = [newsData objectAtIndex:j];
//                {
//                    BOOL isUnlike = NO;
//                    for (PoPoNewsItem *unLikeNews in self.unLikeNewsList) {
//                        if ([unLikeNews.nId compare:tmpItem.nId] == NSOrderedSame) {
//                            isUnlike = YES;
//                            break;
//                        }
//                    }
//                    if (isUnlike == YES)
//                        continue;
//                }
                
                if (tmpItem != nil) {
                    // check is favour
                    BOOL isFind = [self isInFavourList:tmpItem];
                    if (isFind == YES){
                        tmpItem.isMyFav = YES;
                        tmpItem.didFav = YES;
                        tmpItem.fav++;
//                        if (tmpItem.fav > 1) {
//                            tmpItem.fav = 1;
//                        }
                    }
                    // check read list
                    BOOL isRead = [self isInReadList:tmpItem];
                    if (isRead == YES)
                        tmpItem.isRead = YES;
                    [self insertNewsItem:itemData.data news:tmpItem];
                }
            }
            
            NSMutableArray* newsGridList = nil;
//            if (itemData.newsList == nil) {
//                itemData.newsList = itemData.data;
//            }
           // [self getNewsNewsListWithAdList:cid :NEWS_REFRESH_TYPE_BEFORE];
           [self getNewsNewsListWithAdList:cid :NEWS_REFRESH_TYPE_BEFORE];
            NSInteger count = itemData.data.count - itemData.lastCount;
            itemData.lastCount = (int)itemData.data.count;
            
            NSMutableArray *newsList = [[NSMutableArray alloc] init];
            for (NSInteger i = 0; i < itemData.data.count; i++) {
                if (i >= itemData.data.count - count) {
                    id item = [itemData.data objectAtIndex:i];
                    [newsList addObject:item];
                }
            }
            for (NSInteger i = 0; i < newsList.count; i++) {
                id tmpItem = nil;
                tmpItem = [newsList objectAtIndex:i];
            }
            
            [itemData resetTopPhotoIndex];
            break;
        }
    }
}
-(void) setRefreshCategoryNewsByStroages: (NSString*) cid
                      newsList: (NSMutableArray*) newsData{
    if (cid == nil || newsData == nil || self.poponewsList == nil)
        return;
    
    for (int i = 0; i < [self.poponewsList count]; i++) {
        PopoNewsData* itemData = [self.poponewsList objectAtIndex:i];
        NSString* itemCid = itemData.category.cId;
        if (itemData.data == nil)
            itemData.data = [NSMutableArray arrayWithCapacity:1];
        
        if ([itemCid compare:cid] == NSOrderedSame){
            NSString* itemLayout = itemData.category.layout;
            // category layout is "grid"
            
            for (int j = 0; j < [newsData count]; j++) {
                PoPoNewsItem* tmpItem = [newsData objectAtIndex:j];
                if (tmpItem != nil) {
                    // check is favour
                    BOOL isFind = [self isInFavourList:tmpItem];
                    if (isFind == YES){
                        tmpItem.isMyFav = YES;
                        tmpItem.didFav = YES;
                        tmpItem.fav++;
//                        if (tmpItem.fav > 1) {
//                            tmpItem.fav = 1;
//                        }
                    }
                    // check read list
                    BOOL isRead = [self isInReadList:tmpItem];
                    if (isRead == YES)
                        tmpItem.isRead = YES;
                    [self insertNewsItem:itemData.data news:tmpItem];
                    
                    // [self insertNewsItem:itemData.gridData news:tmpItem];
                    //添加数据
                }
            }
            //[itemData resetTopPhotoIndex];
            break;
        }
    }
}

-(int) getCategoryListActiveCount{
    int count = 0;
    if (self.categoryList != nil){
        for (NewsCategory* item in self.categoryList) {
            if (item != nil){
                if (item.hidden == NO)
                    count++;
            }
        }
    }
    return count;
}

-(int) getCategoryNewsCount: (NSString*) cid{
    int count = 0;
    //BOOL AdIsOpen = self.minikitCh.nativeAd.enabled;
        if (self.poponewsList != nil && cid != nil){
            for (PopoNewsData* item in self.poponewsList) {
                if (item != nil){
                    if ([item.category.cId compare:cid] == NSOrderedSame){
                        if (item.data.count != 0)
//                            if (item.newsList == nil) {
//                                item.newsList = item.data;
//                            }
//                        if (AdIsOpen == YES) {
//                            count = (int)[item.newsList count];
//                        }else{
//                            count = (int)[item.data count];
//                        }
                        count = (int)[item.data count];
                    }
                }
            }
        }
        return count;
}
-(int )getGridCategoryNewsCount:(NSString *) cid{

    int count = 0;
    return count;
   
}
-(NewsCategory*) getCategoryByIndex: (int) index{
    NewsCategory* category = nil;
    
    if (self.categoryList != nil && index < [self.categoryList count])
        category = [self.categoryList objectAtIndex:index];
    
    return category;
}

-(NewsCategory*) getCategoryByID: (NSString*) cid{
    NewsCategory* category = nil;
    
    if (self.categoryList != nil && cid != nil){
        for (NewsCategory* item in self.categoryList) {
            if (item != nil){
                if ([item.cId compare:cid] == NSOrderedSame){
                    category = item;
                    break;
                }
            }
        }
    }

    return category;
}

-(NSMutableArray*) getCategoryDataByID: (NSString*) cid {
    NSMutableArray* data = nil;
    
    if (self.poponewsList != nil && cid != nil){
        for (PopoNewsData* item in self.poponewsList) {
            if (item != nil){
                if ([item.category.cId compare:cid] == NSOrderedSame){
                    data = item.data;
                    break;
                }
            }
        }
    }
    
    return data;
}

-(PoPoNewsItem*) getNewsItemByNid: (NSString*) cid
                           newsId: (NSString*) nid {
    PoPoNewsItem* news = nil;
    if (self.categoryList != nil && cid != nil){
        for (PopoNewsData* item in self.poponewsList) {
            if (item != nil){
                if ([item.category.cId compare:cid] == NSOrderedSame){
                    NSMutableArray* newsList = item.data;
                    for (id item in newsList) {
                        if ([item isKindOfClass:[PoPoNewsItem class]]) {
                            PoPoNewsItem *newsItem = item;
                            if ([newsItem.nId compare:nid] == NSOrderedSame){
                                news = newsItem;
                                break;
                            }
                        }
                    }
                    break;
                }
            }
        }
    }
    return news;
}

-(id) getNewsItemAtIndex: (PopoNewsData*) item
                       index: (int) idx{
    id news = nil;
    [item resetTopPhotoIndex];
    if (item != nil && item.data != nil && [item.data count] > idx){
        if (idx == 0 && item.topPhotoIndex != -1){
            news = [item.data objectAtIndex:item.topPhotoIndex ];
        } else {
            if (item.topPhotoIndex != -1){
                int dataIndex = idx;
                if (item.topPhotoIndex >= idx){
                    dataIndex -= 1;
                }
                news = [item.data objectAtIndex:dataIndex];
            } else {
                news = [item.data objectAtIndex:idx];
            }
        }
    }
    return news;
}
-(GRInterstitialAd*) getInterstitialAd: (NSString*)publisher {
    GRAdService* adService = [GRServices get:GR_SERVICE_TYPE_AD];
//    ConfigService *cf = [ConfigService get];
//    NSString *ch = [cf getChannel];
//    NSString *dch = @"";
//    NSString *str = INTERSTITIAL_AD_PLACEMENT_FORMAT;
//    NSString *placement1 = [str stringByReplacingOccurrencesOfString:@"{ch}" withString:ch];
//    NSString *placement2 = [placement1 stringByReplacingOccurrencesOfString:@"{dch}" withString:dch];
//    NSString *placement = [placement2 stringByReplacingOccurrencesOfString:@"{publisher}" withString:publisher];
    GRInterstitialAd *nAd = [adService getInterstitialAd:publisher];
    return nAd;
}
-(GRBannerAd*) getBannerAd :(NSString*)publisher{
    GRAdService* adService = [GRServices get:GR_SERVICE_TYPE_AD];
//    ConfigService *cf = [ConfigService get];
//    NSString *ch = [cf getChannel];
//    NSString *dch = @"";
//    NSString *str = BANNER_AD_PLACEMENT_FORMAT;
//    NSString *placement1 = [str stringByReplacingOccurrencesOfString:@"{ch}" withString:ch];
//    NSString *placement2 = [placement1 stringByReplacingOccurrencesOfString:@"{dch}" withString:dch];
//    NSString *placement = [placement2 stringByReplacingOccurrencesOfString:@"{publisher}" withString:publisher];
    GRBannerAd* nAd = [adService getBannerAd:FACEBOOK_ARTICLE_BANNER_PLACEMENT_ID imageWidth:[UIScreen mainScreen].bounds.size.width-20 imageHeight:60 requiredFields:nil];
    
    return nAd;
}
-(NSString*) getNativedAdPlacement: (NSString*) cid{
    
    ConfigService *cf = [ConfigService get];
    NSString *ch = [cf getChannel];
    NSString *dch = @"";
    NSString *str = NATIVE_AD_PLACEMENT_FORMAT;
    NSString *placement1 = [str stringByReplacingOccurrencesOfString:@"{ch}" withString:ch];
    NSString *placement2 = [placement1 stringByReplacingOccurrencesOfString:@"{dch}" withString:dch];
    NSString *placement = [placement2 stringByReplacingOccurrencesOfString:@"{cid}" withString:cid];
    
    return placement;
}
-(id) getCategoryShowItem: (NSString*) layout
                  cid: (NSString*) cid
                index: (int) idx {
    
    int trueIndex = idx;
//    if ([layout compare:NEWS_LAYOUT_TYPE_GRID] == NSOrderedSame) {
//        return [self getGridNewsItem:cid index:trueIndex];
//    }else{
//        return [self getNewsItem:cid index:trueIndex];
//    }
    return [self getNewsItem:cid index:trueIndex];

}
-(id) getNewsItem: (NSString*) cid
                   index: (int) idx{
    id news = nil;
    
   // BOOL isOpen = self.minikitCh.nativeAd.enabled;
  
        if (self.poponewsList != nil && cid != nil){
            for (PopoNewsData* item in self.poponewsList) {
                if (item != nil){
                    if (item.category.cId == cid) {
                        news = [self getNewsItemAtIndex:item index:idx];
                        break;
                    } else if ([item.category.cId compare:cid] == NSOrderedSame){
                        news = [self getNewsItemAtIndex:item index:idx];
                        break;
                    }
                }
            }
        }
    return news;
}
-(void) removeNewsItem: (NSString *)nid{
    
    if (self.poponewsList != nil && nid != nil) {
        for (PopoNewsData *item in self.poponewsList) {
            if (item != nil) {
                for (NSInteger i = 0; i < item.data.count; i++) {
                    id news = [item.data objectAtIndex:i];
                    if ([news isKindOfClass:[PoPoNewsItem class]]) {
                        PoPoNewsItem *newsItem = news;
                        if ([newsItem.nId compare:nid] == NSOrderedSame) {
                            [item.data removeObjectAtIndex:i];
                            return;
                        }
                    }
                }
            }
        }
    }
}


// parser remote service response data
-(void) parserNewsItemData: (PoPoNewsItem*) item
                      data: (NSDictionary*) dic{
    if (dic == nil || item == nil)
        return;
    
    NSString* tmpData = [dic objectForKey:NEWS_ITEM_ID];
    if (tmpData != nil)
        item.nId = tmpData;
    
    tmpData = [dic objectForKey:NEWS_ITEM_CATEGORY_ID];
    if (tmpData != nil)
        item.cId = tmpData;
    
    NSNumber* numData = [dic objectForKey:NEWS_ITEM_RELEASE_TIME];
    if (numData != nil)
        item.releaseTime = numData.intValue;
    
    tmpData = [dic objectForKey:NEWS_ITEM_TITLE];
    if (tmpData != nil)
        item.title = tmpData;
    
    NSArray* mmData = [dic objectForKey:NEWS_ITEM_MM];
    if (mmData != nil){
        NSMutableArray* tmpArray = [NSMutableArray arrayWithCapacity:2];
        for(NSDictionary* item in mmData){
            NewsImage* image = [[NewsImage alloc] initWithDictionary:item];
            //[self parserNewsImage:image data:item];
            [tmpArray addObject:image];
        }
        item.images = tmpArray;
    }
    
    numData = [dic objectForKey:NEWS_ITEM_FAV];
    if (numData != nil)
        item.fav = numData.intValue;
    
    NSDictionary* moodData = [dic objectForKey:NEWS_ITEM_MOOD];
    if (moodData != nil){
        NewsMood* mood = [[NewsMood alloc] initWithDictionary:moodData];
        //[self parserNewsMood:mood data:moodData];
        item.mood = mood;
    }
    
    tmpData = [dic objectForKey:NEWS_ITEM_PREVIEW];
    if (tmpData != nil)
        item.preview = tmpData;
    
    
    tmpData = [dic objectForKey:NEWS_ITEM_PDOMAIN];
    if (tmpData != nil)
        item.pDomain = tmpData;
    
    tmpData = [dic objectForKey:NEWS_ITEM_SOURCE];
    if (tmpData != nil)
        item.source = tmpData;
    
    tmpData = [dic objectForKey:NEWS_ITEM_BODY];
    if (tmpData != nil)
        item.body = tmpData;
    
    tmpData = [dic objectForKey:NEWS_ITEM_TYPE];
    if (tmpData != nil)
        item.type = tmpData;
    
    tmpData = [dic objectForKey:NEWS_ITEM_PNAME];
    if (tmpData != nil)
        item.pName = tmpData;
    
    tmpData = [dic objectForKey:NEWS_ITEM_PICON];
    if (tmpData != nil)
        item.pIcon = tmpData;
}


-(id) getCurrentDetailNewsItem{
    return self.currentDetailNews;
}

-(void) setCurrentDetailNewsItem: (id) item{
    self.currentDetailNews = item;
}

-(NSMutableArray*) getPoNewsChannelList {
    if (self.popoNewChannelList == nil) {
        SettingService* ss = [SettingService get];
        NSArray* array = [ss getArrayValue:CONFIG_CHANNELS_DATA defValue:nil];
        [self setPoNewsChannelList:array];
    }
    return self.popoNewChannelList;
}

-(void) setPoNewsChannelList: (NSArray*) array{
    if (array == nil)
        return;
    
    if (self.popoNewChannelList == nil){
        self.popoNewChannelList = [NSMutableArray arrayWithCapacity:1];
    } else
        [self.popoNewChannelList removeAllObjects];
    
    SettingService* ss = [SettingService get];
    [ss setArrayValue:CONFIG_CHANNELS_DATA data:array];
    
    ConfigService* cs = [ConfigService get];
    int chCount = 0;
    NSString* currentCH = [cs getChannel];
    for(NSDictionary* item in array){
        if (item != nil){
            NSString* tmpId = [item objectForKey:@"id"];
            NSString* tmpName = [item objectForKey:@"name"];
            NSString* tmpCountry = [item objectForKey:@"country"];
            NSString* tmpIcon = [item objectForKey:@"icon"];
            NSString* tmpLang = [item objectForKey:@"lang"];
            BOOL isChecked = NO;
            
            if (currentCH == nil){
                if (chCount == 0){
                    [cs setChannel:tmpId];
                    isChecked = YES;
                }
            } else {
                if ([currentCH compare:tmpId] == NSOrderedSame){
                    isChecked = YES;
                }
            }
            
            if (tmpId != nil && tmpName != nil && tmpCountry != nil && tmpIcon != nil && tmpLang != nil){
                CBChannel* poCh = [CBChannel alloc];
                poCh.chId = tmpId;
                poCh.name = tmpName;
                poCh.icon = tmpIcon;
                poCh.lang = tmpLang;
                poCh.country = tmpCountry;
                poCh.isChecked = isChecked;
                [self.popoNewChannelList addObject:poCh];
            }
            chCount++;
        }
    }
}

-(void) clearCategoryData{
    // categoryList
    // showCategoryList
    // popoNewChannelList
    // poponewsList
    // downloadList
    // gpChannels
    
    if (self.popoNewChannelList != nil){
        [self.popoNewChannelList removeAllObjects];
        self.popoNewChannelList = nil;
    }
    
    if (self.showCategoryList != nil){
        [self.showCategoryList removeAllObjects];
        self.showCategoryList = nil;
    }
    
    if (self.categoryList != nil){
        [self.categoryList removeAllObjects];
        self.categoryList = nil;
    }
    
    if (self.poponewsList != nil){
        for (PopoNewsData* data in self.poponewsList){
            if (data != nil){
                data.category = nil;
                [data.data removeAllObjects];
                data.data = nil;
            }
        }
        [self.poponewsList removeAllObjects];
        self.poponewsList = nil;
    }
}

-(void) calculateCacheSize{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    //NSFileManager *fileMgr = [NSFileManager defaultManager];
    // create MMlogs folder
    NSString* detailPageFolder = [NSString stringWithFormat:@"%@/cache/articles", documentPath];
    NSString* imageCacheFolder = [NSString stringWithFormat:@"%@/MMImageCache", documentPath];
    
    long detailSize = [MMSystemHelper fileSizeForDir:detailPageFolder];
    long imageSize = [MMSystemHelper fileSizeForDir:imageCacheFolder];
    
    self.cacheDataSize = detailSize+imageSize;
    
    MMEventService *es = [MMEventService getInstance];
    [es send:EVENT_CACHE_SIZE_REFRESHED eventData:nil];
}

-(void) refreshCacheDataSize {
    NSThread* cacheThread = [[NSThread alloc] initWithTarget:self
                                                  selector:@selector(calculateCacheSize)
                                                    object:nil];
    [cacheThread start];
}

-(void) setCacheFolderSize: (long) size{
    self.cacheDataSize = size;
}

-(long) getCacheFolderSize{
    return self.cacheDataSize;
}

-(void) doClearCacheInThread{

    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    
    NSString* detailPageFolder = [NSString stringWithFormat:@"%@/cache/articles", documentPath];
    NSString* imageCacheFolder = [NSString stringWithFormat:@"%@/MMImageCache", documentPath];
    [MMSystemHelper removeFileForDir:detailPageFolder];
    [MMSystemHelper removeFileForDir:imageCacheFolder];
    
    MMEventService *es = [MMEventService getInstance];
    [es send:EVENT_CACHE_CLEARED eventData:nil];
}

-(void) clearCacheFolder {
    NSThread* clearCacheThread = [[NSThread alloc] initWithTarget:self
                                                    selector:@selector(doClearCacheInThread)
                                                      object:nil];
    [clearCacheThread start];
}


// read news
-(void) insert2ReadNewsList: (NSString*) nId
                 categoryId: (NSString*) cId {
    if (nId == nil || cId == nil)
        return;
    
    BOOL isFind = NO;
    
    if (self.readNewsList == nil){
        self.readNewsList = [NSMutableArray arrayWithCapacity:1];
    }
    
    /*
    for (ReadedNewsItem* item in self.readNewsList) {
        if (item != nil){
            if ([item.nId compare:nId] == NSOrderedSame){
                isFind = YES;
                break;
            }
        }
    }
    
    if (isFind == NO){
        ReadedNewsItem* readItem = [ReadedNewsItem alloc];
        readItem.cId = cId;
        readItem.nId = nId;
        [self.readNewsList insertObject:readItem atIndex:0];
        
        long listCount = [self.readNewsList count];
        if (listCount > MAX_READED_NEWS_COUNT){
            [self.readNewsList removeObjectAtIndex:listCount-1];
        }
        
        // save to db
        NewsService* ns = [NewsService get];
        [ns saveReadNewsList:self.readNewsList];
    }
     */
}

-(BOOL) isInReadList: (PoPoNewsItem*) item{
    BOOL isFind = NO;
    if (item == nil || self.readNewsList == nil)
        return isFind;
    /*
    for (ReadedNewsItem* readItem in self.readNewsList) {
        if (readItem != nil){
            if ([readItem.nId compare:item.nId] == NSOrderedSame){
                isFind = YES;
                break;
            }
        }
    }
    */
    return isFind;
}

-(NSMutableArray*) getReadNewsList{
    return self.readNewsList;
}
//myCommentNews list
-(NSMutableArray*) getMyCommentNewsList{
    return self.myCommentNewsList;
}
-(PoPoNewsItem*) getTapMyCommentNews:(NSString *)nid{
    id item = nil;
    if (self.myCommentNewsList != nil && nid != nil){
        for (PoPoNewsItem* newsItem in self.myCommentNewsList) {
            if (newsItem != nil){
                if ([newsItem.nId compare:nid] == NSOrderedSame) {
                    item = newsItem;
                }
            }
        }
    }
    return item;
}
-(void) insert2MyCommentNewsList:(PoPoNewsItem*) item{
    if (item == nil)
        return;
    
    BOOL isFind = NO;
    
    if (self.myCommentNewsList == nil){
        self.myCommentNewsList = [NSMutableArray arrayWithCapacity:1];
    }
    for (PoPoNewsItem *newsItem in self.myCommentNewsList) {
        if (newsItem != nil) {
            if ([item.nId compare:newsItem.nId] == NSOrderedSame) {
                isFind = YES;
                break;
            }
        }
    }
    if (isFind == NO){
        [self.myCommentNewsList insertObject:item atIndex:0];
    }
    long listCount = [self.myCommentNewsList count];
    if (listCount > MAX_READED_NEWS_COUNT){
        [self.myCommentNewsList removeObjectAtIndex:listCount-1];
    }
}
// favour list
-(void) insert2FavourList: (PoPoNewsItem*) item
                 saveFlag: (BOOL) saved
               isPushNews: (BOOL) isPushNews {
    if (item == nil)
        return;
    
    BOOL isFind = NO;
    
    if (self.favourNewsList == nil){
        self.favourNewsList = [NSMutableArray arrayWithCapacity:1];
    }
    /*
    for (FavourNewsItem* tmpItem in self.favourNewsList) {
        if (tmpItem != nil){
            PoPoNewsItem* newsItem = tmpItem.data;
            if (newsItem == item || [newsItem.nId compare:item.nId] == NSOrderedSame){
                isFind = YES;
                break;
            }
        }
    }
    
    if (isFind == NO ){
        FavourNewsItem* favourItem = [FavourNewsItem alloc];
        favourItem.checked = NO;
        favourItem.data = item;
        
        [self.favourNewsList insertObject:favourItem atIndex:0];
        
        item.isMyFav = YES;
        item.didFav = YES;
        item.fav++;
        
        long listCount = [self.favourNewsList count];
        if (listCount > MAX_FAVOUR_NEWS_COUNT){
            [self.favourNewsList removeObjectAtIndex:listCount-1];
        }
        
        if (saved == YES){
           
            // save to db
            NewsService* ns = [NewsService get];
            [ns saveFavourNews:item.nId data:[item toDictionaryData]];
            
            if (isPushNews == YES){
                [ns saveFeedNewsItem:item.nId data:[item toDictionaryDataHasReadStatus]];
            } else {
                // update news
                [ns savePopoNewsItem:item.nId data:[item toDictionaryData]];
            }
        }
    }
     */
}

-(void) removeFavourById: (PoPoNewsItem*) item{
    if (item == nil)
        return;
    
    BOOL isFind = NO;
    
    if (self.favourNewsList == nil)
        return;
    
    int index = 0;
    /*
    for (FavourNewsItem* tmpItem in self.favourNewsList) {
        if (tmpItem != nil){
            PoPoNewsItem* newsItem = tmpItem.data;
            if (newsItem == item || [newsItem.nId compare:item.nId] == NSOrderedSame){
                isFind = YES;
                [self.favourNewsList removeObjectAtIndex:index];
                break;
            }
        }
        index++;
    }
    
    if (isFind == YES){
        item.isMyFav = NO;
        item.fav--;
        if (item.fav < 0)
            item.fav = 0;
        
        // save to db
        NewsService* ns = [NewsService get];
        [ns saveFavourNews:item.nId data:nil];
        // update news
        [ns savePopoNewsItem:item.nId data:[item toDictionaryData]];
    }
     */
}

-(BOOL) isInFavourList:(PoPoNewsItem*) item{
    BOOL isFind = NO;
    if (item == nil || self.favourNewsList == nil)
        return isFind;
    /*
    for (FavourNewsItem* tmpItem in self.favourNewsList) {
        if (tmpItem != nil){
            PoPoNewsItem* newsItem = tmpItem.data;
            if (newsItem == item || [newsItem.nId compare:item.nId] == NSOrderedSame){
                isFind = YES;
                break;
            }
        }
    }
    */
    return isFind;
}

-(NSMutableArray*) getFavourList{
    return self.favourNewsList;
}

-(void) removeAllSelFavour{
    if (self.favourNewsList == nil)
        return;
    
    long count = [self.favourNewsList count];
    /*
    for (int i = 0; i < count; i++) {
        FavourNewsItem* tmpItem = [self.favourNewsList objectAtIndex:i];
        if (tmpItem != nil){
            if (tmpItem.checked == YES) {
                PoPoNewsItem* item = tmpItem.data;
                
                item.isMyFav = NO;
                item.fav--;
                if (item.fav < 0)
                    item.fav = 0;
                
                // save to db
                NewsService* ns = [NewsService get];
                [ns saveFavourNews:item.nId data:nil];
                // update news
                [ns savePopoNewsItem:item.nId data:[item toDictionaryData]];
                
                [self.favourNewsList removeObjectAtIndex:i];
                i--;
                count--;
            }
        }
    }
     */
}

-(void) clearFavourAllSel{
    /*
    for (FavourNewsItem* tmpItem in self.favourNewsList) {
        if (tmpItem != nil){
            tmpItem.checked = NO;
        }
    }
     */
}
//回复的回复
/*
-(NSString *)getCommentRpath:(NSInteger *)index :(NSInteger)section :(NSInteger)row{
    
    NSString *path = @"";
    if (section == 0) {
        if (self.hotCommentList != nil) {
            CommentCellFrame *commentFreaem = [self.hotCommentList objectAtIndex:row];
            if (index >= commentFreaem.commentItem.replyPath.count) {
                if (commentFreaem.commentItem.replyPath.count > 0) {
                    NSInteger count = commentFreaem.commentItem.replyPath.count - 1;
                    path = [commentFreaem.commentItem.replyPath objectAtIndex:count];
                }else{
                    path = commentFreaem.commentItem.path;
                }
            }else{
                path = [commentFreaem.commentItem.replyPath objectAtIndex:index];
            }
        }
    }else{
        if(self.commentList != nil){
            CommentCellFrame *commentFreaem = [self.commentList objectAtIndex:row];
            if (index >= commentFreaem.commentItem.replyPath.count) {
                if (commentFreaem.commentItem.replyPath.count > 0) {
                    NSInteger count = commentFreaem.commentItem.replyPath.count - 1;
                    path = [commentFreaem.commentItem.replyPath objectAtIndex:count];
                }else{
                    path = commentFreaem.commentItem.path;
                }
                
            }else{
                path =  [commentFreaem.commentItem.replyPath objectAtIndex:index];
            }
        }//1*1465805781759/2*1466059551646/3*1466059678654
    }
    return path;
}

// comment
-(NSString *)getCommentPath:(int *)index :(NSInteger)section {
    
    NSString *path = @"";
  
    if (section == 0) {
        if (index >= 0) {
            if (self.hotCommentList != nil) {
                CommentCellFrame *commentFreaem = [self.hotCommentList objectAtIndex:index];
                path =  commentFreaem.commentItem.path;
            }
        }else{
            CommentCellFrame *commentFream = [self.hotCommentList objectAtIndex:0];
            path = commentFream.commentItem.path;
        }
    }else{
        if (index >= 0) {
            if(self.commentList != nil){
                CommentCellFrame *commentFreaem = [self.commentList objectAtIndex:index];
                path =  commentFreaem.commentItem.path;
            }
        }else{
            CommentCellFrame *commentFreaem = [self.commentList objectAtIndex:0];
            path =  commentFreaem.commentItem.path;
        }
    }
    return path;
}
- (NSMutableArray *) getMyCommentList{
    return self.myCommentList;
}
-(void) getMyCommentList:(NSDictionary *)dic{
    if (self.myCommentList == nil) {
        self.myCommentList = [NSMutableArray arrayWithCapacity:3];
    }else{
        [self.myCommentList removeAllObjects];
    }
    [[PopoApplication get].remoteSvr getMyComment:dic];
}
- (void)setPoMyCommentList:(NSMutableArray*)data{
    
    if (data != nil) {
        for (NSDictionary* dic in data) {
            
            MyCommentItem *item = [[MyCommentItem alloc] init];
            item.u_name = [dic objectForKey:@"u_name"];
            item.u_avatar = [dic objectForKey:@"u_avatar"];
            item._at = [dic objectForKey:@"_at"];
            item.content = [dic objectForKey:@"content"];
            item.t_id = [dic objectForKey:@"t_id"];
            item.u_id = [dic objectForKey:@"u_id"];
            item.path = [dic objectForKey:@"path"];
            item.forereply_at = [[dic objectForKey:@"fore_reply"] objectForKey:@"_at"];
            item.forereply_content = [[dic objectForKey:@"fore_reply"] objectForKey:@"content"];
            item.forereply_id = [[dic objectForKey:@"fore_reply"] objectForKey:@"_id"];
            item.forereply_nid = [[dic objectForKey:@"fore_reply"] objectForKey:@"i_id"];
            item.forereply_path = [[dic objectForKey:@"fore_reply"] objectForKey:@"path"];
            item.forereply_uAvatar = [[dic objectForKey:@"fore_reply"] objectForKey:@"u_avatar"];
            item.forereply_uid = [[dic objectForKey:@"fore_reply"] objectForKey:@"u_id"];
            item.forereply_uName = [[dic objectForKey:@"fore_reply"] objectForKey:@"u_name"];

            PoPoNewsItem *data = [[PoPoNewsItem alloc] init];
            data.title = [[dic objectForKey:@"items"] objectForKey:@"title"];
            data.source = [[dic objectForKey:@"items"] objectForKey:@"source"];
            data.pDomain = [[dic objectForKey:@"items"] objectForKey:@"p_domain"];
            data.go2source = [[[dic objectForKey:@"items"] objectForKey:@"go2source"] intValue];
            data.nId = [[dic objectForKey:@"items"] objectForKey:@"_id"];
            data.preview = [[dic objectForKey:@"items"] objectForKey:@"preview"];
            item.data = data;
            MyCommentCellFrame* commentFrame = [[MyCommentCellFrame alloc] init];
            commentFrame.myCommentItem = item;
            [self.myCommentList addObject:commentFrame];
            
            [[PopoApplication get].remoteSvr getDetailNewsById:data.nId isShowDetailPage:YES];
        }
    }
    
    MMEventService *es = [MMEventService getInstance];
    [es send:[[NSString alloc] initWithFormat:@"%@_%@", EVENT_NEWS_DATA_REFRESH_PREFIX, self.user.uId]  eventData:NEWS_REFRESH_SUCCESS];
    
}
- (NSMutableArray *) getCommentList{
    
    return self.commentList;
}

- (void)setPoCommentList:(NSDictionary*)data{
    
    PoPoNewsItem* item = [self getCurrentDetailNewsItem];
    SettingService* ss = [SettingService get];
    self.comment_count = [[data objectForKey:@"count"] intValue];
    [ss setIntValue:item.nId data:self.comment_count];
    if ([data objectForKey:@"data"] != nil) {
        for (NSDictionary *dic in [data objectForKey:@"data"]) {
            CommentItem *commentItem = [[CommentItem alloc] init];
            commentItem.replys = [[NSMutableArray alloc] init];
            commentItem.replyPath = [[NSMutableArray alloc] init];
            commentItem.u_id = [dic objectForKey:@"u_id"];
            commentItem._at = [dic objectForKey:@"_at"];
            commentItem.content = [dic objectForKey:@"content"];
            commentItem.i_id = [dic objectForKey:@"i_id"];
            commentItem.avatar = [dic objectForKey:@"u_avatar"];
            commentItem.approval = [dic objectForKey:@"approval"];
            commentItem.name = [dic objectForKey:@"u_name"];
            commentItem._id = [dic objectForKey:@"_id"];
            NSMutableArray *reply = [dic objectForKey:@"reply"];
            commentItem.replyCount = 0;
            for (NSDictionary *rDic in reply) {
                ReplyItem *item = [[ReplyItem alloc] init];
                item.u_name = [rDic objectForKey:@"u_name"];
                item.t_name = [rDic objectForKey:@"t_name"];
                item.content = [rDic objectForKey:@"content"];
                item.tId = [rDic objectForKey:@"t_id"];
                item.uId = [rDic objectForKey:@"u_id"];
                
                [item setValuesForKeysWithDictionary:rDic];
                commentItem.replyItem = item;
                commentItem.replyCount += 1;
                commentItem.r_path = [rDic objectForKey:@"path"];
//                commentItem.repil_content = [rDic objectForKey:@"content"];
                [commentItem.replys addObject:commentItem.replyItem];
                [commentItem.replyPath addObject:commentItem.r_path];
            }
            if(commentItem.replys.count > 0){
                commentItem.replyCount = commentItem.replys.count;
            }
            CommentCellFrame *commentFreaem = [[CommentCellFrame alloc] init];
            commentFreaem.commentItem = commentItem;
            commentItem.isFavour = [ss getBooleanValue:commentItem._id defValue:NO];
            [commentItem  setValuesForKeysWithDictionary:dic];
            commentItem.isShow = NO;
            [self.commentList addObject:commentFreaem];
        }
    }
//    PoPoNewsItem *item = [self getCurrentDetailNewsItem];

    MMEventService *es = [MMEventService getInstance];
    [es send:[[NSString alloc] initWithFormat:@"%@_%@", EVENT_NEWS_DATA_REFRESH_PREFIX,item.nId ]  eventData:NEWS_REFRESH_SUCCESS];
}
-(void) getCommentList:(NSDictionary *)dic{
    if (self.commentList == nil) {
        self.commentList = [NSMutableArray arrayWithCapacity:3];
    }else{
        [self.commentList removeAllObjects];
    }
    [[PopoApplication get].remoteSvr getComment:dic];
}
-(void) refreshCommentList: (NSDictionary*) dic{

    [[PopoApplication get].remoteSvr getComment:dic];
    
}
- (NSMutableArray *) getDetailHotCommentList{

    return self.detailHotCommentList;
}
- (void)setPoDetailHotCommentList:(NSMutableArray*)data{
    SettingService* ss = [SettingService get];
    
    if (data != nil) {
        for (NSDictionary *dic in data) {
            CommentItem *commentItem = [[CommentItem alloc] init];
            commentItem.replys = [[NSMutableArray alloc] init];
            commentItem.u_id = [dic objectForKey:@"u_id"];
            commentItem._at = [dic objectForKey:@"_at"];
            commentItem.content = [dic objectForKey:@"content"];
            commentItem.i_id = [dic objectForKey:@"i_id"];
            commentItem.avatar = [dic objectForKey:@"u_avatar"];
            commentItem.approval = [dic objectForKey:@"approval"];
            commentItem.name = [dic objectForKey:@"u_name"];
            commentItem._id = [dic objectForKey:@"_id"];
//            NSMutableArray *reply = [dic objectForKey:@"reply"];
            commentItem.replyCount = 0;
//            for (NSDictionary *rDic in reply) {
//                commentItem.r_path = [rDic objectForKey:@"path"];
//                commentItem.repil_content = [rDic objectForKey:@"content"];
//            }
            commentItem.replys = nil;
            CommentCellFrame *commentFream = [[CommentCellFrame alloc] init];
            commentFream.commentItem = commentItem;
            commentItem.isFavour = [ss getBooleanValue:commentItem._id defValue:NO];
//            [commentItem  setValuesForKeysWithDictionary:dic];
            commentItem.isShow = NO;
            [self.detailHotCommentList addObject:commentFream];
        }
    }
}
-(void) refreshDetailHotCommentList:(NSDictionary *)dic{
    if (self.detailHotCommentList == nil) {
        self.detailHotCommentList = [NSMutableArray arrayWithCapacity:3];
    }else{
        [self.detailHotCommentList removeAllObjects];
    }
    [[PopoApplication get].remoteSvr getHotCommnet:dic];

}
- (NSMutableArray *) getHotCommentList{

    return self.hotCommentList;
}
-(void)setPoHotComentList:(NSMutableArray*)data{

    SettingService* ss = [SettingService get];

    if (data != nil) {
        for (NSDictionary *dic in data) {
            CommentItem *commentItem = [[CommentItem alloc] init];
            commentItem.replyPath = [[NSMutableArray alloc] init];
            commentItem.replys = [[NSMutableArray alloc] init];
            commentItem.u_id = [dic objectForKey:@"u_id"];
            commentItem._at = [dic objectForKey:@"_at"];
            commentItem.content = [dic objectForKey:@"content"];
            commentItem.i_id = [dic objectForKey:@"i_id"];
            commentItem.avatar = [dic objectForKey:@"u_avatar"];
            commentItem.approval = [dic objectForKey:@"approval"];
            commentItem.name = [dic objectForKey:@"u_name"];
            commentItem._id = [dic objectForKey:@"_id"];
            NSMutableArray *reply = [dic objectForKey:@"reply"];
            commentItem.replyCount = 0;
            for (NSDictionary *rDic in reply) {
                ReplyItem *item = [[ReplyItem alloc] init];
                item.u_name = [rDic objectForKey:@"u_name"];
                item.t_name = [rDic objectForKey:@"t_name"];
                item.content = [rDic objectForKey:@"content"];
                item.tId = [rDic objectForKey:@"u_id"];
                [item setValuesForKeysWithDictionary:rDic];
                commentItem.replyItem = item;
                commentItem.r_path = [rDic objectForKey:@"path"];
//                commentItem.repil_content = [rDic objectForKey:@"content"];
                [commentItem.replys addObject:commentItem.replyItem];
                [commentItem.replyPath addObject:commentItem.r_path];
            }
            if(commentItem.replys.count > 0){
                commentItem.replyCount = commentItem.replys.count;
            }
            CommentCellFrame *commentFream = [[CommentCellFrame alloc] init];
            commentFream.commentItem = commentItem;
            commentItem.isFavour = [ss getBooleanValue:commentItem._id defValue:NO];
            [commentItem  setValuesForKeysWithDictionary:dic];
            commentItem.isShow = NO;
            [self.hotCommentList addObject:commentFream];
        }
    }
}
-(void) refreshHotCommentList:(NSDictionary *)dic{
    if (self.hotCommentList == nil) {
        self.hotCommentList = [NSMutableArray arrayWithCapacity:3];
    }else{
        [self.hotCommentList removeAllObjects];
    }
    [[PopoApplication get].remoteSvr getHotCommnet:dic];
}
 
 */



- (void)getNewsNewsListWithAdList:(NSString* )cid :(int)type{
    
    BOOL isHadNetwork = [MMSystemHelper isConnectedToNetwork];
    
    if (type == NEWS_REFRESH_TYPE_BEFORE && isHadNetwork == YES) {
        if (self.poponewsList != nil && cid != nil){
            for (PopoNewsData* item in self.poponewsList) {
                if (item != nil){
                    if ([item.category.cId compare:cid] == NSOrderedSame){

                        if (item.data == nil) {
                            item.data = [NSMutableArray arrayWithCapacity:1];
                    }
                        [self getNewsAdItemAtIndex:item];
                    }
                }
            }
        }
    }
}
-(int)getRandomValue :(int)percent{
    int value = arc4random()%percent * 2 + 1;
    return value;
}
- (void)getNewsAdItemAtIndex:(PopoNewsData*)item{
    
    static NSInteger  idx = 0;
    static NSInteger fbIdx = 0;
    BOOL isEnabled = self.minikitCh.nativeAd.enabled;
    if (isEnabled == YES) {
        for (NativeAdItem *AdItem in self.itemData.nativeAdData) {
//            NSInteger fbAdCount = AdItem.adsManager.uniqueNativeAdCount;
//            if (AdItem.FbIsLoad == YES ) {
//                    fbIdx = item.data.count;
//                    id itemNews = [item.data objectAtIndex:fbIdx - 5];
//                    if ([itemNews isKindOfClass:[PoPoNewsItem class]]) {
//                        if (item.data.count > 0 && AdItem.index < fbAdCount) {
//                            FBNativeAd *fbAd = [self.fbAd objectAtIndex:AdItem.index];
//                            [item.data insertObject:fbAd atIndex:fbIdx - 5];
//                            AdItem.index += 1;
//                            
//                            ITSApplication* poApp = [ITSApplication get];
//                            //[poApp.reportSvr recordAdPurchase:fbAd.placementID type:@"facebook"];
//                        }
//                    }
//            }
            
                if (AdItem.isLoad == NO) {
                    [AdItem load];
                }else if (AdItem.isLoad == YES){
                    NSInteger count = [AdItem getCount:AdItem];
                    idx = item.data.count;
                    if (idx > 5) {
                        id itemNews = [item.data objectAtIndex:idx - 5];
                        if ([itemNews isKindOfClass:[PoPoNewsItem class]]) {
                            if (item.data.count > 0 && AdItem.index < count) {
                                GRAdItem* grAd = [self.gmobiAd objectAtIndex:AdItem.index];
                                [item.data insertObject:[self.gmobiAd objectAtIndex:AdItem.index] atIndex:idx - 5];
                                AdItem.index += 1;
                                
                                GRNativeAd* gAd = grAd.ad;
                                ITSApplication* poApp = [ITSApplication get];
                                //[poApp.reportSvr recordAdPurchase:gAd.placement type:@"gmobi"];
                            }
                       }
                  }
             }
        }
    }

}


// push news
-(BOOL) checkPushNewsId: (NSString*) nid{
    if (self.pushNewsList == nil) return NO;
    BOOL isFind = NO;
    for (PoPoNewsItem* tmpItem in self.pushNewsList) {
        if (tmpItem != nil){
            PoPoNewsItem* newsItem = tmpItem;
            if ([newsItem.nId compare:nid] == NSOrderedSame){
                isFind = YES;
                break;
            }
        }
    }
    
    return isFind;
}

-(BOOL) insert2PushNewsList: (PoPoNewsItem*) item
                   saveFlag: (BOOL) saved {
    if (item == nil)
        return NO;
    
    BOOL isFind = NO;
    
    if (self.pushNewsList == nil){
        self.pushNewsList = [NSMutableArray arrayWithCapacity:1];
    }
    
    for (PoPoNewsItem* tmpItem in self.pushNewsList) {
        if (tmpItem != nil){
            PoPoNewsItem* newsItem = tmpItem;
            if (newsItem == item || [newsItem.nId compare:item.nId] == NSOrderedSame){
                isFind = YES;
                break;
            }
        }
    }
    
    if (isFind == NO){
        [self.pushNewsList insertObject:item atIndex:0];
        
        long listCount = [self.pushNewsList count];
        if (listCount > MAX_PUSH_NEWS_COUNT){
            [self.pushNewsList removeObjectAtIndex:listCount-1];
        }
        
        if (saved == YES){
            // save to db
            NewsService* ns = [NewsService get];
            [ns saveFeedNewsItem:item.nId data:[item toDictionaryDataHasReadStatus]];
        }
        return YES;
    }
    
    return NO;
}

-(void) updatePushNewsToStorage: (PoPoNewsItem*) item{
    if (item == nil) return;
    NewsService* ns = [NewsService get];
    [ns saveFeedNewsItem:item.nId data:[item toDictionaryDataHasReadStatus]];
}

-(NSMutableArray*) getPushNewsList{
    return self.pushNewsList;
}

-(void) initPushNewsList {
    NewsService* ns = [NewsService get];
    NSMutableArray* pList = [ns getStorageFeedNewsList];
    if (pList != nil){
        if (self.pushNewsList != nil){
            [self.pushNewsList removeAllObjects];
            self.pushNewsList = nil;
        }
        self.pushNewsList = [NSMutableArray arrayWithArray:pList];
    }
}

-(void) getPushNewsDetail: (NSString*) nId
         isShowDetailPage: (BOOL) isShowDetailPage{
    //[[ITSApplication get].remoteSvr getNewsById:nId isShowDetailPage:isShowDetailPage];
}



-(void) refreshCelebComments: (int) type {
    /*
    BOOL isNetConnect = [MMSystemHelper isConnectedToNetwork];
    if (isNetConnect == NO){
        if (type == NEWS_REFRESH_TYPE_AFTER){
            // do nothing
        } else if (type == NEWS_REFRESH_TYPE_BEFORE){
            // load storage data
            NewsService* ns = [NewsService get];
            NSMutableArray* storageData = [ns getStorageNewsListByCID:cid];
            [self setRefreshCategoryNewsByStroage:cid newsList:storageData];
        }
        MMEventService *es = [MMEventService getInstance];
        [es send:[[NSString alloc] initWithFormat:@"%@_%@", EVENT_NEWS_DATA_REFRESH_PREFIX, cid]  eventData:NEWS_REFRESH_SUCCESS];
    } else */{

//        NSMutableArray* datas = [self getCategoryDataByID:cid];
//        NSString* newsTime = nil;
//        if (datas != nil && [datas count] > 0){
//            PoPoNewsItem* newsItem = nil;
//            if (type == NEWS_REFRESH_TYPE_AFTER){
//                newsItem = [datas objectAtIndex:0];
//                if (newsItem.initType == NEWS_INIT_TYPE_CLIENT)
//                    newsItem = nil;
//            } else if (type == NEWS_REFRESH_TYPE_BEFORE){
//                NSInteger dataCount = [datas count];
//                newsItem = [datas objectAtIndex:dataCount-1];
//                if (newsItem.initType == NEWS_INIT_TYPE_CLIENT){
//                    // load storage data
//                    NewsService* ns = [NewsService get];
//                    NSMutableArray* storageData = [ns getStorageNewsListByCID:cid];
//                    if (storageData != nil){
//                        [self setRefreshCategoryNewsByStroage:cid newsList:storageData];
//                        MMEventService *es = [MMEventService getInstance];
//                        [es send:[[NSString alloc] initWithFormat:@"%@_%@", EVENT_NEWS_DATA_REFRESH_PREFIX, cid]  eventData:NEWS_REFRESH_SUCCESS];
//                        return;
//                    }
//                }
//            }
//            
//            if (newsItem != nil)
//                newsTime = [[NSString alloc] initWithFormat:@"%llu", newsItem.releaseTime];
//        }

//        NewsCategory *cate = [self getCategoryByID:cid];
//        NSString* newsTime = nil;
//        if (type == NEWS_REFRESH_TYPE_AFTER) {
//            newsTime = [NSString stringWithFormat:@"%llu",cate.afterTime];
//        }else{
//            newsTime = [NSString stringWithFormat:@"%llu",cate.beforeTime];
//        }
        NSString* newsTime = nil;
        if (self.celebComments != nil){
            NSInteger count = [self.celebComments count];
            if (count > 0){
                if (type == CB_COMMENT_REFRESH_TYPE_AFTER){
                    // do nothing
                    CelebComment* topComment = [self.celebComments objectAtIndex:0];
                    if (topComment != nil)
                        newsTime = [NSString stringWithFormat:@"%llu", topComment.uts];
                } else if (type == CB_COMMENT_REFRESH_TYPE_BEFORE){
                    CelebComment* latestComment = [self.celebComments objectAtIndex:count-1];
                    if (latestComment != nil)
                        newsTime = [NSString stringWithFormat:@"%llu", latestComment.uts];
                }
            }
        }
        
        if (newsTime == nil){
            newsTime = [NSString stringWithFormat:@"%llu", [MMSystemHelper getMillisecondTimestamp]];
            [[ITSApplication get].remoteSvr getCelebCommentListData:newsTime timeType:CB_COMMENT_REFRESH_TYPE_BEFORE];
        }else{
            [[ITSApplication get].remoteSvr getCelebCommentListData:newsTime timeType:type];
        }
    }
}


-(void) setRefreshCelebComments: (NSArray*) dicData
                    isClearData: (BOOL) clear
                           type:(int)type{
    if (dicData == nil)
        return;
    ITSApplication* itsApp = [ITSApplication get];
    for (NSDictionary* commentDataItem in dicData) {
        CelebComment* tmpItem = [[CelebComment alloc] initWithDictionary:commentDataItem];
        tmpItem.name = itsApp.dataSvr.celebInfo.name;
        tmpItem.avator = itsApp.dataSvr.celebInfo.avator;
        [self insertCelebCommentItem:tmpItem];
    }
}

-(BOOL) insertCelebCommentItem: (CelebComment*) item{
    BOOL same = NO;
    BOOL ret = NO;
    int i = 0;
    
    if (self.celebComments == nil)
        self.celebComments = [NSMutableArray arrayWithCapacity:1];
    
    if (self.celebComments == nil || item == nil)
        return ret;
    
    int listCount = (int)[self.celebComments count];
    for (i = 0; i < listCount; i++) {
        // PoPoNewsItem* newItem = [list objectAtIndex:i];
        id cbComment = [self.celebComments objectAtIndex:i];
        if ([cbComment isKindOfClass:[CelebComment class]]) {
            CelebComment* comment = cbComment;
            if (comment != nil){
                if ([comment.fid compare:item.fid] == NSOrderedSame) {
                    same = YES;
                    
                    //if (item.isOfflineDL == YES && newItem.isOfflineDL == NO){
                    //    newItem.isOfflineDL = YES;
                    //}
                    
                    break;
                }
                
                if (comment.pts < item.pts) {
                    [self.celebComments insertObject:item atIndex:i];
                    ret = YES;
                    break;
                }
            }
        }
    }
    
    if (same == NO && ret == NO){
        [self.celebComments addObject:item];
        ret = YES;
    }
    
    return ret;
}

-(CelebComment*) findCelebCommentById: (NSString*) fid{
    
    if (fid == nil || self.celebComments == nil)
        return nil;
    
    int listCount = (int)[self.celebComments count];
    for (int i = 0; i < listCount; i++) {
        id cbComment = [self.celebComments objectAtIndex:i];
        if ([cbComment isKindOfClass:[CelebComment class]]) {
            CelebComment* comment = cbComment;
            if (comment != nil){
                if ([comment.fid compare:fid] == NSOrderedSame) {
                    return comment;
                }
            }
        }
    }
    
    return nil;
}

-(void) removeCelebCommentItem: (NSString*) fid{
    
    int i = 0;
    if (self.celebComments == nil || fid == nil)
        return;
    
    int listCount = (int)[self.celebComments count];
    for (i = 0; i < listCount; i++) {
        id cbComment = [self.celebComments objectAtIndex:i];
        if ([cbComment isKindOfClass:[CelebComment class]]) {
            CelebComment* comment = cbComment;
            if (comment != nil){
                if ([comment.fid compare:fid] == NSOrderedSame) {
                    [self.celebComments removeObject:comment];
                    break;
                }
            }
        }
    }
}

-(void) updateCelebCommentItem: (NSString*) fid
                       context: (NSString*) context
                   attachments: (NSMutableArray*) attachments{
    int i = 0;
    if (self.celebComments == nil || fid == nil || context == nil || attachments == nil)
        return;
    
    int listCount = (int)[self.celebComments count];
    for (i = 0; i < listCount; i++) {
        id cbComment = [self.celebComments objectAtIndex:i];
        if ([cbComment isKindOfClass:[CelebComment class]]) {
            CelebComment* comment = cbComment;
            if (comment != nil){
                if ([comment.fid compare:fid] == NSOrderedSame) {
                    
                    comment.context = context;
                    
                    NSMutableArray* cbAttr = [NSMutableArray arrayWithCapacity:1];
                    for (int i = 0; i < [attachments count]; i++) {
                        NSDictionary* tData = [attachments objectAtIndex:i];
                        CelebAttachment* attrObj = [[CelebAttachment alloc] initWithDictionary:tData];
                        [cbAttr addObject:attrObj];
                    }
                    comment.attachments = cbAttr;
                    //comment.uts = [MMSystemHelper getMillisecondTimestamp];
                    
                    break;
                }
            }
        }
    }
}
-(void) refreshCelebRecommends: (int) type {
    NSString* newsTime = nil;
    if (self.celebComments != nil){
        NSInteger count = [self.celebComments count];
        if (count > 0){
            if (type == CB_RECOMMEND_REFRESH_TYPE_AFTER){
                // do nothing
                CelebRecommend* topComment = [self.celebComments objectAtIndex:0];
                if (topComment != nil)
                    newsTime = [NSString stringWithFormat:@"%llu", topComment.uts];
            } else if (type == CB_RECOMMEND_REFRESH_TYPE_BEFORE){
                CelebRecommend* latestComment = [self.celebComments objectAtIndex:count-1];
                if (latestComment != nil)
                    newsTime = [NSString stringWithFormat:@"%llu", latestComment.uts];
            }
        }
    }
    
    if (newsTime == nil){
        newsTime = [NSString stringWithFormat:@"%llu", [MMSystemHelper getMillisecondTimestamp]];
        
        [[ITSApplication get].remoteSvr getCelebRecommendListData:newsTime timeType:CB_RECOMMEND_REFRESH_TYPE_BEFORE];
    }else{
        
        [[ITSApplication get].remoteSvr getCelebRecommendListData:newsTime timeType:type];
    }

}
-(void) setRefreshCelebRecommends: (NSArray*) dicData
                     isClearData: (BOOL) clear
                            type: (int) type {
    if (dicData == nil)
        return;
    
    for (NSDictionary* commentDataItem in dicData) {
        CelebRecommend* tmpItem = [[CelebRecommend alloc] initWithDictionary:commentDataItem];
        [self insertCelebRecommendsItem:tmpItem];
    }
}
-(BOOL) insertCelebRecommendsItem: (CelebRecommend*) item{
    BOOL same = NO;
    BOOL ret = NO;
    int i = 0;
    
    if (self.celebRecommends == nil)
        self.celebRecommends = [NSMutableArray arrayWithCapacity:1];
    
    if (self.celebRecommends == nil || item == nil)
        return ret;
    
    int listCount = (int)[self.celebRecommends count];
    for (i = 0; i < listCount; i++) {
        // PoPoNewsItem* newItem = [list objectAtIndex:i];
        id cbComment = [self.celebRecommends objectAtIndex:i];
        if ([cbComment isKindOfClass:[CelebRecommend class]]) {
            CelebRecommend* comment = cbComment;
            if (comment != nil){
                if ([comment.cid compare:item.cid] == NSOrderedSame) {
                    same = YES;
                    
                    //if (item.isOfflineDL == YES && newItem.isOfflineDL == NO){
                    //    newItem.isOfflineDL = YES;
                    //}
                    break;
                }
                
                if (comment.uts < item.uts) {
                    [self.celebRecommends insertObject:item atIndex:i];
                    ret = YES;
                    break;
                }
            }
        }
    }
    
    if (same == NO && ret == NO){
        [self.celebRecommends addObject:item];
        ret = YES;
    }
    
    return ret;
}

-(void) refreshUserTrackComments: (int) type{
    
    NSString* newsTime = nil;
    if (self.userTrackComments != nil){
        NSInteger count = [self.userTrackComments count];
        if (count > 0){
            if (type == TRACK_COMMENT_REFRESH_TYPE_AFTER){
                // do nothing
                UserTrackComment* topComment = [self.userTrackComments objectAtIndex:0];
                if (topComment != nil)
                    newsTime = [NSString stringWithFormat:@"%llu", topComment.uts];
            } else if (type == TRACK_COMMENT_REFRESH_TYPE_BEFORE){
                UserTrackComment* latestComment = [self.userTrackComments objectAtIndex:count-1];
                if (latestComment != nil)
                    newsTime = [NSString stringWithFormat:@"%llu", latestComment.uts];
            }
        }
    }
    
    if (newsTime == nil){
        newsTime = [NSString stringWithFormat:@"%llu", [MMSystemHelper getMillisecondTimestamp]];
        [[ITSApplication get].remoteSvr getUserCommentListData:newsTime timeType:TRACK_COMMENT_REFRESH_TYPE_BEFORE];
    }else{
        [[ITSApplication get].remoteSvr getUserCommentListData:newsTime timeType:type];
    }
    
    
    //NSString* newsTime = [NSString stringWithFormat:@"%llu", [MMSystemHelper getMillisecondTimestamp]];
    //[[ITSApplication get].remoteSvr getUserCommentListData:newsTime timeType:type];
}

-(void) setRefreshUserTrackComments: (NSArray*) dicData
                   isClearData: (BOOL) clear
                          type: (int) type{
    
    if (dicData == nil)
        return;
    
    for (NSDictionary* commentDataItem in dicData) {
        UserTrackComment* tmpItem = [[UserTrackComment alloc] initWithDictionary:commentDataItem];
        [self insertUserTrackCommentItem:tmpItem];
    }
}

-(BOOL) insertUserTrackCommentItem: (UserTrackComment*) item{
    BOOL same = NO;
    BOOL ret = NO;
    int i = 0;
    
    if (self.userTrackComments == nil)
        self.userTrackComments = [NSMutableArray arrayWithCapacity:1];
    
    if (self.userTrackComments == nil || item == nil)
        return ret;
    
    int listCount = (int)[self.userTrackComments count];
    for (i = 0; i < listCount; i++) {
        
        id uComment = [self.userTrackComments objectAtIndex:i];
        if ([uComment isKindOfClass:[UserTrackComment class]]) {
            UserTrackComment* comment = uComment;
            if (comment != nil){
                if ([comment.cid compare:item.cid] == NSOrderedSame) {
                    same = YES;
                    
                    //if (item.isOfflineDL == YES && newItem.isOfflineDL == NO){
                    //    newItem.isOfflineDL = YES;
                    //}
                    
                    break;
                }
                
                if (comment.pts < item.pts) {
                    [self.userTrackComments insertObject:item atIndex:i];
                    ret = YES;
                    break;
                }
            }
        }
    }
    
    if (same == NO && ret == NO){
        [self.userTrackComments addObject:item];
        ret = YES;
    }
    
    return ret;
}

-(void) refreshReplyComments: (int) type
                         fid: (NSString*) fid{
    
    if (fid == nil){
        MMEventService *es = [MMEventService getInstance];
        [es send:EVENT_CELEB_REPLY_COMMENT_DATA_REFRESH eventData:CB_COMMENT_REPLY_REFRESH_ERROR];
        return;
    }
    
    NSString* newsTime = nil;
    if (self.celebComments != nil){
        NSInteger count = [self.celebComments count];
        CelebComment* cbComment = nil;
        for (int i = 0; i < count; i++) {
            CelebComment* tmp = [self.celebComments objectAtIndex:i];
            if (tmp != nil && [tmp.fid isEqualToString:fid]){
                cbComment = tmp;
                break;
            }
        }
        
        if (cbComment == nil){
            MMEventService *es = [MMEventService getInstance];
            [es send:EVENT_CELEB_REPLY_COMMENT_DATA_REFRESH eventData:CB_COMMENT_REPLY_REFRESH_ERROR];
            return;
        }
        
        NSArray* replyList = cbComment.replayComments;
        if (replyList != nil){
            NSInteger count = [replyList count];
            if (count > 0){
                if (type == CB_COMMENT_REPLY_REFRESH_TYPE_AFTER){
                    // do nothing
                    FansComment* topComment = [replyList objectAtIndex:0];
                    if (topComment != nil)
                        newsTime = [NSString stringWithFormat:@"%llu", topComment.uts];
                } else if (type == CB_COMMENT_REPLY_REFRESH_TYPE_BEFORE){
                    FansComment* latestComment = [replyList objectAtIndex:count-1];
                    if (latestComment != nil)
                        newsTime = [NSString stringWithFormat:@"%llu", latestComment.uts];
                }
            }
        }
    }
    if (newsTime == nil){
        newsTime = [NSString stringWithFormat:@"%llu", [MMSystemHelper getMillisecondTimestamp]];
        [[ITSApplication get].remoteSvr getCelebReplyCommentListData:newsTime timeType:CB_COMMENT_REPLY_REFRESH_TYPE_BEFORE fid:fid];
    } else
        [[ITSApplication get].remoteSvr getCelebReplyCommentListData:newsTime timeType:type fid:fid];
}

-(void) setRefreshReplyComments: (NSArray*) dicData
                            fid: (NSString*) fid
                    isClearData: (BOOL) clear
                           type: (int) type{
    if (dicData == nil || fid == nil)
        return;
    
    for (NSDictionary* commentDataItem in dicData) {
        FansComment* tmpItem = [[FansComment alloc] initWithDictionary:commentDataItem];
        [self insertCurrentReplyCommentItem:tmpItem];
    }
}

-(BOOL) insertCurrentReplyCommentItem: (FansComment*) item{
    BOOL same = NO;
    BOOL ret = NO;
    int i = 0;
    
    if (item == nil)
        return ret;
    
    NSInteger count = [self.celebComments count];
    CelebComment* cbComment = nil;
    for (int i = 0; i < count; i++) {
        CelebComment* tmp = [self.celebComments objectAtIndex:i];
        if (tmp != nil && [tmp.fid isEqualToString:item.fid]){
            cbComment = tmp;
            break;
        }
    }
    if (cbComment == nil){
        if (self.currentCelebComment != nil && [self.currentCelebComment.fid isEqualToString:item.fid]){
            cbComment = self.currentCelebComment;
        } else {
            return ret;
        }
    }
    
//    if (item.rid != nil){
//        
//        if (cbComment.replayComments == nil){
//            return ret;
//        }
//        
//        NSInteger replyCount = [cbComment.replayComments count];
//        FansComment* fsComment = nil;
//        for (int j = 0; j < replyCount; j++) {
//            FansComment* tmp = [cbComment.replayComments objectAtIndex:j];
//            if (tmp != nil && [tmp.cid isEqualToString:item.rid]){
//                fsComment = tmp;
//                break;
//            }
//        }
//        
//        if (fsComment.replayComments == nil)
//            fsComment.replayComments = [NSMutableArray arrayWithCapacity:1];
//        
//        NSMutableArray* replayList = (NSMutableArray*)fsComment.replayComments;
//        
//        int listCount = (int)[replayList count];
//        for (i = 0; i < listCount; i++) {
//            
//            id uComment = [replayList objectAtIndex:i];
//            if ([uComment isKindOfClass:[FansComment class]]) {
//                FansComment* comment = uComment;
//                if (comment != nil){
//                    if ([comment.cid compare:item.cid] == NSOrderedSame) {
//                        same = YES;
//                        
//                        //if (item.isOfflineDL == YES && newItem.isOfflineDL == NO){
//                        //    newItem.isOfflineDL = YES;
//                        //}
//                        
//                        break;
//                    }
//                    
//                    if (comment.pts < item.pts) {
//                        [replayList insertObject:item atIndex:i];
//                        ret = YES;
//                        break;
//                    }
//                }
//            }
//        }
//        
//        if (same == NO && ret == NO){
//            [replayList addObject:item];
//            ret = YES;
//        }
//        
//        if (fsComment.uiFrame != nil){
//            fsComment.uiFrame.replysF = nil;
//            fsComment.uiFrame.replyNameF = nil;
//            fsComment.uiFrame.replyPictureF = nil;
//            [fsComment.uiFrame refreshFrame:fsComment];
//        }
//        
//    } else {
        if (cbComment.replayComments == nil)
            cbComment.replayComments = [NSMutableArray arrayWithCapacity:1];
        
        NSMutableArray* replayList = (NSMutableArray*)cbComment.replayComments;
        
        int listCount = (int)[replayList count];
        for (i = 0; i < listCount; i++) {
            
            id uComment = [replayList objectAtIndex:i];
            if ([uComment isKindOfClass:[FansComment class]]) {
                FansComment* comment = uComment;
                if (comment != nil){
                    if ([comment.cid compare:item.cid] == NSOrderedSame) {
                        same = YES;
                        
                        //if (item.isOfflineDL == YES && newItem.isOfflineDL == NO){
                        //    newItem.isOfflineDL = YES;
                        //}
                        
                        break;
                    }
                    
                    if (comment.pts < item.pts) {
                        [replayList insertObject:item atIndex:i];
                        ret = YES;
                        break;
                    }
                }
            }
        }
        
        if (same == NO && ret == NO){
            [replayList addObject:item];
            ret = YES;
        }
    //}
    
    return ret;
}


-(BOOL) userInsertCurrentReplyCommentItem: (FansComment*) item{
    BOOL same = NO;
    BOOL ret = NO;
    int i = 0;
    
    if (item == nil)
        return ret;
    
    NSInteger count = [self.celebComments count];
    CelebComment* cbComment = nil;
    for (int i = 0; i < count; i++) {
        CelebComment* tmp = [self.celebComments objectAtIndex:i];
        if (tmp != nil && [tmp.fid isEqualToString:item.fid]){
            cbComment = tmp;
            break;
        }
    }
    if (cbComment == nil)
        return ret;
    if (item.rid != nil){
        
        if (cbComment.replayComments == nil){
            return ret;
        }
        
        NSInteger replyCount = [cbComment.replayComments count];
        FansComment* fsComment = nil;
        for (int j = 0; j < replyCount; j++) {
            FansComment* tmp = [cbComment.replayComments objectAtIndex:j];
            if (tmp != nil && [tmp.cid isEqualToString:item.rid]){
                fsComment = tmp;
                break;
            }
        }
        
        if (fsComment.replayComments == nil)
            fsComment.replayComments = [NSMutableArray arrayWithCapacity:1];
        
        NSMutableArray* replayList = (NSMutableArray*)fsComment.replayComments;
        
        int listCount = (int)[replayList count];
        for (i = 0; i < listCount; i++) {
            
            id uComment = [replayList objectAtIndex:i];
            if ([uComment isKindOfClass:[FansComment class]]) {
                FansComment* comment = uComment;
                if (comment != nil){
                    if ([comment.cid compare:item.cid] == NSOrderedSame) {
                        same = YES;
                        
                        //if (item.isOfflineDL == YES && newItem.isOfflineDL == NO){
                        //    newItem.isOfflineDL = YES;
                        //}
                        
                        break;
                    }
                    
                    if (comment.pts < item.pts) {
                        [replayList insertObject:item atIndex:i];
                        ret = YES;
                        break;
                    }
                }
            }
        }
        
        if (same == NO && ret == NO){
            [replayList addObject:item];
            ret = YES;
        }
        
        if (fsComment.uiFrame != nil){
            fsComment.uiFrame.replysF = nil;
            fsComment.uiFrame.replyNameF = nil;
            fsComment.uiFrame.replyPictureF = nil;
            [fsComment.uiFrame refreshFrame:fsComment];
        }
        
    } else {
        if (cbComment.replayComments == nil)
            cbComment.replayComments = [NSMutableArray arrayWithCapacity:1];
        
        NSMutableArray* replayList = (NSMutableArray*)cbComment.replayComments;
        
        int listCount = (int)[replayList count];
        for (i = 0; i < listCount; i++) {
            
            id uComment = [replayList objectAtIndex:i];
            if ([uComment isKindOfClass:[FansComment class]]) {
                FansComment* comment = uComment;
                if (comment != nil){
                    if ([comment.cid compare:item.cid] == NSOrderedSame) {
                        same = YES;
                        
                        //if (item.isOfflineDL == YES && newItem.isOfflineDL == NO){
                        //    newItem.isOfflineDL = YES;
                        //}
                        
                        break;
                    }
                    
                    if (comment.pts < item.pts) {
                        [replayList insertObject:item atIndex:i];
                        ret = YES;
                        break;
                    }
                }
            }
        }
        
        if (same == NO && ret == NO){
            [replayList addObject:item];
            ret = YES;
        }
    }
    
    return ret;
}

@end

