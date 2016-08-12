//
//  GRRateBar.h
//  Go2ReachSample
//
//  Created by apple on 15/11/23.
//  Copyright © 2015年 Gmobi. All rights reserved.
//

#ifndef GRRateBar_h
#define GRRateBar_h

#import <UIKit/UIKit.h>
#import "IGRRateView.h"

@interface GRRateBar : UIView <IGRRateView>

@property int MaxCount;
@property NSMutableArray* selStars;
@property float rateing;

-(UIView*) initRateView: (CGRect) frame
                maxStar: (int) maxStar
                selStar: (double) star;

-(void) setRateingStar: (double) rate;


@end

#endif /* GRRateBar_h */
