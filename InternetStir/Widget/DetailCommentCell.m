
//
//  DetailCommentCell.m
//  InternetStir
//
//  Created by Apple on 16/8/15.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import "DetailCommentCell.h"
#import "MMSystemHelper.h"

@implementation DetailCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;   //cell选中时的颜色，无色

        self.icon = [[UIImageView alloc] init];
        self.icon.layer.masksToBounds = YES;
        self.icon.layer.cornerRadius = 20;
        [self.contentView addSubview:self.icon];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = [UIFont systemFontOfSize:14];
        self.nameLabel.textColor = [MMSystemHelper string2UIColor:@"#0079b1"];
        [self.contentView addSubview:self.nameLabel];
        
        self.commentLabel = [[UILabel alloc] init];
        self.commentLabel.numberOfLines = 0;
        self.commentLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.commentLabel];
        
        self.replyLabel = [[UILabel alloc] init];
        self.replyLabel.numberOfLines = 0;
        self.replyLabel.font = [UIFont systemFontOfSize:12];
        [self.replyBackgroundView addSubview:self.replyLabel];
        
        self.replyIcon = [[UIImageView alloc] init];
        self.replyIcon.layer.masksToBounds = YES;
        self.replyIcon.layer.cornerRadius = 15;
        [self.contentView addSubview:self.replyIcon];
        
        self.replyBackgroundView = [[UIImageView alloc] init];
//        self.replyBackgroundView.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:self.replyBackgroundView];
        
        self.line = [[UILabel alloc] init];
        self.line.backgroundColor = [UIColor grayColor];
        self.line.alpha = 0.4;
        [self.contentView addSubview:self.line];
    }
    return self;
}
-(void)setDetailCommentFrame:(DetailCommentFrame *)detailCommentFrame{
    
    _detailCommentFrame = detailCommentFrame;
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
    [self.replyIconView removeAllObjects];
    [self.replyNameView removeAllObjects];
}
-(void)settingtData
{
//    DetailCommentItem *comment = self.detailCommentFrame.detailCommentItem;
    ReplyItem *item = self.detailCommentFrame.item;
    self.icon.image = [UIImage imageNamed:item.icon];
    self.nameLabel.text = item.name;
    self.commentLabel.text = item.comment;
//    for (NSInteger i = 0; i < comment.replys.count; i++) {
//        
//        ReplyItem *item = [comment.replys objectAtIndex:i];
//        UILabel *replyLabel = [[UILabel alloc]init];
//        replyLabel.font = [UIFont systemFontOfSize:12];
//        replyLabel.numberOfLines = 0;
//        replyLabel.text = item.comment;
//        self.replyLabel = replyLabel;
//        [self.contentView addSubview:replyLabel];
//        [self.replysView addObject:replyLabel];
//        
//        UIImageView *replyIcon = [[UIImageView alloc] init];
//        replyIcon.layer.masksToBounds = YES;
//        replyIcon.layer.cornerRadius = 15;
//        replyIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",item.icon]];
//        [self.contentView addSubview:replyIcon];
//        self.replyIcon = replyIcon;
//        [self.replyIconView addObject:replyIcon];
//        
//        UILabel *replyName = [[UILabel alloc] init];
//        replyName.text = item.name;
//        replyName.textColor = [MMSystemHelper string2UIColor:@"#0079b1"];
//        replyName.font = [UIFont systemFontOfSize:14];
//        [self.contentView addSubview:replyName];
//        [self.replyNameView addObject:replyName];
//    }
}
-(void)settingFrame
{
    self.icon.frame = self.detailCommentFrame.iconF;
    self.nameLabel.frame = self.detailCommentFrame.nameF;
    for (int i = 0; i < [self.detailCommentFrame.replysF count]; i++) {
        ((UILabel *)[self.replysView objectAtIndex:i]).frame = [(NSValue *)[self.detailCommentFrame.replysF objectAtIndex:i] CGRectValue];
    }
    for (int i = 0; i < [self.detailCommentFrame.replysF count]; i++) {
        ((UIImageView *)[self.replyIconView objectAtIndex:i]).frame = [(NSValue *)[self.detailCommentFrame.replyPictureF objectAtIndex:i] CGRectValue];
    }
    for (int i = 0; i < [self.detailCommentFrame.replysF count]; i++) {
        ((UILabel *)[self.replyNameView objectAtIndex:i]).frame = [(NSValue *)[self.detailCommentFrame.replyNameF objectAtIndex:i] CGRectValue];
    }
    self.commentLabel.frame = self.detailCommentFrame.contentF;
    self.replyBackgroundView.frame = self.detailCommentFrame.replyBackgroundF;
    self.line.frame = self.detailCommentFrame.lineF;
}
-(NSMutableArray *)replysView
{
    if (!_replysView) {
        _replysView = [[NSMutableArray alloc]init];
    }
    return _replysView;
}
-(NSMutableArray *)replyNameView{
    if (!_replyNameView) {
        _replyNameView = [[NSMutableArray alloc] init];
    }
    return _replyNameView;
}
-(NSMutableArray *)replyIconView{
    if (!_replyIconView) {
        _replyIconView = [[NSMutableArray alloc] init];
    }
    return _replyIconView;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
