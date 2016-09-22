
//
//  MenuViewController.m
//  segment
//
//  Created by Apple on 16/8/11.
//  Copyright © 2016年 gmobi. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuViewCell.h"
#import "MMSystemHelper.h"
#import "ITSApplication.h"
#import "LoginViewController.h"
#import "UIImageView+WebCache.h"
#import "SettingController.h"
#import "WebviewController.h"
#import "SettingService.h"
#import "UIImageView+WebCache.h"
#import "FavourController.h"
#import "DownLoadController.h"
#import "AppStyleConfiguration.h"
#import "FanController.h"
#import "WebviewController.h"
#import "MyCommentController.h"
#import "LoginViewController.h"

#define screenW [MMSystemHelper getScreenWidth]
#define screenH [MMSystemHelper getScreenHeight]

NSString *const MenuTableViewCellIdentifier = @"MenuCell";

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"粉絲小幫手";
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
//    self.headerBg = [[UIView alloc] init];
//    self.headerBg.frame = CGRectMake(0, -20, self.view.bounds.size.width, 20);
//    [self.navigationController.navigationBar addSubview:self.headerBg];
    self.view.backgroundColor = [MMSystemHelper string2UIColor:@"#ECECED"];
//    self.headerBg.backgroundColor = [UIColor grayColor];
    self.bgImage = [[UIImageView alloc] init];
    self.bgImage.frame = CGRectMake(0, 64, screenW, MENU_LOGIN_GB_HEIGHT);
//    self.bgImage.backgroundColor = [MMSystemHelper string2UIColor:NAV_BGCOLOR];
    self.bgImage.contentMode = UIViewContentModeScaleAspectFit;
    self.bgImage.userInteractionEnabled = YES;
    [self.view addSubview:self.bgImage];
    
    self.icon = [[UIImageView alloc] init];
    self.icon.backgroundColor = [UIColor redColor];
    self.icon.frame = CGRectMake(20, (screenH/3  - 70) / 2, 72, 72);
    self.icon.layer.cornerRadius = 35;
    self.icon.layer.masksToBounds = YES;
    self.icon.image = [UIImage imageNamed:@"icon_defaultavatar"];
    [self.bgImage addSubview:self.icon];

//    [self creatButton];
    self.tableView = [[UITableView alloc] init];
//    self.tableView.frame = CGRectMake(0,MENU_LOGIN_GB_HEIGHT+ 64, screenW, screenH - MENU_LOGIN_GB_HEIGHT - 64 - 49);
    self.tableView.frame = CGRectMake(0, 0, screenW, screenH);
//    self.tableView.rowHeight = 44;
    self.tableView.backgroundColor = [MMSystemHelper string2UIColor:@"#ECECED"];
    self.tableView.hidden = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.hidden = NO;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView registerClass:[MenuViewCell class] forCellReuseIdentifier:MenuTableViewCellIdentifier];
    self.tableView.tableHeaderView = self.bgImage;
    [self.view addSubview:self.tableView];
    
    ITSApplication* itsApp = [ITSApplication get];
    CBUserService* us = itsApp.cbUserSvr;
    
    NSString *userName = us.user.userName;
    CGSize nameLabelSize = [MMSystemHelper sizeWithString:userName font:[UIFont systemFontOfSize:20] maxSize:CGSizeMake(MAXFLOAT,30)];
    CGFloat userNameX = self.icon.frame.origin.x + 80;
    self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(userNameX, (screenH/3  - 70) / 2 + 10,nameLabelSize.width, 30)];
    self.userNameLabel.textColor = [UIColor whiteColor];
    self.userNameLabel.font = [UIFont systemFontOfSize:20];
    self.userNameLabel.text = @"";
    self.userNameLabel.tag = 99;
    self.userNameLabel.textAlignment = NSTextAlignmentLeft;
    self.userNameLabel.text = userName;
    self.userNameLabel.userInteractionEnabled = YES;
    [self.bgImage addSubview:self.userNameLabel];
    
    UIButton *bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bgBtn.frame = self.userNameLabel.bounds;
    bgBtn.backgroundColor = [UIColor clearColor];
    [bgBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.userNameLabel addSubview:bgBtn];
    
