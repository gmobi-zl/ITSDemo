//
//  PNNativeAdItem.m
//  PoPoNews
//
//  Created by apple on 16/5/11.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PNNativeAdItem.h"
#import "MMLogger.h"

@implementation PNNativeAdItem

-(void) initWithData: (NSString*) adId
               count: (int) count{
    self.isShow = NO;
    self.isLoad = NO;
    self.isloop = YES;
    self.currentIndex = -1;
    
    
    GRAdService* adService = [GRServices get:GR_SERVICE_TYPE_AD];
    self.ad = [adService getNativeAd:adId preferredImageWidth:400 perferredImageHeight:300 count:20 requiredFields:nil];
    self.ad.grAdDelegate = self;
            
//    NSMutableDictionary* eParams = [NSMutableDictionary dictionaryWithCapacity:1];
//    [eParams setObject:@"gmobi" forKey:@"provider"];
//    NSNumber* countNum = [[NSNumber alloc] initWithInt:self.adCount];
//    eParams setObject:countNum forKey:@"count"];
//    [poApp.reportSvr recordEvent:@"news.list.ad" params:eParams timed:YES];
}

-(int)getRandomValue {
    int value = arc4random()%100 + 1;
    return value;
}

-(void)load{
    [self.ad load];
}

-(void) GRAdOnLoaded: (id) sender
          resultCode: (int) resultCode
              result: (id) result{
    self.isLoad = YES;
//    PopoApplication* poApp = [PopoApplication get];
//    DataService* ds = poApp.dataSvr;
//    
//    for (NativeAdItem *AdItem in ds.itemData.nativeAdData) {
//        NSInteger gmAdCount = [self getCount:AdItem];
//        for (NSInteger i = 0; i < gmAdCount; i++) {
//            GRAdItem *gmobiAd = [AdItem.ad.items objectAtIndex:i];
//            if (gmobiAd != nil) {
//                [ds.gmobiAd addObject:gmobiAd];
//            }
//        }
//    }
    
//    NSMutableDictionary* eParams = [NSMutableDictionary dictionaryWithCapacity:1];
//    [eParams setObject:@"gmobi" forKey:@"provider"];
//    NSNumber* countNum = [[NSNumber alloc] initWithInt:self.adCount];
//    [eParams setObject:countNum forKey:@"count"];
//    [poApp.reportSvr recordEndTimedEvent:@"news.list.ad" params:eParams];
}

-(int) getCount{
    if (self.ad && self.isLoad == YES){
        return [self.ad getAdCount];
    }
    return 0;
}

-(id) getAdItem: (int) index{
    int count = [self getCount];
    if (count > 0 && index >= 0){
        GRAdItem *gAd = [self.ad.items objectAtIndex:index];
        return gAd;
    }
    
    return nil;
}

-(id) getCurrentItem{
    return [self getAdItem:self.currentIndex];
}

-(void) currentItemOnClicked{
    GRAdItem* gAd = [self getCurrentItem];
    if (gAd != nil){
        [gAd go];
    }
}

-(id) getNextItem{
    int count = [self getCount];
    
    if (self.currentIndex < 0){
        self.currentIndex = 0;
    } else if (self.currentIndex >= (count-1)){
        if (self.isloop == YES){
            self.currentIndex = 0;
        } else
            return nil;
    } else {
        self.currentIndex++;
    }
    
    return [self getAdItem:self.currentIndex];
}

@end