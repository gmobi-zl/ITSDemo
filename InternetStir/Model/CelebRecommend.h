//
//  SocialComment.h
//  Jacob
//
//  Created by Apple on 16/10/18.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsImage.h"

#define CELEB_RECOMMEND_ITEM_TITLE @"title"
#define CELEB_RECOMMEND_ITEM_PHOTO @"photo"
#define CELEB_RECOMMEND_ITEM_SOURCE @"source"
#define CELEB_RECOMMEND_ITEM_URL @"url"
#define CELEB_RECOMMEND_ITEM_CID @"_id"
#define CELEB_RECOMMEND_ITEM_UTS @"uts"
#define CELEB_RECOMMEND_ITEM_PDOMAIN @"p_domain"
#define CELEB_RECOMMEND_ITEM_MM @"mm"
#define CELEB_RECOMMEND_ITEM_BODY @"body"
#define CELEB_RECOMMEND_ITEM_RELEASE_TIME @"releaseTime"
#define CELEB_RECOMMEND_ITEM_PREVIEW @"preview"


@interface CelebRecommend : NSObject

@property (copy) NSString* preview;
@property (copy) NSString* body;
@property (assign) unsigned long long releaseTime;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *cid;
@property (nonatomic, copy) NSString *pdomain;
@property (nonatomic, retain) NSMutableArray *images;
@property (nonatomic, assign) UInt64 uts;
@property (nonatomic, assign) UInt64 pts;

-(CelebRecommend*) initWithDictionary: (NSDictionary*) dic;

@end
