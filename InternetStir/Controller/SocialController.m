

//
//  SocialController.m
//  InternetStir
//
//  Created by Apple on 16/8/18.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import "SocialController.h"
#import "MMSystemHelper.h"

#define screenW [MMSystemHelper getScreenWidth]
#define screenH [MMSystemHelper getScreenHeight]

@interface SocialController ()

@end

@implementation SocialController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat space = (screenW - 5*30)/(5 + 1);
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 64, screenW, 40);
    view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:view];
    for (NSInteger i = 0; i < 5; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
        button.frame = CGRectMake(space + i * (30 + space), 5, 30, 30);
        [view addSubview:button];
    }
    self.webView = [[UIWebView alloc] init];
    //https://www.taobao.com/
    self.webView.frame = CGRectMake(0, 104, screenW, screenH - 104);
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:self.webView];

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
