
//
//  HomeViewController.m
//  InternetStir
//
//  Created by Apple on 16/8/18.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import "HomeViewController.h"
#import "MenuViewController.h"
#import "MMSystemHelper.h"
#import "HomeCommentCell.h"
#import "CommentViewController.h"
#import "UUInputAccessoryView.h"
#import "ITSAppConst.h"
#import "CommentFrame.h"
#import "AppStyleConfiguration.h"
#import "TestController.h"
#import "DetailCommentController.h"

#define screenW [MMSystemHelper getScreenWidth]
#define screenH [MMSystemHelper getScreenHeight]

NSString *const HomeCommentCellIdentifier = @"HomeCommentCell";

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, 0, screenW, screenH);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[HomeCommentCell class] forCellReuseIdentifier:HomeCommentCellIdentifier];

    [self.view addSubview:self.tableView];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height;
    HomeCommentFrame *frame = self.commentData[indexPath.row];
    height = frame.cellHeight;
    return height;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.commentData.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:HomeCommentCellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[HomeCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HomeCommentCellIdentifier];
    }
    HomeCommentCell *tmpCell = (HomeCommentCell*)cell;
    tmpCell.commentFrame = self.commentData[indexPath.row];
    tmpCell.button.tag = indexPath.row;
    [tmpCell.button addTarget:self action:@selector(pushComment:) forControlEvents:UIControlEventTouchUpInside];
    [tmpCell.commentBtn addTarget:self action:@selector(pushNextVc:) forControlEvents:UIControlEventTouchUpInside];
    tmpCell.commentBtn.tag = indexPath.row;
    [tmpCell.btn addTarget:self action:@selector(pushDetailVc:) forControlEvents:UIControlEventTouchUpInside];
    tmpCell.btn.tag = indexPath.row;
    for (int i = 0; i < [tmpCell.replysView count]; i++) {
        ((UILabel *)[tmpCell.replysView objectAtIndex:i]).frame = [(NSValue *)[tmpCell.commentFrame.replysF objectAtIndex:i] CGRectValue];
        tmpCell.replyLabel = [tmpCell.replysView objectAtIndex:i];
        tmpCell.replyLabel.userInteractionEnabled = YES;
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(0, 0, tmpCell.replyLabel.frame.size.width, tmpCell.replyLabel.frame .size.height);
        
//        [button addTarget:self action:@selector(tapReply:) forControlEvents:UIControlEventTouchUpInside];
//        button.userInteractionEnabled = YES;
//        button.tag = indexPath.row;
//        [tmpCell.replyLabel addSubview:button];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailCommentController *vc = [[DetailCommentController alloc] init];
    HomeCommentFrame *frame = self.commentData[indexPath.row];
    vc.headHeight = frame.headH;
    vc.item = frame.commentItem;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)pushDetailVc:(UIButton *)button {
    
    DetailCommentController *detail = [[DetailCommentController alloc] init];
    HomeCommentFrame *frame = self.commentData[button.tag];
    detail.hidesBottomBarWhenPushed = YES;
    detail.index = button.tag;
    detail.headHeight = frame.headH;
    detail.item = frame.commentItem;
    [self.navigationController pushViewController:detail animated:YES];
}
- (void)pushNextVc:(UIButton *)button{
    
    CommentViewController *vc = [[CommentViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.index = button.tag;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)pushComment:(UIButton*)button{
    
    CommentViewController *vc = [[CommentViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.index = button.tag;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)tapReply:(UIButton *)button{
    
//    CommentViewController *vc = [[CommentViewController alloc] init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    
//    [UUInputAccessoryView showKeyboardType:UIKeyboardTypeDefault
//                                   content:@""
//                                      name:@""
//                                     Block:^(NSString *contentStr)
//     {
//         
//         
//         
//     }];
}

-(NSMutableArray *)commentData
{
    if (!_commentData) {
        NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"FamilyGroup.plist" ofType:nil];
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:fullPath];
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:[dictArray count]];
        for (NSDictionary *dict in dictArray) {
            HomeCommentItem *commentItem = [[HomeCommentItem alloc] init];
            HomeCommentFrame *commentFrame = [[HomeCommentFrame alloc]init];
            commentItem.replys = [[NSMutableArray alloc] init];
            commentItem.name = [dict objectForKey:@"name"];
            commentItem.icon = [dict objectForKey:@"icon"];
            commentItem.pictures = [dict objectForKey:@"pictures"];
            commentItem.shuoshuoText = [dict objectForKey:@"shuoshuoText"];
            commentItem.time = [dict objectForKey:@"time"];
            NSMutableArray *reply = [dict objectForKey:@"replys"];
            for (NSDictionary *dic in reply) {
                ReplyItem *item = [[ReplyItem alloc] init];
                item.name = [dic objectForKey:@"name"];
                item.comment = [dic objectForKey:@"comment"];
                item.icon = [dic objectForKey:@"icon"];
                [item setValuesForKeysWithDictionary:dic];
                commentItem.item = item;
                [commentItem.replys addObject:item];
            }
            commentFrame.commentItem = commentItem;
            
            [models addObject:commentFrame];
        }
        _commentData = [models copy];
    }
    
    return _commentData;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:[MMSystemHelper string2UIColor:HOME_VIPNAME_COLOR]}];
    
//    UIButton* Btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    Btn.frame = CGRectMake(0, 20, 30, 30);
//    [Btn setBackgroundImage:[UIImage imageNamed:@"icon_Menu"] forState:UIControlStateNormal];
//    [Btn addTarget:self action:@selector(pushMenu) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:Btn];
//    self.navigationItem.leftBarButtonItem = left;
//    
//    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(screenW - 40, 20, 30, 30);
//    [button setBackgroundImage:[UIImage imageNamed:@"icon_Menu"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:button];
//    self.navigationItem.rightBarButtonItem = right;
    
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
- (void)push {
    
    TestController *test = [[TestController alloc] init];
    [self.navigationController pushViewController:test animated:YES];
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
