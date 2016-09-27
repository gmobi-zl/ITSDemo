
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
#import "LoginViewController.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "AppStyleConfiguration.h"

NSString *const CommentTableViewCellIdentifier = @"CommentCell";

#define  WEAKSELF  __weak typeof(self) weakSelf = self;

@interface CommentViewController ()<UIGestureRecognizerDelegate>

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"留言";
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
    [self.view addSubview:self.tableView];
    
    self.commentView = [[CommentView alloc] initWithFrame:CGRectMake(0, screenH - 40, screenW, 44)];
    self.commentView.backgroundColor = [MMSystemHelper string2UIColor:COMMENT_BOTTOM_BG_COLOR];
//    [self.commentView.icon addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    self.commentView.delegate = self;
    [self.view addSubview:self.commentView];
//    [self writeClick];
    
    [self setupRefresh];
}
- (void)setupRefresh
{
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    self.tableView.headerPullToRefreshText = ITS_NSLocalizedString(@"Pull2Load", STR_PULL_REFRESH_PULL);
    self.tableView.headerReleaseToRefreshText = ITS_NSLocalizedString(@"Release2Refresh", STR_PULL_REFRESH_RELEASE);
    self.tableView.headerRefreshingText = ITS_NSLocalizedString(@"LoadingNews", STR_PULL_REFRESH_LOADING);
    
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    self.tableView.footerPullToRefreshText = ITS_NSLocalizedString (@"Pull2Load", STR_PULL_REFRESH_PULL);
    self.tableView.footerReleaseToRefreshText = ITS_NSLocalizedString(@"Release2Refresh", STR_PULL_REFRESH_RELEASE);
    self.tableView.footerRefreshingText = ITS_NSLocalizedString(@"LoadingNews", STR_PULL_REFRESH_LOADING);
}
#pragma mark 开始进入刷新状态
- (void)headerRereshing
{

}
- (void)footerRereshing
{

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
    
//    SettingService* ss = [SettingService get];
//    NSString *str = [ss getStringValue:@"login" defValue:nil];
//    if (str.length > 0) {
//        [self writeClick];
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

- (void)writeNewComment{
    
    [self writeClick];
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
             LoginViewController *loginVc = [[LoginViewController alloc] init];
             [self.navigationController pushViewController:loginVc animated:YES];
             [ss setStringValue:@"login" data:contentStr];

         }else{
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
         }
     }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CommentFrame *frame = self.commentData[indexPath.row];
    return frame.cellHeight;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.commentData.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:CommentTableViewCellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CommentTableViewCellIdentifier];
    }
    CommentCell *tmpCell = (CommentCell*)cell;
    [tmpCell.replyButton addTarget:self action:@selector(replyClick:) forControlEvents:UIControlEventTouchUpInside];
    tmpCell.replyButton.tag = indexPath.row;
    tmpCell.detailCommentFrame = self.commentData[indexPath.row];

    for (int i = 0; i < [tmpCell.replyIconView count]; i++) {
        ((UIImageView *)[tmpCell.replyIconView objectAtIndex:i]).frame = [(NSValue *)[tmpCell.detailCommentFrame.replyPictureF objectAtIndex:i] CGRectValue];
        tmpCell.replyIcon = [tmpCell.replyIconView objectAtIndex:i];
        tmpCell.replyIcon.userInteractionEnabled = YES;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, tmpCell.replyIcon.frame.size.width, tmpCell.replyIcon.frame .size.height);
        [button addTarget:self action:@selector(tapReply:) forControlEvents:UIControlEventTouchUpInside];
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
        [button addTarget:self action:@selector(tapReply:) forControlEvents:UIControlEventTouchUpInside];
        button.userInteractionEnabled = YES;
        button.tag = indexPath.row;
        [tmpCell.replyNameLabel addSubview:button];
    }
    return tmpCell;
}
//回复的回复
- (void)tapReply:(UIButton *)btn{

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
             LoginViewController *loginVc = [[LoginViewController alloc] init];
             [self.navigationController pushViewController:loginVc animated:YES];
//             [ss setStringValue:@"login" data:contentStr];

         }else {
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

         }
    }];
}
- (void)replyClick:(UIButton *)btn {
    
    if (btn.tag == 0) {
        [self writeNewComment];
    }else{
        [self replyToreply:btn.tag];
    }
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
             LoginViewController *loginVc = [[LoginViewController alloc] init];
             [self.navigationController pushViewController:loginVc animated:YES];
//             [ss setStringValue:@"login" data:contentStr];

         }else {
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
