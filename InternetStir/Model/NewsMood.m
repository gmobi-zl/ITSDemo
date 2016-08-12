//
//  NewsMood.m
//  PoPoNews
//
//  Created by apple on 15/4/22.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsMood.h"

@implementation NewsMood



-(NewsMood*) initWithDictionary: (NSDictionary*) dic{
    if (dic == nil)
        return nil;
    
    NSNumber* tmpNum = [dic objectForKey:NEWS_ITEM_MOOD_HAPPY];
    if (tmpNum != nil)
        self.happy = tmpNum.intValue;
    
    tmpNum = [dic objectForKey:NEWS_ITEM_MOOD_SAD];
    if (tmpNum != nil)
        self.sad = tmpNum.intValue;
    
    tmpNum = [dic objectForKey:NEWS_ITEM_MOOD_AMAZE];
    if (tmpNum != nil)
        self.amaze = tmpNum.intValue;
    
    tmpNum = [dic objectForKey:NEWS_ITEM_MOOD_MOVE];
    if (tmpNum != nil)
        self.move = tmpNum.intValue;
    
    tmpNum = [dic objectForKey:NEWS_ITEM_MOOD_WORRY];
    if (tmpNum != nil)
        self.worry = tmpNum.intValue;
    
    tmpNum = [dic objectForKey:NEWS_ITEM_MOOD_ANGRY];
    if (tmpNum != nil)
        self.angry = tmpNum.intValue;
    
    NSString* tmpStr = [dic objectForKey:NEWS_ITEM_MY_MOOD];
    if (tmpStr != nil)
        self.myMood = tmpStr;
    else
        self.myMood = nil;
    
    return self;
}

-(NSMutableDictionary*) toDictionaryData{
    NSMutableDictionary* retDic = [NSMutableDictionary dictionaryWithCapacity:2];
    
    NSNumber* numData = [NSNumber numberWithLong:self.happy];
    if (numData != nil)
        [retDic setObject:numData forKey:NEWS_ITEM_MOOD_HAPPY];
    
    numData = [NSNumber numberWithLong:self.sad];
    if (numData != nil)
        [retDic setObject:numData forKey:NEWS_ITEM_MOOD_SAD];
    
    numData = [NSNumber numberWithLong:self.amaze];
    if (numData != nil)
        [retDic setObject:numData forKey:NEWS_ITEM_MOOD_AMAZE];
    
    numData = [NSNumber numberWithLong:self.move];
    if (numData != nil)
        [retDic setObject:numData forKey:NEWS_ITEM_MOOD_MOVE];
    
    numData = [NSNumber numberWithLong:self.worry];
    if (numData != nil)
        [retDic setObject:numData forKey:NEWS_ITEM_MOOD_WORRY];
    
    numData = [NSNumber numberWithLong:self.angry];
    if (numData != nil)
        [retDic setObject:numData forKey:NEWS_ITEM_MOOD_ANGRY];
    
    if (self.myMood != nil)
        [retDic setObject:self.myMood forKey:NEWS_ITEM_MY_MOOD];
    
    return retDic;
}

-(int) getMaxNumber {
    int max = self.happy;
    
    if (max < self.sad)
        max = self.sad;
    
    if (max < self.amaze)
        max = self.amaze;
    
    if (max < self.move)
        max = self.move;
    
    if (max < self.worry)
        max = self.worry;
    
    if (max < self.angry)
        max = self.angry;
    
    return max;
}

-(int) getTopPercent{
    int percent = 0;
    
    int count = self.happy + self.sad + self.amaze + self.move + self.worry + self.angry;
    if (count > 0)
        percent = [self getMaxNumber] * 100 / count;
    
    return percent;
}

-(NSString*) getTopMoodName{
    int max = self.happy;
    NSString* topMoodName = NEWS_ITEM_MOOD_HAPPY;
    
    if (max < self.sad) {
        max = self.sad;
        topMoodName = NEWS_ITEM_MOOD_SAD;
    }
    
    if (max < self.amaze){
        max = self.amaze;
        topMoodName = NEWS_ITEM_MOOD_AMAZE;
    }
    
    if (max < self.move){
        max = self.move;
        topMoodName = NEWS_ITEM_MOOD_MOVE;
    }
    
    if (max < self.worry){
        max = self.worry;
        topMoodName = NEWS_ITEM_MOOD_WORRY;
    }
    
    if (max < self.angry){
        max = self.angry;
        topMoodName = NEWS_ITEM_MOOD_ANGRY;
    }
    
    return topMoodName;
}

-(NSString*) getTopMoodResName{
    int max = self.happy;
    NSString* topMoodName = @"mood_newslist_happy";
    
    if (max < self.sad) {
        max = self.sad;
        topMoodName = @"mood_newslist_sad";
    }
    
    if (max < self.amaze){
        max = self.amaze;
        topMoodName = @"mood_newslist_amaze";
    }
    
    if (max < self.move){
        max = self.move;
        topMoodName = @"mood_newslist_move";
    }
    
    if (max < self.worry){
        max = self.worry;
        topMoodName = @"mood_newslist_worry";
    }
    
    if (max < self.angry){
        max = self.angry;
        topMoodName = @"mood_newslist_angry";
    }
    
    return topMoodName;
}

-(int) getPercentByType: (NSString*) type{
    int moodNum = 0;
    if (type == nil)
        return moodNum;
    
    if ([type compare:NEWS_ITEM_MOOD_HAPPY] == NSOrderedSame)
        moodNum = self.happy;
    else if ([type compare:NEWS_ITEM_MOOD_SAD] == NSOrderedSame)
        moodNum = self.sad;
    else if ([type compare:NEWS_ITEM_MOOD_AMAZE] == NSOrderedSame)
        moodNum = self.amaze;
    else if ([type compare:NEWS_ITEM_MOOD_MOVE] == NSOrderedSame)
        moodNum = self.move;
    else if ([type compare:NEWS_ITEM_MOOD_WORRY] == NSOrderedSame)
        moodNum = self.worry;
    else if ([type compare:NEWS_ITEM_MOOD_ANGRY] == NSOrderedSame)
        moodNum = self.angry;
    
    int percent = 0;
    int count = self.happy + self.sad + self.amaze + self.move + self.worry + self.angry;
    if (count > 0)
        percent = moodNum * 100 / count;
    
    return percent;
}

-(int) getTotalCount{
    return self.happy + self.sad + self.amaze + self.move + self.worry + self.angry;
}

-(void) setMyMoodType:(NSString *)mood{
    self.myMood = mood;
    
    if ([mood compare:NEWS_ITEM_MOOD_HAPPY] == NSOrderedSame){
        if (self.happy == 0)
            self.happy = 1;
    } else if ([mood compare:NEWS_ITEM_MOOD_SAD] == NSOrderedSame){
        if (self.sad == 0)
            self.sad = 1;
    } else if ([mood compare:NEWS_ITEM_MOOD_AMAZE] == NSOrderedSame){
        if (self.amaze== 0)
            self.amaze = 1;
    } else if ([mood compare:NEWS_ITEM_MOOD_MOVE] == NSOrderedSame){
        if (self.move == 0)
            self.move = 1;
    }else if ([mood compare:NEWS_ITEM_MOOD_WORRY] == NSOrderedSame){
        if (self.worry == 0)
            self.worry = 1;
    }else if ([mood compare:NEWS_ITEM_MOOD_ANGRY] == NSOrderedSame){
        if (self.angry == 0)
            self.angry = 1;
    }
}

-(NSString*) getMyMoodType{
    return self.myMood;
}

@end