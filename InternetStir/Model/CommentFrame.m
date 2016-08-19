//
//  CommentFrame.m
//  InternetStir
//
//  Created by Apple on 16/8/12.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import "CommentFrame.h"
#import "MMSystemHelper.h"
#define padding 10

@implementation CommentFrame
- (void) setCommentItem:(CommentItem *)commentItem{

    _commentItem = commentItem;
    CGFloat screenW = [MMSystemHelper getScreenWidth];
    //iconF头像
    CGFloat iconViewX = padding;
    CGFloat iconViewY = padding;
    CGFloat iconViewWidth = 40;
    CGFloat iconViewHeight = 40;
    self.iconF = CGRectMake(iconViewX, iconViewY, iconViewWidth, iconViewHeight);
    
    //nameF昵称
    CGFloat nameLabelX = CGRectGetMaxX(self.iconF) + padding;
    CGSize nameLabelSize = [MMSystemHelper sizeWithString:self.commentItem.name font:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(MAXFLOAT,MAXFLOAT)];
    CGFloat nameLabelY = iconViewHeight / 2 + 12;
    CGFloat nameLabelWidth = nameLabelSize.width;
    CGFloat nameLabelHeight = nameLabelSize.height;
    self.nameF = CGRectMake(nameLabelX, nameLabelY, nameLabelWidth, nameLabelHeight);

    self.photoF = CGRectMake(0, iconViewY + iconViewHeight + 3, screenW, 9 * (screenW - 20) / 16);
    self.cellHeight = CGRectGetMaxY(self.photoF) + padding;

    CGSize size = [MMSystemHelper sizeWithString:self.commentItem.shuoshuoText font:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(screenW - 120, MAXFLOAT)];
    CGFloat contentH = size.height;
    self.userNameF = CGRectMake(50, self.cellHeight + padding/2 + 2, 50, 20);
    self.imageF = CGRectMake(10, self.cellHeight, 30, 30);
    self.contentF = CGRectMake(100, self.cellHeight + padding,size.width, contentH);
    if (contentH > 30) {
         self.cellHeight = CGRectGetMaxY(self.contentF) + padding;
    }else{
        self.cellHeight = CGRectGetMaxY(self.imageF) + padding;
    }
    
    if ([self.commentItem.replys count]) {
        for (int i = 0; i < [self.commentItem.replys count]; i++) {
            
            ReplyItem *item = [self.commentItem.replys objectAtIndex:i];

            CGRect pictureF = CGRectMake(10, self.cellHeight, 30, 30);
            CGSize size = [MMSystemHelper sizeWithString:item.name font:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(MAXFLOAT, 20)];
            CGRect nameF = CGRectMake(50, self.cellHeight + 5, size.width, 20);
            CGSize replyLabelSize = [MMSystemHelper sizeWithString:item.comment font:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(screenW - 120, MAXFLOAT)];
            CGFloat replyLabelY = nameF.origin.y;
            CGFloat replyLabelWidth = replyLabelSize.width;
            CGFloat replyLabelHeight = replyLabelSize.height;
            self.cellHeight += replyLabelHeight + 2 * padding;
            CGRect replyF = CGRectMake(50 + size.width + 10, replyLabelY + 3, replyLabelWidth, replyLabelHeight);
            [self.replysF addObject:[NSValue valueWithCGRect:replyF]];
            [self.replyIconF addObject:[NSValue valueWithCGRect:pictureF]];
            [self.replyNameF addObject:[NSValue valueWithCGRect:nameF]];
        }
    }
    CGFloat buttonW = [MMSystemHelper sizeWithString:@"查看更多留言" font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, 25)].width;
    self.buttonF = CGRectMake(screenW/2 - buttonW/2, self.cellHeight, buttonW, 30);
    self.cellHeight = CGRectGetMaxY(self.buttonF) + padding;
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
