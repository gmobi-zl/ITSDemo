//
//  GRVideoView.h
//  Go2ReachSample
//
//  Created by apple on 15/12/7.
//  Copyright © 2015年 Gmobi. All rights reserved.
//

#ifndef GRVideoView_h
#define GRVideoView_h


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef enum : NSInteger {
    GRVideoStateUnload = 0,
    GRVideoStateStop,
    GRVideoStateWait,
    GRVideoStatePlay,
    GRVideoStatePause,
    GRVideoStateFinish,
    GRVideoStateError,
} GRVideoPlayState;

@interface GRVideoView : UIView



+(void) setDidAutoPlay: (BOOL) state;

-(id) initVideoWithFrame: (CGRect) viewFrame;

-(void) setBackgroundImage: (UIImage*) image
                      size: (CGSize) size;
-(void) setVideoUrlStr: (NSString*) url;
-(void) setVideoUrl: (NSURL*) url;
-(void) setVideoListener: (id) listener;
-(BOOL) isFullScreen;
-(void) closeFullScreen;
-(void) videoClose;
-(UIImageView*) getCoverImageView;

-(void) setVideoAutoPlay: (BOOL) state;
-(void) setCanShowAreaRect: (CGRect) rect;

@end

#endif /* GRVideoView_h */
