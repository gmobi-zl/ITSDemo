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
    [self.view addSubview:self.bgImage];
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    //[self startBGAnimation];
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