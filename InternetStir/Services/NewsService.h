//
//  NewsService.h
//  PoPoNews
//
//  Created by apple on 15/6/12.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#ifndef PoPoNews_NewsService_h
#define PoPoNews_NewsService_h

#import <Foundation/Foundation.h>
#import "MMJsonDatabase.h"
#import "PoPoNewsItem.h"



@interface StorageNewsItem : NSObject

@property (copy) NSString* cId;
@property (retain) NSMutableArray* newsData;
@property (assign) int getIndex;

@end


@interface NewsService: NSObject

@property Collection* newsCol;
@property Collection* favourCol;
@property Collection* configCol;
@property Collection* fbnewsCol;
@property Collection* gpnewsCol;
@property Collection* twnewsCol;
@property Collection* wenewsCol;
@property Collection* baiduCol;
@property Collection* feednewsCol;
@property Collection* unLikeNewsCol;
@property (retain) NSMutableArray* readList;
@property (retain) NSMutableArray* favourList;
@property (retain) NSMutableArray* storageList;
@property (retain) NSMutableArray* fbStorageList;
@property (retain) NSMutableArray* gpStorageList;
@property (retain) NSMutableArray* twStorageList;
@property (retain) NSMutableArray* weStorageList;
@property (retain) NSMutableArray* bdStorageList;
@property (retain) NSMutableArray* feedNewsList;
@property (retain) NSMutableArray* unLikeNewsList;


+(NewsService*) get;

-(void) initLoadSavedData;

-(void) savePopoNewsItem: (NSString*) nid
                    data: (NSDictionary*) dicData;
-(id) getPopoNewsItem: (NSString*) nid;

-(void) saveReadNewsList: (NSMutableArray*) list;

-(void) saveFavourNews: (NSString*) nid
                  data: (NSDictionary*) dicData;

-(PoPoNewsItem*) getStorageNews: (NSString*) nid;

-(NSMutableArray*) getStorageNewsListByCID: (NSString*) cId;

-(void) saveFacebookNewsItem: (NSString*) nid
                        data: (NSDictionary*) dicData;

-(NSMutableArray*) getStorageFBNewsList;

-(void) saveGoogleNewsItem: (NSString*) nid
                      data: (NSDictionary*) dicData;

-(NSMutableArray*) getStorageGPNewsList;

-(void) saveTwitterNewsItem: (NSString*) nid
                        data: (NSDictionary*) dicData;
-(NSMutableArray*) getStorageTWNewsList;

-(void) saveBaiduNewsItem: (NSString*) nid
                      data: (NSDictionary*) dicData;

-(NSMutableArray*) getStorageBDNewsList;

-(NSMutableArray*) getStorageWENewsList;

-(void) saveFeedNewsItem: (NSString*) nid
                    data: (NSDictionary*) dicData;
-(void) saveUnLikeNewsItem: (NSString*) nid
                      data: (NSDictionary*) dicData;
-(NSMutableArray*) getStorageFeedNewsList;
-(NSMutableArray*) getStorageUnLikeNewsList;

@end


#endif
