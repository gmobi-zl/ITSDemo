
//
//  DetailCommentController.m
//  Jacob
//
//  Created by Apple on 16/9/18.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import "DetailCommentController.h"
#import "HomeCommentItem.h"
#import "HomeCommentFrame.h"
#import "MMSystemHelper.h"
#import "AppStyleConfiguration.h"
#import "DetailCommentCell.h"
#import "ITSApplication.h"
#import "UUInputAccessoryView.h"
#import "LoginViewController.h"
#import "SettingService.h"
#import "CommentView.h"
#import "CommentViewController.h"

#define screenW [MMSystemHelper getScreenWidth]
#define screenH [MMSystemHelper getScreenHeight]

NSString *const DetailCommentCellIdentifier = @"DetailCommentCell";

@interface DetailCommentController ()

@end

@implementation DetailCommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.title = @"留言";
    [self creatHeadView];
    [self creatTableView];
    self.commentView = [[CommentView alloc] initWithFrame:CGRectMake(0, screenH - 40, screenW, 44)];
    self.commentView.backgroundColor = [MMSystemHelper string2UIColor:COMMENT_BOTTOM_BG_COLOR];
    self.commentView.delegate = self;
    [self.view addSubview:self.commentView];
}
- (void)creatHeadView {
    self.headView = [[HeadView alloc] initWithFrame:CGRectMake(0, 64, screenW, self.headHeight) CommentItem:self.item];
    [self.headView.commentBtn addTarget:self action:@selector(pushCommentVc:) forControlEvents:UIControlEventTouchUpInside];
    self.headView.tag = self.index;
    [self.view addSubview:self.headView];
}
- (void)pushCommentVc:(UIButton* )button {
    CommentViewController *view = [[CommentViewController alloc] init];
    view.index = self.index;
    [self.navigationController pushViewController:view animated:YES];
}
- (void)creatTableView {
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, 0, screenW, screenH - 44);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.headView;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[DetailCommentCell class] forCellReuseIdentifier:DetailCommentCellIdentifier];
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailCommentFrame *frame = self.commentData[indexPath.row];
    return frame.cellHeight;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentData.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:DetailCommentCellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[DetailCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DetailCommentCellIdentifier];
    }
    DetailCommentCell *tmpCell = (DetailCommentCell*)cell;
    [tmpCell.bgButton addTarget:self action:@selector(replyClick:) forControlEvents:UIControlEventTouchUpInside];
    tmpCell.bgButton.tag = indexPath.row ;
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
             DetailCommentFrame *frameNeedChanged = [self.commentData objectAtIndex:btn.tag];
             DetailCommentItem *newReplyItem = frameNeedChanged.detailCommentItem;
             
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
             DetailCommentFrame *FrameNeedChanged = [[DetailCommentFrame alloc] init];
             DetailCommentItem *commentItem = [[DetailCommentItem alloc] init];
             commentItem.name = userSvr.user.userName;
             commentItem.icon = userSvr.user.avatar;
             commentItem.comment = contentStr;
             FrameNeedChanged.detailCommentItem = commentItem;
             
             NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
             NSTimeInterval a = [dat timeIntervalSince1970]*1000;
             NSString *timeString = [NSString stringWithFormat:@"%f", a];
             commentItem.time = timeString;
             
             NSMutableArray *mutaArray = [NSMutableArray arrayWithArray:self.commentData];
             [mutaArray insertObject:FrameNeedChanged atIndex:0];
             self.commentData = mutaArray;
             [self.tableView reloadData];
         }
     }];
}
//粉丝互相回复
- (void)replyToreply :(NSInteger)index{
    
    ITSApplication* itsApp = [ITSApplication get];
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
             DetailCommentFrame *frameNeedChanged = [self.commentData objectAtIndex:index];
             DetailCommentItem *newReplyItem = frameNeedChanged.detailCommentItem;
             
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:[MMSystemHelper string2UIColor:HOME_COMMENT_COLOR]}];
    
    UIButton* Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    Btn.frame = CGRectMake(0, 20, 15, 20);
    [Btn setBackgroundImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:Btn];
    self.navigationItem.leftBarButtonItem = left;

}
- (void)clickBack {
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSMutableArray *)commentData
{
    if (!_commentData) {
        NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"replyGroup.plist" ofType:nil];
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:fullPath];
        NSArray *dataArr = [dictArray objectAtIndex:self.index];
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:[dataArr count]];
        for (NSDictionary *dict in dataArr) {
            DetailCommentItem *item = [[DetailCommentItem alloc] init];
            
            DetailCommentFrame *commentFrame = [[DetailCommentFrame alloc]init];
            item.name = [dict objectForKey:@"name"];
            item.icon = [dict objectForKey:@"icon"];
            item.comment = [dict objectForKey:@"comment"];
            commentFrame.detailCommentItem = item;
            [models addObject:commentFrame];
        }
        [models removeObjectAtIndex:0];
        _commentData = [models copy];
//        [_commentData removeObjectAtIndex:0];
    }
    return _commentData;
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
