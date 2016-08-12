//
//  NewsItem.m
//  PoPoNews
//
//  Created by apple on 15/4/22.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PoPoNewsItem.h"
#import "ITSAppConst.h"
#import "MMSystemHelper.h"
@implementation PoPoNewsItem
- (NSString *)getDateStringTimeStap:(NSInteger)date{
    NSDate *nd = [[NSDate alloc]initWithTimeIntervalSince1970:date/1000.0];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormat stringFromDate:nd];
    return dateString;
}

-(PoPoNewsItem*) initWithDictionary: (NSDictionary*) dic{

    if (dic == nil)
        return nil;
    
    NSString* tmpData = [dic objectForKey:NEWS_ITEM_ID];
    if (tmpData != nil)
        self.nId = tmpData;
    
    tmpData = [dic objectForKey:NEWS_ITEM_CATEGORY_ID];
    if (tmpData != nil)
        self.cId = tmpData;
    
    NSNumber* numData = [dic objectForKey:NEWS_ITEM_RELEASE_TIME];
    if (numData != nil)
        self.releaseTime = [numData longLongValue];
    
    tmpData = [dic objectForKey:NEWS_ITEM_TITLE];
    if (tmpData != nil)
        self.title = tmpData;
    
    NSArray* mmData = [dic objectForKey:NEWS_ITEM_MM];
    if (mmData != nil){
        NSMutableArray* tmpArray = [NSMutableArray arrayWithCapacity:2];
        for(NSDictionary* item in mmData){
            NewsImage* image = [[NewsImage alloc] initWithDictionary:item];
            [tmpArray addObject:image];
        }
        self.images = tmpArray;
    }
    
    numData = [dic objectForKey:NEWS_ITEM_COMMENT_COUNT];
    if (numData != nil) {
        self.comment_count = numData.intValue;
    }
    numData = [dic objectForKey:NEWS_ITEM_FAV];
    if (numData != nil)
        self.fav = numData.intValue;
    
    NSDictionary* moodData = [dic objectForKey:NEWS_ITEM_MOOD];
    if (moodData != nil){
        NewsMood* mood = [[NewsMood alloc] initWithDictionary:moodData];
        self.mood = mood;
    }
    
    tmpData = [dic objectForKey:NEWS_ITEM_PREVIEW];
    if (tmpData != nil)
        self.preview = tmpData;
    
    
    tmpData = [dic objectForKey:NEWS_ITEM_PDOMAIN];
    if (tmpData != nil)
        self.pDomain = tmpData;
    
    tmpData = [dic objectForKey:NEWS_ITEM_SOURCE];
    if (tmpData != nil)
        self.source = tmpData;
    
    tmpData = [dic objectForKey:NEWS_ITEM_BODY];
    if (tmpData != nil)
        self.body = tmpData;
    
    tmpData = [dic objectForKey:NEWS_ITEM_TYPE];
    if (tmpData != nil)
        self.type = tmpData;
    
    tmpData = [dic objectForKey:NEWS_ITEM_PNAME];
    if (tmpData != nil)
        self.pName = tmpData;
    
    tmpData = [dic objectForKey:NEWS_ITEM_PICON];
    if (tmpData != nil)
        self.pIcon = tmpData;
    
    numData = [dic objectForKey:NEWS_ITEM_GO2SOURCE];
    if (numData != nil) {
        self.go2source = [numData boolValue];
    }
    
    numData = [dic objectForKey:NEWS_ITEM_MY_FAV];
    if (numData != nil)
        self.isMyFav = [numData boolValue];
    else
        self.isMyFav = NO;
    
    numData = [dic objectForKey:NEWS_ITEM_DID_FAV];
    if (numData != nil)
        self.didFav = [numData boolValue];
    else
        self.didFav = NO;
    
    numData = [dic objectForKey:NEWS_ITEM_OFFLINE_DL];
    if (numData != nil)
        self.isOfflineDL = [numData boolValue];
    else
        self.isOfflineDL = NO;
    
    numData = [dic objectForKey:NEWS_ITEM_IS_READ];
    if (numData != nil)
        self.isRead = [numData boolValue];
    
    self.height = 0;
    [self initCellHeight];
    return self;
}


