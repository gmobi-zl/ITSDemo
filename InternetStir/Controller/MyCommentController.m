
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
#import "MMEventService.h"
#import "UserTrackComment.h"
#import "CommentViewController.h"

#define screenW [MMSystemHelper getScreenWidth]
#define screenH [MMSystemHelper getScreenHeight]

NSString *const MyCommentTableViewCellIdentifier = @"MyCommentCell";

@interface MyCommentController ()

@end

@implementation MyCommentController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = NSLocalizedString(@"fans_menu_track", nil);
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
    MMEventService* es = [MMEventService getInstance];
    [es addEventHandler:self eventName:EVENT_USER_TRACK_COMMENT_DATA_REFRESH selector:@selector(userTrackDataRefreshListener:)];

    ITSApplication* itsApp = [ITSApplication get];
    NSMutableDictionary* eParams = [NSMutableDictionary dictionaryWithCapacity:1];
    [itsApp.reportSvr recordEvent:@"list" params:eParams eventCategory:@"comment.track.view"];
}

-(void)userTrackDataRefreshListener: (id) data{
    if (self.view.hidden == NO){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            ITSApplication* itsApp = [ITSApplication get];
            DataService* ds = itsApp.dataSvr;
            NSMutableArray *trackComment = ds.userTrackComments;
            
            if (trackComment != nil){
                NSInteger count = [trackComment count];
                for (int i = 0; i < count; i++) {
                    UserTrackComment* c = [trackComment objectAtIndex:i];
                    if (c.uiFrame == nil){
                        UserTrackCommentFrame* frame = [UserTrackCommentFrame alloc];
                        [frame initWithDataFrame:c];
                        c.uiFrame = frame;
                    }
                }
            }

            [self.tableView reloadData];
            [self.tableView footerEndRefreshing];
            [self.tableView headerEndRefreshing];
            self.isRefreshing = NO;
        });
    }
}

