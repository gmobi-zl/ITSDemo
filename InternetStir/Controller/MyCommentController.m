
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
#import "HomeViewController.h"

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
    [Btn setBackgroundImage:[UIImage imageNamed:@"icon"] forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:Btn];
    self.navigationItem.leftBarButtonItem = left;
    
    ITSApplication* itsApp = [ITSApplication get];
    DataService* ds = itsApp.dataSvr;
    NSMutableArray *trackComment = ds.userTrackComments;
/*
    if (trackComment.count > 0) {
        self.tableView = [[UITableView alloc] init];
        self.tableView.frame = CGRectMake(0, 0, screenW, screenH);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.tableView];
        [self.tableView registerClass:[MyCommentCell class] forCellReuseIdentifier:MyCommentTableViewCellIdentifier];
    }else {
        UIImageView *tomoto = [[UIImageView alloc] init];
        tomoto.frame = CGRectMake(screenW/2 - 100, screenH/2 - 150, 200, 200);
        tomoto.image = [UIImage imageNamed:@"P119_emptypage_commenttrack"];
        [self.view addSubview:tomoto];
        
        CGSize size = [MMSystemHelper sizeWithString:NSLocalizedString(@"NoComment", nil) font:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(screenW - 20, MAXFLOAT)];
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(10, screenH/2 + 50, screenW - 20, size.height);
        label.text = NSLocalizedString(@"NoComment", nil);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16];
        [self.view addSubview:label];
        
        CGSize btnSize = [MMSystemHelper sizeWithString:NSLocalizedString(@"GoComment", nil) font:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(screenW/2 - btnSize.width/2, screenH/2 + 50 + size.height + 10, btnSize.width, btnSize.height);
        [button setTitle:NSLocalizedString(@"GoComment", nil) forState:UIControlStateNormal];
        [button setTitleColor:[MMSystemHelper string2UIColor:HOME_VIPNAME_COLOR] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pushCommentVc) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.view addSubview:button];
    }
 */
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

