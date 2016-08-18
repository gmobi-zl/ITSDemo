//
//  SettingController.m
//  InternetStir
//
//  Created by Apple on 16/8/17.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingController.h"
#import "ConfigService.h"
#import "MMSystemHelper.h"
#import "ITSApplication.h"
#import "DataService.h"
#import "SettingCell.h"
#import "MMEventService.h"
#import "SettingService.h"
#import "AboutController.h"
#import "EditionController.h"
#import "FeedBackController.h"


NSString *const PopNewsSettingsTableViewCellIdentifier = @"PNewsSettingsCell";

@implementation SettingController

-(void) viewDidLoad{
    [super viewDidLoad];
    [self.tabBarController.tabBar setHidden:YES];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    self.title = @"設定";
    [self initViews];
}

-(void) initViews{
    self.headerBg = [[UIView alloc] init];
    //self.headerBg.backgroundColor = [UIColor redColor];
    
    // ConfigService* cs = [ConfigService get];
    // CGFloat screenTitleBarH = [MMSystemHelper getStatusBarHeight];
    CGFloat screenW = [MMSystemHelper getScreenWidth];
    // CGFloat headerHeight = [cs getPopoNewsHeaderBgHeight];
    CGFloat screenH = [MMSystemHelper getScreenHeight];
//    self.headerBg.frame = CGRectMake(0, -20, screenW, 20);
//    [self.navigationController.navigationBar addSubview:self.headerBg];
    
    //    UIButton* backBtn = [[UIButton alloc] init];
    //    backBtn.frame = CGRectMake(0, 20, 40, 40);
    //    [backBtn setTitle:@"" forState:UIControlStateNormal];
    //    UIImage* backIcon = [UIImage imageNamed:@"title_back"];
    //    [backBtn setBackgroundImage:backIcon forState:UIControlStateNormal];
    //    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    //    [self.headerBg addSubview:backBtn];
    //
    //    self.titleLabel = [[UILabel alloc] init];
    //    self.titleLabel.frame = CGRectMake(45, 30, 200, 20);
    //    self.titleLabel.backgroundColor = [UIColor clearColor];
    //    self.titleLabel.userInteractionEnabled = YES;
    //    UIFont* titleFont = [UIFont boldSystemFontOfSize:20];//[UIFont fontWithName:@"Arial-BoldMT" size:20];
    //    [self.titleLabel setFont:titleFont];
    //    [self.titleLabel setNumberOfLines:1];
    ////    [self.title setTextColor:[UIColor whiteColor]];
    //    [self.titleLabel setText:PPN_NSLocalizedString(@"HomeTitle", @"POPONEWS")];
    //    [self.headerBg addSubview:self.titleLabel];
    //    [self.view addSubview:self.headerBg];
    
    //    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:PPN_NSLocalizedString(@"HomeTitle", @"POPONEWS") style:UIBarButtonItemStylePlain target:self action:nil];
    //
    //    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"title_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked)];
    //    self.navigationItem.leftBarButtonItems = @[back,left];
    
    
    UIButton* backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 20, 120, 60);
//    [backBtn setTitle:PPN_NSLocalizedString(@"HomeTitle", @"POPONEWS") forState:UIControlStateNormal];
    //[backBtn setTitle:@"Categories" forState:UIControlStateNormal];
    
