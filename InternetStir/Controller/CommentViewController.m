
//
//  CommentViewController.m
//  InternetStir
//
//  Created by Apple on 16/8/15.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import "CommentViewController.h"
#import "MMSystemHelper.h"
#import "CommentCell.h"
#import "CommentView.h"
#import "ITSApplication.h"
#import "SettingService.h"
#import "UUInputAccessoryView.h"
#import "PickerImageTools.h"
//#import "LoginViewController.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "AppStyleConfiguration.h"
#import "MMEventService.h"
#import "FansComment.h"
#import "WebviewController.h"
#import "CommentOneCell.h"

NSString *const CommentTableViewCellIdentifier = @"CommentCell";
NSString *const CommentOneTableViewCellIdentifier = @"CommentOneCell";

#define  WEAKSELF  __weak typeof(self) weakSelf = self;

@interface CommentViewController ()<UIGestureRecognizerDelegate>

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.screenName = @"comment.more";
    self.title = NSLocalizedString(@"tab_content", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    CGFloat screenW = [MMSystemHelper getScreenWidth];
    CGFloat screenH = [MMSystemHelper getScreenHeight];
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, 0, screenW, screenH - 40);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView registerClass:[CommentCell class] forCellReuseIdentifier:CommentTableViewCellIdentifier];
    [self.tableView registerClass:[CommentOneCell class] forCellReuseIdentifier:CommentOneTableViewCellIdentifier];
    [self.view addSubview:self.tableView];
    
    self.page = 1;
    self.offset = -64;
    self.commentView = [[CommentView alloc] initWithFrame:CGRectMake(0, screenH - 40, screenW, 44)];
    self.commentView.backgroundColor = [MMSystemHelper string2UIColor:COMMENT_BOTTOM_BG_COLOR];
//    [self.commentView.icon addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    self.commentView.delegate = self;
    [self.view addSubview:self.commentView];
    if (self.type == 1) {
        [self writeClick];
    }
    
    [self setupRefresh];
    
    NSString *str = @"Content with Facebook";
    CGSize size = [MMSystemHelper sizeWithString:str font:[UIFont systemFontOfSize:18] maxSize:CGSizeMake(MAXFLOAT, 45)];
    CGFloat width = size.width + 30 + 10 + 60;
    self.loginView = [[LoginView alloc] initWithFrame:CGRectMake(0, 0, width, 190)viewController:self];
    self.loginView.backgroundColor = [UIColor whiteColor];
    self.loginView.layer.masksToBounds = YES;
    self.loginView.layer.cornerRadius = 10;
    self.loginView.alpha = 0;
    self.loginView.center = self.view.center;
    [self.loginView.effectView addSubview:self.loginView];

    MMEventService* es = [MMEventService getInstance];
    [es addEventHandler:self eventName:EVENT_CELEB_REPLY_COMMENT_DATA_REFRESH selector:@selector(celebReplyCommentsDataRefreshListener:)];
    
    ITSApplication* itsApp = [ITSApplication get];
    DataService* ds = itsApp.dataSvr;
    CelebComment* currentComment = ds.currentCelebComment;

    NSMutableDictionary* eParams = [NSMutableDictionary dictionaryWithCapacity:1];
    [eParams setObject:@"forumid" forKey:@"fid"];
    [eParams setObject:currentComment.context forKey:@"context"];
    [itsApp.reportSvr recordEvent:@"本文" params:eParams eventCategory:@"comment.more.view"];
    
    //获取通知中心
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(keyChange:) name:UIKeyboardDidShowNotification object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    CBUserService* us = itsApp.cbUserSvr;
    if (us.user.isLogin == YES && us.user.isCBADM == YES){
        if (self.currentShowItem == nil)
            self.currentShowItem = [NSMutableArray arrayWithCapacity:1];
        self.currentShowDataCount = 0;
        self.sleepTimeCount = 3;
        self.readZeroCount = 0;
        [self initReadCheckListener];
    }
}

