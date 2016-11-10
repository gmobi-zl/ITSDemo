//
//  FansComment.m
//  InternetStir
//
//  Created by apple on 16/9/2.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FansComment.h"
#import "ITSAppConst.h"

@implementation FansComment



-(FansComment*) initWithDictionary: (NSDictionary*) dic{
    
    if (dic == nil)
        return nil;
    
    NSString* tmpData = [dic objectForKey:FANS_COMMENT_ITEM_UUID];
    if (tmpData != nil)
        self.uuid = tmpData;
    
    tmpData = [dic objectForKey:FANS_COMMENT_ITEM_NAME];
    if (tmpData != nil)
        self.name = tmpData;
    
    tmpData = [dic objectForKey:FANS_COMMENT_ITEM_AVATAR];
    if (tmpData != nil)
        self.avator = tmpData;
    
    tmpData = [dic objectForKey:FANS_COMMENT_ITEM_FORUMS_ID];
    if (tmpData != nil)
        self.fid = tmpData;
    
    tmpData = [dic objectForKey:FANS_COMMENT_ITEM_CELEB];
    if (tmpData != nil)
        self.celeb = tmpData;
    
    tmpData = [dic objectForKey:FANS_COMMENT_ITEM_CID];
    if (tmpData != nil)
        self.cid = tmpData;
    
    tmpData = [dic objectForKey:FANS_COMMENT_ITEM_RID];
    if (tmpData != nil)
        self.rid = tmpData;
    
    self.comment = @"";
    tmpData = [dic objectForKey:FANS_COMMENT_ITEM_COMMENT];
    if (tmpData != nil)
        self.comment = tmpData;
    
    NSNumber* numData = [dic objectForKey:FANS_COMMENT_ITEM_PTS];
    if (numData != nil)
        self.pts = [numData longLongValue];
    
    numData = [dic objectForKey:FANS_COMMENT_ITEM_UTS];
    if (numData != nil)
        self.uts = [numData longLongValue];
    
    numData = [dic objectForKey:FANS_COMMENT_ITEM_CBREAD];
    if (numData != nil)
        self.isCelebRead = [numData boolValue];
    
    tmpData = [dic objectForKey:FANS_COMMENT_ITEM_ROLE];
    if (tmpData != nil){
        if ([tmpData isEqualToString:@"celeb"]){
            self.u_role = CELEB_USER_CELEB;
        } else if ([tmpData isEqualToString:@"admin"]){
            self.u_role = CELEB_USER_ADMIN;
        } else if ([tmpData isEqualToString:@"user"]){
            self.u_role = CELEB_USER_NORMAL;
        }
        
//        id vipObj = [dic objectForKey:FANS_COMMENT_ITEM_VIP];
//        if (vipObj != nil && self.u_role == CELEB_USER_NORMAL)
//            self.u_role = CELEB_USER_VIP;
    }
    
    NSArray* replys = [dic objectForKey:FANS_COMMENT_ITEM_REPLAY];
    if (replys != nil){
        if (self.replayComments == nil)
            self.replayComments = [NSMutableArray arrayWithCapacity:1];
        
        for (int m = 0; m < [replys count]; m++) {
            NSDictionary* rDic = [replys objectAtIndex:m];
            
            FansComment* tmpItem = [[FansComment alloc] initWithDictionary:rDic];
            [self insertReplyCommentItem:tmpItem];
        }
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