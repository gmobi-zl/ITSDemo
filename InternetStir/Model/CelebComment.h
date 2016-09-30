//
//  CelebComment.h
//  InternetStir
//
//  Created by apple on 16/9/2.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#ifndef CelebComment_h
#define CelebComment_h

#import <Foundation/Foundation.h>
#import "HomeCommentFrame.h"

#define CB_COMMENT_ITEM_ID @"fid"
#define CB_COMMENT_ITEM_CONTEXT @"context"
#define CB_COMMENT_ITEM_ATTACHMENTS @"attachments"
#define CB_COMMENT_ITEM_COMMENTS @"comments"
#define CB_COMMENT_ITEM_PTS @"pts"
#define CB_COMMENT_ITEM_UTS @"uts"


@interface CelebComment : NSObject

@property NSString* fid;
@property NSString* context;
@property NSArray* attachments;

@property NSString* ccId;
@property NSString* name;
@property NSString* avator;

//@property NSArray* topFansComments;
@property NSArray* replayComments;

@property UInt64 pts;
@property UInt64 uts;

@property HomeCommentFrame* uiFrame;

-(CelebComment*) initWithDictionary: (NSDictionary*) dic;

@end

#endif /* CelebComment_h */
