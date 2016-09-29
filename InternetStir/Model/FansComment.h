//
//  FansComment.h
//  InternetStir
//
//  Created by apple on 16/9/2.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#ifndef FansComment_h
#define FansComment_h

#import <Foundation/Foundation.h>

#define FANS_COMMENT_ITEM_UUID @"uuid"
#define FANS_COMMENT_ITEM_NAME @"u_name"
#define FANS_COMMENT_ITEM_AVATAR @"u_avatar"
#define FANS_COMMENT_ITEM_FORUMS_ID @"fid"
#define FANS_COMMENT_ITEM_CID @"cid"
#define FANS_COMMENT_ITEM_COMMENT @"comment"
#define FANS_COMMENT_ITEM_PTS @"pts"
#define FANS_COMMENT_ITEM_UTS @"uts"
#define FANS_COMMENT_ITEM_CBREAD @"read"

@interface FansComment : NSObject

@property NSString* uuid;
@property NSString* name;
@property NSString* avator;
@property NSString* fid;
@property NSString* cid;
@property NSString* comment;
@property UInt64 pts;
@property UInt64 uts;
@property BOOL isCelebRead;


-(FansComment*) initWithDictionary: (NSDictionary*) dic;

@end

#endif /* FansComment_h */ 
