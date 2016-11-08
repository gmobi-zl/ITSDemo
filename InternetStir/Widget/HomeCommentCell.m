//
//  CommentCell.m
//  InternetStir
//
//  Created by Apple on 16/8/12.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import "HomeCommentCell.h"
#import "MMSystemHelper.h"
#import "ITSAppConst.h"
#import "AppStyleConfiguration.h"
#import "ITSApplication.h"
#import "FansComment.h"
#import "UIImageView+WebCache.h"

#define screenW [MMSystemHelper getScreenWidth]

@implementation HomeCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;   //cell选中时的颜色，无色

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
        self.icon.layer.cornerRadius = 18;
        [self.contentView addSubview:self.icon];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.textColor = [MMSystemHelper string2UIColor:HOME_VIPNAME_COLOR];
        self.nameLabel.font = [UIFont systemFontOfSize:HOME_USER_NAME_FONT_SIZE];
        [self.contentView addSubview:self.nameLabel];
        
        self.photo = [[UIImageView alloc] init];
        [self.contentView addSubview:self.photo];
        
        self.commentLabel = [[TQRichTextView alloc] init];
        self.commentLabel.font = [UIFont systemFontOfSize:HOME_VIPNAME_FONT_SIZE];
        self.commentLabel.lineSpace = 0.5;
        self.commentLabel.type = 1;
//        self.commentLabel.delegage = self;
        self.commentLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.commentLabel];
        
        self.replyLabel = [[UILabel alloc] init];
        self.replyLabel.font = [UIFont systemFontOfSize:HOME_VIPNAME_FONT_SIZE];
        self.replyLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.replyLabel];
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.button setTitle:NSLocalizedString(@"comment_leave_more", nil) forState:UIControlStateNormal];
//        [self.button setTitle:@"查看更多留言" forState:UIControlStateNormal];
        [self.button setTitleColor:[MMSystemHelper string2UIColor:HOME_MORE_COMMENT_COLOR] forState:UIControlStateNormal];
        [self.contentView addSubview:self.button];
        
//        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.btn.titleLabel.font = [UIFont systemFontOfSize:16];
//        [self.btn setTitle:@"繼續閱讀" forState:UIControlStateNormal];
//        [self.btn setTitleColor:[MMSystemHelper string2UIColor:HOME_MORE_COMMENT_COLOR] forState:UIControlStateNormal];
//        [self.contentView addSubview:self.btn];
        
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.textColor = [MMSystemHelper string2UIColor:HOME_TIME_COLOR];
        self.timeLabel.font = [UIFont systemFontOfSize:14];
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.timeLabel];
        
        self.favBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.favBtn setBackgroundImage:[UIImage imageNamed:@"icon_like"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.favBtn];
        
        self.commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.commentBtn setBackgroundImage:[UIImage imageNamed:@"icon_comment"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.commentBtn];
        
        self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.shareBtn setBackgroundImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.shareBtn];
        
        self.line = [[UILabel alloc] init];
        self.line.backgroundColor = [MMSystemHelper string2UIColor:@"#ECECED"];
        [self.contentView addSubview:self.line];
        
        self.like = [[UIImageView alloc] init];
        self.like.image = [UIImage imageNamed:@"like_slected"];
        [self.contentView addSubview:self.like];
        
        self.likeNum = [[UILabel alloc] init];
        self.likeNum.textAlignment = NSTextAlignmentLeft;
        self.likeNum.textColor = [MMSystemHelper string2UIColor:HOME_VIPNAME_COLOR];
        [self.contentView addSubview:self.likeNum];
        
        self.delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.delBtn setBackgroundImage:[UIImage imageNamed:@"icon_ios_addition"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.delBtn];

