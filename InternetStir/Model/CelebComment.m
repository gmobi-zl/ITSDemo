//
//  CelebComment.m
//  InternetStir
//
//  Created by apple on 16/9/2.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CelebComment.h"
#import "FansComment.h"
#import "ITSApplication.h"

@implementation CelebComment


-(CelebComment*) initWithDictionary: (NSDictionary*) dic{
    
    if (dic == nil)
        return nil;

    NSString* tmpData = [dic objectForKey:CB_COMMENT_ITEM_ID];
    if (tmpData != nil)
        self.fid = tmpData;
    
    tmpData = [dic objectForKey:CB_COMMENT_ITEM_CONTEXT];
    if (tmpData != nil)
        self.context = tmpData;
    
    NSArray* mmData = [dic objectForKey:CB_COMMENT_ITEM_ATTACHMENTS];
    if (mmData != nil){
        self.attachments = mmData;
    }
    
    NSNumber* numData = [dic objectForKey:CB_COMMENT_ITEM_PTS];
    if (numData != nil)
        self.pts = [numData longLongValue];
    
    numData = [dic objectForKey:CB_COMMENT_ITEM_UTS];
    if (numData != nil)
        self.uts = [numData longLongValue];
    
    numData = [dic objectForKey:CB_COMMENT_ITEM_IS_LIKE];
    if (numData != nil)
        self.isLike = [numData boolValue];
    
    numData = [dic objectForKey:CB_COMMENT_ITEM_LIKES];
    if (numData != nil)
        self.likes = [numData integerValue];
    
    NSArray* topComments = [dic objectForKey:CB_COMMENT_ITEM_COMMENTS];
    if (topComments != nil){
        NSMutableArray* tmpArray = [NSMutableArray arrayWithCapacity:2];
        for(NSDictionary* item in topComments){
            FansComment* fansCM = [[FansComment alloc] initWithDictionary:item];
            [tmpArray addObject:fansCM];
        }
        self.topFansComments = tmpArray;
    }
    
    return self;
}

@end