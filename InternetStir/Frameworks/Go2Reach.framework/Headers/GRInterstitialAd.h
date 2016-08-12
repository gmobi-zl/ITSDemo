//
//  GRInterstitialAd.h
//  Go2ReachSample
//
//  Created by apple on 15/11/6.
//  Copyright © 2015年 Gmobi. All rights reserved.
//

#ifndef GRInterstitialAd_h
#define GRInterstitialAd_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GRNativeAd.h"
#import "GRRateBar.h"
#import "SKMRAIDView.h"

#define GR_ISAD_PENDINT_NONE  0
#define GR_ISAD_PENDINT_POPUP 1
#define GR_ISAD_PENDINT_POPUP_AS_TOAST  2

#define GR_ISAD_SIZE_NONE 0
#define GR_ISAD_SIZE_FULL_SCREEN -1

@interface GRInterstitialAd : GRNativeAd

@property UIView* vhContainer;
@property UIView* vhInnerContainer;
@property UIImageView* ivImage;
@property UIImageView* ivIcon;
@property UILabel* tvTitle;
@property GRRateBar* grRate;
@property UILabel* tvSubTitle;
@property UITextView* tvBody;
@property UIButton* btnC2A;
@property UIButton* btnClose;
@property UIViewController* adController;
@property SKMRAIDView* vhHtml;

@property int pendingAction;
@property int portraitWidth;
@property int portraitHeight;
@property int landscapeWidth;
@property int landscapeHeight;
@property double timeout;

-(GRInterstitialAd*) initInterstitialAd: (GRAdService*) service
                              placement: (NSString*) placement
                          portraitWidth: (int) portraitWidth
                         portraitHeight: (int) portraitHeight
                         landscapeWidth: (int) landscapeWidth
                        landscapeHeight: (int) landscapeHeight
                         requiredFields: (NSArray*) requiredFields;

-(UIView*) getView;
-(UIView*) create;
-(void) popup;
-(void) popup: (double) timeout;
-(void) close;

@end


#endif /* GRInterstitialAd_h */
