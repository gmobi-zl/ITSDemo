//
//  SystemHelper.h
//  momock
//
//  Created by apple on 15/4/1.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#ifndef momock_GRSystemHelper_h
#define momock_GRSystemHelper_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "GRReachability.h"

typedef enum{
    GRNoNet = 0,     //无网络连接
    GRWifiNet,        //wifi网络
    GROtherNet,       //gprs/3g网络
}GRNetWorkType;

@interface GRStoreKitController: UIViewController <SKStoreProductViewControllerDelegate>

@end

@interface GRSystemHelper:NSObject

+(CGFloat) getScreenScale;
+(CGFloat) getScreenWidth;
+(CGFloat) getScreenHeight;
+(CGFloat) getStatusBarHeight;
+(NSString*) getAppVersion;
+(NSString*) getIdForVendor;
+(NSString*) getIdForAD;
+(NSString*) getUA;
+(NSString*) getOSVersion;
+(NSString*) getTimeStamp;
+(NSString*) getTimeStampSeconds;
+(UInt64) getMillisecondTimestamp;
+(NSString*) getLanguage;
+(NSString*) getCountry;
+(NSString*) getAppPackageId;

+(NSString*) dateFormatStr: (long) time
                    format: (NSString*) uFormat;

+(NSString*) encodeString:(NSString*)unencodedString;
+(NSString*) decodeString:(NSString*)encodedString;


+(long) fileSizeForDir:(NSString*)path;
+(void) removeFileForDir:(NSString*)path;

/**
 * str : #FF00FF or #FF00FFFF
 */
+(UIColor *) string2UIColor:(NSString *)str;

+(void) startCheckNetworkType;
+(void) stopCheckNetworkType;
+(GRNetWorkType) getNetworkType;
+(BOOL) isConnectedToNetwork;

//根据字符串内容的多少  在固定宽度 下计算出实际的行高
+ (CGFloat)textHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)size;
//获取 当前设备版本
+ (double)getCurrentIOS;

+(NSString*) getMd5String:(NSString *)src;


+(NSString*) gb2312ToUTF8:(NSData *) data;


+(id) getAppInfoPlistData: (NSString*) key
                 defValue: (id) value;

+(NSString*) getAdvertisingID;
+(NSString*) getVendorID;


+(void) openSystemWebUrl: (NSString*) url;
+(void) openSystemWebNSUrl: (NSURL*) url;

+(NSString*) getGRCacheFolder;
+(NSString*) DictTOjsonString:(id)object;

+(void) openAppStoreByWeb: (NSString*) appId;
+(void) openAppStore: (NSString*) appId;

+(int) minInt: (int) i1
          i2: (int) i2;

+(int) maxInt: (int) i1
          i2: (int) i2;
+(UIViewController*) getCurrentVC;
+(UIViewController*) getTopPresentedViewController;

+(BOOL) currentVCIsPortrait;

+(NSBundle*) findBundle: (NSString*) bundleName;

+(CGSize)sizeWithFont: (NSString*) str font:(UIFont *)font maxSize:(CGSize)maxSize;

//+(void) setDeviceOrientation: (UIDeviceOrientation) ori;
//+(void) setStatusbarOrientation: (UIInterfaceOrientation) ori;

+ (BOOL)hasString: (NSString*) str
              key: (NSString*) key;

@end

#endif
