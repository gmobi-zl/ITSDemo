
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
NSInteger scrollTag;
@implementation CommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;   //cell选中时的颜色，无色
        
        self.delButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.delButton setImage:[UIImage imageNamed:@"icon_Trash"] forState:UIControlStateNormal];
        self.delButton.backgroundColor = [MMSystemHelper string2UIColor:HOME_VIPNAME_COLOR];
        [self.contentView addSubview:self.delButton];

        self.bgView = [[UIScrollView alloc] init];
        self.bgView.backgroundColor = [UIColor whiteColor];
        self.bgView.bounces = YES;
        self.bgView.delegate = self;
        self.bgView.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:self.bgView];
        
        self.icon = [[UIImageView alloc] init];
        self.icon.backgroundColor = [UIColor whiteColor];
        self.icon.layer.masksToBounds = YES;
        self.icon.layer.cornerRadius = 20;
        [self.bgView addSubview:self.icon];
        
        self.iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.iconBtn.backgroundColor = [UIColor clearColor];
        [self.icon addSubview:self.iconBtn];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = [UIFont fontWithName:@"PingFangTC-Semibold" size:14];
        [self.bgView addSubview:self.nameLabel];
        
        self.commentLabel = [[UILabel alloc] init];
        self.commentLabel.textColor = [MMSystemHelper string2UIColor:HOME_COMMENT_COLOR];
        self.commentLabel.font = [UIFont systemFontOfSize:14];
        self.commentLabel.backgroundColor = [UIColor clearColor];
        [self.bgView addSubview:self.commentLabel];
        
        self.delImage = [[UIView alloc] init];
