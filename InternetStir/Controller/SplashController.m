//
//  SplashController.m
//  InternetStir
//
//  Created by apple on 16/8/12.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SplashController.h"
#import "MMSystemHelper.h"
#import "ViewController.h"
#import "TabBarController.h"
#import "ITSApplication.h"
#import "DataService.h"
#import "SettingService.h"

#define screenW [MMSystemHelper getScreenWidth]
#define screenH [MMSystemHelper getScreenHeight]

@implementation SplashController


- (void)viewDidLoad {
    [super viewDidLoad];
    //self.screenName = @"launch";
    //    PopoApplication *poApp = [PopoApplication get];
    
    self.navigationController.navigationBarHidden = YES;
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat width = [MMSystemHelper getScreenWidth];
    CGFloat height = [MMSystemHelper getScreenHeight];
    CGFloat barHeight = [MMSystemHelper getStatusBarHeight];
    
    UIView* titleWhiteBgView = [[UIView alloc] initWithFrame:CGRectMake(0, barHeight, width, 200)];
    titleWhiteBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleWhiteBgView];
    
    self.isReconnect = NO;
    self.isConnected = NO;
    self.isWaitMaxTime = NO;
    
    // logo
    UIImage* bgImg = [UIImage imageNamed:@"splash_default"];
    //CGImageRef imgRef = [logoImg CGImage];
    //CGFloat iW = CGImageGetWidth(imgRef);
    //CGFloat iH = CGImageGetHeight(imgRef);
    //CGFloat imgW = width / 3;
    //CGFloat imgH = (imgW * iH) / iW;
    
    self.bgImage = [[UIImageView alloc] init];
    [self.bgImage setImage:bgImg];
    self.bgImage.frame = CGRectMake(0, 0, width, height);
    self.bgImage.hidden = NO;
    self.bgImage.userInteractionEnabled = YES;
    [self.view addSubview:self.bgImage];
}

-(void) pushNextVc{

    ITSApplication* itsApp = [ITSApplication get];
    CBUserService* us = itsApp.cbUserSvr;
    if (us.user.isLogin == YES) {
        TabBarController *tabBar = [[TabBarController alloc] init];
        tabBar.selectedIndex = 1;
        [self.navigationController pushViewController:tabBar animated:YES];
    }else {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        self.effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        self.effectView.frame = CGRectMake(0, 0, screenW, screenH);
        self.effectView.hidden = NO;
        [[UIApplication sharedApplication].keyWindow addSubview:self.effectView];
        
        self.loginView = [[LoginView alloc] initWithFrame:CGRectMake(0, 0, screenW - 40, 190)];
        self.loginView.backgroundColor = [UIColor whiteColor];
        self.loginView.layer.masksToBounds = YES;
        self.loginView.layer.cornerRadius = 10;
        self.loginView.center = self.view.center;
        [self.loginView.loginButton addTarget:self action:@selector(loginFB) forControlEvents:UIControlEventTouchUpInside];
        [self.loginView.cancelButton addTarget:self action:@selector(cancelBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.effectView addSubview:self.loginView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFacebookUserInfo) name:@"getFacebookUserInfo" object:[ITSApplication get].fbSvr];
    }
}
- (void)cancelBtn {
    self.effectView.hidden = YES;
    TabBarController *tabBar = [[TabBarController alloc] init];
    tabBar.selectedIndex = 1;
    [self.navigationController pushViewController:tabBar animated:YES];
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
    TabBarController *tabBar = [[TabBarController alloc] init];
    tabBar.selectedIndex = 1;
    [self.navigationController pushViewController:tabBar animated:YES];
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
-(void) delayToHome{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self pushNextVc];
    });
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    //[self startBGAnimation];
    ITSApplication* itsApp = [ITSApplication get];
    DataService* ds = itsApp.dataSvr;
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         @"launch.view",@"EventCategory",
                         @"tomotoc001",@"EventAction",
                         @"" ,@"name",
                         nil];

    [itsApp.reportSvr recordEvent:@"launch" params:dic eventCategory:nil];
    
    [self delayToHome];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}


@end