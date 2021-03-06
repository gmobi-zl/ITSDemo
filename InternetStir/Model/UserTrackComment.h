//
//  UserTrackComment.h
//  Jacob
//
//  Created by apple on 16/10/10.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#ifndef UserTrackComment_h
#define UserTrackComment_h

#import "CelebComment.h"
#import "UserTrackCommentFrame.h"

#define TRACK_COMMENT_ITEM_RID @"rid"
#define TRACK_COMMENT_ITEM_FORUMS_ID @"fid"
#define TRACK_COMMENT_ITEM_UUID @"uuid"
#define TRACK_COMMENT_ITEM_CID @"cid"
#define TRACK_COMMENT_ITEM_COMMENT @"comment"
#define TRACK_COMMENT_ITEM_READ @"read"
#define TRACK_COMMENT_ITEM_UTS @"uts"
#define TRACK_COMMENT_ITEM_PTS @"pts"
#define TRACK_COMMENT_ITEM_CELEB @"celeb"
#define TRACK_COMMENT_ITEM_NAME @"u_name"
#define TRACK_COMMENT_ITEM_AVATAR @"u_avatar"
#define TRACK_COMMENT_ITEM_ROLE @"u_role"
#define TRACK_COMMENT_ITEM_OBJECT @"u_object"
#define TRACK_COMMENT_ITEM_REPLY @"reply"
#define TRACK_COMMENT_ITEM_ARTICLE @"article"


@interface UserTrackComment : NSObject

@property NSString* rid;
@property NSString* fid;
@property NSString* uuid;
@property NSString* cid;
@property NSString* comment;
@property BOOL isCelebRead;
@property UInt64 uts;
@property UInt64 pts;
@property NSString* celeb;
@property NSString* name;
@property NSString* avator;
@property NSInteger u_role;

@property CelebComment* article;

@property NSMutableArray* replayComments;

@property UserTrackCommentFrame *uiFrame;

-(UserTrackComment*) initWithDictionary: (NSDictionary*) dic;

@end


#endif /* UserTrackComment_h */