//        ITSApplication* itsApp = [ITSApplication get];
//        CBUserService* us = itsApp.cbUserSvr;
//        if (us.user.isCBADM == YES) {
//        }
    }
    return self;
}
-(void)setCommentFrame:(HomeCommentFrame *)commentFrame{

    _commentFrame = commentFrame;
 
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
//    for (int i = 0; i < [self.replyIconView count]; i++) {
//        UIImageView *imageView = [self.replyIconView objectAtIndex:i];
//        if (imageView.superview) {
//            [imageView removeFromSuperview];
//        }
//    }
    for (int i = 0; i < [self.replyNameView count]; i++) {
        UILabel *label = [self.replyNameView objectAtIndex:i];
        if (label.superview) {
            [label removeFromSuperview];
        }
    }
    [self.replysView removeAllObjects];
    [self.replyNameView removeAllObjects];
//    [self.replyIconView removeAllObjects];
}
-(void)settingtData
{
    HomeCommentItem *comment = self.commentFrame.commentItem;
    self.icon.image = [UIImage imageNamed:comment.icon];
//    [self.icon sd_setImageWithURL:[NSURL URLWithString:comment.icon] placeholderImage:[UIImage imageNamed:@"loading"] options:SDWebImageRefreshCached];
    self.nameLabel.text = comment.name;
    self.photo.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",comment.pictures]];
    
    [self.photo sd_setImageWithURL:[NSURL URLWithString:comment.pictures] placeholderImage:[UIImage imageNamed:@"loading"] options:SDWebImageRefreshCached];
    
    NSString *str = [NSString stringWithFormat:@"%@   %@",comment.name,comment.shuoshuoText];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = 0.5;
    NSDictionary *attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:16], NSParagraphStyleAttributeName:paragraphStyle};
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:str attributes:attributes];
    NSRange Range = NSMakeRange(0, [[noteStr string] rangeOfString:@"   "].location);
    [noteStr addAttribute:NSForegroundColorAttributeName value:[MMSystemHelper string2UIColor:HOME_VIPNAME_COLOR] range:Range];
    [noteStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangTC-Semibold" size:16] range:Range];
    
    NSRange replyRange = NSMakeRange([[noteStr string] rangeOfString:@"   "].location, [[noteStr string] rangeOfString:str].length - [[noteStr string] rangeOfString:@"   "].location);
    [noteStr addAttribute:NSForegroundColorAttributeName value:[MMSystemHelper string2UIColor:HOME_COMMENT_COLOR] range:replyRange];
    [self.commentLabel setAttributedText:noteStr];

    
    
//    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:str];
//    NSRange Range = NSMakeRange(0, [[noteStr string] rangeOfString:@"   "].location);
//    [noteStr addAttribute:NSForegroundColorAttributeName value:[MMSystemHelper string2UIColor:HOME_VIPNAME_COLOR] range:Range];
//    [noteStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangTC-Semibold" size:16] range:Range];
//
//    NSRange replyRange = NSMakeRange([[noteStr string] rangeOfString:@"   "].location, [[noteStr string] rangeOfString:str].length - [[noteStr string] rangeOfString:@" "].location);
//    [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:replyRange];
//    [noteStr addAttribute:NSForegroundColorAttributeName value:[MMSystemHelper string2UIColor:HOME_COMMENT_COLOR] range:replyRange];
//    [self.commentLabel setAttributedText:noteStr];
//    [self.commentLabel sizeToFit];

//    self.name.text = comment.name;
    for (NSInteger i = 0; i < comment.replys.count; i++) {
        ReplyItem *item = [comment.replys objectAtIndex:i];
        UILabel *replyLabel = [[UILabel alloc]init];
        replyLabel.font = [UIFont systemFontOfSize:16];
        replyLabel.numberOfLines = 0;
        NSString *str = [NSString stringWithFormat:@"%@   %@",item.name,item.comment];
        
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:str];
        NSRange Range = NSMakeRange(0, [[noteStr string] rangeOfString:@"   "].location);
        [noteStr addAttribute:NSForegroundColorAttributeName value:[MMSystemHelper string2UIColor:HOME_VIPNAME_COLOR] range:Range];
        [noteStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangTC-Semibold" size:16] range:Range];
        
        NSRange replyRange = NSMakeRange([[noteStr string] rangeOfString:@"   "].location, [[noteStr string] rangeOfString:str].length - [[noteStr string] rangeOfString:@"   "].location);
        [noteStr addAttribute:NSForegroundColorAttributeName value:[MMSystemHelper string2UIColor:HOME_COMMENT_COLOR] range:replyRange];
        [replyLabel setAttributedText:noteStr];
        [replyLabel sizeToFit];
        
        self.replyLabel = replyLabel;
        [self.contentView addSubview:replyLabel];
        [self.replysView addObject:replyLabel];

//        UIImageView *imageView = [[UIImageView alloc] init];
//        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",item.icon]];
////        self.replyIcon = imageView;
//        imageView.layer.cornerRadius = 15;
//        imageView.layer.masksToBounds = YES;
//        [self.contentView addSubview:imageView];
////        [self.replyIconView addObject:imageView];
        
//        UILabel *replyName = [[UILabel alloc] init];
//        replyName.font = [UIFont systemFontOfSize:12];
//        replyName.text = item.name;
//        replyName.textColor = [MMSystemHelper string2UIColor:HOME_VIPNAME_COLOR];
//        self.replyName = replyName;
//        [self.contentView addSubview:replyName];
//        [self.replyNameView addObject:replyName];
    }
    self.timeLabel.text = comment.time;
    int fav = 99999;
    self.likeNum.text = [NSString stringWithFormat:@"%d",fav];
}

