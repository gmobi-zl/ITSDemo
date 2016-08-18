
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

#define screenW [MMSystemHelper getScreenWidth]
#define screenH [MMSystemHelper getScreenHeight]

NSString *const CommentCellIdentifier = @"CommentCell";

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"蔡阿嘎";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, 0, screenW, screenH);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[CommentCell class] forCellReuseIdentifier:CommentCellIdentifier];

    [self.view addSubview:self.tableView];
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
            CommentItem *commentItem = [CommentItem familyGroupWithDict:dict];
            CommentFrame *commentFrame = [[CommentFrame alloc]init];
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
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    UIButton* Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    Btn.frame = CGRectMake(0, 20, 30, 30);
    [Btn setBackgroundImage:[UIImage imageNamed:@"list_2"] forState:UIControlStateNormal];
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
