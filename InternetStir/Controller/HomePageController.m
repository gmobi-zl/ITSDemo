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
#import "WebviewController.h"

@interface HomePageController ()<MMTabPagerViewDataSource, MMTabPagerViewDelegate>

@end

@implementation HomePageController

- (void)viewDidLoad {
    self.dataSource = self;
    self.delegate = self;

    [super viewDidLoad];
//    self.title = @"社群";

}
- (void)viewWillAppear:(BOOL)animated{
    //
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}
-(void) viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
    self.navigationController.navigationBar.hidden = YES;
    
    ConfigService *cs = [ConfigService get];
    self.lbTitle.textColor = [cs getTopBgViewFontColor:cs.type];
    
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
    
    NSArray *title = @[@"推薦",@"Facebook",@"You Tube",@"Instagram"];
    
    NSString* tabTitle = title[index];
    
    UIFont* font = [UIFont systemFontOfSize:16.0];
    CGSize size = [tabTitle sizeWithFont:font constrainedToSize:CGSizeMake(1000, 100)];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, size.width + 40, 40)];
    self.label.font = [UIFont systemFontOfSize:16.0];
    self.label.text = tabTitle;
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.textColor = [UIColor blackColor];
    self.label.backgroundColor = [UIColor redColor];
    // self.label.textColor = [cs getScrollViewTitleColor:cs.type];
    return self.label;
}

- (UIViewController *)viewPager:(MMTabPagerView *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index
{
    UIViewController* vc = nil;

    if (index == 0) {
        vc = [[SocialController alloc] init];
    }else {
        vc = [[WebviewController alloc] init];
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
