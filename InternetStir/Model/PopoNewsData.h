//
//  PopoNewsData.h
//  PoPoNews
//
//  Created by apple on 15/4/22.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#ifndef PoPoNews_PopoNewsData_h
#define PoPoNews_PopoNewsData_h

#import <Foundation/Foundation.h>

#import "ITSAppConst.h"
#import "NewsCategory.h"
#import "PoPoNewsItem.h"

@interface PopoNewsData : NSObject

@property (retain) NewsCategory* category;
@property (retain) NSMutableArray* data;
//@property (retain) NSMutableArray* gridData;
@property (retain) NSMutableArray* nativeAdData;
@property (assign) int topPhotoIndex;
//@property (retain) NSMutableArray* newsList;
@property (assign) int lastCount;
@property (assign) int freshLastCount;
-(void) resetTopPhotoIndex;

@end

#endif
