
//
//  DetailCommentCell.m
//  InternetStir
//
//  Created by Apple on 16/8/15.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import "CommentCell.h"
#import "MMSystemHelper.h"
#import "UIImageView+WebCache.h"
#import "AppStyleConfiguration.h"
#import "ITSApplication.h"
NSIndexPath *indexP;

@implementation CommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;   //cell选中时的颜色，无色
//        self.delButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.delButton setImage:[UIImage imageNamed:@"icon_Trash"] forState:UIControlStateNormal];
//        self.delButton.backgroundColor = [UIColor redColor];
//        [self.contentView addSubview:self.delButton];
        
//        self.bgView = [[UIScrollView alloc] init];
//        self.bgView.backgroundColor = [UIColor whiteColor];
//          = self;
//        self.bgView.bounces = YES;
//        self.bgView.showsHorizontalScrollIndicator = NO;
//        [self.contentView addSubview:self.bgView];
        
        self.icon = [[UIImageView alloc] init];
        self.icon.backgroundColor = [UIColor whiteColor];
        self.icon.layer.masksToBounds = YES;
        self.icon.layer.cornerRadius = 20;
        [self.contentView addSubview:self.icon];
        
        self.iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.iconBtn.backgroundColor = [UIColor clearColor];
        [self.icon addSubview:self.iconBtn];
        
        self.nameLabel = [[UILabel alloc] init];
//        self.nameLabel.font = [UIFont systemFontOfSize:16];
        self.nameLabel.font = [UIFont fontWithName:@"PingFangTC-Semibold" size:14];
        [self.contentView addSubview:self.nameLabel];
        
        self.commentLabel = [[UILabel alloc] init];
//        self.commentLabel.numberOfLines = 0;
//        self.commentLabel.userInteractionEnabled = YES;
        self.commentLabel.textColor = [MMSystemHelper string2UIColor:HOME_COMMENT_COLOR];
        self.commentLabel.font = [UIFont systemFontOfSize:14];
//        self.commentLabel.lineSpace = 0.5;
//        self.commentLabel.type = 2;
//        self.commentLabel.backgroundColor = [UIColor redColor];
        self.commentLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.commentLabel];
        
        self.replyLabel = [[UILabel alloc] init];
        self.replyLabel.numberOfLines = 0;
        self.replyLabel.font = [UIFont systemFontOfSize:16];
        [self.replyBackgroundView addSubview:self.replyLabel];
        
        self.replyIcon = [[UIImageView alloc] init];
        self.replyIcon.layer.masksToBounds = YES;
        self.replyIcon.layer.cornerRadius = 15;
        [self.contentView addSubview:self.replyIcon];
        
        self.replyBackgroundView = [[UIImageView alloc] init];
//        self.replyBackgroundView.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:self.replyBackgroundView];
        
        self.line = [[UILabel alloc] init];
        self.line.backgroundColor = [MMSystemHelper string2UIColor:@"#ECECED"];
        [self.contentView addSubview:self.line];
        
        self.bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.commentLabel addSubview:self.bgButton];
        
        self.replyNameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.replyNameLabel];
        
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
        
    }
    return self;
}
- (void)tapClick:(UITapGestureRecognizer*)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.frame =  CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.detailCommentFrame.BgViewF.size.height);
    }];
}
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    NSInteger index = scrollView.contentOffset.x;
//
//    if (index < 32 ) {
//        index = 0;
//    }else {
//        index = 64;
//    }
//    [UIView animateWithDuration:0.3 animations:^{
//        self.bgView.frame =  CGRectMake(-index, 0, [UIScreen mainScreen].bounds.size.width, self.detailCommentFrame.BgViewF.size.height);
//    }];
//
//    if (indexP == nil) {
//        indexP = self.myIndexPath;
//    } else {
//        if ([self.delegate respondsToSelector:@selector(viewCellInitial:scr:)]) {
//            [self.delegate viewCellInitial:indexP scr:nil];
//        }
//        indexP = self.myIndexPath;
//    }
//
//}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//
//    NSInteger index = scrollView.contentOffset.x;
//    
//    [UIView animateWithDuration:0.3 animations:^{
//        self.bgView.frame =  CGRectMake(-index, 0, [UIScreen mainScreen].bounds.size.width, self.detailCommentFrame.BgViewF.size.height);
//        self.bgView.contentOffset = CGPointMake(0, 0);
//    }];
//}

