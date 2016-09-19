
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
    self.bgImage.contentMode = UIViewContentModeScaleToFill;
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
    self.tableView.frame = CGRectMake(0,MENU_LOGIN_GB_HEIGHT+ 64, screenW, screenH - MENU_LOGIN_GB_HEIGHT - 64 - 49 - 60);
    self.tableView.rowHeight = 44;
    self.tableView.backgroundColor = [MMSystemHelper string2UIColor:@"#ECECED"];
    self.tableView.hidden = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.hidden = NO;
//    self.tableView.scrollEnabled = NO;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView registerClass:[MenuViewCell class] forCellReuseIdentifier:MenuTableViewCellIdentifier];
    [self.view addSubview:self.tableView];
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginButton.frame = CGRectMake(120, MENU_LOGIN_GB_HEIGHT + 64 + 60, screenW - 240, 40);
    [self.loginButton addTarget:self action:@selector(pushLoginVc) forControlEvents:UIControlEventTouchUpInside];
    self.loginButton.backgroundColor = [MMSystemHelper string2UIColor:HOME_MORE_COMMENT_COLOR];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginButton.layer.masksToBounds = YES;
    self.loginButton.layer.cornerRadius = 8;
    self.loginButton.layer.borderWidth = 0.5;
    self.loginButton.hidden = YES;
    self.loginButton.layer.borderColor = [UIColor grayColor].CGColor;
    [self.loginButton setTitle:@"點擊登入" forState:UIControlStateNormal];
    [self.view addSubview:self.loginButton];
    
    self.label = [[UILabel alloc] init];
    NSString *name = @"登入後才能瀏覽粉絲小幫手~";
    CGSize size = [MMSystemHelper sizeWithString:name font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, 20)];
    self.label.frame = CGRectMake(screenW/2 - size.width/2, self.loginButton.frame.origin.y + self.loginButton.frame.size.height + 20, size.width, 20);
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.text = name;
    self.label.textColor = [UIColor grayColor];
    self.label.hidden = YES;
    self.label.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.label];
    
    self.imageview = [[UIImageView alloc] initWithFrame:CGRectMake(self.label.frame.origin.x - 35, self.label.frame.origin.y - 5, 30, 30)];
    self.imageview.image = [UIImage imageNamed:@"icon_tips"];
    [self.view addSubview:self.imageview];
    
//    UIButton* Btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    Btn.frame = CGRectMake(0, 20, 30, 30);
//    [Btn setBackgroundImage:[UIImage imageNamed:@"icon_Back"] forState:UIControlStateNormal];
//    [Btn addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:Btn];
//    self.navigationItem.leftBarButtonItem = left;
    
    ITSApplication* itsApp = [ITSApplication get];
    CBUserService* us = itsApp.cbUserSvr;
    
    NSString *userName = us.user.userName;
    CGSize nameLabelSize = [MMSystemHelper sizeWithString:userName font:[UIFont systemFontOfSize:20] maxSize:CGSizeMake(MAXFLOAT,30)];
    CGFloat userNameX = self.icon.frame.origin.x + 80;
    self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(userNameX, (screenH/3  - 70) / 2 + 20,nameLabelSize.width, 30)];
    self.userNameLabel.textColor = [UIColor whiteColor];
    self.userNameLabel.font = [UIFont systemFontOfSize:20];
    self.userNameLabel.text = @"";
    self.userNameLabel.tag = 99;
    self.userNameLabel.textAlignment = NSTextAlignmentCenter;
    self.userNameLabel.text = userName;
    self.userNameLabel.userInteractionEnabled = YES;
    [self.bgImage addSubview:self.userNameLabel];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginOut)];
