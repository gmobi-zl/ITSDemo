
//
//  DetailContentController.m
//  InternetStir
//
//  Created by Apple on 16/8/17.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import "DetailContentController.h"
#import "MMSystemHelper.h"
#import "ConfigService.h"

#define screenW [MMSystemHelper getScreenWidth]
#define screenH [MMSystemHelper getScreenHeight]

@interface DetailContentController ()

@end

@implementation DetailContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    [self configUI];
//    self.webView = [[WKWebView alloc] init];
//    self.webView.frame = CGRectMake(0, 0, screenW, screenH - 64);
//    [self.view addSubview:self.webView];
//    NSURL *url = [NSURL URLWithString:self.path];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
//    

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UIButton* Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    Btn.frame = CGRectMake(0, 20, 30, 30);
    [Btn setBackgroundImage:[UIImage imageNamed:@"icon_Back"] forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:Btn];
    self.navigationItem.leftBarButtonItem = left;
}

- (void)configUI {
    
    ConfigService *cs = [ConfigService get];
    // 进度条
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, screenW, 0)];
    progressView.tintColor = [cs getPrgoressBackgroundColor];
    progressView.trackTintColor = [UIColor whiteColor];
    [self.view addSubview:progressView];
    self.progressView = progressView;
    NSURL* url = [NSURL URLWithString:self.path];

    WKWebView *wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    wkWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    wkWebView.backgroundColor = [UIColor whiteColor];
    wkWebView.navigationDelegate = self;
    [self.view insertSubview:wkWebView belowSubview:progressView];
    
    [wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [wkWebView loadRequest:request];
    self.webView = wkWebView;
    
}

- (void)clickBack{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            //            self.progressView.hidden = YES;
            [self.progressView setProgress:1 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}

- (void)dealloc {
    
        [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    
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