- (NSArray*) check3ImageStyle:(NSArray*) images{
    if (images == nil)
        return nil;
    
    int minW = 0, maxW = 0, minH = 0, maxH = 0;
    int totalW = 0, totalH = 0;
    int imgCount = (int)images.count;
    
    if (imgCount < 3)
        return nil;
    
    for (int i = 0; i < imgCount; i++) {
        NewsImage *image = [self.images objectAtIndex:i];
        if (image != nil){
            if (minW == 0)
                minW = image.w;
            
            if (minW > image.w)
                minW = image.w;
            
            if (maxW < image.w)
                maxW = image.w;
            
            if (minH == 0)
                minH = image.h;
            
            if (minH > image.h)
                minH = image.h;
            
            if (maxH < image.h)
                maxH = image.h;
            
            totalW += image.w;
            totalH += image.h;
        }
    }
    
    int maxMinWp = maxW / minW;
    int maxMinHp = maxH / minH;
    int aveW, aveH;
    if (maxMinWp > 5){
        totalW = totalW - minW - maxW;
        aveW = totalW / (imgCount - 2);
    } else
        aveW = totalW / imgCount;
    
    if (maxMinHp > 5){
        totalH = totalH - minH - maxH;
        aveH = totalH / (imgCount - 2);
    } else
        aveH = totalH / imgCount;
    
    int diffW = aveW / 4;
    int diffH = aveH / 4;
    
    NewsImage *preImage1 = nil;
    NewsImage *preImage2 = nil;
    NewsImage *preImage3 = nil;
    
    for (int i = 0; i < imgCount; i++) {
        NewsImage *image = [self.images objectAtIndex:i];
        if (image != nil){
            int tempDiffW = abs(aveW - image.w);
            int tempDiffH = abs(aveH - image.h);
            
            if (tempDiffW < diffW){
                if (preImage1 == nil || preImage2 == nil || preImage3 == nil){
                    if (preImage1 == nil)
                        preImage1 = image;
                    else if (preImage2 == nil)
                        preImage2 = image;
                    else if (preImage3 == nil)
                        preImage3 = image;
                } else
                    break;
            }
        }
    }
    
    if (preImage1 != nil && preImage2 != nil && preImage3 != nil){
        NSArray* preImgArray = [[NSArray alloc] initWithObjects:preImage1, preImage2, preImage3, nil];
        return preImgArray;
    }
    
    return nil;
}

- (void)initCellHeight{
    
    CGFloat screenW = [MMSystemHelper getScreenWidth];
    CGSize size;
    UILabel *label = [[UILabel alloc] init];

    if (self.images.count > 0) {
        
//        NewsImage *image = [[NewsImage alloc] init];
//        for (NSInteger i = 0; i < self.images.count; i++) {
//            for (NSInteger j = 0; j < self.images.count - i - 1; j++) {
//                NewsImage *newsImage = [self.images objectAtIndex:j];
//                NewsImage *nextImage = [self.images objectAtIndex:j+1];
//                if (newsImage.w < nextImage.w || newsImage.h < nextImage.h) {
//                    image = self.images[j];
//                    self.images[j] = self.images[j+1];
//                    self.images[j+1] = image;
//                }
//            }
//        }
//        image = [self.images objectAtIndex:0];
        
        NewsImage *image = [self.images objectAtIndex:0];
        for (NSInteger i = 0; i < self.images.count; i++) {
            NewsImage *tempImg = [self.images objectAtIndex:i];
            if (image == nil){
                image = tempImg;
            } else {
                if (tempImg.w > image.w || tempImg.h > image.h){
                    image = tempImg;
                }
            }
        }
        self.maxImg = image;
        
//        NewsImage *image = [self.images objectAtIndex:0];
        
        self.image3Array = [self check3ImageStyle:self.images];
        if (self.image3Array != nil){
        //if (self.images.count > 3) {
            self.newsShowType = NEWS_SHOW_TYPE_THREEIMAGE;
            CGFloat titleY = 10;
            CGFloat titleWidth = screenW - 15 - 25;
//            size = [MMSystemHelper sizeWithString:self.title font:[UIFont systemFontOfSize:18] maxSize:CGSizeMake(titleWidth, MAXFLOAT)];
            
            label.frame = CGRectMake(15, titleY, titleWidth, 0);
            label.numberOfLines = 2;
            label.font = [UIFont systemFontOfSize:18];
            label.text = self.title;
            size = [label sizeThatFits:CGSizeMake(titleWidth, MAXFLOAT)];
            
            CGFloat titleHeight = size.height;
            CGFloat iconY = titleY + titleHeight + 3;
            CGFloat width = (screenW - 34)/3;
            CGFloat iconH = 9 * width/16;
            
            self.height = 20 + 7 + 5 + iconH + iconY;
            
        } else if (image.h >= 372 || image.w >= 660){
            self.newsShowType = NEWS_SHOW_TYPE_BIGIMAGE;
            CGFloat titleY = 10;
            label.frame = CGRectMake(15, titleY, screenW - 30, 0);
            label.numberOfLines = 2;
            label.font = [UIFont systemFontOfSize:18];
            label.text = self.title;
            size = [label sizeThatFits:CGSizeMake(screenW - 30, MAXFLOAT)];
            CGFloat titleH = size.height;

            CGFloat iconY = titleY + titleH + 3;
            CGFloat iconH = 9 * (screenW - 30)/16;
            self.height = iconY + iconH + 10 + 20 + 5 ;
            
        }else{
            self.newsShowType = NEWS_SHOW_TYPE_RIGHTIMAGE;
            CGFloat iconY = 10;
            CGFloat iconH = 70;
            self.height = iconY + iconH + 10 + 20 + 5;
        }
    }else{
        self.newsShowType = NEWS_SHOW_TYPE_TITLE;
        CGFloat titleY = 10;
        label.frame = CGRectMake(15, titleY, screenW - 30, 0);
        label.numberOfLines = 2;
        label.font = [UIFont systemFontOfSize:18];
        label.text = self.title;
        size = [label sizeThatFits:CGSizeMake(screenW - 30, MAXFLOAT)];
        CGFloat titleH = size.height;
        
        self.height = titleH + titleY + 5 + 20 + 5 ;
    }
    
}
-(NSMutableDictionary*) toDictionaryDataHasReadStatus{
    NSMutableDictionary* info = [self toDictionaryData];
    if (info != nil){
        NSNumber* numData = [NSNumber numberWithLong:self.isRead];
        if (numData != nil)
            [info setObject:numData forKey:NEWS_ITEM_IS_READ];
    }
    
    return info;
}

