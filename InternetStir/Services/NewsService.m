//
//  NewsService.m
//  PoPoNews
//
//  Created by apple on 15/6/12.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMJsonDatabase.h"
#import "NewsService.h"
#import "MMSystemHelper.h"
#import "MMLogger.h"
#import "ITSApplication.h"
#import "ITSAppConst.h"

#define NEWS_COL_NAME  @"poponews_news"
#define FAVOUR_COL_NAME  @"favour_news"
#define CONFIG_COL_NAME  @"config_news"
#define FB_NEWS_COL_NAME  @"fb_news"
#define GP_NEWS_COL_NAME  @"gp_news"
#define TW_NEWS_COL_NAME @"tw_news"
#define FEED_NEWS_COL_NAME @"feed_news"
#define UNLIKE_NEWS_COL_NAME @"unlike_news"
#define DEFAULT_DATA_STR @"datastring"

#define READED_NEWS_LIST_KEY @"readedNewsKey"

#define MAX_NEWS_STROAGE_COUNT 2000
#define MAX_FB_NEWS_STROAGE_COUNT 500
#define MAX_GP_NEWS_STROAGE_COUNT 300
#define MAX_BD_NEWS_STROAGE_COUNT 300

#define MAX_TW_NEWS_STROAGE_COUNT 500
#define MAX_WE_NEWS_STROAGE_COUNT 500
#define MAX_FEED_NEWS_STROAGE_COUNT 100

#define MAX_UNLIKE_NEWS_STROAGE_COUNT 500

NewsService* newsInstance = nil;

@implementation StorageNewsItem

@end

@implementation NewsService


+(NewsService*) get{
    @synchronized(self){
        if (newsInstance == nil){
            newsInstance = [NewsService alloc];
            [newsInstance initDB];
        }
    }
    
    return newsInstance;
}

-(void) initDB {
    MMJsonDatabase* jdb = [MMJsonDatabase get];
    _newsCol = [jdb getCollection:NEWS_COL_NAME];
    _favourCol = [jdb getCollection:FAVOUR_COL_NAME];
    _configCol = [jdb getCollection:CONFIG_COL_NAME];
    _fbnewsCol = [jdb getCollection:FB_NEWS_COL_NAME];
    _gpnewsCol = [jdb getCollection:GP_NEWS_COL_NAME];
    _twnewsCol = [jdb getCollection:TW_NEWS_COL_NAME];
    _feednewsCol = [jdb getCollection:FEED_NEWS_COL_NAME];
    _unLikeNewsCol = [jdb getCollection:UNLIKE_NEWS_COL_NAME];
}

