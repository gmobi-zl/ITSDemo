
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
#import "CommentCell.h"
#import "CommentViewController.h"
#import "UUInputAccessoryView.h"
#import "ITSAppConst.h"

#define screenW [MMSystemHelper getScreenWidth]
#define screenH [MMSystemHelper getScreenHeight]

NSString *const CommentCellIdentifier = @"CommentCell";

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"蔡阿嘎";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, 0, screenW, screenH - 64);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[CommentCell class] forCellReuseIdentifier:CommentCellIdentifier];

    [self.view addSubview:self.tableView];
    
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, -20, screenW, 20)];
    statusBarView.backgroundColor = [MMSystemHelper string2UIColor:NAV_BGCOLOR];
    [self.navigationController.navigationBar addSubview:statusBarView];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height;
    CommentFrame *frame = self.commentData[indexPath.row];
    height = frame.cellHeight;
    return height;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.commentData.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:CommentCellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CommentCellIdentifier];
    }
    CommentCell *tmpCell = (CommentCell*)cell;
    tmpCell.commentFrame = self.commentData[indexPath.row];
    tmpCell.button.tag = indexPath.row;
    [tmpCell.button addTarget:self action:@selector(pushComment:) forControlEvents:UIControlEventTouchUpInside];
    for (int i = 0; i < [tmpCell.replysView count]; i++) {
        ((UILabel *)[tmpCell.replysView objectAtIndex:i]).frame = [(NSValue *)[tmpCell.commentFrame.replysF objectAtIndex:i] CGRectValue];
        tmpCell.replyLabel = [tmpCell.replysView objectAtIndex:i];
        tmpCell.replyLabel.userInteractionEnabled = YES;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, tmpCell.replyLabel.frame.size.width, tmpCell.replyLabel.frame .size.height);
        
        [button addTarget:self action:@selector(tapReply:) forControlEvents:UIControlEventTouchUpInside];
        button.userInteractionEnabled = YES;
        button.tag = indexPath.row;
        [tmpCell.replyLabel addSubview:button];
    }
    
    return cell;
}
- (void)pushComment:(UIButton*)button{
    
    CommentViewController *vc = [[CommentViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.frame = [self.commentData objectAtIndex:button.tag];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)tapReply:(UIButton *)button{
    
    [UUInputAccessoryView showKeyboardType:UIKeyboardTypeDefault
                                   content:@""
                                      name:@""
                                     Block:^(NSString *contentStr)
     {
         
         
         
     }];
}

-(NSMutableArray *)commentData
{
    if (!_commentData) {
        NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"FamilyGroup.plist" ofType:nil];
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:fullPath];
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:[dictArray count]];
        for (NSDictionary *dict in dictArray) {
            CommentItem *commentItem = [[CommentItem alloc] init];
            CommentFrame *commentFrame = [[CommentFrame alloc]init];
            commentItem.replys = [[NSMutableArray alloc] init];
            commentItem.name = [dict objectForKey:@"name"];
            commentItem.icon = [dict objectForKey:@"icon"];
            commentItem.pictures = [dict objectForKey:@"pictures"];
            commentItem.shuoshuoText = [dict objectForKey:@"shuoshuoText"];
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
    //NSLog(@"%lu",(unsigned long)[_statusFrames count]);
    return _commentData;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.title = @"蔡阿嘎";
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    UIButton* Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    Btn.frame = CGRectMake(0, 20, 30, 30);
    [Btn setBackgroundImage:[UIImage imageNamed:@"icon_Menu"] forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(pushMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:Btn];
    self.navigationItem.leftBarButtonItem = left;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
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
