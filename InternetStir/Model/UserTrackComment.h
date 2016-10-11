//
//  UserTrackComment.h
//  Jacob
//
//  Created by apple on 16/10/10.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#ifndef UserTrackComment_h
#define UserTrackComment_h

#define TRACK_COMMENT_ITEM_UUID @"uuid"
#define TRACK_COMMENT_ITEM_NAME @"u_name"
#define TRACK_COMMENT_ITEM_AVATAR @"u_avatar"
#define TRACK_COMMENT_ITEM_FORUMS_ID @"fid"
#define TRACK_COMMENT_ITEM_CID @"cid"
#define TRACK_COMMENT_ITEM_COMMENT @"comment"
#define TRACK_COMMENT_ITEM_PTS @"pts"
#define TRACK_COMMENT_ITEM_UTS @"uts"
#define TRACK_COMMENT_ITEM_CBREAD @"read"
#define TRACK_COMMENT_ITEM_RID @"rid"

@interface UserTrackComment : NSObject

@property NSString* uuid;
@property NSString* name;
@property NSString* avator;
@property NSString* fid;
@property NSString* cid;
@property NSString* comment;
@property NSString* rid;
@property UInt64 pts;
@property UInt64 uts;
@property BOOL isCelebRead;

@property NSString* celebComment;
@property NSArray* celebAttachments;
@property NSString* celebCCId;
@property NSString* celebName;
@property NSString* celebAvator;

@property NSArray* replayComments;

-(UserTrackComment*) initWithDictionary: (NSDictionary*) dic;

@end


#endif /* UserTrackComment_h */
