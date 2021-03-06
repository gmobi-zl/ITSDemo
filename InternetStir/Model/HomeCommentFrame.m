//
//  CommentFrame.m
//  InternetStir
//
//  Created by Apple on 16/8/12.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import "HomeCommentFrame.h"
#import "MMSystemHelper.h"
#import "AppStyleConfiguration.h"
#import "CelebComment.h"
#import "FansComment.h"
//#import "TQRichTextView.h"
#import "TTTAttributedLabel.h"

//#define padding 10

@implementation HomeCommentFrame
- (void) setCommentItem:(CelebComment *)commentItem{

    _commentItem = commentItem;
    CGFloat screenW = [MMSystemHelper getScreenWidth];
    //iconF头像
    CGFloat iconViewX = HOME_CONTENT_LEFT_PADDING;
    CGFloat iconViewY = 10;
    CGFloat iconViewWidth = 50;
    CGFloat iconViewHeight = 50;
    self.iconF = CGRectMake(iconViewX, iconViewY, iconViewWidth, iconViewHeight);
    
    self.delBtnF = CGRectMake(screenW - 50, 15, 25, 18);
    //nameF昵称
    CGFloat nameLabelX = CGRectGetMaxX(self.iconF) + 10;
    CGSize nameLabelSize = [MMSystemHelper sizeWithString:self.commentItem.name font:[UIFont systemFontOfSize:HOME_USER_NAME_FONT_SIZE] maxSize:CGSizeMake(MAXFLOAT,30)];
    CGFloat nameLabelY = iconViewY;
    CGFloat nameLabelWidth = nameLabelSize.width;
    CGFloat nameLabelHeight = nameLabelSize.height;
    self.nameF = CGRectMake(nameLabelX, nameLabelY, nameLabelWidth, 30);

    CGSize timeLabelSize = [MMSystemHelper sizeWithString:self.commentItem.time font:[UIFont systemFontOfSize :HOME_TIME_FONT_SIEZ] maxSize:CGSizeMake(MAXFLOAT, 20)];
    self.timeF = CGRectMake(nameLabelX, nameLabelY + nameLabelHeight + 10 , timeLabelSize.width, 20);
    
    self.photoF = CGRectMake(0, iconViewY + iconViewHeight + HOME_ICON_PHOTO_PADDING, screenW, 9 * (screenW - 20) / 16);
    self.cellHeight = CGRectGetMaxY(self.photoF) + 10;

    self.favF = CGRectMake(HOME_CONTENT_LEFT_PADDING, self.cellHeight, 28, 24);
    self.commentF = CGRectMake(HOME_CONTENT_LEFT_PADDING + 25 + HOME_ICON_PADDING, self.cellHeight, 25, 22);
    self.shareF = CGRectMake(self.commentF.origin.x + 2 * HOME_ICON_PADDING, self.cellHeight, 21, 24);
    self.cellHeight = self.photoF.origin.y + self.photoF.size.height + 50;
    self.lineF = CGRectMake(HOME_CONTENT_LEFT_PADDING, self.cellHeight - 1, screenW - 2*HOME_CONTENT_LEFT_PADDING, 1);
    
    self.likeF = CGRectMake(HOME_CONTENT_LEFT_PADDING + 5, self.cellHeight + HOME_LINE_FAV_PADDING + 3, 16, 13);
    self.likeNumF = CGRectMake(HOME_CONTENT_LEFT_PADDING + 20 + 5, self.cellHeight + HOME_LINE_FAV_PADDING, 200, 20);
    self.cellHeight = CGRectGetMaxY(self.lineF) + HOME_FAV_CONTENT_PADDING;

    NSString *str = [NSString stringWithFormat:@"%@   %@",self.commentItem.name,self.commentItem.shuoshuoText];
    CGFloat height = [self height:str];
    self.contentF = CGRectMake(HOME_CONTENT_LEFT_PADDING, self.cellHeight + HOME_CONTENT_LEFT_PADDING + 5,screenW - 30, [self height:str]);

    CGFloat contentH = height;
    self.headH = contentH + self.cellHeight + HOME_CONTENT_LEFT_PADDING + 20;

    self.userNameF = CGRectMake(50, self.cellHeight + HOME_CONTENT_LEFT_PADDING/2 + 2, 50, 20);
//    self.imageF = CGRectMake(10, self.cellHeight, 30, 30);
    self.cellHeight = CGRectGetMaxY(self.contentF);
    CGFloat btnW = [MMSystemHelper sizeWithString:@"繼續閱讀" font:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(MAXFLOAT, 25)].width;
    self.BtnF = CGRectMake(screenW - HOME_CONTENT_LEFT_PADDING - btnW, self.contentF.origin.y + height + 5, btnW, 25);
    
    CGFloat buttonW = [MMSystemHelper sizeWithString:NSLocalizedString(@"comment_leave_more", nil) font:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(MAXFLOAT, 25)].width;
    self.buttonF = CGRectMake(HOME_CONTENT_LEFT_PADDING, self.contentF.origin.y + height + 5, buttonW, 25);
    self.cellHeight = CGRectGetMaxY(self.buttonF);

    if ([self.commentItem.replys count]) {
        for (int i = 0; i < [self.commentItem.replys count]; i++) {
            
            ReplyItem *item = [self.commentItem.replys objectAtIndex:i];

            CGRect pictureF = CGRectMake(10, self.cellHeight, 30, 30);
            CGSize size = [MMSystemHelper sizeWithString:item.name font:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(MAXFLOAT, 20)];
//            CGRect nameF = CGRectMake(HOME_CONTENT_LEFT_PADDING, self.cellHeight + 5, size.width, 20);
            CGSize replyLabelSize = [MMSystemHelper sizeWithString:item.comment font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(screenW - 50, MAXFLOAT)];
            CGFloat replyLabelY = self.cellHeight + 5;
            CGFloat replyLabelWidth = screenW - 50;
            CGFloat replyLabelHeight = replyLabelSize.height;
            self.cellHeight += replyLabelHeight + HOME_CONTENT_PADDING - 3;
            CGRect replyF = CGRectMake(HOME_CONTENT_LEFT_PADDING, replyLabelY + 3, replyLabelWidth, replyLabelHeight);
            [self.replysF addObject:[NSValue valueWithCGRect:replyF]];
//            [self.replyIconF addObject:[NSValue valueWithCGRect:pictureF]];
//            [self.replyNameF addObject:[NSValue valueWithCGRect:nameF]];
        }
    }
    self.cellHeight = self.cellHeight + 20;
}
-(CGFloat)height: (NSString *)content {
 
    UILabel *dataLabel = [[UILabel alloc] init];
    dataLabel.backgroundColor = [UIColor clearColor];
    dataLabel.textColor = [UIColor redColor];
//    dataLabel.font = [UIFont fontWithName:@"Arial" size:16];
    dataLabel.numberOfLines = 0;
    dataLabel.text = content;
    
    NSString *str = content;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = 0.5;
    
    NSDictionary *attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:16], NSParagraphStyleAttributeName:paragraphStyle};
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:str attributes:attributes];
    NSRange Range = NSMakeRange(0, [[noteStr string] rangeOfString:@"   "].location);
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:Range];
    [noteStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangTC-Semibold" size:16] range:Range];

    NSRange replyRange = NSMakeRange([[noteStr string] rangeOfString:@"   "].location, [[noteStr string] rangeOfString:str].length - [[noteStr string] rangeOfString:@"   "].location);
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor cyanColor] range:replyRange];
    [dataLabel setAttributedText:noteStr];
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGRect fram = [dataLabel.attributedText boundingRectWithSize:CGSizeMake(screenW - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    dataLabel.frame = CGRectMake(20, 100, screenW - 40, fram.size.height);

    return fram.size.height;
}
-(NSMutableArray *)replysF
{
    if (!_replysF) {
        _replysF = [[NSMutableArray alloc]init];
    }
    return _replysF;
}
-(NSMutableArray *)replyNameF{
    if (!_replyNameF) {
        _replyNameF = [[NSMutableArray alloc] init];
    }
    return _replyNameF;
}
-(NSMutableArray *)replyIconF{
    if (!_replyIconF) {
        _replyIconF = [[NSMutableArray alloc] init];
    }
    return _replyIconF;
}

-(void) initWithCommentData: (id) data{
    
    CelebComment* comment = (CelebComment*)data;
    CelebAttachment *celeAttachment = [comment.attachments objectAtIndex:0];
    CGFloat screenW = [MMSystemHelper getScreenWidth];
    //iconF头像
    CGFloat iconViewX = HOME_CONTENT_LEFT_PADDING;
    CGFloat iconViewY = 10;
    CGFloat iconViewWidth = 36;
    CGFloat iconViewHeight = 36;
    self.iconF = CGRectMake(iconViewX, iconViewY, iconViewWidth, iconViewHeight);
    
    self.delBtnF = CGRectMake(screenW - 51, 10, 36, 36);
    //nameF昵称
    CGFloat nameLabelX = CGRectGetMaxX(self.iconF) + 10;
    CGSize nameLabelSize = [MMSystemHelper sizeWithString:comment.name font:[UIFont fontWithName:@"PingFangTC-Semibold" size:HOME_USER_NAME_FONT_SIZE] maxSize:CGSizeMake(MAXFLOAT,30)];
    CGFloat nameLabelY = iconViewY;
    CGFloat nameLabelWidth = nameLabelSize.width;
    CGFloat nameLabelHeight = nameLabelSize.height;
    self.nameF = CGRectMake(nameLabelX, nameLabelY - 5, nameLabelWidth, 30);
    
    NSString* time = [MMSystemHelper compareCurrentTime:[NSString stringWithFormat:@"%lld", comment.pts]];
    CGSize timeLabelSize = [MMSystemHelper sizeWithString:time font:[UIFont systemFontOfSize :HOME_TIME_FONT_SIEZ] maxSize:CGSizeMake(MAXFLOAT, 20)];
    self.timeF = CGRectMake(nameLabelX, nameLabelY + nameLabelHeight, timeLabelSize.width + 20, 20);
    
    self.photoF = CGRectMake(0, iconViewY + iconViewHeight + HOME_ICON_PHOTO_PADDING, screenW, celeAttachment.h * screenW / celeAttachment.w);
    self.cellHeight = CGRectGetMaxY(self.photoF) + 10;
    
    self.favF = CGRectMake(HOME_CONTENT_LEFT_PADDING, self.cellHeight, 32, 32);
    self.commentF = CGRectMake(HOME_CONTENT_LEFT_PADDING + 32 + 8 , self.cellHeight, 32, 32);
    self.shareF = CGRectMake(HOME_CONTENT_LEFT_PADDING + 16 + 64, self.cellHeight, 32, 32);
    self.cellHeight = self.photoF.origin.y + self.photoF.size.height + 50;
    self.lineF = CGRectMake(HOME_CONTENT_LEFT_PADDING, self.cellHeight - 1, screenW - 2*HOME_CONTENT_LEFT_PADDING, 1);
    
    self.likeF = CGRectMake(HOME_CONTENT_LEFT_PADDING, self.cellHeight + HOME_LINE_FAV_PADDING + 3, 16, 13);
    self.likeNumF = CGRectMake(HOME_CONTENT_LEFT_PADDING + 20, self.cellHeight + HOME_LINE_FAV_PADDING, 200, 20);
    self.cellHeight = CGRectGetMaxY(self.lineF) + HOME_FAV_CONTENT_PADDING;
    
    NSString *str = [NSString stringWithFormat:@"%@   %@",comment.name,comment.context];
    TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    label.font = [UIFont systemFontOfSize:HOME_VIPNAME_FONT_SIZE];
    label.lineSpacing = 0.5;
    label.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor clearColor];
    __block CGSize size;
    [label setText:str afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        size = [TTTAttributedLabel sizeThatFitsAttributedString:mutableAttributedString
                                                withConstraints:CGSizeMake([MMSystemHelper getScreenWidth] - 30, MAXFLOAT)
                                         limitedToNumberOfLines:3];
        return mutableAttributedString;
    }];
    
    __block CGSize size1;
    [label setText:str afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        size1 = [TTTAttributedLabel sizeThatFitsAttributedString:mutableAttributedString
                                                withConstraints:CGSizeMake([MMSystemHelper getScreenWidth] - 30, MAXFLOAT)
                                         limitedToNumberOfLines:0];
        return mutableAttributedString;
    }];
    CGFloat height;
    
    if (comment.isShow == NO) {
        height = size.height;
    }else {
        height = size1.height;
    }
    self.contentF = CGRectMake(HOME_CONTENT_LEFT_PADDING, self.cellHeight + HOME_CONTENT_LEFT_PADDING + 5,screenW - 30, height);
    CGFloat btnW = [MMSystemHelper sizeWithString:@"繼續閱讀" font:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(MAXFLOAT, 25)].width;
    self.BtnF = CGRectMake(screenW - HOME_CONTENT_LEFT_PADDING - btnW, self.contentF.origin.y + height + 5, btnW, 25);
    CGFloat contentH = height;
    self.headH = contentH + self.cellHeight + HOME_CONTENT_LEFT_PADDING + 5;
    
    self.userNameF = CGRectMake(50, self.cellHeight + HOME_CONTENT_LEFT_PADDING/2 + 2, 50, 20);
    //    self.imageF = CGRectMake(10, self.cellHeight, 30, 30);
    self.cellHeight = CGRectGetMaxY(self.contentF);
 
    CGFloat buttonW = [MMSystemHelper sizeWithString:NSLocalizedString(@"comment_leave_more", nil) font:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(MAXFLOAT, 25)].width;
    if (comment.replayComments.count ) {
        if (comment.replayComments.count > CB_MAX_COUNT) {
            self.buttonF = CGRectMake(HOME_CONTENT_LEFT_PADDING, self.contentF.origin.y + height + 5, buttonW, 25);
        }else {
            self.buttonF = self.contentF;
        }
    }else {
        if (comment.topFansComments.count > CB_MAX_COUNT) {
            self.buttonF = CGRectMake(HOME_CONTENT_LEFT_PADDING, self.contentF.origin.y + height + 5, buttonW, 25);
        }else {
            self.buttonF = self.contentF;
        }
    }
    
    if (size.height < size1.height) {
        if (comment.isShow == YES) {
            self.cellHeight = CGRectGetMaxY(self.buttonF);
        }else{
            self.cellHeight = CGRectGetMaxY(self.BtnF);
        }
    }else {
        self.cellHeight = CGRectGetMaxY(self.buttonF);
    }
    
