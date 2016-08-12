//
//  AdItem.h
//  PoPoNews
//
//  Created by Apple on 15/12/1.
//  Copyright © 2015年 Gmobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NativeAd : NSObject
@property (assign) BOOL enabled;
@property (assign) NSNumber* count;
@property (retain) NSNumber* fb;
@end

@interface BannerAd : NSObject
@property (assign) BOOL enabled;
@property (retain) NSNumber* fb;
@end

@interface InterstitialAd : NSObject
@property (assign) BOOL enabled;
@property (assign) NSNumber* time;
@property (retain) NSNumber* percent;
@property (retain) NSNumber* fb;
@end

//ad4
@interface Interstitial : NSObject
@property (assign) BOOL enabled;
@property (assign) NSNumber* time;
@property (retain) NSNumber* percent;
@property (retain) NSNumber* fb;
@end

//ad5
@interface DetailAd : NSObject
@property (assign) BOOL enabled;
@property (retain) NSNumber* percent;
@end
