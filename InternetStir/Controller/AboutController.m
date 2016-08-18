//
//  AboutController.m
//  PoPoNews
//
//  Created by apple on 15/6/10.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "AboutController.h"
#import "ConfigService.h"
#import "MMSystemHelper.h"
#import "ITSApplication.h"


@implementation AboutController

-(void) viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self initViews];
}

-(void) initViews{
    self.headerBg = [[UIView alloc] init];
    //self.headerBg.backgroundColor = [UIColor redColor];
    
    ConfigService* cs = [ConfigService get];
    CGFloat screenTitleBarH = [MMSystemHelper getStatusBarHeight];
    CGFloat screenW = [MMSystemHelper getScreenWidth];
    CGFloat screenH = [MMSystemHelper getScreenHeight];
    CGFloat headerHeight = [cs getPopoNewsHeaderBgHeight];
//    self.headerBg.frame = CGRectMake(0, -20, screenW,20);
//    [self.navigationController.navigationBar addSubview:self.headerBg];
//
//    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:PPN_NSLocalizedString(@"SettingAbout", @"About") style:UIBarButtonItemStylePlain target:self action:nil];
//    
//    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"title_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked)];
//    self.navigationItem.leftBarButtonItems = @[back,left];

    
    
    NSString *str = ITS_NSLocalizedString(@"SettingAbout",@"About");
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGRect rect = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    
    UIButton* backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 20, 60 + rect.size.width, 60);

    [backBtn setTitle:ITS_NSLocalizedString(@"SettingAbout", @"About") forState:UIControlStateNormal];
    //[backBtn setTitle:@"Categories" forState:UIControlStateNormal];
    
    backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 25);
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 30);
    UIImage* backIcon = [UIImage imageNamed:@"title_back"];
    [backBtn setImage:backIcon forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = back;
    
    //[self.view addSubview:self.headerBg];
    
    UIImage* aboutIcon = [UIImage imageNamed:@"about_icon"];
    UIImageView* aboutIconView = [[UIImageView alloc] init];
    CGFloat iconSize = 144;
    CGFloat iconY = headerHeight + screenTitleBarH + 70;
    aboutIconView.frame = CGRectMake( (screenW-iconSize)/2, iconY, iconSize, iconSize);
    [aboutIconView setImage:aboutIcon];
    aboutIconView.userInteractionEnabled = YES;
    UITapGestureRecognizer *aboutIconClicked =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickedAboutIcon)];
    [aboutIconView addGestureRecognizer:aboutIconClicked];
    
    [self.view addSubview:aboutIconView];
    
    //UIColor textColor = [MMSystemHelper string2UIColor:COLOR_NEWSLIST_SOURCE_GREY]
    // appName
    UILabel* appName = [[UILabel alloc] init];
    appName.frame = CGRectMake(10, iconY + iconSize + 20, screenW - 20, 40);
    [appName setText:ITS_NSLocalizedString(@"HomeTitle", @"PoPoNews")];
    appName.textAlignment = NSTextAlignmentCenter;
    appName.backgroundColor = [UIColor clearColor];
    appName.font = [UIFont boldSystemFontOfSize:35];//[UIFont fontWithName:@"Arial" size:14];
    [appName setTextColor:[MMSystemHelper string2UIColor:COLOR_SPLASH_FT_TITLE]];
    [self.view addSubview:appName];
    
    // version
    UILabel* appVerLab = [[UILabel alloc] init];
    appVerLab.frame = CGRectMake(10, iconY + iconSize + 20 + 40 + 10, screenW - 20, 18);
    NSString* appVer = [MMSystemHelper getAppVersion];
    [appVerLab setText:[NSString stringWithFormat:@"%@:%@(%@)", ITS_NSLocalizedString(@"VersionLabel", @"Version"), appVer, [MMSystemHelper getAppInfoPlistData:@"PoPoNewsBuildType" defValue:@""]]];
    appVerLab.textAlignment = NSTextAlignmentCenter;
    appVerLab.backgroundColor = [UIColor clearColor];
    appVerLab.font = [UIFont systemFontOfSize:14];//[UIFont fontWithName:@"Arial" size:14];
    [appVerLab setTextColor:[MMSystemHelper string2UIColor:COLOR_SPLASH_FT_INFO]];
    [self.view addSubview:appVerLab];
    
    // build date
    self.appBuildDateLab = [[UILabel alloc] init];
    self.appBuildDateLab.frame = CGRectMake(10, iconY + iconSize + 20 + 40 + 10 + 30, screenW - 20, 18);
    //NSString* appVer = [MMSystemHelper getAppVersion];
    NSString* buildDateStr = NSLocalizedStringFromTable(@"PoPoNewsBuildDate", @"BuildDate", nil);
    NSString* buildDate = @"";
    if (buildDateStr != nil){
        long long buildDataLong = [buildDateStr longLongValue];
        NSDate* nd = [NSDate dateWithTimeIntervalSince1970:buildDataLong];
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        buildDate = [dateFormat stringFromDate:nd];
    }
    
    [self.appBuildDateLab setText:[NSString stringWithFormat:@"(%@)", buildDate]];
    self.appBuildDateLab.textAlignment = NSTextAlignmentCenter;
    self.appBuildDateLab.backgroundColor = [UIColor clearColor];
    self.appBuildDateLab.font = [UIFont systemFontOfSize:14];
    [self.appBuildDateLab setTextColor:[MMSystemHelper string2UIColor:COLOR_SPLASH_FT_INFO]];
    self.appBuildDateLab.hidden = YES;
    [self.view addSubview:self.appBuildDateLab];
    
    UILabel* appWebSite = [[UILabel alloc] init];
    appWebSite.frame = CGRectMake(10, screenH - 120, screenW - 20, 15);
    //appWebSite.backgroundColor = [UIColor blackColor];
    [appWebSite setText:ITS_NSLocalizedString(@"WebSite", @"webSite")];
    appWebSite.textAlignment = NSTextAlignmentCenter;
    appWebSite.backgroundColor = [UIColor clearColor];
    appWebSite.font = [UIFont systemFontOfSize:14];
    [appWebSite setTextColor:[MMSystemHelper string2UIColor:COLOR_SPLASH_FT_INFO]];
    [self.view addSubview:appWebSite];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_light"] forBarMetrics:UIBarMetricsDefault];
    ConfigService *cs = [ConfigService get];
    if (cs.type == MODE_DAY) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_light"] forBarMetrics:UIBarMetricsDefault];
    }else if (cs.type == MODE_NIGHT){
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_night"] forBarMetrics:UIBarMetricsDefault];
    }
    self.headerBg.backgroundColor = [cs getTopBgViewRedColor:cs.type];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        return YES;
    }
    return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    BOOL result = NO;
    
    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        result = YES;
    }
    
    return result;
}

-(void) onClickedAboutIcon{
    self.aboutClickCount++;
    if (self.aboutClickCount > 3){
        self.appBuildDateLab.hidden = NO;
    }
}

-(void) backBtnClicked{
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    ConfigService *cs = [ConfigService get];
    self.headerBg.backgroundColor = [cs getTopBgViewRedColor:cs.type];
    self.aboutClickCount = 0;
//    NSMutableDictionary* eParams = [NSMutableDictionary dictionaryWithCapacity:1];
}

@end