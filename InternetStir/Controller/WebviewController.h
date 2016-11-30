//
//  WebviewController.h
//  InternetStir
//
//  Created by Apple on 16/8/19.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@interface WebviewController : UIViewController<WKNavigationDelegate,WKUIDelegate,WKNavigationDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (strong, nonatomic) UIProgressView *progressView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIActivityIndicatorView *testActivityIndicato;
@property (nonatomic, strong) NSString *path;

@end
