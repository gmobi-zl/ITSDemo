
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

#define screenW [MMSystemHelper getScreenWidth]
#define screenH [MMSystemHelper getScreenHeight]

NSString *const MenuTableViewCellIdentifier = @"MenuCell";

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"粉絲小幫手";
//    self.headerBg = [[UIView alloc] init];
//    self.headerBg.frame = CGRectMake(0, -20, self.view.bounds.size.width, 20);
//    [self.navigationController.navigationBar addSubview:self.headerBg];
    self.view.backgroundColor = [UIColor whiteColor];
    self.headerBg.backgroundColor = [UIColor grayColor];
    //    [self.navigationController.navigationBar addSubview:self.headerBg];
    self.bgImage = [[UIImageView alloc] init];
    self.bgImage.frame = CGRectMake(0, 64, screenW, screenH/3);
    self.bgImage.backgroundColor = [UIColor grayColor];
    self.bgImage.contentMode = UIViewContentModeScaleToFill;
    self.bgImage.userInteractionEnabled = YES;
    [self.view addSubview:self.bgImage];
    
    self.icon = [[UIImageView alloc] init];
    self.icon.frame = CGRectMake((screenW - 70) / 2, (screenH/3  - 70) / 2 - 20, 70, 70);
    self.icon.image = [UIImage imageNamed:@"head"];
//    [self.icon addTarget:self action:@selector(pushLoginVc) forControlEvents:UIControlEventTouchUpInside];
    self.icon.layer.masksToBounds = YES;
    self.icon.userInteractionEnabled = NO;
    self.icon.layer.cornerRadius = 35;
    [self.bgImage addSubview:self.icon];

    [self creatButton];
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, 0, screenW, screenH -screenH/3-104);
    self.tableView.rowHeight = 60;
    self.tableView.hidden = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.hidden = NO;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView registerClass:[MenuViewCell class] forCellReuseIdentifier:MenuTableViewCellIdentifier];
    [self.scrollView addSubview:self.tableView];
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginButton.frame = CGRectMake(120, screenH - 250, screenW - 240, 40);
    [self.loginButton addTarget:self action:@selector(pushLoginVc) forControlEvents:UIControlEventTouchUpInside];
    self.loginButton.backgroundColor = [UIColor yellowColor];
    [self.loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.loginButton.layer.masksToBounds = YES;
    self.loginButton.layer.cornerRadius = 8;
    self.loginButton.layer.borderWidth = 0.5;
    self.loginButton.hidden = YES;
    self.loginButton.layer.borderColor = [UIColor grayColor].CGColor;
    [self.loginButton setTitle:@"點擊登入" forState:UIControlStateNormal];
    [self.view addSubview:self.loginButton];
    
    self.label = [[UILabel alloc] init];
    NSString *name = @"(登入後才能瀏覽粉絲小幫手~)";
    CGSize size = [MMSystemHelper sizeWithString:name font:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(MAXFLOAT, 20)];
    self.label.frame = CGRectMake(screenW/2 - size.width/2, screenH - 200, size.width, 20);
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.text = name;
    self.label.hidden = YES;
    self.label.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:self.label];
}
- (void)pushLoginVc{
    
    LoginViewController *loginVc = [[LoginViewController alloc] init];
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
    
    NSArray *titleArr  = @[@"設定",@"加入網紅計畫",@"其他網紅"];
    for(NSInteger i = 0;i < 3;i++)
    {
        UIButton *but = [UIButton buttonWithType:UIButtonTypeSystem];
        but.frame = CGRectMake(screenW/3 * i , screenH/3 + 64, screenW/3, 38);
        [but setTitle:titleArr[i] forState:UIControlStateNormal];
        but.tag = 100 + i;
        [but setTitleColor:[UIColor colorWithRed:3/255.0 green:155/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
        [but addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:but];
    }
    //3 155 255
    self.line = [[UILabel alloc] initWithFrame:CGRectMake(0, screenH/3 + 64 + 38, screenW, 2)];
    self.line.backgroundColor = [UIColor colorWithRed:3/255.0 green:155/255.0 blue:255/255.0 alpha:1];
    [self.view addSubview:self.line];

}
- (void)btnClick:(UIButton *)button{
    switch (button.tag) {
        case 100:
        {
            SettingController *vc = [[SettingController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 101:
        {
            
        }
            break;
        case 102:
        {

        }
            break;
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    ITSApplication* poApp = [ITSApplication get];
    DataService* ds = poApp.dataSvr;

    if (ds.user.isLogin == YES) {
        NSString *icon = ds.user.avatar; //[loginDic objectForKey:@"avatar"];
        [self.icon sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:[UIImage imageNamed:@"avator"] options:SDWebImageRefreshCached];
        
        NSString *name = @"點擊登出";
        CGSize nameLabelSize = [MMSystemHelper sizeWithString:name font:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(MAXFLOAT,MAXFLOAT)];
        CGFloat userNameX = ([UIScreen mainScreen].bounds.size.width - nameLabelSize.width)/2;
        CGFloat userNmaeY = self.icon.frame.origin.y + 80;
        UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(userNameX, userNmaeY,nameLabelSize.width, nameLabelSize.height)];
        userNameLabel.textColor = [UIColor whiteColor];
        userNameLabel.font = [UIFont systemFontOfSize:16];
        userNameLabel.text = @"";
        userNameLabel.tag = 99;
        userNameLabel.textAlignment = NSTextAlignmentCenter;
        userNameLabel.text = name;
        userNameLabel.userInteractionEnabled = YES;
        [self.bgImage addSubview:userNameLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginOut)];
        [userNameLabel addGestureRecognizer:tap];
        
        self.tableView.hidden = NO;
        self.label.hidden = YES;
        self.loginButton.hidden = YES;
    }else{
        self.tableView.hidden = YES;
        self.label.hidden = NO;
        self.loginButton.hidden = NO;
    }
}
- (void)loginOut{
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"登出帳號" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"確定",nil];
    [al show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

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
    tmpCell.title.text = menuItem.actionName;
    UIImage* defIcon = [UIImage imageNamed:menuItem.iconName];
    [tmpCell.icon setImage:defIcon];

    tmpCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return tmpCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger index = indexPath.row;
    if (index == 0) {
        
    }else if (index == 1){
    
    }else if (index == 2){
    
    }else if (index == 3){
    
    }else if (index == 4){
    
    }else if (index == 5){
    
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
