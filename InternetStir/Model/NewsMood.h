//
//  NewsMood.h
//  PoPoNews
//
//  Created by apple on 15/4/22.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#ifndef PoPoNews_NewsMood_h
#define PoPoNews_NewsMood_h

#define NEWS_ITEM_MOOD_HAPPY @"happy"
#define NEWS_ITEM_MOOD_SAD @"sad"
#define NEWS_ITEM_MOOD_AMAZE @"amaze"
#define NEWS_ITEM_MOOD_MOVE @"move"
#define NEWS_ITEM_MOOD_WORRY @"worry"
#define NEWS_ITEM_MOOD_ANGRY @"angry"

#define NEWS_ITEM_MY_MOOD @"mymood"


#import <Foundation/Foundation.h>

@interface NewsMood : NSObject

@property (assign) int happy;
@property (assign) int sad;
@property (assign) int amaze;
@property (assign) int move;
@property (assign) int worry;
@property (assign) int angry;
@property (copy) NSString* myMood;

-(NewsMood*) initWithDictionary: (NSDictionary*) dic;
-(int) getTopPercent;
-(NSString*) getTopMoodName;
-(NSString*) getTopMoodResName;
-(void) setMyMoodType:(NSString *)mood;
-(NSString*) getMyMoodType;
-(int) getPercentByType: (NSString*) type;
-(int) getTotalCount;

-(NSMutableDictionary*) toDictionaryData;

@end

#endif
