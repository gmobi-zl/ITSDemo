//
//  TabBarController.m
//  PoPoNews
//
//  Created by Apple on 15/8/12.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#import "TabBarController.h"
#import "ITSApplication.h"
@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.opaque = NO;
    [self creatTabBarController];
}
- (void)creatTabBarController{

    NSArray *vcName = @[@"HomeViewController",@"ContentController",@"SocialController"];
    NSString* newsTitle = ITS_NSLocalizedString(@"PageMain", @"News");
    NSString* disTitle = ITS_NSLocalizedString(@"PageDiscover", @"Discover");
    NSString* meTitle = ITS_NSLocalizedString(@"PageMe", @"Me");
    //NSString* videoTitle = PPN_NSLocalizedString(@"PageVideo", @"Video");
    NSArray *title = @[newsTitle,disTitle,meTitle];

    NSArray *imageArr = @[@"高圆圆",@"高圆圆",@"高圆圆"];
    NSArray *imageSelectArr = @[@"高圆圆",@"高圆圆",@"高圆圆"];

    int cnt = 0;
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (NSString *className in vcName) {
        Class MyClass = NSClassFromString(className);
        UIViewController *VC = [[MyClass alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:VC];
        [nav.navigationBar setBackgroundImage:[UIImage imageNamed: @"nav_light"] forBarMetrics:UIBarMetricsDefault];
        nav.tabBarItem.title = title[cnt];
        nav.tabBarItem.image = [[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArr[cnt]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //VC.title = title[cnt];
        nav.tabBarItem.selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageSelectArr[cnt]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBar.tintColor = [UIColor redColor];
        //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
        //self.tabBar.tranlucent = NO;
        cnt++;
        [arr addObject:nav];
    }
    
    self.viewControllers = arr;
    self.delegate = self;
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
