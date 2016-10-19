//
//  ContentViewCell.m
//  segment
//
//  Created by Apple on 16/8/11.
//  Copyright © 2016年 gmobi. All rights reserved.
//

#import "ContentViewCell.h"
#import "MMSystemHelper.h"
#import "ITSAppConst.h"
#import "UIImageView+WebCache.h"

@implementation ContentViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;   //cell选中时的颜色，无色
        self.icon = [[UIImageView alloc] init];
        [self.contentView addSubview:self.icon];
        
        self.bgView = [[UIView alloc] init];
//        self.bgView.backgroundColor = [MMSystemHelper string2UIColor:NAV_BGCOLOR];
        [self.contentView addSubview:self.bgView];

        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:18];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.bgView addSubview:self.titleLabel];
        
        self.sourceLabel = [[UILabel alloc] init];
        self.sourceLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.sourceLabel];
        
        self.timeLabel = [[UILabel alloc]init];
        self.timeLabel.font = [UIFont systemFontOfSize:10];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.timeLabel];
        
        self.line = [[UILabel alloc]init];
        self.line.backgroundColor = [UIColor grayColor];
        self.line.alpha = 0.5;
        [self.contentView addSubview:self.line];
        
        self.photo = [[UIImageView alloc] init];
        self.photo.layer.cornerRadius = 20;
        self.photo.layer.masksToBounds = YES;
        [self.bgView addSubview:self.photo];
        
    }
    return self;
}
-(void)showDataWithModel:(CelebRecommend*)item{
    
    CGFloat screenW = [MMSystemHelper getScreenWidth];
    self.bgView.frame = CGRectMake(0, 10, screenW, 40);
    
    self.titleLabel.frame = CGRectMake(15, 0, self.bounds.size.width - 30, 40);
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    self.titleLabel.textColor = [MMSystemHelper string2UIColor:@"#4A4A4A"];
    self.titleLabel.text = item.title;
    self.titleLabel.numberOfLines = 2;
    CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(self.titleLabel.bounds.size.width, MAXFLOAT)];
    CGRect frame = self.titleLabel.frame;
    frame.size.height = size.height;
    [self.titleLabel setFrame:frame];
    self.titleLabel.frame = frame;
    
    self.icon.frame = CGRectMake(0, 60 , [[UIScreen mainScreen] bounds].size.width ,  3 * [[UIScreen mainScreen] bounds].size.width/4);
    self.icon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%1.jpg"]];
    
    self.sourceLabel.frame = CGRectMake(15,self.icon.frame.size.height + self.icon.frame.origin.y + 5, 40, 20);
    self.sourceLabel.font = [UIFont systemFontOfSize:10];
    self.sourceLabel.text = item.source;
    
//    self.timeLabel.frame = CGRectMake(self.sourceLabel.frame.size.width + self.sourceLabel.frame.origin.x + 10, self.sourceLabel.frame.origin.y, 40, 20);
//    self.timeLabel.text = @"4小时前";
    
    self.line.frame = CGRectMake(0, self.sourceLabel.frame.origin.y + 20, screenW, 0.5);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
