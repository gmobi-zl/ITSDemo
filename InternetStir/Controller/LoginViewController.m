
//
//  LoginViewController.m
//  InternetStir
//
//  Created by Apple on 16/8/17.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import "LoginViewController.h"
#import "MMSystemHelper.h"
#import "AboutController.h"
#import "FeedBackController.h"
#import "ITSApplication.h"
#import "FacebookService.h"
#import "SettingService.h"
#import "TwitterService.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
static NSString * const kClientID =
@"972637543371-5t6ssr6qj1vfff0m55rfc91qskdivbtf.apps.googleusercontent.com";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    

    self.title = @"登入帳號";
    [self creatUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFacebookUserInfo) name:@"getFacebookUserInfo" object:[ITSApplication get].fbSvr];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTwitterUserInfo) name:@"getTwitterUserInfo" object:[ITSApplication get].tw];
}
- (void)creatUI{
    CGFloat screenW = [MMSystemHelper getScreenWidth];
    CGFloat space = screenW/6;
    NSArray *titleArr = @[@"Facebook",@"Twitter",@"Google"];
    for (int i = 0; i < titleArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.masksToBounds = YES;
        button.tag = i + 1;
        button.layer.cornerRadius = 6;
        button.frame = CGRectMake(70, 64 + space + i * 100, screenW - 140, 40);
        [button setTitle:[titleArr objectAtIndex:i] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor cyanColor];
        [button addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
    CGSize size = [MMSystemHelper sizeWithString:@"未經允許，我們不會發布至您的Facebook,Twitter,Google" font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(screenW - 140, MAXFLOAT)];
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(70, 310 + 64, screenW - 140, size.height);
    label.text = @"未經允許，我們不會發布至您的Facebook,Twitter,Google";
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:label];
}

//login
- (void)login:(UIButton*)button{

    ITSApplication* poApp = [ITSApplication get];
    FacebookService *faceBook = poApp.fbSvr;
    TwitterService *tw = poApp.tw;
    if (button.tag == 1) {
        
        [faceBook facebookLogin:^(int resultCode) {
            if (resultCode == ITS_FB_LOGIN_SUCCESS) {
                [faceBook facebookUserInfo];
            } else {
             
                UIAlertView *al = [[UIAlertView alloc] initWithTitle:nil message:@"登陸超時" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
                [al show];
            }

        } viewController:self];
    }else if (button.tag == 2) {
        [tw twitterLogin:^(int resultCode) {
            if (resultCode == ITS_TW_LOGIN_SUCCESS) {
                [tw getUserInfo];
            }else{
            
            }
        }];
    }else {
//        GIDSignIn* signIn = [GIDSignIn sharedInstance];
//        signIn.clientID = kClientID;
//        signIn.scopes = @[ @"profile", @"email"];
//        signIn.delegate = self;
//        signIn.uiDelegate = self;
//        [[GIDSignIn sharedInstance] signIn];

    }
}

/*
#pragma mark GIDSignInDelegate google
- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    if (error) {
        return;
    }
    
    NSString* avatar = @"";
    if ([GIDSignIn sharedInstance].currentUser.profile.hasImage) {
        NSURL *imageURL =
        [[GIDSignIn sharedInstance].currentUser.profile imageURLWithDimension:1];
        avatar = [NSString stringWithFormat:@"%@",imageURL];
    }
    
    ITSApplication* itsApp = [ITSApplication get];
    DataService* ds = itsApp.dataSvr;
    CBUserService* us = itsApp.cbUserSvr;
    
    us.user.userName = user.profile.name;
    us.user.avatar = avatar;
    us.user.isLogin = YES;
    us.user.uId = user.userID;

    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         @"google",@"type",
                         user.userID,@"openid",
                         user.profile.name ,@"name",
                         avatar,@"avatar",
                         [[NSNumber alloc] initWithBool:us.user.isLogin],@"isLogin",
                         nil];
    
    SettingService* ss = [SettingService get];
    [ss setDictoryValue:CONFIG_USERLOGIN_INFO data:dic];
    [self.navigationController popViewControllerAnimated:YES];

}
- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
}
 */
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
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getTwitterUserInfo{
    ITSApplication* itsApp = [ITSApplication get];
    CBUserService* us = itsApp.cbUserSvr;
    
    TwitterService *twitter = itsApp.tw;

    us.user.avatar = twitter.icon;
    us.user.userName = twitter.name;
    us.user.isLogin = YES;
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         @"twitter",@"type",
                         twitter.uId,@"openid",
                         twitter.name ,@"name",
                         twitter.icon ,@"avatar",
                         [[NSNumber alloc] initWithBool:us.user.isLogin],@"isLogin",
                         nil];
    SettingService* ss = [SettingService get];
    [ss setDictoryValue:CONFIG_USERLOGIN_INFO data:dic];
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor grayColor];

    UIButton* Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    Btn.frame = CGRectMake(0, 20, 15, 20);
    [Btn setBackgroundImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:Btn];
    self.navigationItem.leftBarButtonItem = left;
}
#pragma mark GIDSignInDelegate google
//- (void)signIn:(GIDSignIn *)signIn
//didSignInForUser:(GIDGoogleUser *)user
//     withError:(NSError *)error {
//    if (error) {
//        return;
//    }
//
//   
//}
//- (void)signIn:(GIDSignIn *)signIn
//didDisconnectWithUser:(GIDGoogleUser *)user
//     withError:(NSError *)error {
//}
//
- (void)clickBack{
    
    [self.navigationController popViewControllerAnimated:YES];
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
