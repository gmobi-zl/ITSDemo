

//
//  SocialController.m
//  InternetStir
//
//  Created by Apple on 16/8/18.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import "SocialController.h"
#import "MMSystemHelper.h"
#import "ITSAppConst.h"
#import "MenuViewController.h"

#define screenW [MMSystemHelper getScreenWidth]
#define screenH [MMSystemHelper getScreenHeight]

@interface SocialController ()

@end

@implementation SocialController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dataArr = @[@"https://www.facebook.com/WithGaLoveTaiwan/?fref=ts",@"https://www.youtube.com/user/kyoko38",@"https://www.instagram.com/yga0721/",@"https://plus.google.com/u/0/+%E8%94%A1%E9%98%BF%E5%98%8E/posts",@"http://yga0721.pixnet.net/blog"];
    
    CGFloat space = (screenW - 5*30)/(5 + 1);
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, screenW, 40);
    view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:view];
    for (NSInteger i = 0; i < 5; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
        button.frame = CGRectMake(space + i * (30 + space), 5, 30, 30);
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [view addSubview:button];
    }
    self.webView = [[UIWebView alloc] init];
    self.webView.frame = CGRectMake(0, 40, screenW, screenH - 104);
    [self.view addSubview:self.webView];
    NSURL *url = [NSURL URLWithString:@"https://www.facebook.com/WithGaLoveTaiwan/?fref=ts"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, -20, screenW, 20)];
    statusBarView.backgroundColor = [MMSystemHelper string2UIColor:NAV_BGCOLOR];
    [self.navigationController.navigationBar addSubview:statusBarView];

}
- (void)btnClick:(UIButton *)button{
    NSURL *url = [NSURL URLWithString:[self.dataArr objectAtIndex:button.tag]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    UIButton* Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    Btn.frame = CGRectMake(0, 20, 30, 30);
    [Btn setBackgroundImage:[UIImage imageNamed:@"icon_Menu"] forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(pushMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:Btn];
    self.navigationItem.leftBarButtonItem = left;
}
- (void)pushMenu{

    MenuViewController *menu = [[MenuViewController alloc] init];
    [self.navigationController pushViewController:menu animated:YES];
    
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
