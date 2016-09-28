

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
#import "AppStyleConfiguration.h"
#import "ContentViewCell.h"
#import "DetailContentController.h"
#import "HomeViewController.h"

#define screenW [MMSystemHelper getScreenWidth]
#define screenH [MMSystemHelper getScreenHeight]
NSString *const ContentCellIdentifier = @"ContentViewCell";

@interface SocialController () 


@end

@implementation SocialController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.urlArr = @[@"https://www.youtube.com/watch?v=QqPtEB9rxg4",
                    @"https://www.youtube.com/watch?v=iDXgBkIeZG0",
                    @"https://www.youtube.com/watch?v=VCkL3AsnHTo",
                    @"https://www.youtube.com/watch?v=veBjTuLDzF0",
                    @"https://www.youtube.com/watch?v=i_Z_j-U4yK4"];

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"社群";
    self.dataArr = @[@"https://www.facebook.com/WithGaLoveTaiwan/?fref=ts",@"https://plus.google.com/u/0/+%E8%94%A1%E9%98%BF%E5%98%8E/posts",@"https://www.instagram.com/yga0721/",@"http://yga0721.pixnet.net/blog"];
    
    NSArray *title = @[@"推薦",@"Facebook",@"You Tube",@"Instagram"];

    CGFloat space = (screenW - title.count*80)/(title.count + 1);
    

//    [self configUI];

//    for (NSInteger i = 0; i < title.count; i++) {
//        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        self.btn.frame = CGRectMake(space + i * (80 + space), 20, 80, 40);
//        [self.btn setTitle:[title objectAtIndex:i] forState:UIControlStateNormal];
//        [self.btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//        self.btn.backgroundColor = [UIColor whiteColor];
//        self.btn.tag = i + 100;
//        if (i == 0) {
//            self.btn.selected  = YES;
//        }
//        [self.view addSubview:self.btn];
//    }
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, 20, screenW, screenH - 60 - 49);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[ContentViewCell class] forCellReuseIdentifier:ContentCellIdentifier];
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 0.5 + 20 + 5 + 40 + 10 + 3 * (screenW - 30)/4 + 10;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:ContentCellIdentifier forIndexPath:indexPath];
    if (cell == nil){
        cell = [[ContentViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ContentCellIdentifier];
    }
    ContentViewCell* tmpCell = (ContentViewCell*)cell;
    [tmpCell showDataWithModel:indexPath.row];
    
    return tmpCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailContentController *detail = [[DetailContentController alloc] init];
    detail.path = self.urlArr[indexPath.row];
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
}
//- (void)creatActivityIndicat{
//
//    self.backView = [[UIView alloc] init];
//    self.backView.frame = CGRectMake(0, 45 + 64, screenW,screenH - 45 - 64);
//    self.backView.backgroundColor = [UIColor blackColor];
//    self.backView.alpha = 0.5;
//    self.backView.hidden = YES;
//    [self.view addSubview:self.backView];
//    
//    self.testActivityIndicato = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//    self.testActivityIndicato.frame = CGRectMake(0, 150+64, screenW, 50);
//    [self.backView addSubview:self.testActivityIndicato];
//
//}
//- (void)configUI {
//    
//    ConfigService *cs = [ConfigService get];
//    // 进度条
//    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, screenW, 0)];
//    progressView.tintColor = [MMSystemHelper string2UIColor:HOME_VIPNAME_COLOR];
//    progressView.trackTintColor = [UIColor whiteColor];
//    [self.view addSubview:progressView];
//    self.progressView = progressView;
//    
//    WKWebView *wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 45 + 64, screenW, screenH - 49 - 45 - 64)];
//    wkWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    wkWebView.backgroundColor = [UIColor whiteColor];
//    wkWebView.navigationDelegate = self;
//    [self.view insertSubview:wkWebView belowSubview:progressView];
//    
//    [wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
//    self.webView = wkWebView;
//    
//}
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
//        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
//        if (newprogress == 1) {
//            //            self.progressView.hidden = YES;
//            [self.progressView setProgress:1 animated:NO];
//        }else {
//            self.progressView.hidden = NO;
//            [self.progressView setProgress:newprogress animated:YES];
//        }
//    }
//}
//- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
//
//    self.backView.hidden = NO;
//    [self.testActivityIndicato startAnimating];
//}
//- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
//    [self.backView setHidden:YES];
//    [self.testActivityIndicato stopAnimating];
//    
//}
//- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
//
//}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollVie{
//    
//    if ([scrollVie isKindOfClass:[UITableView class]]) {
//        return;
//    }
//    CGPoint curPoint = scrollVie.contentOffset;
//    NSInteger current = curPoint.x/scrollVie.frame.size.width;
//    [UIView animateWithDuration:0.3 animations:^{
//        self.line.frame = CGRectMake(screenW/4 * current, 57, screenW/4,3);
//    }];
//}

