//
//  IGRRateView.h
//  Go2ReachSample
//
//  Created by apple on 15/11/18.
//  Copyright © 2015年 Gmobi. All rights reserved.
//

#ifndef IGRRateView_h
#define IGRRateView_h

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

@protocol IGRRateView <NSObject>

-(void) setRate: (double) rate;

@optional
-(void) setMaxRate: (int) max;

@end

#endif /* IGRRateView_h */