-(void) initLoadSavedData{
    id data = [_configCol get:READED_NEWS_LIST_KEY];
    if (data != nil && [data isKindOfClass:[NSArray class]]){
        NSArray* dataArray = (NSArray*)data;
        NSInteger dataCount = [dataArray count];
        for (NSInteger i = dataCount-1; i >= 0; i--) {
            NSDictionary* tmpDic = [data objectAtIndex:i];
            NSString* nid = [tmpDic objectForKey:@"nid"];
            NSString* cid = [tmpDic objectForKey:@"cid"];
            
            id savedata = [_newsCol get:nid];
            
            if (savedata != nil){
                ITSApplication* app = [ITSApplication get];
                [app.dataSvr insert2ReadNewsList:nid categoryId:cid];
            }
        }
    }
    
    int dataCount = [_favourCol size];
    NSMutableArray* dataList = [_favourCol getDataListByStartCount:0 listCount:dataCount];
    
    if (dataList != nil){
        long totalCount = [dataList count];
        for (int i = 0; i < totalCount; i++) {
            //NSDictionary* tmpDic = [dataList objectAtIndex:i];
            //NSString* newsStr = [tmpDic objectForKey:@"jo"];
            //NSError *error;
            //NSData *dataStr = [newsStr dataUsingEncoding:NSUTF8StringEncoding];
            //NSDictionary* newsDic = [NSJSONSerialization JSONObjectWithData:dataStr options:NSJSONReadingAllowFragments error:&error];
            
            Document* tmpDoc = [dataList objectAtIndex:i];
            NSDictionary* newsDic = [tmpDoc getData];
            
            PoPoNewsItem* news = [[PoPoNewsItem alloc] initWithDictionary:newsDic];
            
            if (news != nil){
                ITSApplication* app = [ITSApplication get];
                [app.dataSvr insert2FavourList:news saveFlag:NO isPushNews:NO];
            }
        }
    }
    
    if (newsInstance != nil){
        [newsInstance checkUnLikeMaxNews];
        [newsInstance initLoadStorageUnLikeNews];

        
        [newsInstance checkMaxNews];
        // init storage news
        [newsInstance initLoadStorageNews];
        
        [newsInstance checkFeedMaxNews];
        [newsInstance initLoadStorageFeedNews];
        
    }
}
-(void) checkUnLikeMaxNews{
    
    if (_unLikeNewsCol){
        int count = [_unLikeNewsCol size];
        int needRemoveCount = count - MAX_UNLIKE_NEWS_STROAGE_COUNT;
        if (needRemoveCount > 0){
            NSMutableArray* removeData = [_unLikeNewsCol getDataListByStartCount:0 listCount:needRemoveCount];
            
            if (removeData != nil){
                long totalCount = [removeData count];
                for (int i = 0; i < totalCount; i++) {
                    
                    Document* tmpDoc = [removeData objectAtIndex:i];
                    NSDictionary* newsDic = [tmpDoc getData];
                    
                    PoPoNewsItem* news = [[PoPoNewsItem alloc] initWithDictionary:newsDic];
                    
                    if (news != nil){
                        [_unLikeNewsCol set:news.nId setData:nil];
                    }
                }
            }
        }
    }
}
-(void)initLoadStorageUnLikeNews{
    if (_unLikeNewsCol){
        
        NSMutableArray* sList = [_unLikeNewsCol list];
        if (sList != nil){
            for (int i = 0; i < [sList count]; i++) {
                Document* tmpDoc = [sList objectAtIndex:i];
                NSDictionary* newsDic = [tmpDoc getData];
                PoPoNewsItem* news = [[PoPoNewsItem alloc] initWithDictionary:newsDic];
                
                [self insert2StorageUnLikeNewsList:news];
            }
        }
    }
}
-(void) insert2StorageUnLikeNewsList: (PoPoNewsItem*) item{
    if (item == nil || newsInstance == nil)
        return;
    
    if (newsInstance.unLikeNewsList == nil)
        newsInstance.unLikeNewsList = [NSMutableArray arrayWithCapacity:1];
    
    BOOL isAdded = NO;
    for (int i = 0; i < [newsInstance.unLikeNewsList count]; i++) {
        PoPoNewsItem* tmp = [newsInstance.unLikeNewsList objectAtIndex:i];
        if (tmp != nil){
            if ([tmp.nId compare:item.nId] == NSOrderedSame){
                isAdded = YES;
                break;
            }
        }
    }
    
    if (isAdded == NO){
        if ([newsInstance.unLikeNewsList count] >= 1)
            [newsInstance.unLikeNewsList insertObject:item atIndex:0];
        else
            [newsInstance.unLikeNewsList addObject:item];
    }
}

-(void) checkMaxNews {
    if (_newsCol){
        int count = [_newsCol size];
        int needRemoveCount = count - MAX_NEWS_STROAGE_COUNT;
        if (needRemoveCount > 0){
            NSMutableArray* removeData = [_newsCol getDataListByStartCount:0 listCount:needRemoveCount];
            
            if (removeData != nil){
                long totalCount = [removeData count];
                for (int i = 0; i < totalCount; i++) {
                    
                    Document* tmpDoc = [removeData objectAtIndex:i];
                    NSDictionary* newsDic = [tmpDoc getData];
                    
                    PoPoNewsItem* news = [[PoPoNewsItem alloc] initWithDictionary:newsDic];
                    
                    if (news != nil){
                        [_newsCol set:news.nId setData:nil];
                    }
                }
            }
        }
    }
}








