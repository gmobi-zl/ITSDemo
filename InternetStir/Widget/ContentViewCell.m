//
//  ContentViewCell.m
//  segment
//
//  Created by Apple on 16/8/11.
//  Copyright © 2016年 gmobi. All rights reserved.
//

#import "ContentViewCell.h"

@implementation ContentViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;   //cell选中时的颜色，无色
        self.icon = [[UIImageView alloc] init];
        [self.contentView addSubview:self.icon];
        
        self.titleLabel = [[UILabel alloc] init];
        //        self.title.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.titleLabel];
        
        self.sourceLabel = [[UILabel alloc] init];
        self.sourceLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.sourceLabel];
        
        self.timeLabel = [[UILabel alloc]init];
        self.timeLabel.font = [UIFont systemFontOfSize:10];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.timeLabel];
        
        self.line = [[UILabel alloc]init];
        self.line.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:self.line];
    }
    return self;
}
-(void)showDataWithModel:(NSInteger)index{
    
    NSArray *titleArr = @[@"為什麼台灣還不能下載Pokemon Go啊?!!(惱怒)只好先來個真人版過過乾癮了~",@"哈哈哈~ 全台灣都在瘋Pokemon Go的症候群，Level從1到10，你已經第幾級了呀? 今天起床我第一件事，就是先看我的道場有沒有被打來? 嗯... 我已經走火入魔的第8級了 XDDD",@"如果Line聊天群組真人化！(蔡阿嘎 X HTC10)",@"日本超商10大必買零食飲料！(蔡阿嘎真心推薦)",@"嘎名人落台語10：蔡阿嘎X玖壹壹。911出道至今最犧牲演出！"];
    
    self.titleLabel.frame = CGRectMake(15, 10, self.bounds.size.width - 30, 0);
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.text = titleArr[index];
    self.titleLabel.numberOfLines = 2;
    
    CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(self.titleLabel.bounds.size.width, MAXFLOAT)];
    CGRect frame = self.titleLabel.frame;
    frame.size.height = size.height;
    [self.titleLabel setFrame:frame];
    self.titleLabel.frame = frame;

    self.icon.frame = CGRectMake(15, size.height + 10 , [[UIScreen mainScreen] bounds].size.width - 30,  9 * ([[UIScreen mainScreen] bounds].size.width - 30)/16);
    self.icon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",index]];
    
    self.sourceLabel.frame = CGRectMake(15,self.icon.frame.size.height + self.icon.frame.origin.y + 10, 40, 20);
    self.sourceLabel.font = [UIFont systemFontOfSize:10];
    self.sourceLabel.text = @"环球网";
    
    self.timeLabel.frame = CGRectMake(self.sourceLabel.frame.size.width + self.sourceLabel.frame.origin.x + 10, self.sourceLabel.frame.origin.y, 40, 20);
    self.timeLabel.text = @"4小时前";

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
