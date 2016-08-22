//
//  DetailContentController.h
//  InternetStir
//
//  Created by Apple on 16/8/17.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNMoodView.h"
#import <WebKit/WebKit.h>

@interface DetailContentController : UIViewController<UIGestureRecognizerDelegate,WKUIDelegate,WKNavigationDelegate,WKUIDelegate,WKNavigationDelegate>
@property (copy) NSString *path;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) PNMoodView* moodView;
@property (strong, nonatomic) UIProgressView *progressView;
//@property (strong, nonatomic) UIWebView *webView;
//@property (strong, nonatomic) WKWebView *wkWebView;
@end
