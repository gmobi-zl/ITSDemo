//
//  GRDeviceService.h
//  Go2Reach
//
//  Created by apple on 15/7/30.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#ifndef Go2Reach_GRDeviceService_h
#define Go2Reach_GRDeviceService_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "GRSystemHelper.h"


@interface GRDeviceService: NSObject

@property NSString* appChannel;
@property CTTelephonyNetworkInfo* networkStatus;
@property NSString* currentStatus;
@property NSString* bua;

-(void) initService;
-(NSString*) gerBrowserUA;
-(NSString*) getSDK;
-(NSString*) getSDKVersion;
-(NSString*) getSDKBuild;
-(NSString*) getAPPID;
-(NSString*) getAppChannel;
-(NSString*) getAPPVersion;
-(NSString*) getUA;
-(NSString*) getOS;
-(NSString*) getOSVersion;
-(NSString*) getAdvertisingID;
-(NSString*) getVendorID;

-(int) getScreenWidth;
-(int) getScreenHeight;
-(int) getScreenDPI;


-(NSMutableDictionary*) getDeviceInfoAsDict;
-(NSString*) getDeviceNetworkType;
@end

#endif
