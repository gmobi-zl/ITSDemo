
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
#import "ITSApplication.h"
#import "DetailCommentController.h"
#import "SettingService.h"
#import "WriteArticleController.h"

#define screenW [MMSystemHelper getScreenWidth]
#define screenH [MMSystemHelper getScreenHeight]

NSString *const HomeCommentCellIdentifier = @"HomeCommentCell";
#define  WEAKSELF  __weak typeof(self) weakSelf = self;

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
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    self.effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    self.effectView.frame = CGRectMake(0, 0, screenW, screenH);
    self.effectView.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:self.effectView];
    
    self.loginView = [[LoginView alloc] initWithFrame:CGRectMake(0, 0, screenW - 40, 190)];
    self.loginView.backgroundColor = [UIColor whiteColor];
    self.loginView.alpha = 0.5;
    self.loginView.layer.masksToBounds = YES;
    self.loginView.layer.cornerRadius = 10;
    self.loginView.center = self.view.center;
    [self.loginView.loginButton addTarget:self action:@selector(loginFB) forControlEvents:UIControlEventTouchUpInside];
    [self.loginView.cancelButton addTarget:self action:@selector(cancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.effectView addSubview:self.loginView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFacebookUserInfo) name:@"getFacebookUserInfo" object:[ITSApplication get].fbSvr];
}
- (void)loginFB {
    
    ITSApplication* poApp = [ITSApplication get];
    FacebookService *faceBook = poApp.fbSvr;
    self.effectView.hidden = YES;
    [faceBook facebookLogin:^(int resultCode) {
        if (resultCode == ITS_FB_LOGIN_SUCCESS) {
            [faceBook facebookUserInfo];
        } else {
            UIAlertView *al = [[UIAlertView alloc] initWithTitle:nil message:@"登陸超時" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
            [al show];
        }
    } viewController:self];
}
- (void)cancelBtn {
    self.effectView.hidden = YES;
}
- (void)getFacebookUserInfo{
    
    ITSApplication* itsApp = [ITSApplication get];
    CBUserService* us = itsApp.cbUserSvr;
    
    FacebookService *facebook = itsApp.fbSvr;
    us.user.userName = facebook.userName;
    us.user.avatar = facebook.icon;
    us.user.email = facebook.email;
    us.user.isLogin = YES;
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         @"facebook",@"type",
                         facebook.uId,@"openid",
                         facebook.userName ,@"name",
                         facebook.icon,@"avatar",
                         facebook.email,@"email",
                         [[NSNumber alloc] initWithBool:us.user.isLogin],@"isLogin",
                         nil];
    
    SettingService* ss = [SettingService get];
    [ss setDictoryValue:CONFIG_USERLOGIN_INFO data:dic];
    self.effectView.hidden = YES;
    [self.Btn setTitle:@"" forState:UIControlStateNormal];
    self.Btn.userInteractionEnabled = NO;
//    [self.tableView reloadData];
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
    [tmpCell.favBtn addTarget:self action:@selector(favBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    tmpCell.favBtn.tag = indexPath.row;
    tmpCell.btn.tag = indexPath.row;
    [tmpCell.delBtn addTarget:self action:@selector(pushSheet:) forControlEvents:UIControlEventTouchUpInside];
    tmpCell.delBtn.tag = indexPath.row;
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
- (void)pushSheet:(UIButton *)button {
     self.sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"置頂",@"編輯",@"刪除", nil];
    self.sheet.tag = 80;
    [self.sheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
   
    WEAKSELF
    if (actionSheet.tag == 80) {
        if (buttonIndex == 0) {
            
        }else if (buttonIndex == 1) {
            
        }else if (buttonIndex == 2) {

        }
    }else {
        if (buttonIndex == 0) {
            [[PickerImageTools ShareInstance] selectImageToolsWith:weakSelf];
        }else if (buttonIndex == 1) {
            [[PickerImageTools ShareInstance] selectPhotograph:weakSelf];
        }
        [PickerImageTools ShareInstance].pickerImageCameraBlock = ^(NSData *pickerImage){
            WriteArticleController *vc = [[WriteArticleController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.data = pickerImage;
            [self.navigationController pushViewController:vc animated:YES];
        };
    }
}

- (void)favBtnClick:(UIButton *)button {
    
    HomeCommentCell *cell = (HomeCommentCell *)button.superview.superview;

    SettingService* ss = [SettingService get];
    BOOL isFav = [ss getBooleanValue:[NSString stringWithFormat:@"%ld",button.tag] defValue:NO];
    if (isFav == NO) {
        [cell.favBtn setBackgroundImage:[UIImage imageNamed:@"like_slected"] forState:UIControlStateNormal];
        cell.commentFrame.commentItem.isFavour = YES;
        [ss setBooleanValue:[NSString stringWithFormat:@"%ld",button.tag] data:YES];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    DetailCommentController *vc = [[DetailCommentController alloc] init];
//    HomeCommentFrame *frame = self.commentData[indexPath.row];
//    vc.headHeight = frame.headH;
//    vc.item = frame.commentItem;
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
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
        SettingService* ss = [SettingService get];

        NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"FamilyGroup.plist" ofType:nil];
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:fullPath];
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:[dictArray count]];
        NSInteger count = 0;
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
            commentItem.isFavour = [ss getBooleanValue:[NSString stringWithFormat:@"%ld",count++] defValue:NO];

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
       
       NSForegroundColorAttributeName:[MMSystemHelper string2UIColor:HOME_COMMENT_COLOR]}];
    ITSApplication* itsApp = [ITSApplication get];
    CBUserService* us = itsApp.cbUserSvr;
    
    self.Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.Btn.frame = CGRectMake(0, 20, 25, 23);
    [self.Btn setTitleColor:[MMSystemHelper string2UIColor:HOME_VIPNAME_COLOR] forState:UIControlStateNormal];
    [self.Btn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    if (us.user.isCBADM == NO) {
        [self.Btn setBackgroundImage:[UIImage imageNamed:@"camera [#952]"] forState:UIControlStateNormal];
    }else {
        if (us.user.isLogin == NO) {
            [self.Btn setTitle:@"登入" forState:UIControlStateNormal];
        }else {
            [self.Btn setTitle:@"" forState:UIControlStateNormal];
            self.Btn.userInteractionEnabled = NO;
        }
    }
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:self.Btn];
    self.navigationItem.rightBarButtonItem = right;
    
    [itsApp.dataSvr refreshCelebComments:NEWS_REFRESH_TYPE_BEFORE];

}
- (void)login {
    ITSApplication* itsApp = [ITSApplication get];
    CBUserService* us = itsApp.cbUserSvr;
    if (us.user.isCBADM == NO) {
        self.photoSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍張照",@"相機膠圈", nil];
        [self.photoSheet showInView:self.view];

    }else {
        if (us.user.isLogin == NO) {
            self.effectView.hidden = NO;
        }
    }
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
