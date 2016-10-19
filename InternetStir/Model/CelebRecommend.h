//
//  SocialComment.h
//  Jacob
//
//  Created by Apple on 16/10/18.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CELEB_RECOMMEND_ITEM_TITLE @"title"
#define CELEB_RECOMMEND_ITEM_PHOTO @"photo"
#define CELEB_RECOMMEND_ITEM_SOURCE @"source"
#define CELEB_RECOMMEND_ITEM_URL @"url"
#define CELEB_RECOMMEND_ITEM_CID @"cid"
#define CELEB_RECOMMEND_ITEM_UTS @"uts"

@interface CelebRecommend : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *cid;
@property (nonatomic, assign) UInt64 uts;
@property (nonatomic, assign) UInt64 pts;

-(CelebRecommend*) initWithDictionary: (NSDictionary*) dic;

@end