-(void)setDetailCommentFrame:(CommentFrame *)detailCommentFrame{
    
    _detailCommentFrame = detailCommentFrame;
#ifdef DEMO_DATA
    [self removeOldReplys];
    [self settingtData];
#endif
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
    for (int i = 0; i < [self.replyScrollView count]; i++) {
        UIScrollView *scrlooView = [self.replyScrollView objectAtIndex:i];
        if (scrlooView.superview) {
            [scrlooView removeFromSuperview];
        }
    }

    [self.replysView removeAllObjects];
    [self.replyIconView removeAllObjects];
    [self.replyNameView removeAllObjects];
    [self.replyScrollView removeAllObjects];
}
-(void)settingtData
{
#ifdef DEMO_DATA
    CommentItem *comment = self.detailCommentFrame.detailCommentItem;
//    self.icon.image = [UIImage imageNamed:comment.icon];
    [self.icon sd_setImageWithURL:[NSURL URLWithString:comment.icon] placeholderImage:[UIImage imageNamed:comment.icon] options:SDWebImageRefreshCached];
    self.nameLabel.text = comment.name;
    self.commentLabel.text = comment.comment;
    self.timeLabel.text = @"3小時前";
    for (NSInteger i = 0; i < comment.replys.count; i++) {
        
        ReplyItem *item = [comment.replys objectAtIndex:i];
        UILabel *replyLabel = [[UILabel alloc]init];
        replyLabel.font = [UIFont systemFontOfSize:16];
        replyLabel.numberOfLines = 0;        
        if (item.type == 1) {
            replyLabel.text = item.comment;
            replyLabel.textColor = [MMSystemHelper string2UIColor:HOME_COMMENT_COLOR];
        }else{
            NSString *searchText = [NSString stringWithFormat:@"%@回复%@：%@",item.name,item.name,item.comment];
            NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:searchText];
            NSRange Range = NSMakeRange(0, [[noteStr string] rangeOfString:@"："].location);
            [noteStr addAttribute:NSForegroundColorAttributeName value:[MMSystemHelper string2UIColor:@"#0079b1"] range:Range];
            
            NSRange replyRange = NSMakeRange([[noteStr string] rangeOfString:@"回复"].location, [[noteStr string] rangeOfString:@"回复"].length);
            [noteStr addAttribute:NSForegroundColorAttributeName value:[MMSystemHelper string2UIColor:HOME_MORE_COMMENT_COLOR] range:replyRange];
            [replyLabel setAttributedText:noteStr] ;
            [replyLabel sizeToFit];
        }
        self.replyLabel = replyLabel;
        [self.contentView addSubview:replyLabel];
        [self.replysView addObject:replyLabel];
        
        UIImageView *replyIcon = [[UIImageView alloc] init];
//        replyIcon.backgroundColor = [UIColor redColor];
        replyIcon.layer.cornerRadius = 15;
        replyIcon.layer.masksToBounds = YES;
        [replyIcon sd_setImageWithURL:[NSURL URLWithString:item.icon] placeholderImage:[UIImage imageNamed:@"head"] options:SDWebImageRefreshCached];
        [self.contentView addSubview:replyIcon];
        self.replyIcon = replyIcon;
        [self.replyIconView addObject:replyIcon];
        
        UILabel *replyName = [[UILabel alloc] init];
        replyName.text = item.name;
        replyName.textColor = [UIColor blackColor];
        replyName.font = [UIFont systemFontOfSize:14];
        
        self.replyNameLabel = replyName;
        [self.contentView addSubview:replyName];
        [self.replyNameView addObject:replyName];
    }