//    self.cellHeight = CGRectGetMaxY(self.buttonF);//

    if ([comment.replayComments count]) {
        NSInteger maxHotCommentCount = comment.replayComments.count;
        if (maxHotCommentCount > CB_MAX_COUNT){
            maxHotCommentCount = CB_MAX_COUNT;
        }else {
            maxHotCommentCount = comment.replayComments.count;
        }
        for (int i = 0; i < maxHotCommentCount; i++) {
            FansComment *item;
            if (maxHotCommentCount >= 3) {
                 item = [comment.replayComments objectAtIndex:comment.replayComments.count + i - 3];
            }else {
                item = [comment.replayComments objectAtIndex:comment.replayComments.count - i - 1];
            }
            
            CGFloat height = [self height:[NSString stringWithFormat:@"%@   %@",item.name,item.comment]];
            CGFloat replyLabelY = self.cellHeight + 5;
            CGFloat replyLabelWidth = screenW - 50;
            CGFloat replyLabelHeight = height;
            self.cellHeight += replyLabelHeight + HOME_CONTENT_PADDING - 3;
            CGRect replyF = CGRectMake(HOME_CONTENT_LEFT_PADDING, replyLabelY + 3, replyLabelWidth, replyLabelHeight);
            [self.replysF addObject:[NSValue valueWithCGRect:replyF]];
        }
    }else {
        if ([comment.topFansComments count]) {
            NSInteger maxHotCommentCount = comment.topFansComments.count;
            if (maxHotCommentCount > 3){
                maxHotCommentCount = 3;
            }else {
                maxHotCommentCount = comment.topFansComments.count;
            }
            for (int i = 0; i < maxHotCommentCount; i++) {
                
                FansComment *item = [comment.topFansComments objectAtIndex:i];
                CGFloat height = [self height:[NSString stringWithFormat:@"%@   %@",item.name,item.comment]];
                CGFloat replyLabelY = self.cellHeight + 5;
                CGFloat replyLabelWidth = screenW - 50;
                CGFloat replyLabelHeight = height;
                self.cellHeight += replyLabelHeight + HOME_CONTENT_PADDING - 3;
                CGRect replyF = CGRectMake(HOME_CONTENT_LEFT_PADDING, replyLabelY + 3, replyLabelWidth, replyLabelHeight);
                [self.replysF addObject:[NSValue valueWithCGRect:replyF]];
            }
        }
    }
    self.cellHeight = self.cellHeight + 20;
}

@end
