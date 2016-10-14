//
//  UserTrackComment.m
//  Jacob
//
//  Created by apple on 16/10/10.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserTrackComment.h"
#import "ITSAppConst.h"
#import "FansComment.h"

@implementation UserTrackComment



-(UserTrackComment*) initWithDictionary: (NSDictionary*) dic{
    
    if (dic == nil)
        return nil;
    
    NSString* tmpData = [dic objectForKey:TRACK_COMMENT_ITEM_UUID];
    if (tmpData != nil)
        self.uuid = tmpData;
    
    tmpData = [dic objectForKey:TRACK_COMMENT_ITEM_RID];
    if (tmpData != nil)
        self.rid = tmpData;
    
    tmpData = [dic objectForKey:TRACK_COMMENT_ITEM_FORUMS_ID];
    if (tmpData != nil)
        self.fid = tmpData;
    
    tmpData = [dic objectForKey:TRACK_COMMENT_ITEM_CID];
    if (tmpData != nil)
        self.cid = tmpData;
    
    tmpData = [dic objectForKey:TRACK_COMMENT_ITEM_COMMENT];
    if (tmpData != nil)
        self.comment = tmpData;
    
    NSNumber* numData = [dic objectForKey:TRACK_COMMENT_ITEM_READ];
    if (numData != nil)
        self.isCelebRead = [numData boolValue];
    
    numData = [dic objectForKey:TRACK_COMMENT_ITEM_UTS];
    if (numData != nil)
        self.uts = [numData longLongValue];
    
    numData = [dic objectForKey:TRACK_COMMENT_ITEM_PTS];
    if (numData != nil)
        self.pts = [numData longLongValue];
    
    tmpData = [dic objectForKey:TRACK_COMMENT_ITEM_CELEB];
    if (tmpData != nil)
        self.celeb = tmpData;
    
    tmpData = [dic objectForKey:TRACK_COMMENT_ITEM_NAME];
    if (tmpData != nil)
        self.name = tmpData;
    
    tmpData = [dic objectForKey:TRACK_COMMENT_ITEM_AVATAR];
    if (tmpData != nil)
        self.avator = tmpData;
    
    NSString* uRole = [dic objectForKey:TRACK_COMMENT_ITEM_ROLE];
    if (uRole != nil){
        if ([uRole isEqualToString:@"celeb"]){
            self.u_role = CELEB_USER_CELEB;
        } else if ([uRole isEqualToString:@"admin"]){
            self.u_role = CELEB_USER_ADMIN;
        } else if ([uRole isEqualToString:@"user"]){
            self.u_role = CELEB_USER_NORMAL;
        }
        
        //        id vipObj = [dic objectForKey:FANS_COMMENT_ITEM_VIP];
        //        if (vipObj != nil && self.u_role == CELEB_USER_NORMAL)
        //            self.u_role = CELEB_USER_VIP;
    } else {
        self.u_role = CELEB_USER_NORMAL;
    }
    
    NSArray* replys = [dic objectForKey:TRACK_COMMENT_ITEM_REPLY];
    if (replys != nil){
        for (int i = 0; i < [replys count]; i++) {
            NSDictionary* replyDic = [replys objectAtIndex:i];
            FansComment* rComment = [[FansComment alloc] initWithDictionary:replyDic];
            [self insertReplyCommentItem:rComment];
        }
    }
    
    NSDictionary* article = [dic objectForKey:TRACK_COMMENT_ITEM_ARTICLE];
    if (article != nil){
        CelebComment* cbComment = [[CelebComment alloc] initWithDictionary:article];
        self.article = cbComment;
    }
    
    return self;
}

-(BOOL) insertReplyCommentItem: (FansComment*) item{
    BOOL same = NO;
    BOOL ret = NO;
    int i = 0;
    
    if (item == nil)
        return ret;
    
    if (self.replayComments == nil)
        self.replayComments = [NSMutableArray arrayWithCapacity:1];
    
    int listCount = (int)[self.replayComments count];
    for (i = 0; i < listCount; i++) {
        
        id uComment = [self.replayComments objectAtIndex:i];
        if ([uComment isKindOfClass:[FansComment class]]) {
            FansComment* comment = uComment;
            if (comment != nil){
                if ([comment.cid compare:item.cid] == NSOrderedSame) {
                    same = YES;
                    
                    //if (item.isOfflineDL == YES && newItem.isOfflineDL == NO){
                    //    newItem.isOfflineDL = YES;
                    //}
                    
                    break;
                }
                
                if (comment.pts < item.pts) {
                    [self.replayComments insertObject:item atIndex:i];
                    ret = YES;
                    break;
                }
            }
        }
    }
    
    if (same == NO && ret == NO){
        [self.replayComments addObject:item];
        ret = YES;
    }
    
    return ret;
}

@end