//    backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 10);
//    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 20);
//    UIImage* backIcon = [UIImage imageNamed:@"title_back"];
//    [backBtn setImage:backIcon forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = back;
//    
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, 0, screenW, screenH );
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    [self.tableView registerClass:[SettingCell class] forCellReuseIdentifier:PopNewsSettingsTableViewCellIdentifier];
    
    [self.view addSubview:self.tableView];
    
    self.cleanMask = [[UIView alloc] init];
    self.cleanMask.frame = CGRectMake(0, 0, screenW, screenH);
    //    self.cleanMask.backgroundColor = [UIColor whiteColor];
    self.cleanMask.alpha = 0.03;
    self.cleanMask.hidden = YES;
    
    self.cleanPanel = [[UIView alloc] init];
    self.cleanPanel.frame = CGRectMake(0, screenH - 140, screenW, 140);
    self.cleanPanel.backgroundColor = [MMSystemHelper string2UIColor:COLOR_BG_BLACK];
    self.cleanPanel.alpha = 0.8;
    self.cleanPanel.hidden = YES;
    
    self.cleanLoad = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.cleanLoad setFrame:CGRectMake(screenW / 2 - 40, 22, 36, 36)];
    self.cleanLoad.hidesWhenStopped = YES;
    self.cleanLoad.hidden = YES;
    [self.cleanLoad startAnimating];
    [self.cleanPanel addSubview:self.cleanLoad];
    
    UILabel* cleanMsg = [[UILabel alloc] init];
    cleanMsg.frame = CGRectMake(screenW / 2 + 4, 29, screenW/2, 22);
    cleanMsg.backgroundColor = [UIColor clearColor];
    UIFont* msgFont = [UIFont boldSystemFontOfSize:20];//[UIFont fontWithName:@"Arial-BoldMT" size:20];
    [cleanMsg setFont:msgFont];
    [cleanMsg setNumberOfLines:1];
    [cleanMsg setTextColor:[UIColor whiteColor]];
    [cleanMsg setText:@"Cleaning"];
    [self.cleanPanel addSubview:cleanMsg];
    [self.view addSubview:self.cleanPanel];
    [self.view addSubview:self.cleanMask];
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
- (void)tapBack{
    [self.navigationController popViewControllerAnimated:YES];
}
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
//        return YES;
//    }
//    return YES;
//}
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    BOOL result = NO;
//
//    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
//        result = YES;
//    }
//
//    return result;
//}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    MMEventService *es = [MMEventService getInstance];
    [es addEventHandler:self eventName:EVENT_CACHE_SIZE_REFRESHED selector:@selector(cacheSizeRefreshedListener:)];
    [es addEventHandler:self eventName:EVENT_CACHE_CLEARED selector:@selector(cacheClearListener:)];
    ConfigService *cs = [ConfigService get];
    self.tableView.backgroundColor = [cs getSettingBackgroundColor:cs.type];
    // self.headerBg.backgroundColor = [cs getTopBgViewRedColor:cs.type];
    [self.titleLabel setTextColor:[cs getPhotoTopLineColor]];
    self.cleanMask.backgroundColor = [cs getPhotoTopLineColor];
}

-(void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    MMEventService *es = [MMEventService getInstance];
    [es removeEventHandler:EVENT_CACHE_SIZE_REFRESHED];
    [es removeEventHandler:EVENT_CACHE_CLEARED];
    
}
-(void)cacheClearListener: (id) data{
    if (self.view.hidden == NO){
        self.clearFinish = YES;
        ITSApplication* poApp = [ITSApplication get];
        [poApp.dataSvr setCacheDataSize:0];
        [self clearCacheFinish];
    }
}

-(void)cacheSizeRefreshedListener: (id) data{
    if (self.view.hidden == NO){
        if (self.tableView != nil){
            [self.tableView reloadData];
        }
    }
}

-(void) clearCacheFinish{
    if (self.clearFinish == YES && self.showClearFinish == YES){
        if (self.tableView != nil){
            [self.tableView reloadData];
        }
        [self hideCleanPanel];
    }
}

-(void) backBtnClicked{
    [self.navigationController popViewControllerAnimated:NO];
}

-(void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSNumber* type = [anim valueForKey:@"anim_type"];
    
    if (type.intValue == 1){
        self.showClearFinish = YES;
        [self.cleanPanel.layer removeAllAnimations];
        [self clearCacheFinish];
    } else if (type.intValue == 2) {
        self.cleanPanel.hidden = YES;
        self.cleanLoad.hidden = YES;
        self.cleanMask.hidden = YES;
        [self.cleanPanel.layer removeAllAnimations];
    }
}

