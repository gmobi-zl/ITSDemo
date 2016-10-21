
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

    ITSApplication* poApp = [ITSApplication get];
    NSMutableDictionary* eParams = [NSMutableDictionary dictionaryWithCapacity:1];
    [poApp.reportSvr recordEvent:@"name" params:eParams eventCategory:@"social.web.view"];

}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
//    self.backView.hidden = NO;
//    [self.testActivityIndicato startAnimating];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
//    self.backView.hidden = YES;
//    [self.testActivityIndicato stopAnimating];
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
