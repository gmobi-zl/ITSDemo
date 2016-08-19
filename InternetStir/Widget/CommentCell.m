//
//  CommentCell.m
//  InternetStir
//
//  Created by Apple on 16/8/12.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import "CommentCell.h"
#import "MMSystemHelper.h"
#import "ITSAppConst.h"

#define screenW [MMSystemHelper getScreenWidth]

@implementation CommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;   //cell选中时的颜色，无色
        
        self.bgView = [[UIView alloc] init];
        self.bgView.backgroundColor = [MMSystemHelper string2UIColor:NAV_BGCOLOR];
        [self.contentView addSubview:self.bgView];

        self.imageview = [[UIImageView alloc] init];
        self.imageview.layer.masksToBounds = YES;
        self.imageview.layer.cornerRadius = 15;
        [self.contentView addSubview:self.imageview];
        
        self.name = [[UILabel alloc] init];
        self.name.font = [UIFont systemFontOfSize:12];
        self.name.textColor = [MMSystemHelper string2UIColor:@"#0079b1"];
        [self.contentView addSubview:self.name];
        
        self.icon = [[UIImageView alloc] init];
        self.icon.layer.masksToBounds = YES;
        self.icon.layer.cornerRadius = 20;
        [self.contentView addSubview:self.icon];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.nameLabel];
        
        self.photo = [[UIImageView alloc] init];
        [self.contentView addSubview:self.photo];
        
        self.commentLabel = [[UILabel alloc] init];
        self.commentLabel.font = [UIFont systemFontOfSize:12];
        self.commentLabel.numberOfLines = 0;
        [self.contentView addSubview:self.commentLabel];
        
        self.replyLabel = [[UILabel alloc] init];
        self.replyLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.replyLabel];
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.titleLabel.font = [UIFont systemFontOfSize: 14.0];
        [self.button setTitle:@"查看更多留言" forState:UIControlStateNormal];
        [self.button setTitleColor:[MMSystemHelper string2UIColor:@"#0079b1"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.button];
        
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.font = [UIFont systemFontOfSize:12];
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.timeLabel];
    }
    return self;
}
-(void)setCommentFrame:(CommentFrame *)commentFrame{

    _commentFrame = commentFrame;
    [self removeOldReplys];
    [self settingtData];
    [self settingFrame];
}
//防止cell重叠
-(void)removeOldReplys
{
    for (int i = 0; i < [self.replysView count]; i++) {
        UILabel *replyView = [self.replysView objectAtIndex:i];
        if (replyView.superview) {
            [replyView removeFromSuperview];
        }
    }
    for (int i = 0; i < [self.replyIconView count]; i++) {
        UIImageView *imageView = [self.replyIconView objectAtIndex:i];
        if (imageView.superview) {
            [imageView removeFromSuperview];
        }
    }
    for (int i = 0; i < [self.replyNameView count]; i++) {
        UILabel *label = [self.replyNameView objectAtIndex:i];
        if (label.superview) {
            [label removeFromSuperview];
        }
    }
    [self.replysView removeAllObjects];
    [self.replyNameView removeAllObjects];
    [self.replyIconView removeAllObjects];
}
-(void)settingtData
{
    CommentItem *comment = self.commentFrame.commentItem;
    self.icon.image = [UIImage imageNamed:comment.icon];
    self.nameLabel.text = comment.name;
    self.photo.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",comment.pictures]];
    self.commentLabel.text = comment.shuoshuoText;
    self.imageview.image = [UIImage imageNamed:comment.icon];
    self.name.text = comment.name;
    for (NSInteger i = 0; i < comment.replys.count; i++) {
        ReplyItem *item = [comment.replys objectAtIndex:i];
        UILabel *replyLabel = [[UILabel alloc]init];
        replyLabel.font = [UIFont systemFontOfSize:12];
        replyLabel.numberOfLines = 0;
        replyLabel.text = item.comment;
        self.replyLabel = replyLabel;
        [self.contentView addSubview:replyLabel];
        [self.replysView addObject:replyLabel];

        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",item.icon]];
        self.replyIcon = imageView;
        imageView.layer.cornerRadius = 15;
        imageView.layer.masksToBounds = YES;
        [self.contentView addSubview:imageView];
        [self.replyIconView addObject:imageView];
        
        UILabel *replyName = [[UILabel alloc] init];
        replyName.font = [UIFont systemFontOfSize:12];
        replyName.text = item.name;
        replyName.textColor = [MMSystemHelper string2UIColor:@"#0079b1"];
        self.replyName = replyName;
        [self.contentView addSubview:replyName];
        [self.replyNameView addObject:replyName];
    }
    self.timeLabel.text = @"發表于 2016-08-18";
}
-(void)settingFrame
{
    self.icon.frame = self.commentFrame.iconF;
    self.nameLabel.frame = self.commentFrame.nameF;
    self.bgView.frame = CGRectMake(0, 30, screenW, 23);
    self.photo.frame = self.commentFrame.photoF;
    self.name.frame = self.commentFrame.userNameF;
    self.imageview.frame = self.commentFrame.imageF;

    for (int i = 0; i < [self.commentFrame.replysF count]; i++) {
        ((UILabel *)[self.replysView objectAtIndex:i]).frame = [(NSValue *)[self.commentFrame.replysF objectAtIndex:i] CGRectValue];
    }
    for (int i = 0; i < [self.commentFrame.replyIconF count]; i++) {
        ((UIImageView *)[self.replyIconView objectAtIndex:i]).frame = [(NSValue*)[self.commentFrame.replyIconF objectAtIndex:i] CGRectValue];
//        UIImageView *image = (UIImageView *)[self.replyIconView objectAtIndex:i];
//        image.layer.masksToBounds = YES;
//        image.layer.cornerRadius = 15;
    }
    for (int i = 0; i < [self.commentFrame.replyNameF count]; i++) {
        ((UILabel *)[self.replyNameView objectAtIndex:i]).frame = [(NSValue *)[self.commentFrame.replyNameF objectAtIndex:i] CGRectValue];
    }
    self.button.frame = self.commentFrame.buttonF;
    self.commentLabel.frame = self.commentFrame.contentF;
    self.timeLabel.frame = CGRectMake(screenW - 155, 10, 150, 20);
}
-(NSMutableArray *)replysView
{
    if (!_replysView) {
        _replysView = [[NSMutableArray alloc]init];
    }
    return _replysView;
}
-(NSMutableArray *)replyIconView{
    if (!_replyIconView) {
        _replyIconView = [[NSMutableArray alloc] init];
    }
    return _replyIconView;
}
-(NSMutableArray *)replyNameView{
    if (!_replyNameView) {
        _replyNameView = [[NSMutableArray alloc] init];
    }
    return _replyNameView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
