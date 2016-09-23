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
//#define padding 10

@implementation HomeCommentFrame
- (void) setCommentItem:(HomeCommentItem *)commentItem{

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

    self.favF = CGRectMake(HOME_CONTENT_LEFT_PADDING, self.cellHeight, 25, 25);
    self.commentF = CGRectMake(HOME_CONTENT_LEFT_PADDING + 25 + HOME_ICON_PADDING, self.cellHeight, 25, 25);
    self.shareF = CGRectMake(self.commentF.origin.x + 2 * HOME_ICON_PADDING, self.cellHeight, 25, 25);
    self.cellHeight = self.photoF.origin.y + self.photoF.size.height + 50;
    self.lineF = CGRectMake(HOME_CONTENT_LEFT_PADDING, self.cellHeight - 1, screenW - 2*HOME_CONTENT_LEFT_PADDING, 1);
    
    self.likeF = CGRectMake(HOME_CONTENT_LEFT_PADDING, self.cellHeight + HOME_LINE_FAV_PADDING, 20, 20);
    self.likeNumF = CGRectMake(HOME_CONTENT_LEFT_PADDING + 20 + 5, self.cellHeight + HOME_LINE_FAV_PADDING, 200, 20);
    self.cellHeight = CGRectGetMaxY(self.lineF) + HOME_FAV_CONTENT_PADDING;

    NSString *str = self.commentItem.shuoshuoText;
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(HOME_CONTENT_LEFT_PADDING, self.cellHeight + HOME_CONTENT_LEFT_PADDING, screenW - 50, 0);
    label.numberOfLines = 3;
    label.font = [UIFont systemFontOfSize:HOME_VIPNAME_FONT_SIZE];
    label.text = str;
    CGSize size = [label sizeThatFits:CGSizeMake(screenW - 50, MAXFLOAT)];
    self.contentF = CGRectMake(HOME_CONTENT_LEFT_PADDING, self.cellHeight + HOME_CONTENT_LEFT_PADDING,screenW - 50, size.height);

    CGSize sizeH = [MMSystemHelper sizeWithString:[NSString stringWithFormat:@"%@   %@",self.commentItem.name,commentItem.shuoshuoText] font:[UIFont systemFontOfSize:HOME_VIPNAME_FONT_SIZE] maxSize:CGSizeMake(screenW - 50, MAXFLOAT)];
    CGFloat contentH = sizeH.height;
    self.headH = contentH + self.cellHeight + HOME_CONTENT_LEFT_PADDING + 20;

    self.userNameF = CGRectMake(50, self.cellHeight + HOME_CONTENT_LEFT_PADDING/2 + 2, 50, 20);
//    self.imageF = CGRectMake(10, self.cellHeight, 30, 30);
    self.cellHeight = CGRectGetMaxY(self.contentF);
    CGFloat btnW = [MMSystemHelper sizeWithString:@"繼續閱讀" font:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(MAXFLOAT, 25)].width;
    self.BtnF = CGRectMake(screenW - HOME_CONTENT_LEFT_PADDING - btnW, self.contentF.origin.y + size.height + 5, btnW, 25);
    
    CGFloat buttonW = [MMSystemHelper sizeWithString:@"查看更多留言" font:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(MAXFLOAT, 25)].width;
    self.buttonF = CGRectMake(HOME_CONTENT_LEFT_PADDING, self.contentF.origin.y + size.height + 5, buttonW, 25);
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
@end
