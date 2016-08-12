//
//  NewsCategory.m
//  PoPoNews
//
//  Created by apple on 15/4/22.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsCategory.h"

@implementation BaiduPlusChannelItem

- (BaiduPlusChannelItem *)initWithDictionary:(NSDictionary *)dic{

    
    if (dic == nil)
        return nil;
    
    NSString* tmpStr = [dic objectForKey:NEWS_CATEGORY_EXTRA_NAME];
    if (tmpStr != nil)
        self.name = tmpStr;
    
    tmpStr = [dic objectForKey:NEWS_CATEGORY_EXTRA_RSS_URL];
    if (tmpStr != nil)
        self.rssUrl = tmpStr;
    
    return self;

}


@end

@implementation GooglePlusChannelItem

-(GooglePlusChannelItem*) initWithDictionary: (NSDictionary*) dic{
    if (dic == nil)
        return nil;
    
    NSString* tmpStr = [dic objectForKey:NEWS_CATEGORY_EXTRA_NAME];
    if (tmpStr != nil)
        self.name = tmpStr;
    
    tmpStr = [dic objectForKey:NEWS_CATEGORY_EXTRA_RSS_URL];
    if (tmpStr != nil)
        self.rssUrl = tmpStr;
    
    NSArray* urlArray = [dic objectForKey:NEWS_CATEGORY_EXTRA_RSS_URLS];
    if (urlArray != nil){
        for(NSString* tmpUrl in urlArray){
            if (tmpUrl != nil){
                if (self.rssUrls == nil)
                    self.rssUrls = [NSMutableArray arrayWithCapacity:1];
                
                [self.rssUrls addObject:tmpUrl];
            }
        }
    }
    
    return self;
}

@end

@implementation SocialCategoryItem

-(SocialCategoryItem*) initWithDictionary: (NSDictionary*) dic{
    if (dic == nil)
        return nil;
    
    NSString* tmpStr = [dic objectForKey:NEWS_CATEGORY_EXTRA_NAME];
    if (tmpStr != nil)
        self.name = tmpStr;
    
    tmpStr = [dic objectForKey:NEWS_CATEGORY_EXTRA_HINT];
    if (tmpStr != nil)
        self.hint = tmpStr;

    if ([self.name isEqualToString:@"baidu"]) {
        NSDictionary* tmpDict = [dic objectForKey:NEWS_CATEGORY_EXTRA_CONFIG];
        if (tmpDict != nil){
            NSArray* channels = [tmpDict objectForKey:NEWS_CATEGORY_EXTRA_CHANNEL];
            for(NSDictionary* tmpCHDict in channels){
                if (tmpCHDict != nil){
                    BaiduPlusChannelItem* bdCH = [[BaiduPlusChannelItem alloc] initWithDictionary:tmpCHDict];
                    if (self.channels == nil){
                        self.channels = [NSMutableArray arrayWithCapacity:1];
                    }
                    
                    [self.channels addObject:bdCH];

                }
            }
        }
    }
    tmpStr = [dic objectForKey:NEWS_CATEGORY_EXTRA_TITLE];
    if (tmpStr != nil)
        self.title = tmpStr;
    if ([self.name isEqualToString:@"google"]) {

    NSDictionary* tmpDict = [dic objectForKey:NEWS_CATEGORY_EXTRA_CONFIG];
    if (tmpDict != nil){
        NSArray* channels = [tmpDict objectForKey:NEWS_CATEGORY_EXTRA_CHANNEL];
        for(NSDictionary* tmpCHDict in channels){
            if (tmpCHDict != nil){
                GooglePlusChannelItem* gpCH = [[GooglePlusChannelItem alloc] initWithDictionary:tmpCHDict];
                if (self.channels == nil){
                    self.channels = [NSMutableArray arrayWithCapacity:1];
                }

                [self.channels addObject:gpCH];
            }
        }
    }
        
    
}
//    }else if ([self.name isEqualToString:@"google"]){
//        NSDictionary* tmpDict = [dic objectForKey:NEWS_CATEGORY_EXTRA_CONFIG];
//        if (tmpDict != nil){
//            NSArray* channels = [tmpDict objectForKey:NEWS_CATEGORY_EXTRA_CHANNEL];
//            for(NSDictionary* tmpCHDict in channels){
//                if (tmpCHDict != nil){
//                    GooglePlusChannelItem* gpCH = [[GooglePlusChannelItem alloc] initWithDictionary:tmpCHDict];
//                    if (self.channels == nil){
//                        self.channels = [NSMutableArray arrayWithCapacity:1];
//                    }
//                    
//                    [self.channels addObject:gpCH];
//                }
//            }
//        }
//
//    }
//
    
    
    
    return self;
}

@end

@implementation NewsCategory

-(NewsCategory*) initWithDictionary: (NSDictionary*) dic{
    
    
    if (dic == nil)
        return nil;
    
    NSString* tmpData = [dic objectForKey:NEWS_CATEGORY_ID];
    if (tmpData != nil)
        self.cId = tmpData;
    
    tmpData = [dic objectForKey:NEWS_CATEGORY_NAME];
    if (tmpData != nil)
        self.name = tmpData;
    
    tmpData = [dic objectForKey:NEWS_CATEGORY_LAYOUT];
    if (tmpData != nil)
        self.layout = tmpData;
    
    tmpData = [dic objectForKey:NEWS_CATEGORY_TYPE];
    if (tmpData != nil)
        self.type = tmpData;
    
    id tmpDict = [dic objectForKey:NEWS_CATEGORY_EXTRA];
    if (tmpDict != nil && [tmpDict isKindOfClass:[NSDictionary class]]){
        NSArray* tmpArray = [tmpDict objectForKey:NEWS_CATEGORY_EXTRA_SOURCES];
        if (tmpArray != nil){
            for (NSDictionary* tmpSourceDict in tmpArray) {
                if (tmpSourceDict != nil){
                    SocialCategoryItem* sourceItem = [[SocialCategoryItem alloc] initWithDictionary:tmpSourceDict];
                    if (self.extra == nil){
                        self.extra = [NSMutableArray arrayWithCapacity:1];
                    }
                    [self.extra addObject:sourceItem];
                }
            }
        }
    }
    
    self.firstAutoLoad = NO;
    
    return self;
}

@end
