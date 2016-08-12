//
//  GRVideoAdController.h
//  Go2ReachSample
//
//  Created by apple on 15/12/16.
//  Copyright © 2015年 Gmobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRNativeAd.h"
#import "GRAdService.h"

@interface GRVideoAdController : UIViewController

@property NSString* adPlacement;
@property int adIndex;
@property GRAdService* adService;
@property GRNativeAd* ad;
@property UIView* adView;
@property double timeout;

@end
