//
//  UserTrackComment.m
//  Jacob
//
//  Created by apple on 16/10/10.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserTrackComment.h"

@implementation UserTrackComment



-(UserTrackComment*) initWithDictionary: (NSDictionary*) dic{
    
    if (dic == nil)
        return nil;
    
    NSString* tmpData = [dic objectForKey:TRACK_COMMENT_ITEM_UUID];
    if (tmpData != nil)
        self.uuid = tmpData;
    
    tmpData = [dic objectForKey:TRACK_COMMENT_ITEM_NAME];
    if (tmpData != nil)
        self.name = tmpData;
    
    tmpData = [dic objectForKey:TRACK_COMMENT_ITEM_AVATAR];
    if (tmpData != nil)
        self.avator = tmpData;
    
    tmpData = [dic objectForKey:TRACK_COMMENT_ITEM_FORUMS_ID];
    if (tmpData != nil)
        self.fid = tmpData;
    
    tmpData = [dic objectForKey:TRACK_COMMENT_ITEM_CID];
    if (tmpData != nil)
        self.cid = tmpData;
    
    
    tmpData = [dic objectForKey:TRACK_COMMENT_ITEM_RID];
    if (tmpData != nil)
        self.rid = tmpData;
    
    tmpData = [dic objectForKey:TRACK_COMMENT_ITEM_COMMENT];
    if (tmpData != nil)
        self.comment = tmpData;
    
    NSNumber* numData = [dic objectForKey:TRACK_COMMENT_ITEM_PTS];
    if (numData != nil)
        self.pts = [numData longLongValue];
    
    numData = [dic objectForKey:TRACK_COMMENT_ITEM_UTS];
    if (numData != nil)
        self.uts = [numData longLongValue];
    
    numData = [dic objectForKey:TRACK_COMMENT_ITEM_CBREAD];
    if (numData != nil)
        self.isCelebRead = [numData boolValue];
    
    return self;
}

@end