-(void) setShowData: (CelebComment*) data{
    [self removeOldReplys];
    
    ITSApplication* itsApp = [ITSApplication get];
    CBUserService* us = itsApp.cbUserSvr;
    if (us.user.isCBADM == YES && us.user.isLogin == YES) {
        self.delBtn.hidden = NO;
    }else {
        self.delBtn.hidden = YES;
    }

    self.nameLabel.text = data.name;
    self.nameLabel.font = [UIFont fontWithName:@"PingFangTC-Semibold" size:16];
    self.icon.contentMode = UIViewContentModeScaleAspectFill;
    self.icon.layer.masksToBounds = YES;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:data.avator] placeholderImage:[UIImage imageNamed:@"Bitmap"] options:SDWebImageRefreshCached];
    
//    ITSApplication* itsApp = [ITSApplication get];
    NSString* fileBaseUrl = [itsApp.remoteSvr getBaseFileUrl];
    //NSString* image = [data.attachments objectAtIndex:0];
    CelebAttachment* cbAtt = [data.attachments objectAtIndex:0];
    NSString* image = cbAtt.fd;
    
    NSString* imageUrl = [[NSString alloc] initWithFormat:@"%@/%@", fileBaseUrl, image];
    self.photo.contentMode = UIViewContentModeScaleAspectFill;
    self.photo.clipsToBounds = YES;
    [self.photo sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"loader_post"] options:SDWebImageRefreshCached];
    
    NSString *str = [NSString stringWithFormat:@"%@   %@",data.name,data.context];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//    paragraphStyle.lineSpacing = 0.5;
//    NSDictionary *attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:16], NSParagraphStyleAttributeName:paragraphStyle};
//    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:str attributes:attributes];;
//
//    NSRange Range = NSMakeRange(0, [[noteStr string] rangeOfString:@"   "].location);
//    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:Range];
//    [noteStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangTC-Semibold" size:16] range:Range];
    
//    NSRange urlRange = [MMSystemHelper getRangeOfEmailAddress:str];
//    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:urlRange];
//    self.commentLabel.attributedText = noteStr;
    self.commentLabel.text = str;
