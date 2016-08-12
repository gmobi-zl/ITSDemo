//
//  IGRVideoView.h
//  Go2Reach
//
//  Created by apple on 15/12/15.
//  Copyright © 2015年 Gmobi. All rights reserved.
//

#ifndef IGRVideoView_h
#define IGRVideoView_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol GRVideoViewDelegate <NSObject>

-(void) onBegin;
-(void) onEnd;
-(void) onPlaying: (NSTimeInterval) elapsed
            total: (NSTimeInterval) total;

@end

#endif /* IGRVideoView_h */
