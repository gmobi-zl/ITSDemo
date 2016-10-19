//
//  SocialComment.h
//  Jacob
//
//  Created by Apple on 16/10/18.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SOCIAL_COMMENT_ITEM_TITLE @"title"
#define SOCIAL_COMMENT_ITEM_PHOTO @"photo"
#define SOCIAL_COMMENT_ITEM_SOURCE @"source"
#define SOCIAL_COMMENT_ITEM_URL @"url"
#define SOCIAL_COMMENT_ITEM_CID @"cid"
#define SOCIAL_COMMENT_ITEM_UTS @"uts"

@interface SocialComment : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *cid;
@property (nonatomic, assign) UInt64 uts;

-(SocialComment*) initWithDictionary: (NSDictionary*) dic;

@end
