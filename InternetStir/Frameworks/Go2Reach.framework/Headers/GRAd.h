//
//  GRAd.h
//  Go2ReachSample
//
//  Created by apple on 15/9/7.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#ifndef Go2Reach_GRAd_h
#define Go2Reach_GRAd_h

#import <Foundation/Foundation.h>


@class GRAdService;

#define GR_AD_EVENT_IMPRESSION  1
#define GR_AD_EVENT_CLICK  2
#define GR_AD_EVENT_INSTALL  3
#define GR_AD_EVENT_RUN  4
#define GR_AD_EVENT_DOWNLOADING 5
#define GR_AD_EVENT_DOWNLOADED 6
#define GR_AD_EVENT_TRIAL 7
#define GR_AD_EVENT_PLAY 8
#define GR_AD_EVENT_VIEW 9
#define GR_AD_EVENT_CLICK2 10
#define GR_AD_EVENT_TRIGGER 11
#define GR_AD_EVENT_TIME_0  1000
#define GR_AD_EVENT_TIME_25  1025
#define GR_AD_EVENT_TIME_50  1050
#define GR_AD_EVENT_TIME_75  1075
#define GR_AD_EVENT_TIME_100  1100

#define GR_AD_STATUS_CREATED  0
#define GR_AD_STATUS_LOADING  1
#define GR_AD_STATUS_LOADED   2



@interface GRAd : NSObject

@property GRAdService* adService;
@property NSString* placement;
@property int count;
@property int status;

-(GRAd*) initAD: (GRAdService*) service
      placement: (NSString*) placement
          count: (int) count;

-(void) setAdStatus: (int) status;
-(int) getAdStatus;


@end

#endif
