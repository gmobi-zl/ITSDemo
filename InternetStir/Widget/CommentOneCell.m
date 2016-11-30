


//
//  CommentOneCell.m
//  Celebrity
//
//  Created by Apple on 16/11/9.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import "CommentOneCell.h"
#import "AppStyleConfiguration.h"
#import "MMSystemHelper.h"
#import "ITSApplication.h"
#import "UIImageView+WebCache.h"

@implementation CommentOneCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;   //cell选中时的颜色，无色

        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = [UIFont fontWithName:@"PingFangTC-Semibold" size:14];
        [self.contentView addSubview:self.nameLabel];

        self.icon = [[UIImageView alloc] init];
        self.icon.backgroundColor = [UIColor whiteColor];
        self.icon.layer.masksToBounds = YES;
        self.icon.layer.cornerRadius = 20;
        [self.contentView addSubview:self.icon];
        
        self.commentLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        self.commentLabel.textColor = [MMSystemHelper string2UIColor:HOME_COMMENT_COLOR];
        self.commentLabel.font = [UIFont systemFontOfSize:14];
        self.commentLabel.lineSpacing = 0.5;
        self.commentLabel.numberOfLines = 0;
        self.commentLabel.backgroundColor = [UIColor clearColor];
        self.commentLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
        [self.contentView addSubview:self.commentLabel];

        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        self.timeLabel.font = [UIFont systemFontOfSize:14];
        self.timeLabel.textColor = [MMSystemHelper string2UIColor:HOME_MORE_COMMENT_COLOR];
        [self.contentView addSubview:self.timeLabel];
        
        self.replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.replyButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.replyButton setTitle:NSLocalizedString (@"comment_reply", nil) forState:UIControlStateNormal];
        self.replyButton.userInteractionEnabled = YES;
        [self.replyButton setTitleColor:[MMSystemHelper string2UIColor:HOME_MORE_COMMENT_COLOR] forState:UIControlStateNormal];
        [self.contentView addSubview:self.replyButton];

        self.line = [[UILabel alloc] init];
        self.line.backgroundColor = [MMSystemHelper string2UIColor:@"#ECECED"];
        [self.contentView addSubview:self.line];
    }
    return self;
}
-(void) setShowData: (id) comment{
//    ITSApplication* itsApp = [ITSApplication get];
//    CBUserService* us = itsApp.cbUserSvr;
    CelebComment *data = comment;
    self.icon.frame = CGRectMake(15, 13, 40, 40);
    self.icon.contentMode = UIViewContentModeScaleAspectFill;
    self.icon.layer.masksToBounds = YES;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:data.avator] placeholderImage:[UIImage imageNamed:@"Bitmap"] options:SDWebImageRefreshCached];
    //        [self.contentView addSubview:self.icon];
    self.nameLabel.text = data.name;
    CGFloat nameLabelX = CGRectGetMaxX(self.icon.frame) + 8;
    CGSize nameLabelSize = [MMSystemHelper sizeWithString:data.name font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT,20)];
    CGFloat nameLabelY = 13;
    CGFloat nameLabelWidth = nameLabelSize.width + 10;
    CGFloat nameLabelHeight = nameLabelSize.height;
    self.nameLabel.frame = CGRectMake(nameLabelX, nameLabelY, nameLabelWidth, 20);
    self.nameLabel.textColor = [MMSystemHelper string2UIColor:HOME_VIPNAME_COLOR];
    //        [self.contentView addSubview:self.nameLabel];
    CGFloat contentLabelX = nameLabelX;
    CGFloat contentLabelY = nameLabelY + nameLabelHeight + 4;
//    CGSize contentLabelSize = [MMSystemHelper sizeWithString:data.context font:[UIFont systemFontOfSize:14 ] maxSize:CGSizeMake([MMSystemHelper getScreenWidth] - nameLabelX - HOME_CONTENT_LEFT_PADDING, MAXFLOAT)];
    
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//    paragraphStyle.lineSpacing = 0.5;
//    NSDictionary *attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paragraphStyle};
//    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc]initWithString:data.context attributes:attributes];
//
//    CGSize contentLabelSize = [TTTAttributedLabel sizeThatFitsAttributedString:noteStr withConstraints:CGSizeMake([MMSystemHelper getScreenWidth] - nameLabelX - HOME_CONTENT_LEFT_PADDING, MAXFLOAT) limitedToNumberOfLines:0];

//   CGRect rect = [TQRichTextView boundingRectWithSize:CGSizeMake([MMSystemHelper getScreenWidth] - nameLabelX - HOME_CONTENT_LEFT_PADDING, MAXFLOAT) font:[UIFont systemFontOfSize:14] string:data.context lineSpace:0.5 type:2];
    __block CGSize size;
    [self.commentLabel setText:data.context afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        size = [TTTAttributedLabel sizeThatFitsAttributedString:mutableAttributedString
                                                  withConstraints:CGSizeMake([MMSystemHelper getScreenWidth] - nameLabelX - HOME_CONTENT_LEFT_PADDING, MAXFLOAT)
                                           limitedToNumberOfLines:0];
        return mutableAttributedString;
    }];

    CGFloat contentLabelWidth = size.width;
    CGFloat contentLabelHeight = size.height;
    self.commentLabel.frame = CGRectMake(contentLabelX, contentLabelY, contentLabelWidth, contentLabelHeight);
    
    
    //        [self.contentView addSubview:self.commentLabel];
    NSString* time = [MMSystemHelper compareCurrentTime:[NSString stringWithFormat:@"%lld", data.pts]];
    CGSize timeLabelSize = [MMSystemHelper sizeWithString:time font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, 20)];
    self.timeLabel.frame = CGRectMake(nameLabelX, self.commentLabel.frame.origin.y + self.commentLabel.frame.size.height + 4, timeLabelSize.width, 20);
    self.timeLabel.text = time;
    //        [self.contentView addSubview:self.timeLabel];
    self.replyButton.frame = CGRectMake(nameLabelX + timeLabelSize.width + 10, self.timeLabel.frame.origin.y, 40, 20);
    self.replyButton.userInteractionEnabled = YES;
    self.line.frame = CGRectMake(nameLabelX, self.timeLabel.frame.size.height + self.timeLabel.frame.origin.y + 10 - 0.5, [MMSystemHelper getScreenWidth] - nameLabelX - 10, 0.5);
}
@end
