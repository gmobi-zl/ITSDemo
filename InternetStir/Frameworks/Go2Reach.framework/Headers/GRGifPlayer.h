//
//  GRGifPlayer.h
//  Go2ReachSample
//
//  Created by apple on 15/11/27.
//  Copyright © 2015年 Gmobi. All rights reserved.
//

#ifndef GRGifPlayer_h
#define GRGifPlayer_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/** if animationRepeatCount = n (n>0)
 *  RepeatCount animation finished can receive this notification: kReapeatCountAnimationFinishedNotification
 */
extern  NSString *const kReapeatCountAnimationFinishedNotification;

@interface GRGifPlayer : NSObject

/**
 *  @brief default runLoopMode is NSDefaultRunLoopMode
 */
@property (nonatomic, copy) NSString *runLoopMode;
@property UIImageView* pView;

- (id)initWithGIFPath:(NSString *)gifPath;
- (void)setGIFPath:(NSString *)gifPath;

- (void)startAnimating;
- (void)stopAnimating;
@end


#endif /* GRGifPlayer_h */
