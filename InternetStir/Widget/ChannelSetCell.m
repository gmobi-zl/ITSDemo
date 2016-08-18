//
//  ChannelSetCell.m
//  PoPoNews
//
//  Created by apple on 15/6/11.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITSAppConst.h"
#import "ChannelSetCell.h"
#import "MMSystemHelper.h"
#import "ConfigService.h"

@implementation ChannelSetCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        CGFloat screenW = [MMSystemHelper getScreenWidth];
        //CGFloat screenH = [MMSystemHelper getScreenHeight];
        
        CGFloat itemHeight = 60;
        CGFloat itemWidth = screenW;
        self.contentView.frame = CGRectMake(0, 0, itemWidth, itemHeight);
        
        self.icon = [[UIImageView alloc] init];
        CGFloat iconW = 40;
        CGFloat iconH = 24;
        self.icon.frame = CGRectMake(16, 18, iconW, iconH);
        //UIImage* defIcon = [UIImage imageNamed:@"newslist_defIcon"];
        //[self.icon setImage:defIcon];
        //[self.icon setDefaultImg:defIcon];
        
        CALayer* iconLayer = [self.icon layer];
        iconLayer.borderColor = [[MMSystemHelper string2UIColor:COLOR_BG_GREY] CGColor];
        iconLayer.borderWidth = 0.5f;
        
        [self.contentView addSubview:self.icon];
        
        
        self.name = [[UILabel alloc] init];
        CGFloat titleW = (itemWidth - 40 - 16 - 16) * 3 / 4;
        CGFloat titleH = 18;
        self.name.frame = CGRectMake(16 + 40 + 16, 21, titleW, titleH);
        UIFont* titleFont = [UIFont systemFontOfSize:16];//[UIFont fontWithName:@"Arial" size:18];
        [self.name setFont:titleFont];
        [self.name setNumberOfLines:1];
        [self.name setTextColor:[MMSystemHelper string2UIColor:COLOR_NEWSLIST_TITLE_BLACK]];
        [self.contentView addSubview:self.name];
        
        
        self.selBtn = [[UIImageView alloc] init];
        self.selBtn.frame = CGRectMake(itemWidth-32-16, 14, 32, 32);
        ConfigService *cs = [ConfigService get];
        if (cs.type == MODE_NIGHT) {
            [self.selBtn setImage:[UIImage imageNamed:@"language_checkbox_normal_night"]];
        }else if (cs.type == MODE_DAY){
            UIImage* defIcon = [[UIImage imageNamed:@"channel_def"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [self.selBtn setImage:defIcon];
        }
       
        [self.contentView addSubview:self.selBtn];
    }
    
    return self;
}

@end