-(void) showCleanPanel{
    self.showClearFinish = NO;
    self.cleanPanel.hidden = NO;
    self.cleanLoad.hidden = NO;
    self.cleanMask.hidden = NO;
    
    CGFloat screenW = [MMSystemHelper getScreenWidth];
    CGFloat screenH = [MMSystemHelper getScreenHeight];
    
    CABasicAnimation *moveAnmi = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnmi.fromValue = [NSValue valueWithCGRect:CGRectMake(screenW/2 , screenH, self.cleanPanel.frame.size.width, self.cleanPanel.frame.size.height)];
    moveAnmi.toValue = [NSValue valueWithCGRect:CGRectMake(screenW/2 , screenH-80, self.cleanPanel.frame.size.width, self.cleanPanel.frame.size.height)];
    moveAnmi.duration = 0.6f;
    moveAnmi.fillMode=kCAFillModeForwards;
    moveAnmi.removedOnCompletion=YES;
    [moveAnmi setValue:[NSNumber numberWithInt:1] forKey:@"anim_type"];
    moveAnmi.delegate = self;
    moveAnmi.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    [self.cleanPanel.layer addAnimation:moveAnmi forKey:nil];
}

-(void) hideCleanPanel{
    self.cleanPanel.hidden = NO;
    self.cleanLoad.hidden = NO;
    self.cleanMask.hidden = NO;
    
    CGFloat screenW = [MMSystemHelper getScreenWidth];
    CGFloat screenH = [MMSystemHelper getScreenHeight];
    
    CABasicAnimation *moveAnmi = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnmi.toValue = [NSValue valueWithCGRect:CGRectMake(screenW/2, screenH+40, self.cleanPanel.frame.size.width, self.cleanPanel.frame.size.height)];
    moveAnmi.fromValue = [NSValue valueWithCGRect:CGRectMake(screenW/2, screenH-80, self.cleanPanel.frame.size.width, self.cleanPanel.frame.size.height)];
    moveAnmi.duration = 0.6f;
    moveAnmi.fillMode=kCAFillModeForwards;
    moveAnmi.removedOnCompletion=NO;
    [moveAnmi setValue:[NSNumber numberWithInt:2] forKey:@"anim_type"];
    moveAnmi.delegate = self;
    moveAnmi.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    [self.cleanPanel.layer addAnimation:moveAnmi forKey:nil];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ITSApplication* poApp = [ITSApplication get];
    DataService* ds = poApp.dataSvr;
    
    NSMutableArray* settingList = [ds getSettingList];
    
    return [settingList count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ITSApplication* poApp = [ITSApplication get];
    DataService* ds = poApp.dataSvr;
    NSMutableArray* settgingList = [ds getSettingList];
    SettingItem* setting = [settgingList objectAtIndex:indexPath.row];
    
    UITableViewCell* cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:PopNewsSettingsTableViewCellIdentifier forIndexPath:indexPath];
    if (cell == nil){
        cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PopNewsSettingsTableViewCellIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    SettingCell* tmpCell = (SettingCell*)cell;
    tmpCell.title.text = setting.settingName;
    
    ConfigService *cs = [ConfigService get];
    tmpCell.title.textColor = [cs getSettingFontColor:cs.type];
    UIImage* defIcon = [UIImage imageNamed:setting.iconName];
    [tmpCell.icon setImage:defIcon];
    
    if (setting.type == SettingTypeButton){
        tmpCell.detailImage.hidden = YES;
        tmpCell.desc.hidden = NO;
        long cacheSize = [ds getCacheFolderSize];
        NSString* showSize = @"0Kb";
        long bSize = 0;
        long kbSize = 0;
        long mbSize = 0;
        long gbSize = 0;
        
        if (cacheSize > 0){
            kbSize = cacheSize / 1024;
            showSize = [NSString stringWithFormat:@"%ld Kb", kbSize];
        }
        
        if (kbSize > 1024){
            mbSize = kbSize / 1024;
            showSize = [NSString stringWithFormat:@"%ld Mb", mbSize];
        }
        
        if (mbSize > 1024){
            gbSize = mbSize / 1024;
            showSize = [NSString stringWithFormat:@"%ld Gb", gbSize];
        }
        tmpCell.desc.text = showSize;
        tmpCell.desc.textColor = [cs getSettingFontColor:cs.type];
    }else if (setting.type == SettingTypeSwitch){
        tmpCell.desc.hidden = YES;
        tmpCell.desc.hidden = YES;
        tmpCell.detailImage.hidden = NO;
        
    }else {
        CGFloat itemWidth = [MMSystemHelper getScreenWidth];
        tmpCell.detailImage.frame = CGRectMake(itemWidth-10-16, 21, 10, 19);
        [tmpCell.detailImage setImage:[UIImage imageNamed:@"set_next"] forState:UIControlStateNormal];
        tmpCell.detailImage.userInteractionEnabled = NO;
        tmpCell.detailImage.hidden = NO;
        tmpCell.desc.hidden = YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //MJTestViewController *test = [[MJTestViewController alloc] init];
    //[self.navigationController pushViewController:test animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSInteger index = indexPath.row;
    
    ITSApplication* poApp = [ITSApplication get];
    DataService* ds = poApp.dataSvr;
    NSMutableArray* settingList = [ds getSettingList];
//    NSMutableDictionary* eParams = [NSMutableDictionary dictionaryWithCapacity:1];
    if (settingList != nil && index < [settingList count]){
        SettingItem* clickItem = [settingList objectAtIndex:index];
        if (clickItem.actionType == SETTING_ACTION_EDITION){
            EditionController *editionPage = [[EditionController alloc] init];
            [self.navigationController pushViewController:editionPage animated:NO];
        } else if (clickItem.actionType == SETTING_ACTION_CLEAN_CACHE) {
            //self.cleanMask.hidden = NO;
            ITSApplication* poApp = [ITSApplication get];
            [poApp.dataSvr clearCacheFolder];
            self.clearFinish = NO;
            [self showCleanPanel];
        } else if (clickItem.actionType == SETTING_ACTION_FEEDBACK) {
            FeedBackController *feedbackPage = [[FeedBackController alloc] init];
            [self.navigationController pushViewController:feedbackPage animated:NO];

        } else if (clickItem.actionType == SETTING_ACTION_ABOUT) {
            
            AboutController *aboutPage = [[AboutController alloc] init];
            
            [self.navigationController pushViewController:aboutPage animated:NO];
            //            PopoApplication* poApp = [PopoApplication get];
            //            [poApp.reportSvr recordEvent:@"me.settings.about" params:nil];
        }
    }
    
    
    //    if (index == 3){
    //
    //    } else if (index == 2) {
    //
    //    } else if (index == 1){
    //
    //    } else if (index == 0) {
    //
    //    }
    
    
    //    PopoApplication* poApp = [PopoApplication get];
    //    DataService* ds = poApp.dataSvr;
    //    PoPoNewsItem* newsItem = [ds getNewsItem:self.cid index:(int)indexPath.row];
    //    [ds setCurrentDetailNewsItem:newsItem];
    //
    //    if ([newsItem.type compare:NEWS_TYPE_IMAGE] == NSOrderedSame){
    //        newsItem.isRead = YES;
    //        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    //
    //        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    //        UIViewController *detailPage = [story instantiateViewControllerWithIdentifier:@"detailPhotoPage"];
    //        [self.navigationController pushViewController:detailPage animated:YES];
    //    } else if ([newsItem.type compare:NEWS_TYPE_ARTICLE] == NSOrderedSame){
    //        newsItem.isRead = YES;
    //        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    //
    //        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    //        UIViewController *detailPage = [story instantiateViewControllerWithIdentifier:@"detailArticlePage"];
    //        [self.navigationController pushViewController:detailPage animated:YES];
    //    }
}

@end