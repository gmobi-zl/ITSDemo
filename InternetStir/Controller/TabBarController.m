//
//  TabBarController.m
//  PoPoNews
//
//  Created by Apple on 15/8/12.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#import "TabBarController.h"
#import "ITSApplication.h"
#import "MMSystemHelper.h"
#import "ITSAppConst.h"
#import "AppStyleConfiguration.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.opaque = NO;
    [self creatTabBarController];
}
- (void)creatTabBarController{

    NSArray *vcName = @[@"HomePageController",@"HomeViewController",@"MenuViewController"];
//    NSString* newsTitle = @"留言";//NSLocalizedString(@"test", nil);
//    NSString* disTitle = @"内容";
//    NSString* meTitle = @"社群";
//    NSArray *title = @[newsTitle,disTitle,meTitle];

    NSArray *imageArr = @[@"social",@"home",@"more"];
    NSArray *imageSelectArr = @[@"social_selected",@"home_selected",@"more_selected"];

    ITSApplication* itsApp = [ITSApplication get];
    NSString* appTitleName = itsApp.dataSvr.celebInfo.title == nil ? @"" : itsApp.dataSvr.celebInfo.title;
    NSArray *titleName = @[@"社群",appTitleName,NSLocalizedString(@"fans_helper",nil)];
    int cnt = 0;
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (NSString *className in vcName) {
        Class MyClass = NSClassFromString(className);
        UIViewController *VC = [[MyClass alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:VC];
//        [nav.navigationBar setBackgroundImage:[UIImage imageNamed: @"nav_light"] forBarMetrics:UIBarMetricsDefault];
        VC.title = titleName[cnt];
        nav.tabBarItem.title = nil;
        nav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0,-6, 0);
        nav.tabBarItem.image = [[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArr[cnt]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nav.tabBarItem.selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageSelectArr[cnt]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBar.tintColor = [UIColor redColor];
        cnt++;
        [arr addObject:nav];
    }
    CGFloat screenW = [MMSystemHelper getScreenWidth];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenW, 49)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.tabBar insertSubview:backView atIndex:0];
    self.tabBar.opaque = YES;
    self.tabBar.tintColor = [MMSystemHelper string2UIColor:HOME_VIPNAME_COLOR];
    self.viewControllers = arr;
    self.delegate = self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
//    if (self.selectedIndex == 2) {
//        PopoApplication* poApp = [PopoApplication get];
//        [poApp.reportSvr recordEvent:nil params:nil eventCategory:@"me"];
//    } else if (self.selectedIndex == 1) {
//        PopoApplication* poApp = [PopoApplication get];
//        [poApp.reportSvr recordEvent:nil params:nil eventCategory:@"discover"];
//    }
}


@end
