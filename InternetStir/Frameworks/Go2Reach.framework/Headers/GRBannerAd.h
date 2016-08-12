//
//  GRBannerAd.h
//  Go2ReachSample
//
//  Created by apple on 15/10/20.
//  Copyright © 2015年 Gmobi. All rights reserved.
//

#ifndef GRBannerAd_h
#define GRBannerAd_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "GRNativeAd.h"
#import "GRRateBar.h"
#import "SKMRAIDView.h"

@interface GRBannerAd : GRNativeAd

@property int interval;
@property UIView* vhContainer;
@property GRRateBar* grRate;
@property UIImageView* vhImage;
@property UIView* vhIconAndText;
@property SKMRAIDView* vhHtml;

//@property WKWebView* checkWB;

@property UIButton* btnCta;
@property UIImageView* ivIcon;
@property UILabel* lTitle;
@property UILabel* lSubTitle;

-(GRBannerAd*) initBannerAd: (GRAdService*) service
                  placement: (NSString*) placement
                  viewWidth: (int) viewWidth
                 viewHeight: (int) viewHeight
             requiredFields: (NSArray*) requiredFields;

-(void) setReloadInterval: (int) secs;
-(void) stopReloadInterval;

-(UIView*) create;

@end

#endif /* GRBannerAd_h */
