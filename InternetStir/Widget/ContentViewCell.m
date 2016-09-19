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
-(void)showDataWithModel:(NSInteger)index{
    
    CGFloat screenW = [MMSystemHelper getScreenWidth];
    self.bgView.frame = CGRectMake(0, 10, screenW, 40);
    
    NSArray *titleArr = @[@"為什麼台灣還不能下載Pokemon Go啊?!!(惱怒)只好先來個真人版過過乾癮了~",@"哈哈哈~ 全台灣都在瘋Pokemon Go的症候群，Level從1到10，你已經第幾級了呀? 今天起床我第一件事，就是先看我的道場有沒有被打來? 嗯... 我已經走火入魔的第8級了 XDDD",@"如果Line聊天群組真人化！(蔡阿嘎 X HTC10)",@"日本超商10大必買零食飲料",@"嘎名人落台語10：蔡阿嘎X玖壹壹。最犧牲演出！"];
    
    self.titleLabel.frame = CGRectMake(15, 0, self.bounds.size.width - 30, 40);
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    self.titleLabel.textColor = [MMSystemHelper string2UIColor:@"#4A4A4A"];
    self.titleLabel.text = titleArr[index];
    self.titleLabel.numberOfLines = 2;
    CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(self.titleLabel.bounds.size.width, MAXFLOAT)];
    CGRect frame = self.titleLabel.frame;
    frame.size.height = size.height;
    [self.titleLabel setFrame:frame];
    self.titleLabel.frame = frame;

//    self.photo.image = [UIImage imageNamed:@"a-1"];
//    self.photo.frame = CGRectMake(10, 0, 40, 40);
    
    self.icon.frame = CGRectMake(0, 60 , [[UIScreen mainScreen] bounds].size.width ,  3 * ([[UIScreen mainScreen] bounds].size.width - 30)/4);
    self.icon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",index]];
    
    self.sourceLabel.frame = CGRectMake(15,self.icon.frame.size.height + self.icon.frame.origin.y + 5, 40, 20);
    self.sourceLabel.font = [UIFont systemFontOfSize:10];
    self.sourceLabel.text = @"环球网";
    
//    self.timeLabel.frame = CGRectMake(self.sourceLabel.frame.size.width + self.sourceLabel.frame.origin.x + 10, self.sourceLabel.frame.origin.y, 40, 20);
//    self.timeLabel.text = @"4小时前";
    
    self.line.frame = CGRectMake(0, self.sourceLabel.frame.origin.y + 20, screenW, 0.5);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
