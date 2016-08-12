//
//  NewsImage.h
//  PoPoNews
//
//  Created by apple on 15/4/22.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#ifndef PoPoNews_NewsImage_h
#define PoPoNews_NewsImage_h

#import <Foundation/Foundation.h>

#define NEWS_ITEM_IMAGE_T @"t"
#define NEWS_ITEM_IMAGE_FILE @"f"
#define NEWS_ITEM_IMAGE_URL @"url"
#define NEWS_ITEM_IMAGE_WIDTH @"w"
#define NEWS_ITEM_IMAGE_HEIGHT @"h"
#define NEWS_ITEM_IMAGE_DESC @"desc"

@interface NewsImage : NSObject

@property (assign) int t;
@property (copy) NSString* image;
@property (copy) NSString* url;
@property (assign) int w;
@property (assign) int h;
@property (copy) NSString* desc;

-(NewsImage*) initWithDictionary: (NSDictionary*) dic;
-(NSMutableDictionary*) toDictionaryData;
@end


#endif
