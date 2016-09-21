 //
//  MenuViewCell.m
//  segment
//
//  Created by Apple on 16/8/11.
//  Copyright © 2016年 gmobi. All rights reserved.
//

#import "MenuViewCell.h"
#import "MMSystemHelper.h"
#import "AppStyleConfiguration.h"

@implementation MenuViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
//        self.selectionStyle = UITableViewCellSelectionStyleNone;   //cell选中时的颜色，无色
        CGFloat screenW = [MMSystemHelper getScreenWidth];
        CGFloat itemHeight = 44; //[[ConfigService get] getNewsListItemHeight:NEWS_TYPE_IMAGE]; //screenH / 7;
        CGFloat itemWidth = screenW * 3 / 4;
        self.contentView.frame = CGRectMake(0, 0, itemWidth, itemHeight);
        self.icon = [[UIImageView alloc] init];
        CGFloat iconW = 20;
        CGFloat iconH = 20;
        
        self.icon.frame = CGRectMake(16, 12, iconW, iconH);
        [self.contentView addSubview:self.icon];
        
        self.title = [[UILabel alloc] init];
        CGFloat titleW = itemWidth - 16*3 - 42;
        CGFloat titleH = 20;
        self.title.frame = CGRectMake(16 + 45 + 10, 12, titleW, titleH);
        //UIFont* titleFont = [UIFont fontWithName:@"Arial" size:18];
        UIFont* titleFont = [UIFont systemFontOfSize:16];
        [self.title setFont:titleFont];
        self.title.text = @"设置";
        [self.title setNumberOfLines:1];
        [self.contentView addSubview:self.title];
        
        self.imageview = [[UIImageView alloc] init];
        self.imageview.frame = CGRectMake(screenW - 30, 12, 10, 15);
        self.imageview.image = [UIImage imageNamed:@"set_next"];
        [self.contentView addSubview:self.imageview];
        
        self.loginLabel = [[UILabel alloc] init];
        self.loginLabel.frame = CGRectMake(0, 0, screenW, 44);
        self.loginLabel.textAlignment = NSTextAlignmentCenter;
        self.loginLabel.textColor = [MMSystemHelper string2UIColor:HOME_VIPNAME_COLOR];
        self.loginLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.loginLabel];
        
        self.bgView = [[UIView alloc] init];
        self.bgView.frame = CGRectMake(0, 0, screenW, 44);
        self.bgView.backgroundColor = [UIColor whiteColor];
        self.bgView.alpha = 0.5;
        [self.contentView addSubview:self.bgView];
        
        self.line = [[UIView alloc] init];
        self.line.frame = CGRectMake(0, 43, screenW, 1);
        self.line.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];//[UIColor lightGrayColor];
        self.line.alpha = 0.5;
        [self.contentView addSubview:self.line];
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
