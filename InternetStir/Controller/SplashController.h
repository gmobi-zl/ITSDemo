//
//  SplashController.h
//  InternetStir
//
//  Created by apple on 16/8/12.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#ifndef SplashController_h
#define SplashController_h

#import <UIKit/UIKit.h>
//#import "GAI.h"
//#import "GAIDictionaryBuilder.h"
//#import "GAITrackedViewController.h"


//@interface SplashController : GAITrackedViewController
@interface SplashController : UIViewController

@property (nonatomic, strong) UIImageView *bgImage;


@property (assign) BOOL isWaitMaxTime;
@property (assign) BOOL isConnected;
@property BOOL isReconnect;

@end

#endif /* SplashController_h */