-(void) checkFeedMaxNews {
    if (_feednewsCol){
        int count = [_feednewsCol size];
        int needRemoveCount = count - MAX_FEED_NEWS_STROAGE_COUNT;
        if (needRemoveCount > 0){
            NSMutableArray* removeData = [_feednewsCol getDataListByStartCount:0 listCount:needRemoveCount];
            
            if (removeData != nil){
                long totalCount = [removeData count];
                for (int i = 0; i < totalCount; i++) {
                    
                    Document* tmpDoc = [removeData objectAtIndex:i];
                    NSDictionary* newsDic = [tmpDoc getData];
                    
                    PoPoNewsItem* news = [[PoPoNewsItem alloc] initWithDictionary:newsDic];
                    
                    if (news != nil){
                        [_feednewsCol set:news.nId setData:nil];
                    }
                }
            }
        }
    }
}


-(NSMutableArray*) getStorageUnLikeNewsList{
    
    if (newsInstance == nil)
        return nil;
    
    return newsInstance.unLikeNewsList;
    
}



-(void) savePopoNewsItem: (NSString*) nid
                    data: (NSDictionary*) dicData {
    if (nid != nil){
        
        [_newsCol set:nid setData:dicData];
    }
}


-(void) saveFeedNewsItem: (NSString*) nid
                    data: (NSDictionary*) dicData {
    if (nid != nil){
        [_feednewsCol set:nid setData:dicData];
    }
}
-(void) saveUnLikeNewsItem: (NSString*) nid
                    data: (NSDictionary*) dicData {
    if (nid != nil){
        [_unLikeNewsCol set:nid setData:dicData];
    }
}
-(NSMutableArray*) getStorageFeedNewsList{
    if (newsInstance == nil)
        return nil;
    
    return newsInstance.feedNewsList;
}


-(id) getPopoNewsItem: (NSString*) nid{
    if (nid != nil && _newsCol != nil)
        return [_newsCol get:nid];
    
    return nil;
}
-(void) saveMyCommentNews: (NSString*) nid
                  data: (NSDictionary*) dicData{
    if (nid != nil){
        [_favourCol set:nid setData:dicData];
    }
}

-(void) saveFavourNews: (NSString*) nid
                  data: (NSDictionary*) dicData{
    if (nid != nil){
        [_favourCol set:nid setData:dicData];
    }
}

-(PoPoNewsItem*) getStorageNews: (NSString*) nid{
    PoPoNewsItem* news = nil;
    if (nid != nil && _newsCol != nil){
        NSDictionary* dic = [_newsCol get:nid];
        if (dic != nil){
            news = [[PoPoNewsItem alloc] initWithDictionary:dic];
            [news setNewsInitType:NEWS_INIT_TYPE_CLIENT];
        }
    }
    return news;
}


-(void) saveReadNewsList: (NSMutableArray*) list {
    if (list != nil){
//        NSMutableArray* saveList = [NSMutableArray arrayWithCapacity:2];
//        for (ReadedNewsItem* item in list) {
//            if (item != nil){
//                NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithCapacity:2];
//                [dic setObject:item.cId forKey:@"cid"];
//                [dic setObject:item.nId forKey:@"nid"];
//                [saveList addObject:dic];
//            }
//        }
//        
//        [_configCol set:READED_NEWS_LIST_KEY setData:saveList];
    }
}

-(void) initLoadStorageNews{
    if (_newsCol){
        
        NSMutableArray *unlike = [self getStorageUnLikeNewsList];
        NSMutableArray* sList = [_newsCol list];
        if (sList != nil){
            for (int i = 0; i < [sList count]; i++) {
                Document* tmpDoc = [sList objectAtIndex:i];
                NSDictionary* newsDic = [tmpDoc getData];
                PoPoNewsItem* news = [[PoPoNewsItem alloc] initWithDictionary:newsDic];
                {
                    BOOL isUnlike = NO;
                    for (PoPoNewsItem *item in unlike) {
                        if ([item.nId compare:news.nId] == NSOrderedSame) {
                            isUnlike = YES;
                            break;
                        }
                    }
                    if (isUnlike == YES) {
                        continue;
                    }
                }
                
                [news setNewsInitType:NEWS_INIT_TYPE_CLIENT];
                
                [self insert2StorageNewsList:news];
            }
        }
    }
}

