//
//  HomePageController.m
//  Jacob
//
//  Created by Apple on 16/9/27.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import "HomePageController.h"
#import "ConfigService.h"
#import "SocialController.h"
#import "SocialWebController.h"
#import "MMSystemHelper.h"
#import "ITSApplication.h"

@interface HomePageController ()<MMTabPagerViewDataSource, MMTabPagerViewDelegate>

@end

@implementation HomePageController

- (void)viewDidLoad {
    self.dataSource = self;
    self.delegate = self;

    self.screenName = @"recommendation";
    [super viewDidLoad];
    
    ITSApplication* poApp = [ITSApplication get];
     NSMutableDictionary* eParams = [NSMutableDictionary dictionaryWithCapacity:1];
    [poApp.reportSvr recordEvent:@"recommendation" params:eParams eventCategory:@"tabbar.click"];
}
- (void)viewWillAppear:(BOOL)animated{
    //
    [super viewWillAppear:animated];
    ITSApplication* itsApp = [ITSApplication get];
    NSMutableDictionary* eParams = [NSMutableDictionary dictionaryWithCapacity:1];
    [itsApp.reportSvr recordEvent:@"list" params:eParams eventCategory:@"recommendation.view"];
    
    CGFloat screenW = [MMSystemHelper getScreenWidth];
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenW, 20)];
    statusBarView.backgroundColor = [MMSystemHelper string2UIColor:@"#FAFAFA"];
    [self.view addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}
-(void) viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
//    [self.tabBarController.tabBar setHidden:NO];
//    self.navigationController.navigationBar.hidden = YES;
    
    ConfigService *cs = [ConfigService get];
//    self.lbTitle.textColor = [cs getTopBgViewFontColor:cs.type];
    
    if (self.tabs != nil){
        for (int i = 0; i < [self.tabs count]; i++) {
            UILabel* tabLabel = [self.tabs objectAtIndex:i];
            if (tabLabel != nil){
                //ConfigService *cs = [ConfigService get];
                // tabLabel.textColor = [cs getScrollViewTitleColor:cs.type];
            }
        }
    }
}

#pragma mark - CMPagerViewDataSource

- (NSUInteger)numberOfTabView
{
    return 4;
}

- (UIView *)viewPager:(MMTabPagerView *)viewPager viewForTabAtIndex:(NSUInteger)index
{
    
    NSArray *title = @[@"推薦",@"Facebook",@"YouTube",@"Instagram"];
    
    NSString* tabTitle = title[index];
    
    UIFont* font = [UIFont systemFontOfSize:16.0];
    CGSize size = [tabTitle sizeWithFont:font constrainedToSize:CGSizeMake(1000, 100)];
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    if (screenW == 320) {
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width + 20, 40)];
    }else if (screenW == 375){
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width + 35, 40)];
    }else {
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width + 45, 40)];
    }
    self.label.font = [UIFont systemFontOfSize:14.0];
    self.label.text = tabTitle;
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.textColor = [UIColor blackColor];
    // self.label.textColor = [cs getScrollViewTitleColor:cs.type];
    return self.label;
}

- (UIViewController *)viewPager:(MMTabPagerView *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index
{
    UIViewController* vc = nil;

    if (index == 0) {
        vc = [[SocialController alloc] init];
    }else {
        vc = [[SocialWebController alloc] init];
        SocialWebController *viewController = (SocialWebController*)vc;
        viewController.viewIndex = index;
    }
    return vc;
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