//    [self.userNameLabel addGestureRecognizer:tap];
    
    UIButton *loginOut = [UIButton buttonWithType:UIButtonTypeCustom];
    loginOut.frame = CGRectMake(0, screenH - 49 - 10 - 44, screenW, 44);
    loginOut.backgroundColor = [UIColor whiteColor];
    [loginOut setTitle:@"登出" forState:UIControlStateNormal];
    [loginOut addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
    [loginOut setTitleColor:[MMSystemHelper string2UIColor:MENU_LOGINOUT_COLOUR] forState:UIControlStateNormal];
    loginOut.hidden = YES;
    loginOut.tag = 100;
    [self.view addSubview:loginOut];
//    self.loginOut = loginOut;
//    self.loginOut.hidden = YES;
}
- (void)clickBack{
    
    [self.navigationController popViewControllerAnimated:YES];
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
    DataService* ds = itsApp.dataSvr;
    CBUserService* us = itsApp.cbUserSvr;
    
    UIButton *button = (UIButton*)[self.view viewWithTag:100];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:[MMSystemHelper string2UIColor:HOME_VIPNAME_COLOR]}];

    if (us.user.isLogin == YES) {
        self.bgImage.backgroundColor = [MMSystemHelper string2UIColor:HOME_MORE_COMMENT_COLOR];
        NSString *icon = us.user.avatar; //[loginDic objectForKey:@"avatar"];
        [self.icon sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:[UIImage imageNamed:@"head"] options:SDWebImageRefreshCached];
        self.imageview.hidden = YES;
        self.userNameLabel.hidden = NO;
        self.userNameLabel.text = us.user.userName;
        self.tableView.hidden = NO;
        self.label.hidden = YES;
        self.loginButton.hidden = YES;
        button.hidden = NO;
    }else{
        self.bgImage.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        self.tableView.hidden = YES;
        self.label.hidden = NO;
        self.loginButton.hidden = NO;
        self.userNameLabel.hidden = YES;
        self.imageview.hidden = NO;
        button.hidden = YES;
    }
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
//    [navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_light"]
//                       forBarPosition:UIBarPositionAny
//                           barMetrics:UIBarMetricsDefault];
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
        DataService* ds = itsApp.dataSvr;
        CBUserService* us = itsApp.cbUserSvr;
        [itsApp.fbSvr facebookLogOut];
        SettingService* ss = [SettingService get];
        [ss setDictoryValue:CONFIG_USERLOGIN_INFO data:nil];
        [us.user resetData];

        self.userNameLabel.hidden = YES;
        self.tableView.hidden = YES;
        self.label.hidden = NO;
        self.loginButton.hidden = NO;
        self.icon.image = [UIImage imageNamed:@"icon_defaultavatar"];
        self.imageview.hidden = NO;
        button.hidden = YES;
//        if (ds.user != nil && ds.user.isLogin == YES) {
//            
//            [poApp.fbSvr facebookLogOut];
//            SettingService* ss = [SettingService get];
//            [ss setDictoryValue:CONFIG_USERLOGIN_INFO data:nil];
//
//            [ds.user resetData];
//        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    ITSApplication* poApp = [ITSApplication get];
    DataService* ds = poApp.dataSvr;
    
    NSMutableArray* menuList = [ds getLeftMenuList];
    
    return [menuList count];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ITSApplication* poApp = [ITSApplication get];
    DataService* ds = poApp.dataSvr;
    NSMutableArray* menuList = [ds getLeftMenuList];
    LeftMenuItem* menuItem = [menuList objectAtIndex:indexPath.row];

    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:MenuTableViewCellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MenuViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MenuTableViewCellIdentifier];
    }
    MenuViewCell *tmpCell = (MenuViewCell*)cell;

    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [MMSystemHelper string2UIColor:NAV_BGCOLOR];
    tmpCell.title.text = menuItem.actionName;
    UIImage* defIcon = [UIImage imageNamed:menuItem.iconName];
    [tmpCell.icon setImage:defIcon];

    tmpCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return tmpCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger index = indexPath.row;
    if (index == 0) {
        SettingController *setVc = [[SettingController alloc] init];
        setVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:setVc animated:YES];
        
    }else if (index == 1){
    
        FanController *fanVc = [[FanController alloc] init];
        fanVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:fanVc animated:YES];
    }else if (index == 2){
    
        
    }else if (index == 3){
    
    }else if (index == 4){
    
    }else if (index == 5){
    
        WebviewController *webVc = [[WebviewController alloc] init];
        webVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVc animated:YES];
    }else if (index == 6){
    
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
