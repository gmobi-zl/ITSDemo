

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
#import "ConfigService.h"

#define screenW [MMSystemHelper getScreenWidth]
#define screenH [MMSystemHelper getScreenHeight]

@interface SocialController ()

@end

@implementation SocialController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dataArr = @[@"https://www.facebook.com/WithGaLoveTaiwan/?fref=ts",@"https://plus.google.com/u/0/+%E8%94%A1%E9%98%BF%E5%98%8E/posts",@"https://www.youtube.com/user/kyoko38",@"https://www.instagram.com/yga0721/",@"http://yga0721.pixnet.net/blog"];
    
    CGFloat space = (screenW - 5*30)/(5 + 1);
    
    self.bgView = [[UIView alloc] init];
    self.bgView.frame = CGRectMake(0, 1, screenW, 45);
    self.bgView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.bgView];
    
    [self configUI];
    
    NSArray *image = @[@"social_fb",@"social_g+",@"social_yt",@"social_in",@"social_blog"];
    NSArray *selectImage = @[@"social_fb_sel",@"social_g+_sel",@"social_yt_sel",@"social_in_sel",@"social_blog_sel"];
    for (NSInteger i = 0; i < 5; i++) {
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn.frame = CGRectMake(space + i * (30 + space), 5, 30, 30);
        [self.btn setBackgroundImage:[UIImage imageNamed:image[i]] forState:UIControlStateNormal];
        [self.btn setImage:[UIImage imageNamed:selectImage[i]] forState:UIControlStateSelected];
        [self.btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.btn.tag = i + 100;
        if (i == 0) {
            self.btn.selected  = YES;
        }
        [self.view addSubview:self.btn];
    }
    self.line = [[UILabel alloc] initWithFrame:CGRectMake(0, 42, screenW/5,4)];
    self.line.backgroundColor = [MMSystemHelper string2UIColor:NAV_BGCOLOR];
    [self.view addSubview:self.line];

    
    NSURL *url = [NSURL URLWithString:@"https://www.facebook.com/WithGaLoveTaiwan/?fref=ts"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, -20, screenW, 20)];
    statusBarView.backgroundColor = [MMSystemHelper string2UIColor:NAV_BGCOLOR];
    [self.navigationController.navigationBar addSubview:statusBarView];
    [self creatActivityIndicat];
}
- (void)creatActivityIndicat{

    self.backView = [[UIView alloc] init];
    self.backView.frame = CGRectMake(0, 45, screenW,screenH - 45);
    self.backView.backgroundColor = [UIColor blackColor];
    self.backView.alpha = 0.5;
    self.backView.hidden = NO;
    [self.view addSubview:self.backView];
    
    self.testActivityIndicato = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.testActivityIndicato.frame = CGRectMake(0, 150, screenW, 50);
    [self.backView addSubview:self.testActivityIndicato];

}
- (void)configUI {
    
    ConfigService *cs = [ConfigService get];
    // 进度条
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, screenW, 0)];
    progressView.tintColor = [cs getPrgoressBackgroundColor];
    progressView.trackTintColor = [UIColor whiteColor];
    [self.view addSubview:progressView];
    self.progressView = progressView;
    
    WKWebView *wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 45, screenW, screenH - 49 - 45)];
    wkWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    wkWebView.backgroundColor = [UIColor whiteColor];
    wkWebView.navigationDelegate = self;
    [self.view insertSubview:wkWebView belowSubview:progressView];
    
    [wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    self.webView = wkWebView;
    
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
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {

    self.backView.hidden = NO;
    [self.testActivityIndicato startAnimating];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    [self.backView setHidden:YES];
    [self.testActivityIndicato stopAnimating];
    
}
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {

}
- (void)dealloc {
    
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    
}

- (void)btnClick:(UIButton *)btn{
    
    [self configUI];
    [self creatActivityIndicat];
    UIButton *button = (UIButton *)[self.view viewWithTag:100];
    if (btn.tag != 0) {
        button.selected = NO;
    }
    if (self.button == nil) {
        btn.selected = YES;
        self.button = btn;
    }else if (self.button != nil && self.button == btn){
        btn.selected = YES;
    }else if (self.button != btn && self.button != nil){
        self.button.selected = NO;
        btn.selected = YES;
        self.button = btn;
    }
    
    switch (btn.tag) {
        case 100:
        {
            [UIView animateWithDuration:0.1 animations:^{
                self.line.frame = CGRectMake(0, 42, screenW/5,4);
            }];
        }
            break;
        case 101:
        {
            [UIView animateWithDuration:0.1 animations:^{
                self.line.frame = CGRectMake(screenW/5, 42, screenW/5,4);
            }];
        }
            break;
        case 102:
        {
            [UIView animateWithDuration:0.1 animations:^{
                self.line.frame = CGRectMake(screenW * 2/5, 42, screenW/5,4);
            }];

        }
            break;
        case 103:
        {
            [UIView animateWithDuration:0.1 animations:^{
                self.line.frame = CGRectMake(screenW * 3/5, 42, screenW/5,4);
            }];

        }
            break;
        case 104:
        {
            [UIView animateWithDuration:0.1 animations:^{
                self.line.frame = CGRectMake(screenW * 4/5, 42, screenW/5,4);
            }];

        }
            break;
        default:
            break;
    }
    NSURL *url = [NSURL URLWithString:[self.dataArr objectAtIndex:btn.tag - 100]];
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
    menu.hidesBottomBarWhenPushed = YES;
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