//- (void)btnClick:(UIButton *)btn{
//    
////    [self configUI];
////    [self creatActivityIndicat];
////    UIButton *button = (UIButton *)[self.view viewWithTag:100];
////    if (btn.tag != 0) {
////        button.selected = NO;
////    }
////    if (self.button == nil) {
////        btn.selected = YES;
////        self.button = btn;
////    }else if (self.button != nil && self.button == btn){
////        btn.selected = YES;
////    }else if (self.button != btn && self.button != nil){
////        self.button.selected = NO;
////        btn.selected = YES;
////        self.button = btn;
////    }
//    
//    switch (btn.tag) {
//        case 100:
//        {
//            self.backView.hidden = YES;
//            [self.testActivityIndicato stopAnimating];
//            [UIView animateWithDuration:0.1 animations:^{
//                self.line.frame = CGRectMake(0, 57, screenW/4,3);
//                self.scrollView.contentOffset = CGPointMake(0, 0);
//            }];
//        }
//            break;
//        case 101:
//        {
//            self.backView.hidden = NO;
//            [self.testActivityIndicato startAnimating];
//            [UIView animateWithDuration:0.1 animations:^{
//                self.line.frame = CGRectMake(screenW/4, 57, screenW/4,3);
//                self.scrollView.contentOffset = CGPointMake(screenW, 0);
//            }];
//        }
//            break;
//        case 102:
//        {
//            self.backView.hidden = NO;
//            [self.testActivityIndicato startAnimating];
//            [UIView animateWithDuration:0.1 animations:^{
//                self.line.frame = CGRectMake(screenW * 2/4, 57, screenW/4,3);
//                self.scrollView.contentOffset = CGPointMake(2 * screenW, 0);
//            }];
//
//        }
//            break;
//        case 103:
//        {
//            self.backView.hidden = NO;
//            [self.testActivityIndicato startAnimating];
//            [UIView animateWithDuration:0.1 animations:^{
//                self.line.frame = CGRectMake(screenW * 3/4, 57, screenW/4,3);
//                self.scrollView.contentOffset = CGPointMake(3 * screenW, 0);
//            }];
//        }
//            break;
//        case 104:
//        {
//            self.backView.hidden = NO;
//            [self.testActivityIndicato startAnimating];
//            [UIView animateWithDuration:0.1 animations:^{
//                self.line.frame = CGRectMake(screenW * 4/4, 57, screenW/4,3);
//                self.scrollView.contentOffset = CGPointMake(4 * screenW, 0);
//            }];
//        }
//            break;
//        default:
//            break;
//    }
//}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:[MMSystemHelper string2UIColor:HOME_COMMENT_COLOR]}];
    
//    UIButton* Btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    Btn.frame = CGRectMake(0, 20, 30, 30);
//    [Btn setBackgroundImage:[UIImage imageNamed:@"icon_Menu"] forState:UIControlStateNormal];
//    [Btn addTarget:self action:@selector(pushMenu) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:Btn];
//    self.navigationItem.leftBarButtonItem = left;
    self.navigationController.navigationBar.hidden = YES;
}
- (void)pushMenu{

    MenuViewController *menu = [[MenuViewController alloc] init];
    menu.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:menu animated:YES];
}



//
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
