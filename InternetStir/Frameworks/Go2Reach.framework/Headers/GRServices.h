//
//  GRServices.h
//  Go2Reach
//
//  Created by apple on 15/7/29.
//  Copyright (c) 2015年 Gmobi All rights reserved.
//

#ifndef Go2Reach_GRServices_h
#define Go2Reach_GRServices_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GRUserService.h"
#import "GRMessagingService.h"
#import "GRDeviceService.h"
#import "GRSettingsService.h"
#import "GRAdService.h"
#import "GRImageService.h"
#import "GRLocalHttpService.h"
#import "GRLogger.h"

#define GR_SDK @"Go2Reach"
#define GR_SDK_VERSION @"1.4.0"
#define GR_SDK_BUILD @"2016.07.19.1"

#define GR_SDK_APP_KEY @"Go2ReachAppKey"
#define GR_SDK_APP_SECRET @"Go2ReachAppSecret"
#define GR_SDK_SSO_SERVER_URI @"Go2ReachSSOServerUri"

#define GR_SDK_APP_CHANNEL @"Go2ReachAppChannel"

#define GR_SDK_AD_KEY @"Go2ReachADKey"
#define GR_SDK_AD_SERVER_URI @"Go2ReachADServerUri"
#define GR_SDK_AD_SHOW_SPLASH @"Go2ReachADShowSplash"

#define GR_SERVICE_TYPE_USER @"GRUserService"
#define GR_SERVICE_TYPE_MESSAGEING @"GRMessageService"
#define GR_SERVICE_TYPE_DEVICE @"GRDeviceService"
#define GR_SERVICE_TYPE_SETTING @"GRSettingService"
#define GR_SERVICE_TYPE_AD @"GRADService"
#define GR_SERVICE_TYPE_IMAGE @"GRImageService"
#define GR_SERVICE_TYPE_LOCALHTTPSERVER @"GRLocalHttpServer"

typedef enum {
    GRServiceTypeUser = 0,
    GRServiceTypeMessageing
}GRServicesType;



@interface GRServices : NSObject

+(void) debugMode: (BOOL) mode;

+(id) get: (NSString*) serviceClass;

-(id) createService: (NSString*) serviceClass;

+(void) start;
+(void) app2Foreground;
+(void) app2Background;

@end


#endif
