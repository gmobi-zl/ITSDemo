
//
//  MyCommentController.m
//  Jacob
//
//  Created by Apple on 16/9/20.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import "MyCommentController.h"
#import "MMSystemHelper.h"
#import "AppStyleConfiguration.h"
#import "MyCommentCell.h"
#import "UUInputAccessoryView.h"
#import "ITSApplication.h"
#import "MJRefresh.h"

#define screenW [MMSystemHelper getScreenWidth]
#define screenH [MMSystemHelper getScreenHeight]

NSString *const MyCommentTableViewCellIdentifier = @"MyCommentCell";

@interface MyCommentController ()

@end

@implementation MyCommentController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"留言追蹤";
    self.screenName = @"comment.track";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    UIButton* Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    Btn.frame = CGRectMake(0, 20, 15, 20);
    [Btn setBackgroundImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:Btn];
    self.navigationItem.leftBarButtonItem = left;
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, 0, screenW, screenH);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[MyCommentCell class] forCellReuseIdentifier:MyCommentTableViewCellIdentifier];
    
    [self setupRefresh];
    
    ITSApplication* itsApp = [ITSApplication get];
    NSMutableDictionary* eParams = [NSMutableDictionary dictionaryWithCapacity:1];
    [itsApp.reportSvr recordEvent:@"list" params:eParams eventCategory:@"comment.track.view"];
}
- (void)setupRefresh
{
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    self.tableView.headerPullToRefreshText = ITS_NSLocalizedString(@"Pull2Load", STR_PULL_REFRESH_PULL);
    self.tableView.headerReleaseToRefreshText = ITS_NSLocalizedString(@"Release2Refresh", STR_PULL_REFRESH_RELEASE);
    self.tableView.headerRefreshingText = ITS_NSLocalizedString(@"Loading", STR_PULL_REFRESH_LOADING);
    
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    self.tableView.footerPullToRefreshText = ITS_NSLocalizedString (@"Pull2Load", STR_PULL_REFRESH_PULL);
    self.tableView.footerReleaseToRefreshText = ITS_NSLocalizedString(@"Release2Refresh", STR_PULL_REFRESH_RELEASE);
    self.tableView.footerRefreshingText = ITS_NSLocalizedString(@"Loading", STR_PULL_REFRESH_LOADING);
}
#pragma mark 开始进入刷新状态
- (void)headerRereshing
{

}
- (void)footerRereshing
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 270;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:MyCommentTableViewCellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MyCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyCommentTableViewCellIdentifier];
    }
    MyCommentCell *tmpCell = (MyCommentCell*)cell;
    [tmpCell.replyButton addTarget:self action:@selector(replyBtn) forControlEvents:UIControlEventTouchUpInside];
    tmpCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return tmpCell;
}
- (void)replyBtn {
    
    [UUInputAccessoryView showKeyboardType:UIKeyboardTypeDefault
                                   content:@""
                                      name:@""
                                     Block:^(NSString *contentStr)
     {
     
         ITSApplication* itsApp = [ITSApplication get];
         NSMutableDictionary* eParams = [NSMutableDictionary dictionaryWithCapacity:1];
         [eParams setObject:@"reply" forKey:@"fid"];
         [eParams setObject:contentStr forKey:@"reply"];
         [itsApp.reportSvr recordEvent:@"reply" params:eParams eventCategory:@"comment.track.click"];
     }];
}
- (void)clickBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:[MMSystemHelper string2UIColor:HOME_VIPNAME_COLOR]}];
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
