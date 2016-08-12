

//
//  NativeAdItem.m
//  PoPoNews
//
//  Created by Apple on 15/12/1.
//  Copyright © 2015年 Gmobi. All rights reserved.
//

#import "NativeAdItem.h"
#import "MMLogger.h"
#import "ITSAppConst.h"
#import "ITSApplication.h"
@implementation NativeAdItem
//-(void) initWithAdData: (int) count :(NSMutableArray*) arr{
//
//    for (int i = 0; i < (arr.count - 1); i++) {
//        
//        PopoNewsData* itemData = [arr objectAtIndex:i];
//        if (itemData.nativeAdData == nil)
//            itemData.nativeAdData = [NSMutableArray arrayWithCapacity:1];
//        NSString *cid = itemData.category.cId;
//        NativeAdItem *item = [[NativeAdItem alloc] init];
//        
//        PopoApplication* app = [PopoApplication get];
//        NSString* adId = [app.dataSvr getNativedAdPlacement:cid];
//       // [item initWithData:[self getNativedAdPlacement:cid] :count];
//      //  [self initWithData:adId :count];
//        [item load];
//        [itemData.nativeAdData addObject:item];
//    }
//
//}
-(void) initWithData: (NSString*) adId :(int) count :(NSString*) type{
    self.isShow = NO;
    self.position = -1;
    self.FbPosition = -1;
    self.index = 0;
    self.isLoad = NO;
    self.FbIsLoad = NO;
    self.isloop = NO;
    self.adCount = count;
   
//    PopoApplication* poApp = [ITSApplication get];
//    DataService* ds = poApp.dataSvr;
//    
//    BOOL isOpenAd = ds.minikitCh.nativeAd.enabled;
//    if (isOpenAd == YES) {
//        if ([type compare:@"fbAd"] == NSOrderedSame) {
//            
//            self.adsManager = [[FBNativeAdsManager alloc] initWithPlacementID:FACEBOOK_LIST_PLACEMENT_ID forNumAdsRequested:ds.categoryList.count * count];
//            self.adsManager.delegate = self;
//            [self.adsManager loadAds];
//            
//            NSMutableDictionary* eParams = [NSMutableDictionary dictionaryWithCapacity:1];
//            [eParams setObject:@"facebook" forKey:@"provider"];
//            NSNumber* countNum = [[NSNumber alloc] initWithInt:self.adCount];
//            [eParams setObject:countNum forKey:@"count"];
//            [poApp.reportSvr recordEvent:@"facebook" params:eParams timed:YES eventCategory:@"news.list.ad"];
//            
//        }else{
//            GRAdService* adService = [GRServices get:GR_SERVICE_TYPE_AD];
//            self.ad = [adService getNativeAd:adId preferredImageWidth:400 perferredImageHeight:300 count:ds.categoryList.count * count requiredFields:nil];
//            self.adItem = self.ad.items;
//            self.ad.grAdDelegate = self;
//            
//            NSMutableDictionary* eParams = [NSMutableDictionary dictionaryWithCapacity:1];
//            [eParams setObject:@"gmobi" forKey:@"provider"];
//            NSNumber* countNum = [[NSNumber alloc] initWithInt:self.adCount];
//            [eParams setObject:countNum forKey:@"count"];
//            [poApp.reportSvr recordEvent:@"gmobi" params:eParams timed:YES eventCategory:@"news.list.ad"];
//
//        }
//    }
}
-(int)getRandomValue {
    int value = arc4random()%100 + 1;
    return value;
}
//- (void)nativeAdDidLoad:(FBNativeAd *)nativeAd
//{
//    self.FbIsShow = YES;
//}

-(void)load{
    [self.ad load];
}

-(void) GRAdOnLoaded: (id) sender
          resultCode: (int) resultCode
              result: (id) result{
    self.isLoad = YES;
//    ITSApplication.h* poApp = [ITSApplication.h get];
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
//    
//    NSMutableDictionary* eParams = [NSMutableDictionary dictionaryWithCapacity:1];
//    [eParams setObject:@"gmobi" forKey:@"provider"];
//    NSNumber* countNum = [[NSNumber alloc] initWithInt:self.adCount];
//    [eParams setObject:countNum forKey:@"count"];
//    [poApp.reportSvr recordEndTimedEvent:@"news.list.ad" params:eParams];
}

-(int) getCount :(NativeAdItem*)item{
    if (item.ad && item.isLoad == YES){
        return [item.ad getAdCount];
    }
    return 0;
}
@end
