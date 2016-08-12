//
//  GRInterstitialAdController.h
//  Go2ReachSample
//
//  Created by apple on 15/11/9.
//  Copyright © 2015年 Gmobi. All rights reserved.
//

#ifndef GRInterstitialAdController_h
#define GRInterstitialAdController_h


#import <UIKit/UIKit.h>
#import "GRAdService.h"
#import "GRInterstitialAd.h"

@interface GRInterstitialAdController : UIViewController <GRAdCallbackDelegate>

@property NSString* adPlacement;
@property GRInterstitialAd* interAd;
@property GRAdService* adService;
@property UIView* adView;
@property double timeout;

@end

#endif /* GRInterstitialAdController_h */
