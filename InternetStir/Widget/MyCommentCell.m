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
#import "ITSApplication.h"
#import "UserTrackComment.h"

#define screenW [MMSystemHelper getScreenWidth]
#define screenH [MMSystemHelper getScreenHeight]

@implementation MyCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.icon = [[UIImageView alloc] init];
        self.icon.layer.masksToBounds = YES;
        self.icon.layer.cornerRadius = 22;
        [self.contentView addSubview:self.icon];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = [UIFont systemFontOfSize:16];
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.nameLabel];
        
        self.contentLabel = [[UILabel alloc] init];
        self.contentLabel.font = [UIFont systemFontOfSize:16];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.textColor = [MMSystemHelper string2UIColor:HOME_COMMENT_COLOR];
        self.contentLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.contentLabel];
        
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.textColor = [MMSystemHelper string2UIColor:HOME_MORE_COMMENT_COLOR];
        self.timeLabel.font = [UIFont systemFontOfSize:14];
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.timeLabel];
        
        self.replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.replyButton setTitle:@"回復" forState:UIControlStateNormal];
        [self.replyButton setTitleColor:[MMSystemHelper string2UIColor:HOME_MORE_COMMENT_COLOR] forState:UIControlStateNormal];
        self.replyButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.replyButton];
        
        self.replyIcon = [[UIImageView alloc] init];
        self.replyIcon.layer.masksToBounds = YES;
        self.replyIcon.layer.cornerRadius = 15;
        [self.contentView addSubview:self.replyIcon];
        
        self.replyName = [[UILabel alloc] init];
        self.replyName.textAlignment = NSTextAlignmentLeft;
        self.replyName.font = [UIFont systemFontOfSize:16];
        self.replyName.textColor = [MMSystemHelper string2UIColor:HOME_VIPNAME_COLOR];
        [self.contentView addSubview:self.replyName];
        
        self.replyContent = [[UILabel alloc] init];
        self.replyContent.numberOfLines = 0;
        self.replyContent.font = [UIFont systemFontOfSize:16];
        self.replyContent.textColor = [MMSystemHelper string2UIColor:HOME_COMMENT_COLOR];
        [self.contentView addSubview:self.replyContent];
        
        self.bgView = [[UIView alloc] init];
        self.bgView.layer.masksToBounds = YES;
        self.bgView.layer.cornerRadius = 10;
        self.bgView.userInteractionEnabled = YES;
        self.bgView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        [self.contentView addSubview:self.bgView];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.titleLabel.textColor = [UIColor blackColor];
        [self.bgView addSubview:self.titleLabel];
        
        self.photo = [[UIImageView alloc] init];
        [self.bgView addSubview:self.photo];
        
        self.readBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.readBtn.layer.masksToBounds = YES;
        self.readBtn.frame = CGRectMake(screenW - 45, 8, 30, 30);
        self.readBtn.layer.cornerRadius = 3;
        self.readBtn.layer.borderWidth = 1;
        self.readBtn.layer.borderColor = [UIColor grayColor].CGColor;
        UIImage *btnIcon = [UIImage imageNamed:@"rectangle.unread"];
        [self.readBtn setImage:btnIcon forState:UIControlStateNormal];

        self.readBtn.layer.cornerRadius = 5;
        [self.contentView addSubview:self.readBtn];
        
        self.line = [[UILabel alloc] init];
        self.line.backgroundColor = [MMSystemHelper string2UIColor:@"#ECECED"];
        [self.contentView addSubview:self.line];
    }
    return self;
}
- (void)setTrackCommentFrame:(UserTrackCommentFrame *)trackCommentFrame {
    _trackCommentFrame = trackCommentFrame;
    [self settingFrame];
}
-(void)settingFrame
{
    self.icon.frame = self.trackCommentFrame.userIconF;
    self.nameLabel.frame = self.trackCommentFrame.userNameF;
    self.contentLabel.frame = self.trackCommentFrame.userCommentF;
    self.photo.frame = self.trackCommentFrame.photoF;
    self.timeLabel.frame = self.trackCommentFrame.timeF;
    self.replyButton.frame = self.trackCommentFrame.replyBtnF;
    self.bgView.frame = self.trackCommentFrame.articleBgF;
    self.titleLabel.frame = self.trackCommentFrame.articleF;
    self.photo.frame = self.trackCommentFrame.photoF;
    for (int i = 0; i < [self.trackCommentFrame.replyCommentF count]; i++) {
        ((UILabel *)[self.replysView objectAtIndex:i]).frame = [(NSValue *)[self.trackCommentFrame.replyCommentF objectAtIndex:i] CGRectValue];
    }
    for (int i = 0; i < [self.trackCommentFrame.replyIconF count]; i++) {
        ((UIImageView *)[self.replyIconView objectAtIndex:i]).frame = [(NSValue *)[self.trackCommentFrame.replyIconF objectAtIndex:i] CGRectValue];
    }
    for (int i = 0; i < [self.trackCommentFrame.replyNameF count]; i++) {
        ((UILabel *)[self.replyNameView objectAtIndex:i]).frame = [(NSValue *)[self.trackCommentFrame.replyNameF objectAtIndex:i] CGRectValue];
    }
    self.line.frame = self.trackCommentFrame.lineF;
}
-(void) setShowData: (id) comment {

    [self removeOldReplys];
    if ([comment isKindOfClass:[UserTrackComment class]]) {
        
        UserTrackComment *data = comment;
        self.icon.contentMode = UIViewContentModeScaleAspectFill;
        self.icon.clipsToBounds = YES;
        [self.icon sd_setImageWithURL:[NSURL URLWithString:data.avator] placeholderImage:[UIImage imageNamed:@"Bitmap"] options:SDWebImageRefreshCached];
        self.nameLabel.text = data.name;
        self.contentLabel.text = data.comment;
        NSString* time = [MMSystemHelper compareCurrentTime:[NSString stringWithFormat:@"%lld", data.pts]];
        self.timeLabel.text = time;
        self.titleLabel.text = data.article.context;
        
        ITSApplication* itsApp = [ITSApplication get];
        NSString* fileBaseUrl = [itsApp.remoteSvr getBaseFileUrl];

        //NSString* image = [data.article.attachments objectAtIndex:0];
        CelebAttachment* cbAtt = [data.article.attachments objectAtIndex:0];
        NSString* image = cbAtt.fd;
        
        NSString* imageUrl = [[NSString alloc] initWithFormat:@"%@/%@", fileBaseUrl, image];
        self.photo.contentMode = UIViewContentModeScaleAspectFill;
        self.photo.layer.masksToBounds = YES;
        [self.photo sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"loader_post"] options:SDWebImageRefreshCached];
        
        if (data.isCelebRead == YES) {
            self.readBtn.frame = CGRectMake(screenW - 75, 13, 60, 30);
            self.readBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            self.readBtn.backgroundColor = [MMSystemHelper string2UIColor:HOME_VIPNAME_COLOR];
            [self.readBtn setTitle:@"Read" forState:UIControlStateNormal];
            self.readBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
            self.readBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            UIImage *btnIcon = [UIImage imageNamed:@"Rectangle.read"];
            [self.readBtn setImage:btnIcon forState:UIControlStateNormal];

        }else {
            self.readBtn.frame = CGRectMake(screenW - 45, 13, 30, 30);
            UIImage *btnIcon = [UIImage imageNamed:@"rectangle.unread"];
            [self.readBtn setImage:btnIcon forState:UIControlStateNormal];
        }
        for (NSInteger i = 0; i < data.replayComments.count; i++) {
            
            FansComment *item = [data.replayComments objectAtIndex:i];
            UILabel *replyLabel = [[UILabel alloc]init];
            replyLabel.font = [UIFont systemFontOfSize:16];
            replyLabel.numberOfLines = 0;
            replyLabel.text = item.comment;
            replyLabel.textColor = [MMSystemHelper string2UIColor:HOME_COMMENT_COLOR];
            self.replyContent = replyLabel;
            [self.contentView addSubview:replyLabel];
            [self.replysView addObject:replyLabel];

            UIImageView *replyIcon = [[UIImageView alloc] init];
            replyIcon.backgroundColor = [UIColor redColor];
            replyIcon.layer.cornerRadius = 15;
            replyIcon.contentMode = UIViewContentModeScaleAspectFill;
            replyIcon.layer.masksToBounds = YES;
            [replyIcon sd_setImageWithURL:[NSURL URLWithString:item.avator] placeholderImage:[UIImage imageNamed:@"loader_post"] options:SDWebImageRefreshCached];
            [self.contentView addSubview:replyIcon];
            self.replyIcon = replyIcon;
            [self.replyIconView addObject:replyIcon];
            
            UILabel *replyName = [[UILabel alloc] init];
            replyName.text = item.name;
            replyName.textColor = [UIColor blackColor];
            replyName.font = [UIFont systemFontOfSize:14];
            
            self.replyName = replyName;
            [self.contentView addSubview:replyName];
            [self.replyNameView addObject:replyName];
        }
    }
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

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