//        [self.delImage setImage:[UIImage imageNamed:@"icon_Trash"] forState:UIControlStateNormal];
        self.delImage.backgroundColor = [MMSystemHelper string2UIColor:HOME_VIPNAME_COLOR];
        [self.contentView addSubview:self.delImage];
        
        self.scrollView = [[UIScrollView alloc] init];
        [self.contentView addSubview:self.scrollView];
        
        self.replyLabel = [[UILabel alloc] init];
        self.replyLabel.numberOfLines = 0;
        self.replyLabel.font = [UIFont systemFontOfSize:16];
        [self.scrollView addSubview:self.replyLabel];
        
        self.replyIcon = [[UIImageView alloc] init];
        self.replyIcon.layer.masksToBounds = YES;
        self.replyIcon.layer.cornerRadius = 15;
        [self.scrollView addSubview:self.replyIcon];
        
        self.replyBackgroundView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.replyBackgroundView];
        
        self.line = [[UILabel alloc] init];
        self.line.backgroundColor = [MMSystemHelper string2UIColor:@"#ECECED"];
        [self.contentView addSubview:self.line];
        
        self.bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.commentLabel addSubview:self.bgButton];
        
        self.replyNameLabel = [[UILabel alloc] init];
        [self.scrollView addSubview:self.replyNameLabel];
        
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        self.timeLabel.font = [UIFont systemFontOfSize:14];
        self.timeLabel.textColor = [MMSystemHelper string2UIColor:HOME_MORE_COMMENT_COLOR];
        [self.bgView addSubview:self.timeLabel];
        
        self.replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.replyButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.replyButton setTitle:NSLocalizedString (@"comment_reply", nil) forState:UIControlStateNormal];
        self.replyButton.userInteractionEnabled = YES;
        [self.replyButton setTitleColor:[MMSystemHelper string2UIColor:HOME_MORE_COMMENT_COLOR] forState:UIControlStateNormal];
        [self.bgView addSubview:self.replyButton];
    }
    return self;
}
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
//    [UIView animateWithDuration:0.3 animations:^{
//        self.bgView.frame =  CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,  self.detailCommentFrame.BgViewF.size.height);
//    }];
//}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    NSInteger tag =  scrollView.tag;
    NSInteger index = scrollView.contentOffset.x;

    if (index < 25) {
        index = 0;
    }else {
        index = 63;
    }
    if (scrollView == self.bgView) {
        [UIView animateWithDuration:0.3 animations:^{
            self.bgView.frame = CGRectMake(-index, self.detailCommentFrame.BgViewF.origin.y, [UIScreen mainScreen].bounds.size.width, self.detailCommentFrame.BgViewF.size.height);
            if (index == 0) {
                self.bgView.contentOffset = CGPointMake(0, 0);
            }else if (index == 63) {
                self.bgView.contentOffset = CGPointMake(63, 0);
            }
        }];
    }else if(scrollView == self.scrollView){
        CGRect frame = [[self.detailCommentFrame.replyScrollF objectAtIndex:tag] CGRectValue];
        UIScrollView *scrollview = [self.replyScrollView objectAtIndex:tag];
        [UIView animateWithDuration:0.3 animations:^{
            scrollview.frame = CGRectMake(-index + frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
            if (index == 0) {
                scrollView.contentOffset = CGPointMake(0, 0);
            }else if (index == 63) {
                scrollView.contentOffset = CGPointMake(63, 0);
            }
        }];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.otherScroll = scrollView;

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    NSInteger tag = scrollView.tag;
    NSLog(@"@@@@@@@@@@@@%d",tag);
 
    NSInteger index = scrollView.contentOffset.x;
    if (scrollView == self.bgView) {
        self.type = 1;
        if (indexP.row == _myIndexPath.row) {
            if (self.otherScroll == self.bgView) {
                [UIView animateWithDuration:0.3 animations:^{
                    self.bgView.frame = CGRectMake(-index, self.detailCommentFrame.BgViewF.origin.y, [UIScreen mainScreen].bounds.size.width, self.detailCommentFrame.BgViewF.size.height);
                }];
            }else {
                [UIView animateWithDuration:0.3 animations:^{
                    self.otherScroll.frame = self.scrollFrame;
                    self.otherScroll.contentOffset = CGPointMake(0, 0);
                }];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(viewCellInitial:index:frame:)]) {
                [self.delegate viewCellInitial:indexP index:scrollTag frame:self.scrollFrame];
            }
            [UIView animateWithDuration:0.3 animations:^{
                self.bgView.frame = CGRectMake(-index, 0, [UIScreen mainScreen].bounds.size.width, self.detailCommentFrame.BgViewF.size.height);
            }];
        }
        indexP = _myIndexPath;
        self.otherScroll = scrollView;
        self.scrollFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,self.detailCommentFrame.BgViewF.size.height);
    }else {
//        if (self.detailCommentFrame.replyScrollF.count > scrollTag) {
            CGRect frame = [[self.detailCommentFrame.replyScrollF objectAtIndex:tag] CGRectValue];
            self.type = 2;
            UIScrollView *scrollview = [self.replyScrollView objectAtIndex:tag];

            if (indexP.row == _myIndexPath.row) {
                if (self.otherScroll == scrollView) {
                    [UIView animateWithDuration:0.3 animations:^{
                        scrollview.frame = CGRectMake(-index + frame.origin.x, frame.origin.y,frame.size.width, frame.size.height);
                    }];
                }else {
                    [UIView animateWithDuration:0.3 animations:^{
                        self.otherScroll.frame = self.scrollFrame;
                        self.otherScroll.contentOffset = CGPointMake(0, 0);
                    }];
                }
            }else {
                if ([self.delegate respondsToSelector:@selector(viewCellInitial:index:frame:)]) {
                    [self.delegate viewCellInitial:indexP index:scrollTag frame:self.scrollFrame];
                }
                
                [UIView animateWithDuration:0.3 animations:^{
                    scrollview.frame = CGRectMake(-index + frame.origin.x, frame.origin.y,frame.size.width, frame.size.height);
                }];
            }
            self.scrollFrame = frame;
            indexP = _myIndexPath;
//        }
    }
    scrollTag = tag;
}
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
        UIScrollView *scrollView = [self.replyScrollView objectAtIndex:i];
        if (scrollView.superview) {
            [scrollView removeFromSuperview];
        }
    }
    for (int i = 0; i < [self.replyDel count]; i++) {
        UIButton *del = [self.replyDel objectAtIndex:i];
        if (del.superview) {
            [del removeFromSuperview];
        }
    }
    [self.replyDel removeAllObjects];
    [self.replysView removeAllObjects];
    [self.replyIconView removeAllObjects];
    [self.replyNameView removeAllObjects];
    [self.replyScrollView removeAllObjects];
}
-(void)settingFrame
{
    self.icon.frame = self.detailCommentFrame.iconF;
    self.nameLabel.frame = self.detailCommentFrame.nameF;
    self.iconBtn.frame = self.icon.bounds;
    self.bgView.frame = self.detailCommentFrame.BgViewF;
    self.delButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 63, 0, 63, self.detailCommentFrame.BgViewF.size.height);
    self.bgView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width + 63, self.detailCommentFrame.BgViewF.size.height);
    for (int i = 0; i < [self.detailCommentFrame.replyScrollF count]; i++) {
        ((UIScrollView *)[self.replyScrollView objectAtIndex:i]).frame = [(NSValue *)[self.detailCommentFrame.replyScrollF objectAtIndex:i] CGRectValue];
        CGRect rect = [[self.detailCommentFrame.replyScrollF objectAtIndex:i] CGRectValue];
        
        ((UIScrollView *)[self.replyScrollView objectAtIndex:i]).contentSize =             CGSizeMake([UIScreen mainScreen].bounds.size.width, rect.size.height);
        ((UIView *)[self.replyDel objectAtIndex:i]).frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 63, rect.origin.y + 1, 63, rect.size.height - 1);
    }

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
- (NSMutableArray *)replyScrollView {
    if (!_replyScrollView) {
        _replyScrollView = [[NSMutableArray alloc]init];
    }
    return _replyScrollView;
}
-(NSMutableArray *)replyDel {
    if (!_replyDel) {
        _replyDel = [[NSMutableArray alloc] init];
    }
    return _replyDel;
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
            if ([us.user.uId compare:data.uuid] == NSOrderedSame) {
                self.bgView.scrollEnabled = YES;
            }else {
                self.bgView.scrollEnabled = NO;
            }
//        self.bgView.userInteractionEnabled = NO;
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
            
            UIView *delImage = [[UIView alloc] init];
            delImage.backgroundColor = [MMSystemHelper string2UIColor:HOME_VIPNAME_COLOR];
            [self.contentView addSubview:delImage];
            delImage.userInteractionEnabled = YES;
            self.delImage = delImage;
            [self.contentView addSubview:delImage];
            self.delImage.userInteractionEnabled = YES;
            [self.replyDel addObject:delImage];
            
            UIScrollView *scrollView = [[UIScrollView alloc] init];
            scrollView.bounces = YES;
            scrollView.delegate = self;
            scrollView.tag = i;
            scrollView.showsHorizontalScrollIndicator = NO;
            self.scrollView = scrollView;
            self.scrollView.backgroundColor = [UIColor whiteColor];
            [self.contentView addSubview:scrollView];
            [self.replyScrollView addObject:scrollView];

            FansComment *item = [data.replayComments objectAtIndex:i];
            if ([us.user.uId compare:item.uuid] == NSOrderedSame) {
                self.scrollView.scrollEnabled = YES;
            }else {
                self.scrollView.scrollEnabled = NO;
            }
            UILabel *replyLabel = [[UILabel alloc]init];
            replyLabel.font = [UIFont systemFontOfSize:14];
            replyLabel.numberOfLines = 0;
            replyLabel.text = item.comment;
            replyLabel.textColor = [MMSystemHelper string2UIColor:HOME_COMMENT_COLOR];
            self.replyLabel = replyLabel;
            [scrollView addSubview:replyLabel];
            [self.replysView addObject:replyLabel];
            
            UIImageView *replyIcon = [[UIImageView alloc] init];
            replyIcon.layer.cornerRadius = 15;
            replyIcon.contentMode = UIViewContentModeScaleAspectFill;
            replyIcon.layer.masksToBounds = YES;
            [replyIcon sd_setImageWithURL:[NSURL URLWithString:item.avator] placeholderImage:[UIImage imageNamed:@"Bitmap"] options:SDWebImageRefreshCached];
            [scrollView addSubview:replyIcon];
            self.replyIcon = replyIcon;
            [self.replyIconView addObject:replyIcon];
            
            UILabel *replyName = [[UILabel alloc] init];
            replyName.text = item.name;
            replyName.textColor = [UIColor blackColor];
            replyName.font = [UIFont fontWithName:@"PingFangTC-Semibold" size:14];
            
            self.replyNameLabel = replyName;
            [scrollView addSubview:replyName];
            [self.replyNameView addObject:replyName];
        }
    }
}

@end
