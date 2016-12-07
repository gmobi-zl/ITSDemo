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

@implementation CelebAttachment

-(CelebAttachment*) initWithDictionary: (NSDictionary*) dic{
    if (dic == nil)
        return nil;
    
    NSString* tmpData = [dic objectForKey:CB_COMMENT_ITEM_ATTACHMENTS_ID];
    if (tmpData != nil)
        self.fd = tmpData;
    
    NSNumber* numData = [dic objectForKey:CB_COMMENT_ITEM_ATTACHMENTS_W];
    if (numData != nil)
        self.w = [numData integerValue];
    
    numData = [dic objectForKey:CB_COMMENT_ITEM_ATTACHMENTS_H];
    if (numData != nil)
        self.h = [numData integerValue];
    
    return self;
}

@end

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
        if (self.attachments == nil)
            self.attachments = [NSMutableArray arrayWithCapacity:1];
        
        NSInteger aCount = [mmData count];
        for (int m = 0; m < aCount; m++) {
            NSDictionary* aDic = [mmData objectAtIndex:m];
            CelebAttachment* att = [[CelebAttachment alloc] initWithDictionary:aDic];
            [self.attachments addObject:att];
        }
        //self.attachments = mmData;
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
        FansComment *fans = [[FansComment alloc] init];
        for (NSInteger i = 0; i < tmpArray.count; i++) {
            for (NSInteger j = 0; j < tmpArray.count - i - 1; j++) {
                FansComment *fan = [tmpArray objectAtIndex:j];
                FansComment *comment = [tmpArray objectAtIndex:j+1];
                if (fan.uts > comment.uts) {
                    fans = tmpArray[j];
                    tmpArray[j] = tmpArray[j + 1];
                    tmpArray[j + 1] = fans;
                }
            }
        }
        self.topFansComments = tmpArray;
    }
    
    self.weight = 0;
    
    return self;
}

@end
