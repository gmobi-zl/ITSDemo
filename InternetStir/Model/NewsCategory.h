//
//  NewsCategory.h
//  PoPoNews
//
//  Created by apple on 15/4/22.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#ifndef PoPoNews_NewsCategory_h
#define PoPoNews_NewsCategory_h


#import <Foundation/Foundation.h>
#import "AdItem.h"
#define NEWS_CATEGORY_ID @"id"
#define NEWS_CATEGORY_LABEL @"label"
#define NEWS_CATEGORY_LAYOUT @"layout"
#define NEWS_CATEGORY_TYPE @"type"
#define NEWS_CATEGORY_EXTRA @"extra"
#define NEWS_CATEGORY_URL @"url"


#define NEWS_CATEGORY_EXTRA_SOURCES @"sources"
#define NEWS_CATEGORY_EXTRA_NAME @"name"
#define NEWS_CATEGORY_EXTRA_TITLE @"title"
#define NEWS_CATEGORY_EXTRA_CONFIG @"config"
#define NEWS_CATEGORY_EXTRA_CHANNEL @"channels"
#define NEWS_CATEGORY_EXTRA_RSS_URL @"rss_url"
#define NEWS_CATEGORY_EXTRA_RSS_URLS @"rss_urls"
#define NEWS_CATEGORY_EXTRA_HINT @"hint"

@interface BaiduPlusChannelItem : NSObject
@property (copy) NSString* name;
@property (copy) NSString* rssUrl;

-(BaiduPlusChannelItem*) initWithDictionary: (NSDictionary*) dic;

@end

@interface GooglePlusChannelItem : NSObject
@property (copy) NSString* name;
@property (copy) NSString* rssUrl;
@property (retain) NSMutableArray* rssUrls;

-(GooglePlusChannelItem*) initWithDictionary: (NSDictionary*) dic;

@end

@interface SocialCategoryItem : NSObject
@property (copy) NSString* name;
@property (copy) NSString* title;
@property (retain) NSMutableArray* channels;
@property (copy) NSString* hint;

-(SocialCategoryItem*) initWithDictionary: (NSDictionary*) dic;

@end

@interface NewsCategory : NSObject

@property (copy) NSString* cId;
@property (copy) NSString* label;
@property (copy) NSString* layout;
@property (copy) NSString* type;
@property (copy) NSString* url;

@property (assign) unsigned long long afterTime;
@property (assign) unsigned long long beforeTime;

@property (assign) BOOL firstAutoLoad;

@property (assign) BOOL hidden;
@property (retain) NSMutableArray* extra;

-(NewsCategory*) initWithDictionary: (NSDictionary*) dic;

@end

#endif