//    ITSApplication* itsApp = [ITSApplication get];
    NSMutableDictionary* eParams = [NSMutableDictionary dictionaryWithCapacity:1];
    [itsApp.reportSvr recordEvent:@"list" params:eParams eventCategory:@"comment.track.view"];
}
-(void)pushCommentVc {
    HomeViewController *controller = [[HomeViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
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
    self.tableView.headerPullToRefreshText = NSLocalizedString(@"PullLoad", STR_PULL_REFRESH_PULL);
    self.tableView.headerReleaseToRefreshText = NSLocalizedString(@"Release2Refresh", STR_PULL_REFRESH_RELEASE);
    self.tableView.headerRefreshingText = NSLocalizedString(@"LoadingNews", STR_PULL_REFRESH_LOADING);
    
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    self.tableView.footerPullToRefreshText = NSLocalizedString (@"Pull2Load", STR_PULL_REFRESH_PULL);
    self.tableView.footerReleaseToRefreshText = NSLocalizedString(@"Release2Refresh", STR_PULL_REFRESH_RELEASE);
    self.tableView.footerRefreshingText = NSLocalizedString(@"LoadingNews", STR_PULL_REFRESH_LOADING);
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
    [tmpCell.replyButton addTarget:self action:@selector(replyBtn:) forControlEvents:UIControlEventTouchUpInside];
    tmpCell.replyButton.tag = indexPath.row;
    
    ITSApplication* itsApp = [ITSApplication get];
    DataService* ds = itsApp.dataSvr;
    NSMutableArray* trackComment = ds.userTrackComments;
    if (trackComment != nil){
        UserTrackComment* c = [trackComment objectAtIndex:indexPath.row];
        UserTrackCommentFrame *frame = [[UserTrackCommentFrame alloc] init];
        [frame initWithDataFrame:c];
        c.uiFrame = frame;
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
    
    CelebComment* celebC = [ds findCelebCommentById:comment.fid];
    if (celebC == nil){
        [itsApp.dataSvr setCurrentCelebComment:comment.article];
        CommentViewController *commentVc = [[CommentViewController alloc] init];
        commentVc.context = celebC.context;
        [self.navigationController pushViewController:commentVc animated:YES];
        
    } else {
        comment.article = celebC;
        [itsApp.dataSvr setCurrentCelebComment:comment.article];
        CommentViewController *commentVc = [[CommentViewController alloc] init];
        commentVc.context = celebC.context;
        [self.navigationController pushViewController:commentVc animated:YES];
    }
}
- (void)replyBtn:(UIButton *)button {
    
    
    ITSApplication* itsApp = [ITSApplication get];
    DataService* ds = itsApp.dataSvr;
    CBUserService* userSvr = itsApp.cbUserSvr;
    [UUInputAccessoryView showKeyboardType:UIKeyboardTypeDefault
                                   content:@""
                                      name:@""
                                     Block:^(NSString *contentStr)
     {
         
         if (userSvr.user.isLogin == NO) {
         
         }else {
#ifdef DEMO_DATA
             CommentFrame *frameNeedChanged = [self.commentData objectAtIndex:index];
             CommentItem *newReplyItem = frameNeedChanged.detailCommentItem;
             
             //做个中转
             NSMutableArray *mutaArray = [[NSMutableArray alloc] init];
             [mutaArray addObjectsFromArray:newReplyItem.replys];
             ReplyItem *newsItem = [[ReplyItem alloc] init];
             newsItem.comment = contentStr;
             frameNeedChanged.replysF = nil;
             frameNeedChanged.replyPictureF = nil;
             frameNeedChanged.replyNameF = nil;
             newsItem.name = userSvr.user.userName;
             newsItem.icon = userSvr.user.avatar;
             [mutaArray addObject:newsItem];
             newReplyItem.replys = mutaArray;
             newsItem.type = 1;
             frameNeedChanged.detailCommentItem = newReplyItem;
             [self.tableView reloadData];
#else
             // send to server
             ITSApplication* itsApp = [ITSApplication get];
             DataService* ds = itsApp.dataSvr;
             NSMutableArray* trackComment= ds.userTrackComments;

             UserTrackComment *currentFansComment = [trackComment objectAtIndex:button.tag];
             CelebComment* currentComment = currentFansComment.article;
             
             if (currentFansComment == nil){
                 return;
             }
             
             NSString* replyCId = currentFansComment.cid;
             if (currentFansComment.rid != nil && ![currentFansComment.rid isKindOfClass:[NSNull class]] && ![currentFansComment.rid isEqualToString:@""]){
                 replyCId = currentFansComment.rid;
             }
             
             [itsApp.remoteSvr replayFansComment:currentComment.fid replayCommendId:replyCId comment:contentStr callback:^(int status, int code, NSDictionary *resultData) {
                 if (resultData != nil){
                     NSNumber* retNum = [resultData objectForKey:@"success"];
                     if (retNum != nil){
                         BOOL ret = [retNum boolValue];
                         if (ret == YES){
                             CelebUser* user = itsApp.cbUserSvr.user;
                             FansComment* sendComment = [FansComment alloc];
                             sendComment.name = user.userName;
                             sendComment.avator = user.avatar;
                             sendComment.comment = contentStr;
                             NSString* retuuid = [resultData objectForKey:@"uuid"];
                             NSString* retfid = [resultData objectForKey:@"fid"];
                             NSString* retcid = [resultData objectForKey:@"cid"];
                             NSString* retrid = [resultData objectForKey:@"rid"];
                             sendComment.uuid = retuuid;
                             sendComment.fid = retfid;
                             sendComment.cid = retcid;
                             sendComment.rid = retrid;
                             sendComment.pts = [MMSystemHelper getMillisecondTimestamp];
                             sendComment.uts = sendComment.pts;
                             
                             [ds userInsertCurrentReplyCommentItem:sendComment];
                             [ds userInsertUserTrackCommentItem:sendComment];
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 [self.tableView reloadData];
                             });
                         }
                     }
                 }
             }];
#endif
         }
     }];
//    ITSApplication* itsApp = [ITSApplication get];
//    DataService* ds = itsApp.dataSvr;
//    NSMutableArray* trackComment= ds.userTrackComments;
//    UserTrackComment *comment = [trackComment objectAtIndex:button.tag];
//    
//    if(comment.replayComments == nil){
//        CelebComment* celebC = [ds findCelebCommentById:comment.fid];
//        if (celebC == nil){
//            [itsApp.dataSvr setCurrentCelebComment:comment.article];
//            CommentViewController *commentVc = [[CommentViewController alloc] init];
//            [self.navigationController pushViewController:commentVc animated:YES];
//            
//        } else {
//            comment.article = celebC;
//            [itsApp.dataSvr setCurrentCelebComment:comment.article];
//            CommentViewController *commentVc = [[CommentViewController alloc] init];
//            [self.navigationController pushViewController:commentVc animated:YES];
//        }
//    } else {
//        [itsApp.dataSvr setCurrentCelebComment:comment.article];
//        
//        CommentViewController *commentVc = [[CommentViewController alloc] init];
//        [self.navigationController pushViewController:commentVc animated:YES];
//    }

}
- (void)clickBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setTitleTextAttributes:
//     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
//       NSForegroundColorAttributeName:[UIColor grayColor]}];
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
