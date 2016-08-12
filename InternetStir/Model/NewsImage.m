//
//  NewsImage.m
//  PoPoNews
//
//  Created by apple on 15/4/22.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsImage.h"

@implementation NewsImage


-(NewsImage*) initWithDictionary: (NSDictionary*) dic{
    
    if (dic == nil)
        return nil;
    
    NSNumber* tmpNum = [dic objectForKey:NEWS_ITEM_IMAGE_T];
    if (tmpNum != nil)
        self.t = tmpNum.intValue;
    
    NSString* tmpData = [dic objectForKey:NEWS_ITEM_IMAGE_FILE];
    if (tmpData != nil)
        self.image = tmpData;
    
    tmpData = [dic objectForKey:NEWS_ITEM_IMAGE_URL];
    if (tmpData != nil)
        self.url = tmpData;
    
    tmpNum = [dic objectForKey:NEWS_ITEM_IMAGE_WIDTH];
    if (tmpNum != nil)
        self.w = tmpNum.intValue;
    
    tmpNum = [dic objectForKey:NEWS_ITEM_IMAGE_HEIGHT];
    if (tmpNum != nil)
        self.h = tmpNum.intValue;
    
    tmpData = [dic objectForKey:NEWS_ITEM_IMAGE_DESC];
    if (tmpData != nil)
        self.desc = tmpData;
    
    return self;
}

-(NSMutableDictionary*) toDictionaryData{
    NSMutableDictionary* retDic = [NSMutableDictionary dictionaryWithCapacity:2];
    
    NSNumber* numData = [NSNumber numberWithLong:self.t];
    if (numData != nil)
        [retDic setObject:numData forKey:NEWS_ITEM_IMAGE_T];
    
    if (self.image != nil)
        [retDic setObject:self.image forKey:NEWS_ITEM_IMAGE_FILE];
    
    if (self.url != nil)
        [retDic setObject:self.url forKey:NEWS_ITEM_IMAGE_URL];
    
    numData = [NSNumber numberWithLong:self.w];
    if (numData != nil)
        [retDic setObject:numData forKey:NEWS_ITEM_IMAGE_WIDTH];
    
    numData = [NSNumber numberWithLong:self.h];
    if (numData != nil)
        [retDic setObject:numData forKey:NEWS_ITEM_IMAGE_HEIGHT];
    
    
    if (self.desc != nil)
        [retDic setObject:self.desc forKey:NEWS_ITEM_IMAGE_DESC];
    
    return retDic;
}

@end