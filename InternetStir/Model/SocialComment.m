


//
//  SocialComment.m
//  Jacob
//
//  Created by Apple on 16/10/18.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import "SocialComment.h"

@implementation SocialComment
-(SocialComment*) initWithDictionary: (NSDictionary*) dic {
    if (dic == nil)
        return nil;
    
    NSString* tmpData = [dic objectForKey:SOCIAL_COMMENT_ITEM_TITLE];
    if (tmpData != nil)
        self.title = tmpData;
    
    tmpData = [dic objectForKey:SOCIAL_COMMENT_ITEM_PHOTO];
    if (tmpData != nil)
        self.photo = tmpData;
    
    tmpData = [dic objectForKey:SOCIAL_COMMENT_ITEM_SOURCE];
    if (tmpData != nil)
        self.photo = tmpData;
    
    tmpData = [dic objectForKey:SOCIAL_COMMENT_ITEM_URL];
    if (tmpData != nil)
        self.photo = tmpData;
    
    tmpData = [dic objectForKey:SOCIAL_COMMENT_ITEM_CID];
    if (tmpData != nil)
        self.cid = tmpData;
    
    tmpData = [dic objectForKey:SOCIAL_COMMENT_ITEM_UTS];
    if (tmpData != nil)
        self.uts = [tmpData longLongValue];

    
    return self;
}
@end