#endif
}
-(void)settingFrame
{
    self.icon.frame = self.detailCommentFrame.iconF;
    self.nameLabel.frame = self.detailCommentFrame.nameF;
    self.iconBtn.frame = self.icon.bounds;
    self.bgView.frame = self.detailCommentFrame.BgViewF;
    self.delButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 64, 0, 64, self.detailCommentFrame.BgViewF.size.height);
    self.bgView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width + 64, self.detailCommentFrame.BgViewF.size.height);
    for (int i = 0; i < [self.detailCommentFrame.replysF count]; i++) {
        ((UILabel *)[self.replysView objectAtIndex:i]).frame = [(NSValue *)[self.detailCommentFrame.replysF objectAtIndex:i] CGRectValue];
    }
    for (int i = 0; i < [self.detailCommentFrame.replyPictureF count]; i++) {
        ((UIImageView *)[self.replyIconView objectAtIndex:i]).frame = [(NSValue *)[self.detailCommentFrame.replyPictureF objectAtIndex:i] CGRectValue];
    }
    for (int i = 0; i < [self.detailCommentFrame.replyNameF count]; i++) {
        ((UILabel *)[self.replyNameView objectAtIndex:i]).frame = [(NSValue *)[self.detailCommentFrame.replyNameF objectAtIndex:i] CGRectValue];
    }
    self.commentLabel.frame = self.detailCommentFrame.contentF;
    self.replyBackgroundView.frame = self.detailCommentFrame.replyBackgroundF;
    self.line.frame = self.detailCommentFrame.lineF;
    self.timeLabel.frame = self.detailCommentFrame.timeF;
    self.replyButton.frame = self.detailCommentFrame.replyBtnF;
    
    self.bgButton.frame = self.commentLabel.bounds;
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

