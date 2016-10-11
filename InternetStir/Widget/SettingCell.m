//
//  SettingCell.m
//  PoPoNews
//
//  Created by apple on 15/6/10.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingCell.h"
#import "MMSystemHelper.h"
#import "ITSAppConst.h"
#import "ConfigService.h"
#import "SettingService.h"
#import "ITSApplication.h"
@implementation SettingCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        CGFloat screenW = [MMSystemHelper getScreenWidth];
        //CGFloat screenH = [MMSystemHelper getScreenHeight];
        //SettingService* ss = [SettingService get];
        CGFloat itemHeight = 60;
        CGFloat itemWidth = screenW;
        self.contentView.frame = CGRectMake(0, 0, itemWidth, itemHeight);
        
        self.icon = [[UIImageView alloc] init];
        CGFloat iconW = 42;
        CGFloat iconH = 42;
        
        self.icon.frame = CGRectMake(16, 9, iconW, iconH);
        //UIImage* defIcon = [UIImage imageNamed:@"newslist_defIcon"];
        //[self.icon setImage:defIcon];
        //[self.photo1 setDefaultImg:defIcon];
        [self.contentView addSubview:self.icon];
        
        
        self.title = [[UILabel alloc] init];
        CGFloat titleW = (itemWidth - 42 - 16 - 16) * 3 / 4;
        CGFloat titleH = 20;
        self.title.frame = CGRectMake(16 + 42 + 16, 18, titleW, titleH);
        //UIFont* titleFont = [UIFont fontWithName:@"Arial" size:18];
        UIFont* titleFont = [UIFont systemFontOfSize:18];
        [self.title setFont:titleFont];
        [self.title setNumberOfLines:1];
        [self.title setTextColor:[MMSystemHelper string2UIColor:COLOR_NEWSLIST_TITLE_BLACK]];
        [self.contentView addSubview:self.title];
        
        self.desc = [[UILabel alloc] init];
        CGFloat descW = (itemWidth - 42 - 16 - 16) / 3;
        CGFloat descH = 20;
        self.desc.frame = CGRectMake(itemWidth - 16 - descW + 10, 18, descW, descH);
        //UIFont* descFont = [UIFont fontWithName:@"Arial" size:18];
        UIFont* desFont = [UIFont systemFontOfSize:18];
        [self.desc setFont:desFont];
        [self.desc setNumberOfLines:1];
        self.desc.textAlignment = NSTextAlignmentRight;
        [self.desc setTextColor:[MMSystemHelper string2UIColor:COLOR_NEWSLIST_TITLE_BLACK]];
        self.desc.hidden = YES;
        [self.contentView addSubview:self.desc];
        
        self.detailImage = [UIButton buttonWithType:UIButtonTypeCustom];
        self.detailImage.frame = CGRectMake(screenW - 60, 5, 50, 50);
        int indexi = [[[NSUserDefaults standardUserDefaults] objectForKey:@"switch"] intValue];
        if (indexi == 0) {
            self.detailImage.selected = NO;
            [self.detailImage setImage:[UIImage imageNamed:@"switch_off"] forState:UIControlStateNormal];
        } else {
            self.detailImage.selected = YES;
            [self.detailImage setImage:[UIImage imageNamed:@"switch_on"] forState:UIControlStateNormal];
        }
        [self.detailImage addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.detailImage];
        self.sepLine = [[UIView alloc] init];
        self.sepLine.backgroundColor = [MMSystemHelper string2UIColor:COLOR_NEWSLIST_DIVIDER_GREY];
        self.sepLine.frame = CGRectMake(8, itemHeight - 1, itemWidth - 16, 0.5);
        [self.contentView addSubview:self.sepLine];
    }
    return self;
}
- (void)btnClick :(UIButton*)button{
    
//    NSString *switchStr;;
    NSMutableDictionary* eParams = [NSMutableDictionary dictionaryWithCapacity:1];
    if (button.selected == NO) {
        button.selected = YES;
        [button setImage:[UIImage imageNamed:@"switch_on"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"switch"];
        [eParams setObject:@"on" forKey:@"switch"];
//        switchStr = @"on";
    }else {
        [button setImage:[UIImage imageNamed:@"switch_off"] forState:UIControlStateNormal];
        button.selected = NO;
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"switch"];
        [eParams setObject:@"off" forKey:@"switch"];
//        switchStr = @"off";
    }
    
    ITSApplication* poApp = [ITSApplication get];
    [poApp.reportSvr recordEvent:@"push" params:eParams eventCategory:@"setting.click"];
}
@end