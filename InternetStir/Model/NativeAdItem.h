//
//  NativeAdItem.h
//  PoPoNews
//
//  Created by Apple on 15/12/1.
//  Copyright © 2015年 Gmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Go2Reach/GRServices.h"
//#import <FBAudienceNetwork/FBAudienceNetwork.h>

//@interface NativeAdItem : NSObject<GRAdCallbackDelegate,FBNativeAdDelegate,FBNativeAdsManagerDelegate>
@interface NativeAdItem : NSObject<GRAdCallbackDelegate>
@property (assign) BOOL isLoad;
@property (assign) BOOL isShow;
@property (assign) BOOL FbIsLoad;
@property (assign) NSInteger FbPosition;
@property (assign) int position;
@property (assign) int adCount;
@property (assign) BOOL isError;
@property (assign) BOOL isloop;
@property (assign) int index;
@property (copy) NSString* type;
@property (nonatomic, strong) GRNativeAd *ad;
//@property (nonatomic, strong)  FBNativeAdsManager *adsManager;
@property (retain) NSMutableArray* adItem;
-(void) initWithData: (NSString*) adId :(int) count :(NSString*) type;
-(void) load;
-(int) getCount:(NativeAdItem*)item;
-(id) getAd;

@end
