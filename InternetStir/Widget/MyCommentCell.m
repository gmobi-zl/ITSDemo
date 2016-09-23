//
//  MyCommentCell.m
//  Jacob
//
//  Created by Apple on 16/9/20.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import "MyCommentCell.h"
#import "AppStyleConfiguration.h"
#import "UIImageView+WebCache.h"
#import "MMSystemHelper.h"

#define screenW [MMSystemHelper getScreenWidth]
#define screenH [MMSystemHelper getScreenHeight]

@implementation MyCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.icon = [[UIImageView alloc] init];
        self.icon.frame = CGRectMake(HOME_CONTENT_LEFT_PADDING, 15, 45, 45);
        self.icon.image = [UIImage imageNamed:@"b-6.jpg"];
        self.icon.layer.masksToBounds = YES;
        self.icon.layer.cornerRadius = 22;
        [self.contentView addSubview:self.icon];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.icon.frame), 18, 100, 25);
        self.nameLabel.font = [UIFont systemFontOfSize:16];
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.text = @"Gmobi";
        [self.contentView addSubview:self.nameLabel];
        
        self.contentLabel = [[UILabel alloc] init];
        self.contentLabel.frame = CGRectMake(CGRectGetMaxX(self.icon.frame), CGRectGetMaxY(self.nameLabel.frame), 200, 20);
        self.contentLabel.text = @"哈哈哈哈哈哈哈哈哈";
        self.contentLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.contentLabel];
        
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.icon.frame), CGRectGetMaxY(self.contentLabel.frame), 60, 20);
        self.timeLabel.textColor = [MMSystemHelper string2UIColor:HOME_MORE_COMMENT_COLOR];
        self.timeLabel.font = [UIFont systemFontOfSize:14];
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        self.timeLabel.text = @"3小時前";
        [self.contentView addSubview:self.timeLabel];
        
        self.replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.replyButton.frame = CGRectMake(CGRectGetMaxX(self.timeLabel.frame), CGRectGetMaxY(self.contentLabel.frame), 40, 20);
        [self.replyButton setTitle:@"回復" forState:UIControlStateNormal];
        [self.replyButton setTitleColor:[MMSystemHelper string2UIColor:HOME_MORE_COMMENT_COLOR] forState:UIControlStateNormal];
        self.replyButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.replyButton];
        
        self.replyIcon = [[UIImageView alloc] init];
        self.replyIcon.frame = CGRectMake(80, CGRectGetMaxY(self.timeLabel.frame) + 10, 30, 30);
        self.replyIcon.image = [UIImage imageNamed:@"a-1"];
        self.replyIcon.layer.masksToBounds = YES;
        self.replyIcon.layer.cornerRadius = 15;
        [self.contentView addSubview:self.replyIcon];
        
        self.replyName = [[UILabel alloc] init];
        self.replyName.frame = CGRectMake(CGRectGetMaxX(self.replyIcon.frame) + 10, self.replyIcon.frame.origin.y, 100, 20);
        self.replyName.textAlignment = NSTextAlignmentLeft;
        self.replyName.text = @"蔡阿嘎";
        self.replyName.font = [UIFont systemFontOfSize:16];
        self.replyName.textColor = [MMSystemHelper string2UIColor:HOME_VIPNAME_COLOR];
        [self.contentView addSubview:self.replyName];
        
        CGSize size = [MMSystemHelper sizeWithString:@"騙鬼，我相信有這麼難喝！不用拿來給我了d" font:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(screenW - 35 - 100, MAXFLOAT)];
        self.replyContent = [[UILabel alloc] init];
        self.replyContent.numberOfLines = 0;
        self.replyContent.frame = CGRectMake(CGRectGetMaxX(self.replyIcon.frame) + 10, CGRectGetMaxY(self.replyName.frame), screenW - CGRectGetMaxX(self.replyIcon.frame) - 10 - 25, size.height);
        self.replyContent.font = [UIFont systemFontOfSize:16];
        self.replyContent.text = @"騙鬼，我相信有這麼難喝！不用拿來給我了d";
        self.replyContent.textColor = [MMSystemHelper string2UIColor:HOME_TIME_COLOR];
        [self.contentView addSubview:self.replyContent];
        
        self.bgView = [[UIView alloc] init];
        self.bgView.frame = CGRectMake(80, CGRectGetMaxY(self.replyContent.frame)+10, screenW - 80 - 25, 92);
        self.bgView.layer.masksToBounds = YES;
        self.bgView.layer.cornerRadius = 10;
        self.bgView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        [self.contentView addSubview:self.bgView];
        
//        size = [MMSystemHelper sizeWithString:@"15年前，狂吃波卡蒐集裡面的神奇寶貝，15年後，在手機上狂收集Pokemon Go寶可夢。欸欸!! 這才不是玩物喪志!! 是在緬懷那段回不去的童年啊!!! 哈哈哈 XDDD" font:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(screenW - 80 - 25 - 140,MAXFLOAT)];
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.frame = CGRectMake(10, 10, screenW - 80 - 25 - 140, 0);
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.text = @"15年前，狂吃波卡蒐集裡面的神奇寶貝，15年後，在手機上狂收集Pokemon Go寶可夢。欸欸!! 這才不是玩物喪志!! 是在緬懷那段回不去的童年啊!!! 哈哈哈 XDDD";
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.titleLabel.textColor = [UIColor blackColor];
        [self.bgView addSubview:self.titleLabel];
        
        CGSize size1 = [self.titleLabel sizeThatFits:CGSizeMake(screenW - 80 - 25 - 140, MAXFLOAT)];
        CGRect frame = self.titleLabel.frame;
        frame.size.height = size1.height;
        [self.titleLabel setFrame:frame];
        self.titleLabel.frame = frame;
        
        self.photo = [[UIImageView alloc] init];
        self.photo.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+10, 10, 100, 67);
        self.photo.image = [UIImage imageNamed:@"a-3.jpg"];
        [self.bgView addSubview:self.photo];
        
        self.readBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.readBtn.frame = CGRectMake(screenW - 80, 25, 60, 30);
        self.readBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.readBtn setTitle:@"Read" forState:UIControlStateNormal];
        self.readBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
        self.readBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        UIImage *btnIcon = [UIImage imageNamed:@"Rectangle.read"];
        [self.readBtn setImage:btnIcon forState:UIControlStateNormal];
        self.readBtn.backgroundColor = [MMSystemHelper string2UIColor:HOME_VIPNAME_COLOR];
        self.readBtn.layer.masksToBounds = YES;
        self.readBtn.layer.cornerRadius = 5;
        [self.contentView addSubview:self.readBtn];
        
        
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
