//
//  FeedBackController.h
//  PoPoNews
//
//  Created by apple on 15/6/10.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#ifndef PoPoNews_FeedBackController_h
#define PoPoNews_FeedBackController_h

#import <UIKit/UIKit.h>
@interface FeedBackController : UIViewController<UITextViewDelegate>


@property UITextView* feedbackMsg;
@property UIButton* sendBtn;
@property UIView* headerBg;
@property (assign) int Height;
@end


#endif