-(void) insert2StorageNewsList: (PoPoNewsItem*) item{
    if (item == nil || newsInstance == nil)
        return;
    
    if (newsInstance.storageList == nil)
        newsInstance.storageList = [NSMutableArray arrayWithCapacity:1];

    StorageNewsItem* storageCate = nil;
    
    for (int i = 0; i < [newsInstance.storageList count]; i++) {
        StorageNewsItem* tmp = [newsInstance.storageList objectAtIndex:i];
        if (tmp != nil){
            if ([tmp.cId compare:item.cId] == NSOrderedSame){
                storageCate =  tmp;
                break;
            }
        }
    }
    
    if (storageCate == nil) {
        StorageNewsItem* nItem = [StorageNewsItem alloc];
        nItem.cId = item.cId;
        nItem.getIndex = 0;
        
        storageCate = nItem;
        [newsInstance.storageList addObject:storageCate];
    }
    
    if (storageCate.newsData == nil)
        storageCate.newsData = [NSMutableArray arrayWithCapacity:1];
    
    BOOL isInsert = NO;
    for (int j = 0; j < [storageCate.newsData count]; j++) {
        PoPoNewsItem* newItem = [storageCate.newsData objectAtIndex:j];
        if (newItem != nil){
            if (item.releaseTime > newItem.releaseTime){
                [storageCate.newsData insertObject:item atIndex:j];
                isInsert = YES;
                break;
            }
        }
    }
    
    if (isInsert == NO)
        [storageCate.newsData addObject:item];
}

-(NSMutableArray*) getStorageNewsListByCID: (NSString*) cId{
    NSMutableArray* retData = nil;
    
    if (newsInstance != nil && cId != nil && newsInstance.storageList != nil){
        StorageNewsItem* storageCate = nil;
        
        for (int i = 0; i < [newsInstance.storageList count]; i++) {
            StorageNewsItem* tmp = [newsInstance.storageList objectAtIndex:i];
            if (tmp != nil){
                if ([tmp.cId compare:cId] == NSOrderedSame){
                    storageCate =  tmp;
                    break;
                }
            }
        }
        
        if (storageCate != nil) {
            if (storageCate.newsData != nil){
                long newsCount = [storageCate.newsData count];
                long getDataCount = newsCount - storageCate.getIndex;
                
                if (getDataCount > 0){
                    if (getDataCount > FETCH_COUNT)
                        getDataCount = FETCH_COUNT;
                    
                    if (retData == nil)
                        retData = [NSMutableArray arrayWithCapacity:1];
                    
                    for (int i = storageCate.getIndex; i < storageCate.getIndex + getDataCount; i++) {
                        PoPoNewsItem* tmpNews = [storageCate.newsData objectAtIndex:i];
                        [retData addObject:tmpNews];
                    }
                    storageCate.getIndex += (int)getDataCount;
                }
            }
        }
    }
    
    return retData;
}

-(void) initLoadStorageFeedNews{
    if (_feednewsCol){
        
        NSMutableArray* sList = [_feednewsCol list];
        if (sList != nil){
            for (int i = 0; i < [sList count]; i++) {
                Document* tmpDoc = [sList objectAtIndex:i];
                NSDictionary* newsDic = [tmpDoc getData];
                PoPoNewsItem* news = [[PoPoNewsItem alloc] initWithDictionary:newsDic];
                
                [self insert2StorageFeedNewsList:news];
            }
        }
    }
}

-(void) insert2StorageFeedNewsList: (PoPoNewsItem*) item{
    if (item == nil || newsInstance == nil)
        return;
    
    if (newsInstance.feedNewsList == nil)
        newsInstance.feedNewsList = [NSMutableArray arrayWithCapacity:1];
    
    BOOL isAdded = NO;
    for (int i = 0; i < [newsInstance.feedNewsList count]; i++) {
        PoPoNewsItem* tmp = [newsInstance.feedNewsList objectAtIndex:i];
        if (tmp != nil){
            if ([tmp.nId compare:item.nId] == NSOrderedSame){
                isAdded = YES;
                break;
            }
        }
    }
    
    if (isAdded == NO){
        if ([newsInstance.feedNewsList count] >= 1)
            [newsInstance.feedNewsList insertObject:item atIndex:0];
        else
            [newsInstance.feedNewsList addObject:item];
    }
}




@end