//    self.commentLabel.backgroundColor = [UIColor redColor];
    NSInteger maxHotCommentCount = data.topFansComments.count;
    NSInteger maxReplyCommentCount = data.replayComments.count;
    
    if (data.replayComments != nil) {
        if (maxReplyCommentCount > CB_MAX_COUNT) {
            maxHotCommentCount = CB_MAX_COUNT;
            self.button.hidden = NO;
        }else {
            self.button.hidden = YES;
            maxHotCommentCount = maxReplyCommentCount;
        }
    }else {
        if (maxHotCommentCount > CB_MAX_COUNT){
            self.button.hidden = NO;
            maxHotCommentCount = CB_MAX_COUNT;
        }else {
            self.button.hidden = YES;
        }
    }
    for (NSInteger i = 0; i < maxHotCommentCount; i++) {
        FansComment *item;
        if (data.replayComments != nil) {
            item = [data.replayComments objectAtIndex:i];
        }else {
            item = [data.topFansComments objectAtIndex:i];
        }
        UILabel *replyLabel = [[UILabel alloc]init];
        replyLabel.font = [UIFont systemFontOfSize:16];
        replyLabel.numberOfLines = 0;
    
        NSString *str = [NSString stringWithFormat:@"%@   %@",item.name,item.comment];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineSpacing = 0.5;
        NSDictionary *attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:16], NSParagraphStyleAttributeName:paragraphStyle};
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:str attributes:attributes];
        NSRange Range = NSMakeRange(0, [[noteStr string] rangeOfString:@"   "].location);
        [noteStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangTC-Semibold" size:16] range:Range];
        
        NSRange replyRange;
        if (item.u_role == CELEB_USER_CELEB) {
            [noteStr addAttribute:NSForegroundColorAttributeName value:[MMSystemHelper string2UIColor:HOME_VIPNAME_COLOR] range:Range];
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            attch.image = [UIImage imageNamed:@"tomato"];
            attch.bounds = CGRectMake(0, -2, 16, 16);
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
            [noteStr insertAttributedString:string atIndex:0];
            replyLabel.attributedText = noteStr;
            replyRange = NSMakeRange([[noteStr string] rangeOfString:@"   "].location, [[noteStr string] rangeOfString:str].length - [[noteStr string] rangeOfString:@"   "].location + 1);
        }else {
            [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:Range];
            replyRange = NSMakeRange([[noteStr string] rangeOfString:@"   "].location, [[noteStr string] rangeOfString:str].length - [[noteStr string] rangeOfString:@"   "].location);
        }
    
        [noteStr addAttribute:NSForegroundColorAttributeName value:[MMSystemHelper string2UIColor:HOME_COMMENT_COLOR] range:replyRange];
//        replyLabel .attributedText = noteStr;
        [replyLabel setAttributedText:noteStr];
        [replyLabel sizeToFit];
        
        self.replyLabel = replyLabel;
        [self.contentView addSubview:replyLabel];
        [self.replysView addObject:replyLabel];
        
        //        UIImageView *imageView = [[UIImageView alloc] init];
        //        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",item.icon]];
        ////        self.replyIcon = imageView;
        //        imageView.layer.cornerRadius = 15;
        //        imageView.layer.masksToBounds = YES;
        //        [self.contentView addSubview:imageView];
        ////        [self.replyIconView addObject:imageView];
        
        //        UILabel *replyName = [[UILabel alloc] init];
        //        replyName.font = [UIFont systemFontOfSize:12];
        //        replyName.text = item.name;
        //        replyName.textColor = [MMSystemHelper string2UIColor:HOME_VIPNAME_COLOR];
        //        self.replyName = replyName;
        //        [self.contentView addSubview:replyName];
        //        [self.replyNameView addObject:replyName];
    }
    NSString* time = [MMSystemHelper compareCurrentTime:[NSString stringWithFormat:@"%lld", data.pts]];
    
    self.timeLabel.text = time;
    self.likeNum.text = [NSString stringWithFormat:@"%ld",data.likes];
    
}

-(void)settingFrame
{
    self.icon.frame = self.commentFrame.iconF;
    self.nameLabel.frame = self.commentFrame.nameF;
    self.photo.frame = self.commentFrame.photoF;
//    self.name.frame = self.commentFrame.userNameF;
//    self.imageview.frame = self.commentFrame.imageF;
    self.timeLabel.frame = self.commentFrame.timeF;
    self.favBtn.frame = self.commentFrame.favF;
    self.commentBtn.frame = self.commentFrame.commentF;
    self.shareBtn.frame = self.commentFrame.shareF;
    self.line.frame = self.commentFrame.lineF;
    self.like.frame = self.commentFrame.likeF;
    self.likeNum.frame = self.commentFrame.likeNumF;
    self.delBtn.frame = self.commentFrame.delBtnF;
    
    for (int i = 0; i < [self.commentFrame.replysF count]; i++) {
        ((UILabel *)[self.replysView objectAtIndex:i]).frame = [(NSValue *)[self.commentFrame.replysF objectAtIndex:i] CGRectValue];
    }
    for (int i = 0; i < [self.commentFrame.replyIconF count]; i++) {
//        ((UIImageView *)[self.replyIconView objectAtIndex:i]).frame = [(NSValue*)[self.commentFrame.replyIconF objectAtIndex:i] CGRectValue];
//        UIImageView *image = (UIImageView *)[self.replyIconView objectAtIndex:i];
//        image.layer.masksToBounds = YES;
//        image.layer.cornerRadius = 15;
    }
    for (int i = 0; i < [self.commentFrame.replyNameF count]; i++) {
        ((UILabel *)[self.replyNameView objectAtIndex:i]).frame = [(NSValue *)[self.commentFrame.replyNameF objectAtIndex:i] CGRectValue];
    }
    self.button.frame = self.commentFrame.buttonF;
    self.btn.frame = self.commentFrame.BtnF;
    self.commentLabel.frame = self.commentFrame.contentF;
}
-(NSMutableArray *)replysView
{
    if (!_replysView) {
        _replysView = [[NSMutableArray alloc]init];
    }
    return _replysView;
}
//-(NSMutableArray *)replyIconView{
//    if (!_replyIconView) {
//        _replyIconView = [[NSMutableArray alloc] init];
//    }
//    return _replyIconView;
//}
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