-(NSMutableDictionary*) toDictionaryData {
    NSMutableDictionary* retDic = [NSMutableDictionary dictionaryWithCapacity:2];
    
    if (self.nId != nil)
        [retDic setObject:self.nId forKey:NEWS_ITEM_ID];
    
    if (self.cId != nil)
        [retDic setObject:self.cId forKey:NEWS_ITEM_CATEGORY_ID];
    
    NSNumber* numData = [NSNumber numberWithLong:self.releaseTime];
    if (numData != nil)
        [retDic setObject:numData forKey:NEWS_ITEM_RELEASE_TIME];
    
    if (self.title != nil)
        [retDic setObject:self.title forKey:NEWS_ITEM_TITLE];
    
    if (self.images != nil){
        NSMutableArray* tmpImgArray = nil;
        for (NewsImage* item in self.images) {
            if (item != nil) {
                if (tmpImgArray == nil)
                    tmpImgArray = [NSMutableArray arrayWithCapacity:1];
                
                NSMutableDictionary* imgDic = [item toDictionaryData];
                [tmpImgArray addObject:imgDic];
            }
        }
        if (tmpImgArray != nil)
            [retDic setObject:tmpImgArray forKey:NEWS_ITEM_MM];
    }
    
    numData = [NSNumber numberWithLong:self.fav];
    if (numData != nil)
        [retDic setObject:numData forKey:NEWS_ITEM_FAV];
    
    if (self.mood != nil){
        NSMutableDictionary* moodDic = [self.mood toDictionaryData];
        if (moodDic != nil)
            [retDic setObject:moodDic forKey:NEWS_ITEM_MOOD];
    }
    
    if (self.preview != nil)
        [retDic setObject:self.preview forKey:NEWS_ITEM_PREVIEW];
    
    if (self.pDomain != nil)
        [retDic setObject:self.pDomain forKey:NEWS_ITEM_PDOMAIN];
    
    if (self.source != nil)
        [retDic setObject:self.source forKey:NEWS_ITEM_SOURCE];
    
    if (self.body != nil)
        [retDic setObject:self.body forKey:NEWS_ITEM_BODY];
    
    if (self.type != nil)
        [retDic setObject:self.type forKey:NEWS_ITEM_TYPE];
    
    if (self.pName != nil)
        [retDic setObject:self.pName forKey:NEWS_ITEM_PNAME];
    
    if (self.pIcon != nil)
        [retDic setObject:self.pIcon forKey:NEWS_ITEM_PICON];
    
    
    numData = [NSNumber numberWithBool:self.go2source];
    if (numData != nil) {
        [retDic setObject:numData forKey:NEWS_ITEM_GO2SOURCE];
    }
    
    numData = [NSNumber numberWithBool:self.isMyFav];
    if (numData != nil)
        [retDic setObject:numData forKey:NEWS_ITEM_MY_FAV];
    
    numData = [NSNumber numberWithBool:self.didFav];
    if (numData != nil)
        [retDic setObject:numData forKey:NEWS_ITEM_DID_FAV];
    
    if (self.isOfflineDL == YES){
        numData = [NSNumber numberWithBool:self.isOfflineDL];
        if (numData != nil)
            [retDic setObject:numData forKey:NEWS_ITEM_OFFLINE_DL];
    }
    if (self.newsShowType != nil) {
        [retDic setObject:self.newsShowType forKey:NEWS_INIT_SHOWTYPE];
    }
    numData = [NSNumber numberWithFloat:self.height];
    if (numData != nil) {
        [retDic setObject:numData forKey:NEWS_INIT_HEIGHT];
    }
    return retDic;
}

-(void) setNewsInitType: (int) type{
    self.initType = type;
}

-(int) getNewsInitType{
    return self.initType;
}

@end