//    NSString *email = us.user.email;
//    CGSize emailSize = [MMSystemHelper sizeWithString:email font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, 20)];
    self.userEmailLabel = [[UILabel alloc] init];
    self.userEmailLabel.frame = CGRectMake(userNameX, (screenH/3  - 70) / 2 + 40, screenW - userNameX - 10, 20);
    self.userEmailLabel.textColor = [UIColor whiteColor];
    self.userEmailLabel.textAlignment = NSTextAlignmentLeft;
    self.userEmailLabel.text = @"";
    self.userEmailLabel.font = [UIFont systemFontOfSize:14];
    [self.bgImage addSubview:self.userEmailLabel];

    if (us.user.isLogin == NO) {
        self.userNameLabel.text = @"登入";
        self.userEmailLabel.text = @"須登入才能瀏覽粉絲小幫手";
    }
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    self.effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    self.effectView.frame = CGRectMake(0, 0, screenW, screenH);
    self.effectView.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:self.effectView];
    
    self.loginView = [[LoginView alloc] initWithFrame:CGRectMake(20, 0, screenW - 40, 190)];
    self.loginView.backgroundColor = [UIColor whiteColor];
    self.loginView.layer.masksToBounds = YES;
    self.loginView.layer.cornerRadius = 10;
    self.loginView.center = self.view.center;
    [self.loginView.loginButton addTarget:self action:@selector(loginFB) forControlEvents:UIControlEventTouchUpInside];
    [self.loginView.cancelButton addTarget:self action:@selector(cancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.effectView addSubview:self.loginView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFacebookUserInfo) name:@"getFacebookUserInfo" object:[ITSApplication get].fbSvr];

}
- (void)clickBack{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)loginFB {
    
    ITSApplication* poApp = [ITSApplication get];
    FacebookService *faceBook = poApp.fbSvr;

    [faceBook facebookLogin:^(int resultCode) {
        if (resultCode == ITS_FB_LOGIN_SUCCESS) {
            [faceBook facebookUserInfo];
        } else {
            UIAlertView *al = [[UIAlertView alloc] initWithTitle:nil message:@"登陸超時" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
            [al show];
        }
    } viewController:self];
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
    [self.tableView reloadData];
    self.userEmailLabel.text = us.user.email;
    self.userNameLabel.text = us.user.userName;
}

- (void)cancelBtn {
    self.effectView.hidden = YES;
}
- (void)pushLoginVc{
    
    LoginViewController *loginVc = [[LoginViewController alloc] init];
    loginVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:loginVc animated:YES];
}
- (void)creatScrollView{
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = CGRectMake(0, screenH/3 + 64 + 40, screenW, screenH - screenH/3 - 104);
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    
    self.scrollView.contentSize = CGSizeMake(screenW * 3, screenH - screenH/3 - 104);
    [self.view addSubview:self.scrollView];
}
- (void)creatButton{
    
    NSArray *titleArr = @[@"設定",@"加入網紅計畫",@"其他網紅"];
    for(NSInteger i = 0;i < 3;i++)
    {
        self.but = [UIButton buttonWithType:UIButtonTypeSystem];
        self.but.frame = CGRectMake(screenW/3 * i , screenH/3 , screenW/3, 41);
        [self.but setTitle:titleArr[i] forState:UIControlStateNormal];
        self.but.tag = 100 + i;
        if (i == 0) {
            self.otherButton = self.but;
            [self.but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }else {
            [self.but setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
        self.but.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        [self.but addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.but];
    }
    //3 155 255
    self.line = [[UILabel alloc] initWithFrame:CGRectMake(0, screenH/3 + 37, screenW/3,4)];
    self.line.backgroundColor = [MMSystemHelper string2UIColor:NAV_BGCOLOR];
    [self.view addSubview:self.line];
}
- (void)btnClick:(UIButton *)button{
    
    [self.otherButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.otherButton = button;
    
    switch (button.tag) {
        case 100:
        {
            [UIView animateWithDuration:0.1 animations:^{
                self.line.frame = CGRectMake(0, screenH/3 + 37, screenW/3, 4);
            }completion:^(BOOL finished) {
                SettingController *vc = [[SettingController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }];
        }
            break;
        case 101:
        {
            [UIView animateWithDuration:0.1 animations:^{
                self.line.frame = CGRectMake(screenW/3, screenH/3 + 37, screenW/3, 4);
            } completion:^(BOOL finished) {
                WebviewController *vc = [[WebviewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }];
        }
            break;
        case 102:
        {
            [UIView animateWithDuration:0.1 animations:^{
                self.line.frame = CGRectMake(2*screenW/3, screenH/3 + 37, screenW/3, 4);
            }];
        }
            break;
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    ITSApplication* itsApp = [ITSApplication get];
    CBUserService* us = itsApp.cbUserSvr;
    
    UIButton *button = (UIButton*)[self.view viewWithTag:100];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:[MMSystemHelper string2UIColor:HOME_COMMENT_COLOR]}];

    if (us.user.isLogin == YES) {
        self.bgImage.backgroundColor = [MMSystemHelper string2UIColor:HOME_MORE_COMMENT_COLOR];
        NSString *icon = us.user.avatar; //[loginDic objectForKey:@"avatar"];
        [self.icon sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:[UIImage imageNamed:@"head"] options:SDWebImageRefreshCached];
        self.imageview.hidden = YES;
        self.userNameLabel.hidden = NO;
        self.userEmailLabel.hidden = NO;
        self.userNameLabel.text = us.user.userName;
        self.userEmailLabel.text = us.user.email;
        self.label.hidden = YES;
        self.loginButton.hidden = YES;
        button.hidden = NO;
    }else{
        self.bgImage.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        self.label.hidden = NO;
        self.loginButton.hidden = NO;
        self.userNameLabel.text = @"登入";
        self.userEmailLabel.text = @"須登入才能瀏覽粉絲小幫手";
        self.imageview.hidden = NO;
        button.hidden = YES;
    }
    [self.tableView reloadData];
//    [self.bgView removeFromSuperview];
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setShadowImage:[UIImage new]];
}
- (void)loginOut{
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"登出帳號" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"確定",nil];
    [al show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    UIButton *button = (UIButton *)[self.view viewWithTag:100];
    if (buttonIndex == 1) {
        
        self.bgImage.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];

        ITSApplication* itsApp = [ITSApplication get];
        CBUserService* us = itsApp.cbUserSvr;
        [itsApp.fbSvr facebookLogOut];
        SettingService* ss = [SettingService get];
        [ss setDictoryValue:CONFIG_USERLOGIN_INFO data:nil];
        [us.user resetData];

        self.userNameLabel.text = @"登入";
        self.userEmailLabel.text = @"須登入才能瀏覽粉絲小幫手";
        self.label.hidden = NO;
        self.loginButton.hidden = NO;
        self.icon.image = [UIImage imageNamed:@"icon_defaultavatar"];
        self.imageview.hidden = NO;
        button.hidden = YES;
        [self.tableView reloadData];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 7 || indexPath.row == 9) {
        return 35;
    }else {
        return 44;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    ITSApplication* poApp = [ITSApplication get];
    DataService* ds = poApp.dataSvr;
    
    NSMutableArray* menuList = [ds getLeftMenuList];
    
    return [menuList count];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ITSApplication* itsApp = [ITSApplication get];
    DataService* ds = itsApp.dataSvr;
    NSMutableArray* menuList = [ds getLeftMenuList];
    LeftMenuItem* menuItem = [menuList objectAtIndex:indexPath.row];
    CBUserService* us = itsApp.cbUserSvr;
    
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:MenuTableViewCellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MenuViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MenuTableViewCellIdentifier];
    }
    MenuViewCell *tmpCell = (MenuViewCell*)cell;
    tmpCell.bgView.hidden = YES;
    if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4){
        if (us.user.isLogin == NO) {
            tmpCell.bgView.hidden = NO;
        }
    }
    if (indexPath.row == 7 || indexPath.row == 8 || indexPath.row == 9) {
        if (indexPath.row == 8) {
            if (us.user.isLogin == YES) {
                tmpCell.loginLabel.text = @"登出";
            }else {
                tmpCell.loginLabel.text = @"登入";
            }
        }else {
            tmpCell.contentView.backgroundColor = [MMSystemHelper string2UIColor:@"#ECECED"];
        }
        tmpCell.imageview.hidden = YES;
        tmpCell.line.hidden = YES;
    }
    tmpCell.title.text = menuItem.actionName;
    UIImage* defIcon = [UIImage imageNamed:menuItem.iconName];
    [tmpCell.icon setImage:defIcon];

    tmpCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return tmpCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger index = indexPath.row;
    ITSApplication* itsApp = [ITSApplication get];
    CBUserService* us = itsApp.cbUserSvr;

    if (index == 0) {
        SettingController *setVc = [[SettingController alloc] init];
        setVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:setVc animated:YES];
        
    }else if (index == 1){
        if (us.user.isLogin == YES) {
            FanController *fanVc = [[FanController alloc] init];
            fanVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:fanVc animated:YES];
        }
    }else if (index == 2){
        if (us.user.isLogin == YES) {
            MyCommentController *Vc = [[MyCommentController alloc] init];
            Vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:Vc animated:YES];
        }
    }else if (index == 3){
    
    }else if (index == 4){
    
    }else if (index == 5){
    
        WebviewController *webVc = [[WebviewController alloc] init];
        webVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVc animated:YES];
    }else if (index == 6){
    
    }else if (index == 8){
        [self login];
    }
}
- (void)login {
    
    ITSApplication* itsApp = [ITSApplication get];
    CBUserService* us = itsApp.cbUserSvr;
    if (us.user.isLogin == YES) {
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"登出帳號" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"確定",nil];
        [al show];
    }else {
        self.effectView.hidden = NO;
    }
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
