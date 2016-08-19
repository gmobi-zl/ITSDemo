//
//  EditionController.m
//  PoPoNews
//
//  Created by apple on 15/6/10.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EditionController.h"
#import "ConfigService.h"
#import "MMSystemHelper.h"
#import "ITSApplication.h"
#import "DataService.h"
#import "ChannelSetCell.h"
#import "SettingService.h"
#import "AppDelegate.h"
#import "SplashController.h"
#import "UIImageView+WebCache.h"
#import "MMEventService.h"

NSString *const PopNewsChannelSetTableViewCellIdentifier = @"PNewsChannelSetCell";

@implementation EditionController

-(void) viewDidLoad{
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self initViews];
    UIButton* Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    Btn.frame = CGRectMake(0, 20, 30, 30);
    [Btn setBackgroundImage:[UIImage imageNamed:@"icon_Back"] forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:Btn];
    self.navigationItem.leftBarButtonItem = left;
    
}
-(void) clickBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) initViews{
    self.headerBg = [[UIView alloc] init];
    self.headerBg.backgroundColor = [MMSystemHelper string2UIColor:COLOR_BG_RED];
    CGFloat screenW = [MMSystemHelper getScreenWidth];
    CGFloat screenH = [MMSystemHelper getScreenHeight];
//    self.headerBg.frame = CGRectMake(0, -20, screenW,20);
//    [self.navigationController.navigationBar addSubview:self.headerBg];
    
    NSString *str = ITS_NSLocalizedString(@"SettingEdition",@"Edition");
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGRect rect = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    
    UIButton* backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 20, 60 + rect.size.width, 60);

    [backBtn setTitle:ITS_NSLocalizedString(@"SettingEdition", @"Edition") forState:UIControlStateNormal];
    //[backBtn setTitle:@"Categories" forState:UIControlStateNormal];
    
    backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 15);
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 30);
    UIImage* backIcon = [UIImage imageNamed:@"title_back"];
    [backBtn setImage:backIcon forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = back;
    
//    UIButton* backBtn = [[UIButton alloc] init];
//    backBtn.frame = CGRectMake(0, 20, 40, 40);
//    [backBtn setTitle:@"" forState:UIControlStateNormal];
//    UIImage* backIcon = [UIImage imageNamed:@"title_back"];
//    
//    [backBtn setBackgroundImage:backIcon forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    
//    UILabel* title = [[UILabel alloc] init];
//    title.frame = CGRectMake(45, 30, 200, 20);
//    title.backgroundColor = [UIColor clearColor];
//    UIFont* titleFont = [UIFont boldSystemFontOfSize:20];//[UIFont fontWithName:@"Arial-BoldMT" size:20];
//    [title setFont:titleFont];
//    [title setNumberOfLines:1];
//    title.userInteractionEnabled = YES;
//    [title setTextColor:[UIColor whiteColor]];
//    [title setText:PPN_NSLocalizedString(@"SettingEdition", @"Edition")];
//   

//    [self.headerBg addSubview:backBtn];
//    [self.headerBg addSubview:title];
//    
    //[self.view addSubview:self.headerBg];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, 0, screenW, screenH );
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[ChannelSetCell class] forCellReuseIdentifier:PopNewsChannelSetTableViewCellIdentifier];
    
    [self.view addSubview:self.tableView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
   // [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_light"] forBarMetrics:UIBarMetricsDefault];
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
/*
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    BOOL result = NO;
    
    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        result = YES;
    }
    
    return result;
}
*/
-(void) backBtnClicked{
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ITSApplication* poApp = [ITSApplication get];
    DataService* ds = poApp.dataSvr;
    
    NSMutableArray* chList = [ds getPoNewsChannelList];
    
    return [chList count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ITSApplication* poApp = [ITSApplication get];
    DataService* ds = poApp.dataSvr;
    NSMutableArray* chList = [ds getPoNewsChannelList];
    PopoNewsChannel* chItem = nil;
    if (chList != nil)
        chItem = [chList objectAtIndex:indexPath.row];
    
    UITableViewCell* cell = nil;
    ;
    cell = [tableView dequeueReusableCellWithIdentifier:PopNewsChannelSetTableViewCellIdentifier forIndexPath:indexPath];
    if (cell == nil){
        cell = [[ChannelSetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PopNewsChannelSetTableViewCellIdentifier];
    }
    cell.backgroundColor=[UIColor clearColor];
    if (chItem != nil){
        ChannelSetCell* tmpCell = (ChannelSetCell*)cell;
        tmpCell.name.text = chItem.name;
        ConfigService *cs = [ConfigService get];
        tmpCell.name.textColor = [cs getSettingFontColor:cs.type];
        
        if (chItem.icon != nil){
            NSString* imageUrl = [[NSString alloc] initWithFormat:@"%@%@", ds.fileBaseUrl, chItem.icon];
            //[tmpCell.icon setWebImage:imageUrl fName:chItem.icon];
            [tmpCell.icon sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"top_news_nonpic"]];
        }
        
        if (chItem.isChecked){
            UIImage* selIcon = [[UIImage imageNamed:@"channel_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            if (cs.type == MODE_NIGHT) {
                [tmpCell.selBtn setImage:[UIImage imageNamed:@"language_checkbox_selected_night"]];
            }else if (cs.type == MODE_DAY){
                [tmpCell.selBtn setImage:selIcon];
            }
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ITSApplication* poApp = [ITSApplication get];
    DataService* ds = poApp.dataSvr;
    NSMutableArray* chList = [ds getPoNewsChannelList];
    
    for (int i = 0; i < [chList count]; i++) {
        PopoNewsChannel* chItem = [chList objectAtIndex:i];
        chItem.isChecked = NO;
        
        if (i == indexPath.row){
            chItem.isChecked = YES;
            ConfigService* cs = [ConfigService get];
            [cs setChannel:chItem.chId];
            
            SettingService* ss = [SettingService get];
            if ([chItem.lang isEqualToString:@"cn"]){
                [ss setStringValue:CUSTOMER_LOCAL_LANGUAGE_TYPE data:CUSTOMER_LOCAL_LANGUAGE_TYPE_CN];
                [poApp setCustomerLanguage:CUSTOMER_LOCAL_LANGUAGE_TYPE_CN];
            } else if ([chItem.lang isEqualToString:@"tw"]){
                [ss setStringValue:CUSTOMER_LOCAL_LANGUAGE_TYPE data:CUSTOMER_LOCAL_LANGUAGE_TYPE_TW];
                [poApp setCustomerLanguage:CUSTOMER_LOCAL_LANGUAGE_TYPE_TW];
            } else if ([chItem.lang isEqualToString:@"ru"]){
                [ss setStringValue:CUSTOMER_LOCAL_LANGUAGE_TYPE data:CUSTOMER_LOCAL_LANGUAGE_TYPE_RU];
                [poApp setCustomerLanguage:CUSTOMER_LOCAL_LANGUAGE_TYPE_RU];
            } else if ([chItem.lang isEqualToString:@"in"]){
                [ss setStringValue:CUSTOMER_LOCAL_LANGUAGE_TYPE data:CUSTOMER_LOCAL_LANGUAGE_TYPE_INDONESIAN];
                [poApp setCustomerLanguage:CUSTOMER_LOCAL_LANGUAGE_TYPE_INDONESIAN];
            } else if ([chItem.lang isEqualToString:@"th"]){
                [ss setStringValue:CUSTOMER_LOCAL_LANGUAGE_TYPE data:CUSTOMER_LOCAL_LANGUAGE_TYPE_TH];
                [poApp setCustomerLanguage:CUSTOMER_LOCAL_LANGUAGE_TYPE_TH];
            } else if ([chItem.lang isEqualToString:@"id"]){
                [ss setStringValue:CUSTOMER_LOCAL_LANGUAGE_TYPE data:CUSTOMER_LOCAL_LANGUAGE_TYPE_INDONESIAN];
                [poApp setCustomerLanguage:CUSTOMER_LOCAL_LANGUAGE_TYPE_INDONESIAN];
            }else if([chItem.lang isEqualToString:@"my"]){
                [ss setStringValue:CUSTOMER_LOCAL_LANGUAGE_TYPE data:CUSTOMER_LOCAL_LANGUAGE_TYPE_MY];
                [poApp setCustomerLanguage:CUSTOMER_LOCAL_LANGUAGE_TYPE_MY];
            } else{
                [ss setStringValue:CUSTOMER_LOCAL_LANGUAGE_TYPE data:CUSTOMER_LOCAL_LANGUAGE_TYPE_EN];
                [poApp setCustomerLanguage:CUSTOMER_LOCAL_LANGUAGE_TYPE_EN];
            }
        }
    }
    
    [self.tableView reloadData];
    
    // remove storage connect info
    SettingService* ss = [SettingService get];
    [ss setDictoryValue:CONFIG_LAST_CONNECT_INFO data:nil];
    
    SplashController *spl = [[SplashController alloc] init];
    [self.navigationController pushViewController:spl animated:YES];
    //[self.navigationController popToRootViewControllerAnimated:NO];
    
    [ds clearCategoryData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    ConfigService *cs = [ConfigService get];
    self.headerBg.backgroundColor = [cs getTopBgViewRedColor:cs.type];
    self.tableView.backgroundColor = [cs getSettingBackgroundColor:cs.type];
//    NSMutableDictionary* eParams = [NSMutableDictionary dictionaryWithCapacity:1];

//    ITSApplication* poApp = [ITSApplication get];
//    [poApp.reportSvr recordEvent:@" " params:eParams eventCategory:@"me.settings.edition"];
}

@end