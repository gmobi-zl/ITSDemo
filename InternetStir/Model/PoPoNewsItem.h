//
//  NewsItem.h
//  PoPoNews
//
//  Created by apple on 15/4/22.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#ifndef PoPoNews_NewsItem_h
#define PoPoNews_NewsItem_h


#import <Foundation/Foundation.h>
#import "NewsMood.h"
#import "NewsImage.h"

#define NEWS_INIT_TYPE_SERVER  0
#define NEWS_INIT_TYPE_CLIENT  1

#define NEWS_ITEM_ID @"_id"
#define NEWS_ITEM_CATEGORY_ID @"_cid"
#define NEWS_ITEM_RELEASE_TIME @"releaseTime"
#define NEWS_ITEM_TITLE @"title"
#define NEWS_ITEM_MM @"mm"
#define NEWS_ITEM_FAV @"fav"
#define NEWS_ITEM_MOOD @"mood"
#define NEWS_ITEM_PREVIEW @"preview"
#define NEWS_ITEM_PDOMAIN @"p_domain"
#define NEWS_ITEM_SOURCE @"source"
#define NEWS_ITEM_BODY @"body"
#define NEWS_ITEM_TYPE @"type"
#define NEWS_ITEM_PNAME @"p_name"
#define NEWS_ITEM_PICON @"p_icon"
#define NEWS_ITEM_OFFLINE_DL @"offline_dl"
#define NEWS_ITEM_IS_READ @"is_read"
#define NEWS_ITEM_COMMENT_COUNT @"comment_count"

#define NEWS_ITEM_MY_FAV @"myfav"
#define NEWS_ITEM_DID_FAV @"didFav"

#define NEWS_ITEM_GO2SOURCE @"go2source"

#define NEWS_INIT_SHOWTYPE @"newsShowType"
#define NEWS_INIT_HEIGHT @"height"
@interface PoPoNewsItem : NSObject

@property (nonatomic, copy) NSString* cId;
@property (copy) NSString* nId;
@property (copy) NSString* title;
@property (assign) unsigned long long releaseTime;
@property (retain) NSMutableArray* images;
@property (assign) int fav;
@property (assign) BOOL isMyFav;
@property (assign) BOOL didFav;
@property (retain) NewsMood* mood;
@property (copy) NSString* preview;
@property (copy) NSString* pDomain;
@property (copy) NSString* source;
@property (copy) NSString* body;
@property (copy) NSString* type;
@property (copy) NSString* pName;
@property (copy) NSString* pIcon;
@property (assign) int comment_count;
@property (assign) BOOL isOfflineDL; // 是否是离线下载的新闻
@property (assign) BOOL go2source;
@property (assign) int initType;
@property (assign) float height;
@property (copy) NSString *newsShowType;
@property (assign) BOOL isRead;
@property (retain) NSArray* image3Array;
@property (retain) NewsImage* maxImg;

-(PoPoNewsItem*) initWithDictionary: (NSDictionary*) dic;

-(NSMutableDictionary*) toDictionaryData;
-(NSMutableDictionary*) toDictionaryDataHasReadStatus;
- (NSString *)getDateStringTimeStap:(NSInteger)date;
-(void) setNewsInitType: (int) type;
-(int) getNewsInitType;

@end

#endif