-(void) setShowData: (id) comment{
    [self removeOldReplys];
    ITSApplication* itsApp = [ITSApplication get];
    CBUserService* us = itsApp.cbUserSvr;
//    if ([comment isKindOfClass:[CelebComment class]]) {
//        CelebComment *data = comment;
//        self.icon.frame = CGRectMake(15, 13, 40, 40);
//        self.icon.contentMode = UIViewContentModeScaleAspectFill;
//        self.icon.layer.masksToBounds = YES;
//        [self.icon sd_setImageWithURL:[NSURL URLWithString:data.avator] placeholderImage:[UIImage imageNamed:@"Bitmap"] options:SDWebImageRefreshCached];
//        [self.contentView addSubview:self.icon];
//        self.nameLabel.text = data.name;
//        CGFloat nameLabelX = CGRectGetMaxX(self.icon.frame) + 8;
//        CGSize nameLabelSize = [MMSystemHelper sizeWithString:data.name font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT,20)];
//        CGFloat nameLabelY = 13;
//        CGFloat nameLabelWidth = nameLabelSize.width + 20;
//        CGFloat nameLabelHeight = nameLabelSize.height;
//        self.nameLabel.frame = CGRectMake(nameLabelX, nameLabelY, nameLabelWidth, 20);
//        self.nameLabel.textColor = [MMSystemHelper string2UIColor:HOME_VIPNAME_COLOR];
//        [self.contentView addSubview:self.nameLabel];
//        CGFloat contentLabelX = nameLabelX;
//        CGFloat contentLabelY = nameLabelY + nameLabelHeight + 4;
//        CGSize contentLabelSize = [MMSystemHelper sizeWithString:data.context font:[UIFont systemFontOfSize:16 ] maxSize:CGSizeMake([MMSystemHelper getScreenWidth] - nameLabelX - HOME_CONTENT_LEFT_PADDING, MAXFLOAT)];
////        CGRect rect = [TQRichTextView boundingRectWithSize:CGSizeMake([MMSystemHelper getScreenWidth] - nameLabelX - HOME_CONTENT_LEFT_PADDING, MAXFLOAT) font:[UIFont systemFontOfSize:16] string:data.context lineSpace:0.5 type:2];
//
//        CGFloat contentLabelWidth = contentLabelSize.width;
//        CGFloat contentLabelHeight = contentLabelSize.height;
//        self.commentLabel.frame = CGRectMake(contentLabelX, contentLabelY, contentLabelWidth, contentLabelHeight);
//        self.commentLabel.text = data.context;
//        [self.contentView addSubview:self.commentLabel];
//        NSString* time = [MMSystemHelper compareCurrentTime:[NSString stringWithFormat:@"%lld", data.pts]];
//        CGSize timeLabelSize = [MMSystemHelper sizeWithString:time font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, 20)];
//        self.timeLabel.frame = CGRectMake(nameLabelX, self.commentLabel.frame.origin.y + self.commentLabel.frame.size.height + 4, timeLabelSize.width, 20);
//        self.timeLabel.text = time;
//        [self.contentView addSubview:self.timeLabel];
//        self.replyButton.frame = CGRectMake(nameLabelX + timeLabelSize.width + 10, self.timeLabel.frame.origin.y, 40, 20);
//        self.replyButton.userInteractionEnabled = YES;
//        self.line.frame = CGRectMake(nameLabelX, self.timeLabel.frame.size.height + self.timeLabel.frame.origin.y + 10 - 0.5, [MMSystemHelper getScreenWidth] - nameLabelX - 10, 0.5);
//        [self.contentView addSubview:self.replyButton];
//        self.iconBtn.frame = self.icon.bounds;
//    }else
    if ([comment isKindOfClass:[FansComment class]]) {
        FansComment *data = comment;
        //        if ([us.user.uId compare:data.uuid] == NSOrderedSame) {
        //            self.bgView.scrollEnabled = YES;
        //        }else {
        //            self.bgView.scrollEnabled = NO;
        //        }
        self.bgView.userInteractionEnabled = NO;
        self.icon.contentMode = UIViewContentModeScaleAspectFill;
        self.icon.layer.masksToBounds = YES;
        [self.icon sd_setImageWithURL:[NSURL URLWithString:data.avator] placeholderImage:[UIImage imageNamed:@"Bitmap"] options:SDWebImageRefreshCached];
        self.nameLabel.text = data.name;
        self.commentLabel.text = data.comment;
        self.commentLabel.numberOfLines = 0;
        NSString* time = [MMSystemHelper compareCurrentTime:[NSString stringWithFormat:@"%lld", data.pts]];
        self.timeLabel.text = time;
        self.nameLabel.textColor = [UIColor blackColor];
        for (NSInteger i = 0; i < data.replayComments.count; i++) {
            
            FansComment *item = [data.replayComments objectAtIndex:i];
            UILabel *replyLabel = [[UILabel alloc]init];
            replyLabel.font = [UIFont systemFontOfSize:14];
            replyLabel.numberOfLines = 0;
            replyLabel.text = item.comment;
            replyLabel.textColor = [MMSystemHelper string2UIColor:HOME_COMMENT_COLOR];
            self.replyLabel = replyLabel;
            //            self.replyLabel.backgroundColor = [UIColor redColor];
            [self.contentView addSubview:replyLabel];
            [self.replysView addObject:replyLabel];
            
            UIImageView *replyIcon = [[UIImageView alloc] init];
//            replyIcon.backgroundColor = [UIColor redColor];
            replyIcon.layer.cornerRadius = 15;
            replyIcon.contentMode = UIViewContentModeScaleAspectFill;
            replyIcon.layer.masksToBounds = YES;
            [replyIcon sd_setImageWithURL:[NSURL URLWithString:item.avator] placeholderImage:[UIImage imageNamed:@"Bitmap"] options:SDWebImageRefreshCached];
            [self.contentView addSubview:replyIcon];
            self.replyIcon = replyIcon;
            [self.replyIconView addObject:replyIcon];
            
            UILabel *replyName = [[UILabel alloc] init];
            replyName.text = item.name;
            replyName.textColor = [UIColor blackColor];
            //            replyName.backgroundColor = [UIColor redColor];
            replyName.font = [UIFont fontWithName:@"PingFangTC-Semibold" size:14];
            
            self.replyNameLabel = replyName;
            [self.contentView addSubview:replyName];
            [self.replyNameView addObject:replyName];
        }
    }
}

@end
