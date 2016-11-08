
//
//  SocialWebController.m
//  Jacob
//
//  Created by Apple on 16/9/27.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import "SocialWebController.h"
#import "MMSystemHelper.h"
#import "ITSApplication.h"
#import "NewsCategory.h"

#define screenW [MMSystemHelper getScreenWidth]
#define screenH [MMSystemHelper getScreenHeight]

@interface SocialWebController ()

@end

@implementation SocialWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenName = @"social.web";
    self.view.backgroundColor = [UIColor whiteColor];
//    self.arr = @[@"https://www.facebook.com/Jacob.ek07/",
//                    @"https://www.youtube.com/channel/UCfcGjEq_b-7lfBbD8tQSYNg",
//                    @"https://www.instagram.com/jacob.ek07/"];
    self.arr = [[NSMutableArray alloc] init];
    ITSApplication* itsApp = [ITSApplication get];
    NSMutableArray* arr = itsApp.dataSvr.categoryList;
    for (NewsCategory *cate in arr) {
        if (cate.url != nil) {
            [self.arr addObject:cate.url];
        }
    }
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 20, screenW, screenH - 60 )];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.navigationDelegate = self;
    if (self.viewIndex - 1 < self.arr.count) {
        NSURL* url = [NSURL URLWithString:self.arr[self.viewIndex - 1]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
   
    [self.view addSubview:self.webView];
    
    self.backView = [[UIView alloc] init];
    self.backView.frame = CGRectMake(0, 0, screenW,screenH);
    self.backView.backgroundColor = [UIColor blackColor];
    self.backView.alpha = 0.5;
    self.backView.hidden = NO;
    [self.view addSubview:self.backView];
    
    self.testActivityIndicato = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.testActivityIndicato.frame = CGRectMake(0, screenH/2 - 64, screenW, 50);
    [self.backView addSubview:self.testActivityIndicato];

    ITSApplication* poApp = [ITSApplication get];
    NSMutableDictionary* eParams = [NSMutableDictionary dictionaryWithCapacity:1];
    [poApp.reportSvr recordEvent:@"name" params:eParams eventCategory:@"social.web.view"];
    
    self.backBtn = [[UIButton alloc] init];
    self.backBtn.frame = CGRectMake(15, screenH - 49 - 55 - 15 - 45, 36, 36);
    [self.backBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    self.backBtn.backgroundColor = [UIColor colorWithRed:0.92 green:0.91 blue:0.93 alpha:1];
    self.backBtn.hidden = NO;
    self.backBtn.layer.cornerRadius = 18;
    self.backBtn.layer.shadowOffset = CGSizeMake(1, 1);
    self.backBtn.layer.shadowOpacity = 0.7;
    self.backBtn.layer.shadowColor =  [UIColor blackColor].CGColor;
//    [self.backBtn setImage:[UIImage imageNamed:@"PinLeft"] forState:UIControlStateNormal];
    [self.webView addSubview:self.backBtn];
    
    UIImageView *bgImage = [[UIImageView alloc] init];
    bgImage.frame = CGRectMake(11, 7, 13, 22);
//    bgImage.center = self.backBtn.center;
    bgImage.image = [UIImage imageNamed:@"PinLeft"];
    [self.backBtn addSubview:bgImage];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)btnClick {
    [self.webView goBack];
}
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
////
//    NSString *strRequest = [navigationAction.request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    
//    NSLog(@"!!!!!!!!!!!!!!!!!!%@",strRequest);
//    
//    
//    if([strRequest isEqualToString:@"about:blank"]) {//主页面加载内容
//    
////        decisionHandler(WKNavigationActionPolicyAllow);//允许跳转
//        
//    } else {//截获页面里面的链接点击
//        
//        //do something you want
//        
//        decisionHandler(WKNavigationActionPolicyAllow);//不允许跳转
//        
//    }
//}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
    self.backView.hidden = NO;
    self.backBtn.hidden = YES;
    [self.testActivityIndicato startAnimating];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
    self.backView.hidden = YES;
    [self.testActivityIndicato stopAnimating];
    self.backBtn.hidden = NO;
    
//    NSString *strRequest = webView.URL.absoluteString;
//    for (NSInteger i = 0; i < self.arr.count; i++) {
//        NSString *url = [self.arr objectAtIndex:i];
//        if ([url isEqualToString:strRequest]) {
//            self.backBtn.hidden = YES;
//        }
//    }
}
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
//    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"404" ofType:@"html"];
//    NSURL *url = [NSURL fileURLWithPath:filePath];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
