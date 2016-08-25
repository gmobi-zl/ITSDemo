//
//  SocialController.h
//  InternetStir
//
//  Created by Apple on 16/8/18.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface SocialController : UIViewController<WKNavigationDelegate,WKUIDelegate,WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIActivityIndicatorView *testActivityIndicato;
@property (nonatomic, strong) UIView *backView;

@end
