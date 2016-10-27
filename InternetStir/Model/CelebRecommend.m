


//
//  SocialComment.m
//  Jacob
//
//  Created by Apple on 16/10/18.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import "CelebRecommend.h"

@implementation CelebRecommend
-(CelebRecommend*) initWithDictionary: (NSDictionary*) dic {
    if (dic == nil)
        return nil;
    
    NSString* tmpData = [dic objectForKey:CELEB_RECOMMEND_ITEM_TITLE];
    if (tmpData != nil)
        self.title = tmpData;
    
    tmpData = [dic objectForKey:CELEB_RECOMMEND_ITEM_PHOTO];
    if (tmpData != nil)
        self.photo = tmpData;
    
    NSNumber* numData = [dic objectForKey:CELEB_RECOMMEND_ITEM_RELEASE_TIME];
    if (numData != nil)
        self.releaseTime = [numData longLongValue];

    tmpData = [dic objectForKey:CELEB_RECOMMEND_ITEM_SOURCE];
    if (tmpData != nil)
        self.source = tmpData;
    
    tmpData = [dic objectForKey:CELEB_RECOMMEND_ITEM_PDOMAIN];
    if (tmpData != nil)
        self.pdomain = tmpData;
    
    tmpData = [dic objectForKey:CELEB_RECOMMEND_ITEM_CID];
    if (tmpData != nil)
        self.cid = tmpData;
    
    NSArray* mmData = [dic objectForKey:CELEB_RECOMMEND_ITEM_MM];
    if (mmData != nil){
        NSMutableArray* tmpArray = [NSMutableArray arrayWithCapacity:2];
        for(NSDictionary* item in mmData){
            NewsImage* image = [[NewsImage alloc] initWithDictionary:item];
            [tmpArray addObject:image];
            self.photo = [item objectForKey:@"url"];
        }
        self.images = tmpArray;
    }
    tmpData = [dic objectForKey:CELEB_RECOMMEND_ITEM_UTS];
    if (tmpData != nil)
        self.uts = [tmpData longLongValue];

    tmpData = [dic objectForKey:CELEB_RECOMMEND_ITEM_PREVIEW];
    
    tmpData = [dic objectForKey:CELEB_RECOMMEND_ITEM_BODY];
    if (tmpData != nil)
        self.body = tmpData;

    if (tmpData != nil)
        self.preview = tmpData;
    return self;
}
@end
