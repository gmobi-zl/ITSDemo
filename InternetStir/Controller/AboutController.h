//
//  AboutController.h
//  PoPoNews
//
//  Created by apple on 15/6/10.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#ifndef PoPoNews_AboutController_h
#define PoPoNews_AboutController_h

#import <UIKit/UIKit.h>
@interface AboutController : UIViewController<UIGestureRecognizerDelegate>

@property UILabel* appBuildDateLab;
@property int aboutClickCount;

@property (strong, nonatomic)  UIView* headerBg;
@end

#endif
