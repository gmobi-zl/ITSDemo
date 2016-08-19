//
//  DetailContentController.h
//  InternetStir
//
//  Created by Apple on 16/8/17.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNMoodView.h"

@interface DetailContentController : UIViewController<UIGestureRecognizerDelegate>
@property (copy) NSString *path;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) PNMoodView* moodView;

@end
