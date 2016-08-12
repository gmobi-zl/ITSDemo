//
//  GRAdItem.h
//  Go2ReachSample
//
//  Created by apple on 15/9/7.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#ifndef Go2Reach_GRAdItem_h
#define Go2Reach_GRAdItem_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "IGRAdItem.h"
#import "GRVideoView.h"

#define GR_AD_ITEM_VIDEO_AD_C2A_CLICK @"grAdItemVideoAdC2AClicked"
#define GR_AD_MSG_CLOSE_INTERSTITIAL @"grAdMsgCloseInterstitial"

@class GRAdService;
@class GRNativeAd;


@interface GRAdItem : NSObject
@property GRAdService* adService;
@property GRNativeAd* ad;
@property int index;
@property BOOL shown;

-(GRAdItem*) initItem: (GRAdService*) service
             nativeAd: (GRNativeAd*) nativeAd
                index: (int) index;

-(UIColor*) getBorderColor;
-(UInt64) getBorderWidth;
-(GRAdRichWebView*) parseRichWebView: (NSString*) name;
-(GRAdImage*) parseImage: (NSString*) name;
-(UIColor*) parseColor: (NSString*) color;
-(NSDictionary*) getRawData;
-(void) bindGRVideoPlayer: (GRVideoView*) p;
-(id) get: (NSString*) propName;
-(BOOL) isAvailable;
-(BOOL) has: (NSString*) propName;
-(CGSize) getImageSize: (NSString*) propName;
-(void) open: (NSString*) url;
-(void) go;
-(void) bind: (NSMutableDictionary*) views;

-(BOOL) isShown;
-(UIView*) composeVideoAdView;
-(void) closeVideoAdView;
-(void) updateVideoAdViewFrame;

-(NSMutableArray*) getTrackUrls: (NSString*) key;

@end



#endif
