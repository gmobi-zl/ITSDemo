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

//    ViewController *vc = [[ViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    TabBarController *tabBar = [[TabBarController alloc] init];
    tabBar.selectedIndex = 1;
    [self.navigationController pushViewController:tabBar animated:YES];
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
    ITSApplication* poApp = [ITSApplication get];
    DataService* ds = poApp.dataSvr;
    
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