-(void) viewWillDisappear:(BOOL)animated{
    if (self.checkReadThread != nil)
        [self.checkReadThread cancel];
    [super viewWillDisappear:animated];
}

- (void) initReadCheckListener{
    self.checkReadThread = [[NSThread alloc] initWithTarget:self
                                                 selector:@selector(runCheckService)
                                                   object:nil];
    [self.checkReadThread start];
}

-(void) runCheckService{
    [[NSThread currentThread] setName:@"CBCheckRead"];
    //NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    //[runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
    
    while (![[NSThread currentThread] isCancelled]) {
        @try {
            //MMLogDebug(@"=======================================    checkThread");
            if (self == nil){
                return;
            }
            
            ITSApplication* itsApp = [ITSApplication get];
            DataService* ds = itsApp.dataSvr;
            CelebComment* currentComment = ds.currentCelebComment;
            NSMutableArray* replyList = currentComment.replayComments;
            NSInteger replyCount = replyList == nil ? 0 : [replyList count];
            
            //MMLogDebug(@"***************************************    %@", currentComment.fid);
            
            if (self.currentShowDataCount == 0 || self.currentShowDataCount != replyCount){
                self.readZeroCount = 0;
                self.sleepTimeCount = 3;
                
                self.currentShowDataCount = replyCount;
                [self.currentShowItem removeAllObjects];
                
                for (int i = 0; i < [self.tableView.indexPathsForVisibleRows count] ; i++) {
                    NSIndexPath* iPath = [self.tableView.indexPathsForVisibleRows objectAtIndex:i];
                    [self.currentShowItem addObject:iPath];
                }
            } else {
                NSMutableArray* readList = [NSMutableArray arrayWithCapacity:1];
                for (int i = 0; i < [self.tableView.indexPathsForVisibleRows count] ; i++) {
                    NSIndexPath* iPath = [self.tableView.indexPathsForVisibleRows objectAtIndex:i];
                    if (iPath.row > 0){
                        for (int j = 0; j < [self.currentShowItem count]; j++) {
                            NSIndexPath* oPath = [self.currentShowItem objectAtIndex:j];
                            if (iPath.row == oPath.row && iPath.row > 0 && oPath.row > 0){
                                FansComment* fc = [replyList objectAtIndex:oPath.row-1];
                                if (fc.isCelebRead == NO){
                                    [readList addObject:fc.cid];
                                    fc.isCelebRead = YES;
                                }
                                
                                if (fc.replayComments != nil){
                                    for (int m = 0; m < [fc.replayComments count]; m++) {
                                        FansComment* rfc = [fc.replayComments objectAtIndex:m];
                                        if (rfc.isCelebRead == NO){
                                            [readList addObject:rfc.cid];
                                            rfc.isCelebRead = YES;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                [itsApp.remoteSvr sendCelebReadReplys:currentComment.fid replys:readList];
                if ([readList count] == 0){
                    self.readZeroCount++;
                    if (self.readZeroCount >= 10){
                        self.readZeroCount = 0;
                        self.sleepTimeCount += self.sleepTimeCount;
                        if (self.sleepTimeCount > 10)
                            self.sleepTimeCount = 10;
                    }
                } else {
                    self.readZeroCount = 0;
                    self.sleepTimeCount = 3;
                }
                
                self.currentShowDataCount = replyCount;
                [self.currentShowItem removeAllObjects];
                for (int i = 0; i < [self.tableView.indexPathsForVisibleRows count] ; i++) {
                    NSIndexPath* iPath = [self.tableView.indexPathsForVisibleRows objectAtIndex:i];
                    [self.currentShowItem addObject:iPath];
                }
            }
            
            [NSThread sleepForTimeInterval:self.sleepTimeCount];
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    }
}

- (void)keyChange:(NSNotification *)notification {
    //获得键盘的尺寸
//        CGFloat curkeyBoardHeight = [[[notification userInfo] objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue].size.height;
    CGRect begin = [[[notification userInfo] objectForKey:@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    CGRect end = [[[notification userInfo] objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
        // 第三方键盘回调三次问题，监听仅执行最后一次
    if(begin.size.height > 0 && (begin.origin.y - end.origin.y > 0)){
        NSDictionary *dic = notification.userInfo;
        CGRect keyboardRect = [dic[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
        if (keyboardRect.size.height > 250 && self.replyViewDraw > keyboardRect.origin.y) {
            [UIView animateWithDuration:[dic[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
                    
                [UIView setAnimationCurve:[dic[UIKeyboardAnimationCurveUserInfoKey] doubleValue]];
                CGPoint point = self.tableView.contentOffset;
                self.offset = point.y;
                point.y -= (keyboardRect.origin.y - self.replyViewDraw);
                self.tableView.contentOffset = point;
            }];
        }
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
        NSDictionary *dic = notification.userInfo;
        CGRect keyboardRect = [dic[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
        if (keyboardRect.size.height > 250) {
            [UIView animateWithDuration:[dic[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
                
                [UIView setAnimationCurve:[dic[UIKeyboardAnimationCurveUserInfoKey] doubleValue]];
//                CGPoint point = self.tableView.contentOffset;
//                point.y += (keyboardRect.origin.y - self.replyViewDraw);
//                self.tableView.contentOffset = point;
                self.tableView.contentOffset = CGPointMake(0, self.offset);
        }];
    }
}

-(void)celebReplyCommentsDataRefreshListener: (id) data{
    if (self.view.hidden == NO){
        
        self.page++;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ITSApplication* itsApp = [ITSApplication get];
            DataService* ds = itsApp.dataSvr;
            CelebComment* currentComment = ds.currentCelebComment;
            NSArray* replyList = currentComment.replayComments;
    
            if (replyList != nil){
                NSInteger count = [replyList count];
                for (int i = 0; i < count; i++) {
                    FansComment* c = [replyList objectAtIndex:i];
                    if (c.uiFrame == nil){
                        CommentFrame* frame = [CommentFrame alloc];
                        [frame initWithCommentData:c];
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
        self.refreshType = CB_COMMENT_REPLY_REFRESH_TYPE_AFTER;
        ITSApplication* itsApp = [ITSApplication get];
        DataService* ds = itsApp.dataSvr;
        CelebComment* currentComment = ds.currentCelebComment;
        
//        [ds refreshReplyComments:CB_COMMENT_REPLY_REFRESH_TYPE_AFTER fid:currentComment.fid];
        [ds refreshReplyComments:self.page fid:currentComment.fid];

        self.isRefreshing = YES;
    }
}

- (void)footerRereshing
{
    if (self.isRefreshing == NO){
        self.refreshType = CB_COMMENT_REPLY_REFRESH_TYPE_BEFORE;
        ITSApplication* itsApp = [ITSApplication get];
        DataService* ds = itsApp.dataSvr;
        CelebComment* currentComment = ds.currentCelebComment;
        
//        [ds refreshReplyComments:CB_COMMENT_REPLY_REFRESH_TYPE_BEFORE fid:currentComment.fid];
        [ds refreshReplyComments:1 fid:currentComment.fid];
        self.isRefreshing = YES;
    }
}

- (void)push{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    [sheet showInView:self.view];
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    UIButton* Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    Btn.frame = CGRectMake(0, 20, 15, 20);
    [Btn setBackgroundImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:Btn];
    self.navigationItem.leftBarButtonItem = left;
    
    ITSApplication* itsApp = [ITSApplication get];
    DataService* ds = itsApp.dataSvr;
    CelebComment* currentComment = ds.currentCelebComment;
    if (currentComment.replayComments == nil){
        [self headerRereshing];
    }
    
//    SettingService* ss = [SettingService get];
//    NSString *str = [ss getStringValue:@"login" defValue:nil];
//    if (str.length > 0) {
//        [self writeClick];
//    }
}
- (void)clickBack{
    
    [self.navigationController popViewControllerAnimated:YES];
}
//调用相册
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    ITSApplication* poApp = [ITSApplication get];
//    DataService* ds = poApp.dataSvr;
    WEAKSELF
    if (0 == buttonIndex)
    {
        [[PickerImageTools ShareInstance] selectImageToolsWith:weakSelf];
        
    }
    if (1 == buttonIndex)
    {
        [[PickerImageTools ShareInstance] selectPhotograph:weakSelf];
    }
    
//    [PickerImageTools ShareInstance].pickerImageCameraBlock = ^(NSData *pickerImage){
//        
//       
//    };
}
#ifdef DEMO_DATA
-(NSMutableArray *)commentData
{
    if (!_commentData) {
        NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"replyGroup.plist" ofType:nil];
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:fullPath];
        NSArray *dataArr = [dictArray objectAtIndex:self.index];
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:[dataArr count]];
        for (NSDictionary *dict in dataArr) {
            CommentItem *item = [[CommentItem alloc] init];
            
//            DetailCommentItem *commentItem = [[DetailCommentItem alloc] init];
            CommentFrame *commentFrame = [[CommentFrame alloc]init];
            item.name = [dict objectForKey:@"name"];
            item.icon = [dict objectForKey:@"icon"];
            item.comment = [dict objectForKey:@"comment"];
            commentFrame.detailCommentItem = item;
            [models addObject:commentFrame];
//            commentItem.replys = [[NSMutableArray alloc] init];
//            commentItem.name = [dict objectForKey:@"name"];
//            commentItem.icon = [dict objectForKey:@"icon"];
//            commentItem.pictures = [dict objectForKey:@"pictures"];
//            commentItem.shuoshuoText = [dict objectForKey:@"shuoshuoText"];
//            NSMutableArray *reply = [dict objectForKey:@"replys"];
//            for (NSDictionary *dic in reply) {
//                ReplyItem *item = [[ReplyItem alloc] init];
//                item.name = [dic objectForKey:@"name"];
//                item.comment = [dic objectForKey:@"comment"];
//                item.icon = [dic objectForKey:@"icon"];
//                [item setValuesForKeysWithDictionary:dic];
//                commentItem.item = item;
//                [commentItem.replys addObject:item];
//            }
//            commentFrame.detailCommentItem = commentItem;
            
//            [models addObject:commentFrame];
        }
        _commentData = [models copy];
        
    }

    return _commentData;
}
#endif

- (void)writeNewComment{
    
    [self writeClick];
}
- (void)delayMethod {
    [UIView animateWithDuration:0.5 animations:^{
        self.loginView.alpha = 1;
    }];
}

//写新的评论
-(void)writeClick{
    
    UIKeyboardType type = UIKeyboardTypeDefault;
    ITSApplication* itsApp = [ITSApplication get];
    CBUserService* userSvr = itsApp.cbUserSvr;
    SettingService* ss = [SettingService get];

    [UUInputAccessoryView showKeyboardType:type
                                   content:@""
                                      name:@""
                                     Block:^(NSString *contentStr)
     {
         if (userSvr.user.isLogin == NO) {
//             LoginViewController *loginVc = [[LoginViewController alloc] init];
//             [self.navigationController pushViewController:loginVc animated:YES];
             [UIView animateWithDuration:0.5 animations:^{
                 self.loginView.effectView.alpha = 1;
             }];
             [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.5f];
             
//             [ss setStringValue:@"login" data:contentStr];

         }else{
             
#ifdef DEMO_DATA
             CommentFrame *FrameNeedChanged = [[CommentFrame alloc] init];
             CommentItem *commentItem = [[CommentItem alloc] init];
             commentItem.name = userSvr.user.userName;
             commentItem.icon = userSvr.user.avatar;
             //         commentItem.replys = 0;
             commentItem.comment = contentStr;
             FrameNeedChanged.detailCommentItem = commentItem;
             //        familyGroupFrameNeedChanged.
             NSMutableArray *mutaArray = [NSMutableArray arrayWithArray:self.commentData];
             
             [mutaArray insertObject:FrameNeedChanged atIndex:1];
             self.commentData = mutaArray;
             
             [self.tableView reloadData];
             
             
#else
             
             BOOL isEmpty = [MMSystemHelper isEmpty:contentStr];
             if (isEmpty == NO) {
                 ITSApplication* itsApp = [ITSApplication get];
                 DataService* ds = itsApp.dataSvr;
                 CelebComment* currentComment = ds.currentCelebComment;
                 
                 [itsApp.remoteSvr replayCelebComment:currentComment.fid comment:contentStr callback:^(int status, int code, NSDictionary *resultData) {
                     
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
                                 
                                 sendComment.uuid = retuuid;
                                 sendComment.fid = retfid;
                                 sendComment.cid = retcid;
                                 sendComment.pts = [MMSystemHelper getMillisecondTimestamp];
                                 sendComment.uts = sendComment.pts;
                                 
                                 CommentFrame* frame = [CommentFrame alloc];
                                 [frame initWithCommentData:sendComment];
                                 sendComment.uiFrame = frame;
                                 
                                 [ds userInsertCurrentReplyCommentItem:sendComment];
                                 
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     [self.tableView reloadData];
                                 });
                             }
                         }
                     }
                 }];

             }
#endif
         }
     }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    CGFloat height = 0;
#ifdef DEMO_DATA
    CommentFrame *frame = self.commentData[indexPath.row];
    return frame.cellHeight;
#else 
    
    ITSApplication* itsApp = [ITSApplication get];
    DataService* ds = itsApp.dataSvr;
    CelebComment* currentComment = ds.currentCelebComment;
    NSArray* replyList = currentComment.replayComments;
    if (currentComment != nil){
        if (replyList != nil) {
            if (indexPath.row == 0) {
                
                CGRect rect = [TQRichTextView boundingRectWithSize:CGSizeMake([MMSystemHelper getScreenWidth] - 63 - HOME_CONTENT_LEFT_PADDING, MAXFLOAT) font:[UIFont systemFontOfSize:16] string:currentComment.context lineSpace:0.5 type:2];
                height = 13 + 20 + 4 + rect.size.height + 4 + 20 + 10;
            }else {
                FansComment* c = [replyList objectAtIndex:indexPath.row - 1];
                height = c.uiFrame.cellHeight;
            }
        }else {

            CGRect rect = [TQRichTextView boundingRectWithSize:CGSizeMake([MMSystemHelper getScreenWidth] - 63 - HOME_CONTENT_LEFT_PADDING, MAXFLOAT) font:[UIFont systemFontOfSize:16] string:currentComment.context lineSpace:0.5 type:2];
            height = 13 + 20 + 4 + rect.size.height + 4 + 20 + 10;
        }
    }
    return height;
#endif
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
#ifdef DEMO_DATA
    return self.commentData.count;
#else
    ITSApplication* itsApp = [ITSApplication get];
    DataService* ds = itsApp.dataSvr;
    CelebComment* currentComment = ds.currentCelebComment;
    NSArray* replyList = currentComment.replayComments;
    
    if (replyList != nil){
        NSInteger count = [replyList count];
        for (int i = 0; i < count; i++) {
            FansComment* c = [replyList objectAtIndex:i];
            if (c.uiFrame == nil){
                CommentFrame* frame = [CommentFrame alloc];
                [frame initWithCommentData:c];
                c.uiFrame = frame;
            }
        }
    }
    
    if (replyList != nil){
        return replyList.count + 1;
    }else {
        return 1;
    }
//    return 0;
#endif
    
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = nil;
    
#ifdef DEMO_DATA
    tmpCell.detailCommentFrame = self.commentData[indexPath.row];
    
#else
    ITSApplication* itsApp = [ITSApplication get];
    DataService* ds = itsApp.dataSvr;
    CelebComment* currentComment = ds.currentCelebComment;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:CommentOneTableViewCellIdentifier forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[CommentOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CommentOneTableViewCellIdentifier];
        }
        CommentOneCell *tmpCell = (CommentOneCell*)cell;
        tmpCell.commentLabel.delegage = self;

        [tmpCell setShowData:currentComment];
//        tmpCell.delButton.hidden = YES;
        [tmpCell.replyButton addTarget:self action:@selector(replyClick:) forControlEvents:UIControlEventTouchUpInside];
        tmpCell.replyButton.userInteractionEnabled = YES;
        tmpCell.replyButton.tag = indexPath.row;

        return tmpCell;

    }else {

        cell = [tableView dequeueReusableCellWithIdentifier:CommentTableViewCellIdentifier forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CommentTableViewCellIdentifier];
        }
        CommentCell *tmpCell = (CommentCell*)cell;

        NSArray* replyList = currentComment.replayComments;
        if (replyList != nil){
            [tmpCell.replyButton addTarget:self action:@selector(replyClick:) forControlEvents:UIControlEventTouchUpInside];
            tmpCell.replyButton.tag = indexPath.row;

            FansComment* c = [replyList objectAtIndex:indexPath.row - 1];
            CommentFrame *frame = [[CommentFrame alloc] init];
            [frame initWithCommentData:c];
            c.uiFrame = frame;
            [tmpCell setShowData:c];
            [tmpCell setDetailCommentFrame:c.uiFrame];
        }
        tmpCell.myIndexPath = indexPath;
        tmpCell.delegate = self;
        
        [tmpCell.iconBtn addTarget:self action:@selector(replyClick:) forControlEvents:UIControlEventTouchUpInside];
        tmpCell.iconBtn.tag = indexPath.row;
        for (int i = 0; i < [tmpCell.replyIconView count]; i++) {
            ((UIImageView *)[tmpCell.replyIconView objectAtIndex:i]).frame = [(NSValue *)[tmpCell.detailCommentFrame.replyPictureF objectAtIndex:i] CGRectValue];
            tmpCell.replyIcon = [tmpCell.replyIconView objectAtIndex:i];
            tmpCell.replyIcon.userInteractionEnabled = YES;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, tmpCell.replyIcon.frame.size.width, tmpCell.replyIcon.frame .size.height);
            //        [button addTarget:self action:@selector(tapReply:) forControlEvents:UIControlEventTouchUpInside];
            button.userInteractionEnabled = YES;
            button.tag = indexPath.row;
            [tmpCell.replyIcon addSubview:button];
        }
        for (int i = 0; i < [tmpCell.replyNameView count]; i++) {
            ((UILabel *)[tmpCell.replyNameView objectAtIndex:i]).frame = [(NSValue *)[tmpCell.detailCommentFrame.replyNameF objectAtIndex:i] CGRectValue];
            tmpCell.replyNameLabel = [tmpCell.replyNameView objectAtIndex:i];
            tmpCell.replyNameLabel.userInteractionEnabled = YES;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, tmpCell.replyNameLabel.frame.size.width, tmpCell.replyNameLabel.frame .size.height);
            //        [button addTarget:self action:@selector(tapReply:) forControlEvents:UIControlEventTouchUpInside];
            button.userInteractionEnabled = YES;
            button.tag = indexPath.row;
            [tmpCell.replyNameLabel addSubview:button];
        }
        return tmpCell;
    }
   
#endif
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if ([scrollView isKindOfClass:[UITableView class]]) {
        self.offset = self.tableView.contentOffset.y;
    }
}
//#pragma mark - UIGestureRecognizerDelegate
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    // 输出点击的view的类名
//    NSLog(@"%@", NSStringFromClass([touch.view class]));
//    
//    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
//    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
//        return YES;
//    }
//    return  NO;
//}  

- (void)richTextView:(TQRichTextView *)view touchBeginRun:(TQRichTextRun *)run
{
    
}

- (void)richTextView:(TQRichTextView *)view touchEndRun:(TQRichTextRun *)run
{
    WebviewController *webView = [[WebviewController alloc] init];
    webView.path = run.text;
    webView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webView animated:YES];
}
//-(void)viewCellInitial:(NSIndexPath *)indepath scr:(UIScrollView *)scr{
//    CommentCell *cell = [self.tableView cellForRowAtIndexPath:indepath];
//    CGFloat screenW = [MMSystemHelper getScreenWidth];
//
//    [UIView animateWithDuration:0.3 animations:^{
//        cell.bgView.frame =  CGRectMake(0, 0, screenW, cell.detailCommentFrame.BgViewF.size.height);
//    }];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {


}
//回复的回复
- (void)tapReply:(UIButton *)btn{

    ITSApplication* itsApp = [ITSApplication get];
    DataService* ds = itsApp.dataSvr;
    CBUserService* userSvr = itsApp.cbUserSvr;
//    SettingService* ss = [SettingService get];
    
    NSString* commentId = @"";

    [UUInputAccessoryView showKeyboardType:UIKeyboardTypeDefault
                                   content:@""
                                      name:@""
                                     Block:^(NSString *contentStr)
     {
         
         if (userSvr.user.isLogin == NO) {
             [UIView animateWithDuration:0.5 animations:^{
                 self.loginView.effectView.alpha = 1;
             }];
             [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.5f];

//             LoginViewController *loginVc = [[LoginViewController alloc] init];
//             [self.navigationController pushViewController:loginVc animated:YES];
//             [ss setStringValue:@"login" data:contentStr];

         }else {
             
#ifdef DEMO_DATA
             CommentFrame *frameNeedChanged = [self.commentData objectAtIndex:btn.tag];
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
             newsItem.type = 2;
             frameNeedChanged.detailCommentItem = newReplyItem;
             [self.tableView reloadData];
             
#endif

         }
    }];
}
- (void)replyClick:(UIButton *)btn {
    
    if (btn.tag == 0) {
        CommentOneCell *cell = (CommentOneCell *)btn.superview.superview;
        self.replyViewDraw = [cell convertRect:cell.bounds toView:self.view.window].origin.y + cell.frame.size.height;
    }else {
        CommentCell *cell = (CommentCell *)btn.superview.superview;
        self.replyViewDraw = [cell convertRect:cell.bounds toView:self.view.window].origin.y + cell.frame.size.height;
    }

//    self.replyViewDraw = rectInTableView.origin.y + rectInTableView.size.height;
    if (btn.tag == 0) {
        [self writeNewComment];
    }else{
        [self replyToreply:btn.tag];
    }
    ITSApplication* itsApp = [ITSApplication get];
    NSMutableDictionary* eParams = [NSMutableDictionary dictionaryWithCapacity:1];
    [eParams setObject:@"forumid" forKey:@"fid"];
    [eParams setObject:self.context forKey:@"context"];
    [itsApp.reportSvr recordEvent:@"reply" params:eParams eventCategory:@"comment.more.click"];
}

//粉丝互相回复
- (void)replyToreply :(NSInteger)index{
    
    ITSApplication* itsApp = [ITSApplication get];
    DataService* ds = itsApp.dataSvr;
    CBUserService* userSvr = itsApp.cbUserSvr;
//    SettingService* ss = [SettingService get];

    
    [UUInputAccessoryView showKeyboardType:UIKeyboardTypeDefault
                                   content:@""
                                      name:@""
                                     Block:^(NSString *contentStr)
     {
         
         if (userSvr.user.isLogin == NO) {
             [UIView animateWithDuration:0.5 animations:^{
                 self.loginView.effectView.alpha = 1;
             }];
             [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.5f];
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
             CelebComment* currentComment = ds.currentCelebComment;
             FansComment* currentFansComment = nil;
             NSArray* replyList = currentComment.replayComments;
             if (replyList != nil){
                 if (index-1 < [replyList count]){
                     currentFansComment = [replyList objectAtIndex:index-1];
                 }
             }
             
             if (currentFansComment == nil){
                 return;
             }

             [itsApp.remoteSvr replayFansComment:currentComment.fid replayCommendId:currentFansComment.cid comment:contentStr callback:^(int status, int code, NSDictionary *resultData) {
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
