//
//  SocialWebController.h
//  Jacob
//
//  Created by Apple on 16/9/27.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface SocialWebController : UIViewController<WKNavigationDelegate,WKUIDelegate,WKNavigationDelegate>
@property (nonatomic, assign) NSUInteger viewIndex;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSArray *arr;
@end
