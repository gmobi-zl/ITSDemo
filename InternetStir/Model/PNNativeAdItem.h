//
//  PNNativeAdItem.h
//  PoPoNews
//
//  Created by apple on 16/5/11.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#ifndef PNNativeAdItem_h
#define PNNativeAdItem_h

#import <Foundation/Foundation.h>
#import "Go2Reach/GRServices.h"


@interface PNNativeAdItem : NSObject<GRAdCallbackDelegate>
@property (assign) BOOL isLoad;
@property (assign) BOOL isShow;
@property (assign) BOOL isloop;
@property (assign) int currentIndex;
@property (nonatomic, strong) GRNativeAd *ad;
//@property (retain) NSMutableArray* adItem;

-(void) initWithData: (NSString*) adId
               count: (int) count;

-(void) load;
-(int) getCount;
-(id) getAdItem: (int) index;
-(id) getCurrentItem;
-(void) currentItemOnClicked;
-(id) getNextItem;

@end

#endif /* PNNativeAdItem_h */
