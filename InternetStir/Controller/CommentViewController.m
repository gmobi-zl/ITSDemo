
//
//  CommentViewController.m
//  InternetStir
//
//  Created by Apple on 16/8/15.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import "CommentViewController.h"
#import "MMSystemHelper.h"
#import "DetailCommentCell.h"
#import "CommentView.h"
#import "ITSApplication.h"
#import "SettingService.h"
#import "UUInputAccessoryView.h"
#import "PickerImageTools.h"

NSString *const DetailCommentTableViewCellIdentifier = @"DetailCommentCell";

#define  WEAKSELF  __weak typeof(self) weakSelf = self;

@interface CommentViewController ()<UIGestureRecognizerDelegate>

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"蔡阿嘎";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    CGFloat screenW = [MMSystemHelper getScreenWidth];
    CGFloat screenH = [MMSystemHelper getScreenHeight];
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, 0, screenW, screenH - 104);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView registerClass:[DetailCommentCell class] forCellReuseIdentifier:DetailCommentTableViewCellIdentifier];
    [self.view addSubview:self.tableView];
    
    self.commentView = [[CommentView alloc] initWithFrame:CGRectMake(0, screenH - 104, screenW, 40)];
    self.commentView.backgroundColor = [UIColor blackColor];
    [self.commentView.icon addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    self.commentView.delegate = self;
    [self.view addSubview:self.commentView];
    [self writeClick];
    
//    self.replyData = [[NSMutableArray alloc] init];
}
- (void)push{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    [sheet showInView:self.view];
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    UIButton* Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    Btn.frame = CGRectMake(0, 20, 30, 30);
    [Btn setBackgroundImage:[UIImage imageNamed:@"icon_Back"] forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:Btn];
    self.navigationItem.leftBarButtonItem = left;

}
- (void)clickBack{
    
    [self.navigationController popViewControllerAnimated:YES];
}
//调用相册
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ITSApplication* poApp = [ITSApplication get];
    DataService* ds = poApp.dataSvr;
    WEAKSELF
    if (0 == buttonIndex)
    {
        [[PickerImageTools ShareInstance] selectImageToolsWith:weakSelf];
        
    }
    if (1 == buttonIndex)
    {
        [[PickerImageTools ShareInstance] selectPhotograph:weakSelf];
    }
    
    [PickerImageTools ShareInstance].pickerImageCameraBlock = ^(NSData *pickerImage){
        
       
    };
}
-(NSMutableArray *)commentData
{
    if (!_commentData) {
        NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"replyGroup.plist" ofType:nil];
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:fullPath];
        NSArray *dataArr = [dictArray objectAtIndex:self.index];
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:[dataArr count]];
        for (NSDictionary *dict in dataArr) {
            ReplyItem *item = [[ReplyItem alloc] init];
            
//            DetailCommentItem *commentItem = [[DetailCommentItem alloc] init];
            DetailCommentFrame *commentFrame = [[DetailCommentFrame alloc]init];
            item.name = [dict objectForKey:@"name"];
            item.icon = [dict objectForKey:@"icon"];
            item.comment = [dict objectForKey:@"comment"];
            commentFrame.item = item;
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
    SettingService* ss = [SettingService get];
    
    ITSApplication* poApp = [ITSApplication get];
    DataService* ds = poApp.dataSvr;
    
    [UUInputAccessoryView showKeyboardType:type
                                   content:@""
                                      name:@""
                                     Block:^(NSString *contentStr)
     {
         DetailCommentFrame *FrameNeedChanged = [[DetailCommentFrame alloc] init];
         ReplyItem *commentItem = [[ReplyItem alloc] init];
         commentItem.name = @"孙燕姿";
         commentItem.icon = @"高圆圆";
//         commentItem.replys = 0;
         commentItem.comment = contentStr;
         FrameNeedChanged.item = commentItem;
         //        familyGroupFrameNeedChanged.
         NSMutableArray *mutaArray = [NSMutableArray arrayWithArray:self.commentData];
         
         [mutaArray insertObject:FrameNeedChanged atIndex:self.commentData.count];
         self.commentData = mutaArray;
         
         [self.tableView reloadData];

     }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailCommentFrame *frame = self.commentData[indexPath.row];
    return frame.cellHeight;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.commentData.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:DetailCommentTableViewCellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[DetailCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DetailCommentTableViewCellIdentifier];
    }
    DetailCommentCell *tmpCell = (DetailCommentCell*)cell;
    tmpCell.detailCommentFrame = self.commentData[indexPath.row];
    return tmpCell;
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