- (void)setupRefresh
{
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    self.tableView.headerPullToRefreshText = NSLocalizedString(@"Pull2Load", STR_PULL_REFRESH_PULL);
    self.tableView.headerReleaseToRefreshText = NSLocalizedString(@"Release2Refresh", STR_PULL_REFRESH_RELEASE);
    self.tableView.headerRefreshingText = NSLocalizedString(@"Loading", STR_PULL_REFRESH_LOADING);
    
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    self.tableView.footerPullToRefreshText = NSLocalizedString (@"Pull2Load", STR_PULL_REFRESH_PULL);
    self.tableView.footerReleaseToRefreshText = NSLocalizedString(@"Release2Refresh", STR_PULL_REFRESH_RELEASE);
    self.tableView.footerRefreshingText = NSLocalizedString(@"Loading", STR_PULL_REFRESH_LOADING);
}
#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    if (self.isRefreshing == NO){
        self.refreshType = TRACK_COMMENT_REFRESH_TYPE_AFTER;
        ITSApplication* itsApp = [ITSApplication get];
        DataService* ds = itsApp.dataSvr;
        [ds refreshUserTrackComments:TRACK_COMMENT_REFRESH_TYPE_AFTER];
        self.isRefreshing = YES;
    }
}
- (void)footerRereshing
{
    if (self.isRefreshing == NO){
        self.refreshType = TRACK_COMMENT_REFRESH_TYPE_BEFORE;
        ITSApplication* itsApp = [ITSApplication get];
        DataService* ds = itsApp.dataSvr;
        [ds refreshUserTrackComments:TRACK_COMMENT_REFRESH_TYPE_BEFORE];
        self.isRefreshing = YES;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    CGFloat height = 0;
    
    ITSApplication* itsApp = [ITSApplication get];
    DataService* ds = itsApp.dataSvr;
    NSMutableArray *trackComment = ds.userTrackComments;
    if (trackComment != nil){
        UserTrackComment* c = [trackComment objectAtIndex:indexPath.row];
        height = c.uiFrame.cellHeight;
    }
    return height;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ITSApplication* itsApp = [ITSApplication get];
    DataService* ds = itsApp.dataSvr;
    NSMutableArray *trackComment = ds.userTrackComments;
    
    if (trackComment != nil){
        NSInteger count = [trackComment count];
        for (int i = 0; i < count; i++) {
            UserTrackComment* c = [trackComment objectAtIndex:i];
            if (c.uiFrame == nil){
                UserTrackCommentFrame* frame = [UserTrackCommentFrame alloc];
                
                [frame initWithDataFrame:c];
                c.uiFrame = frame;
            }
        }
    }
    return trackComment.count;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:MyCommentTableViewCellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MyCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyCommentTableViewCellIdentifier];
    }
    MyCommentCell *tmpCell = (MyCommentCell*)cell;
    [tmpCell.replyButton addTarget:self action:@selector(pushCommentVc:) forControlEvents:UIControlEventTouchUpInside];
    tmpCell.replyButton.tag = indexPath.row;
    
    ITSApplication* itsApp = [ITSApplication get];
    DataService* ds = itsApp.dataSvr;
    NSMutableArray* trackComment= ds.userTrackComments;
    if (trackComment != nil){
        UserTrackComment* c = [trackComment objectAtIndex:indexPath.row];
        [tmpCell setShowData:c];
        [tmpCell setTrackCommentFrame:c.uiFrame];
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = tmpCell.bgView.bounds;
    button.tag = indexPath.row;
    [button addTarget:self action:@selector(pushCommentVc:) forControlEvents:UIControlEventTouchUpInside];
    [tmpCell.bgView addSubview:button];
    tmpCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return tmpCell;
}
- (void)pushCommentVc: (UIButton *)button {
    
    ITSApplication* itsApp = [ITSApplication get];
    DataService* ds = itsApp.dataSvr;
    NSMutableArray* trackComment= ds.userTrackComments;
    UserTrackComment *comment = [trackComment objectAtIndex:button.tag];
    
    if(comment.replayComments == nil){
        CelebComment* celebC = [ds findCelebCommentById:comment.fid];
        if (celebC == nil){
            [itsApp.dataSvr setCurrentCelebComment:comment.article];
            CommentViewController *commentVc = [[CommentViewController alloc] init];
            [self.navigationController pushViewController:commentVc animated:YES];
            
        } else {
            comment.article = celebC;
            [itsApp.dataSvr setCurrentCelebComment:comment.article];
            CommentViewController *commentVc = [[CommentViewController alloc] init];
            [self.navigationController pushViewController:commentVc animated:YES];
        }
    } else {
        [itsApp.dataSvr setCurrentCelebComment:comment.article];
        
        CommentViewController *commentVc = [[CommentViewController alloc] init];
        [self.navigationController pushViewController:commentVc animated:YES];
    }
}
- (void)replyBtn:(UIButton *)button {
    
//    [UUInputAccessoryView showKeyboardType:UIKeyboardTypeDefault
//                                   content:@""
//                                      name:@""
//                                     Block:^(NSString *contentStr)
//     {
//     
//         ITSApplication* itsApp = [ITSApplication get];
//         NSMutableDictionary* eParams = [NSMutableDictionary dictionaryWithCapacity:1];
//         [eParams setObject:@"reply" forKey:@"fid"];
//         [eParams setObject:contentStr forKey:@"reply"];
//         [itsApp.reportSvr recordEvent:@"reply" params:eParams eventCategory:@"comment.track.click"];
//     }];
    ITSApplication* itsApp = [ITSApplication get];
    DataService* ds = itsApp.dataSvr;
    NSMutableArray* trackComment= ds.userTrackComments;
    UserTrackComment *comment = [trackComment objectAtIndex:button.tag];
    
    if(comment.replayComments == nil){
        CelebComment* celebC = [ds findCelebCommentById:comment.fid];
        if (celebC == nil){
            [itsApp.dataSvr setCurrentCelebComment:comment.article];
            CommentViewController *commentVc = [[CommentViewController alloc] init];
            [self.navigationController pushViewController:commentVc animated:YES];
            
        } else {
            comment.article = celebC;
            [itsApp.dataSvr setCurrentCelebComment:comment.article];
            CommentViewController *commentVc = [[CommentViewController alloc] init];
            [self.navigationController pushViewController:commentVc animated:YES];
        }
    } else {
        [itsApp.dataSvr setCurrentCelebComment:comment.article];
        
        CommentViewController *commentVc = [[CommentViewController alloc] init];
        [self.navigationController pushViewController:commentVc animated:YES];
    }

}
- (void)clickBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:[MMSystemHelper string2UIColor:HOME_VIPNAME_COLOR]}];
    
    ITSApplication* itsApp = [ITSApplication get];
    DataService* ds = itsApp.dataSvr;
    NSMutableArray *trackComment = ds.userTrackComments;
    
    if (trackComment == nil)
        [self headerRereshing];
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
