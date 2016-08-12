//
//  GRAdService.h
//  Go2ReachSample
//
//  Created by apple on 15/9/7.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#ifndef Go2Reach_GRAdService_h
#define Go2Reach_GRAdService_h

#import <Foundation/Foundation.h>
#import "GRJsonDatabase.h"
#import "GRImageHolder.h"
#import "GRSettingsService.h"
#import "GRAdAudience.h"
#import "GRDeviceService.h"
#import "GRImageService.h"
#import "GRAdItem.h"
#import "GRNativeAd.h"

@class GRAdItem;
@class GRNativeAd;
@class GRBannerAd;
@class GRInterstitialAd;

#define GRAD_CONNECT_TIMEOUT (60*3*1000)

typedef void (^GRAdCallback)(int resultCode, NSDictionary* result);

typedef enum{
    GRAD_CONNECTING,
    GRAD_CONNECTED,
    GRAD_ERROR,
    GRAD_NONE
}GRAdConnectStatus;



@interface GRAdService : NSObject

@property NSMutableDictionary* ads;
@property GRSettingsService* setting;
@property GRImageService* imageService;
@property GRAdConnectStatus status;
@property GRJsonDatabase* db;
@property GRCollection* colData;
@property GRAdAudience* audience;
@property GRDeviceService* deviceService;
@property BOOL showSplash;
@property NSInteger splashInterval;
@property NSMutableArray* splashExcludedKeywords;
@property NSInteger splashDailyQuota;
@property NSInteger splashTimeout;
@property NSString* adKey;
@property NSString* server;
@property NSString* fileUrlTpl;
@property NSString* actInterstitialAd;
@property BOOL record;


-(GRAdService*) initService: (GRSettingsService*) setting
                  deviceSvr: (GRDeviceService*) deviceSvr
                   imageSvr: (GRImageService*) imgSvr;

-(NSString*) getDeviceId;
-(void) setDeviceId: (NSString*) val;
-(BOOL) isSplashEnabled;
-(void) setSplashEnabled: (BOOL) val;
-(long) getSplashLastDisplayTime;
-(void) setSplashLastDisplayTime: (long) val;
-(long) getSplashDisplayTime;
-(void) setSplashDisplayTime: (long) val;
-(NSString*) getSessionId;
-(void) setSessionId: (NSString*) val;

-(NSString*) getCookie;
-(void) saveCookie: (NSMutableDictionary*) val;
-(NSMutableDictionary*) addCookie: (NSMutableDictionary*) val;

-(NSString*) getServerUrl: (NSString*) path;
-(NSString*) getFileUrl: (NSString*) fId;

-(NSMutableDictionary*) getDeviceInfo;
-(BOOL) isConnected;
-(BOOL) isConnectedOrConnecting;
-(BOOL) ensureConnected: (long) timeOut;

-(void) reportEvent: (NSString*) plm
               item: (GRAdItem*) item
              event: (int) event;

-(void) reportEvent: (NSString*) plm
              event: (int) event
              ctvId: (NSString*) ctvId
              cmpId: (NSString*) cmpId
              grpId: (NSString*) grpId;

-(void) reportApp: (NSString*) ac
             apps: (NSMutableArray*) apps;

-(void) collectData;
-(void) reconnect;
-(void) connect;
-(void) fetch: (NSString*) placement
         type: (NSString*) type
   imageWidth: (int) imageWidth
  imageHeight: (int) imageHeight
        count: (int) count
requiredFields: (NSMutableArray*) requiredFields
           cb: (GRAdCallback) cb;
-(NSString*) getActiveInterstitialAd;
-(void) setActiveInterstitialAd: (NSString*) plm;

-(GRBannerAd*) getBannerAd: (NSString*) placement;
-(GRBannerAd*) getBannerAd: (NSString*) placement
                imageWidth: (int) imageWidth
               imageHeight: (int) imageHeight
            requiredFields: (NSMutableArray*) requiredFields;
//-(GRInterstitialAd*) getInterstitialAd: (NSString*) placement;
-(GRNativeAd*) getNativeAd: (NSString*) placement
       preferredImageWidth: (int) preferredImageWidth
      perferredImageHeight: (int) preferredImageHeight
                     count: (int) count
            requiredFields: (NSMutableArray*) requiredFields;

-(GRInterstitialAd*) getInterstitialAd: (NSString*) placement;
-(GRInterstitialAd*) getInterstitialAd: (NSString*) placement
                         portraitWidth: (int) portraitWidth
                        portraitHeight: (int) portraitHeight
                        landscapeWidth: (int) landscapeWidth
                       landscapeHeight: (int) landscapeHeight
                        requiredFields: (NSArray*) requiredFields;

-(id) getAd: (NSString*) placement;

@end


#endif
