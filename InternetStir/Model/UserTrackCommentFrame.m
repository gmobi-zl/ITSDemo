


//
//  UserTrackCommentFrame.m
//  Jacob
//
//  Created by Apple on 16/10/14.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import "UserTrackCommentFrame.h"
#import "MMSystemHelper.h"
#import "AppStyleConfiguration.h"
#import "FansComment.h"
#import "UserTrackComment.h"


#define padding 5

@implementation UserTrackCommentFrame
-(void) initWithDataFrame: (id)data{
    UserTrackComment* trackComment = data;
    
    CGFloat screenW = [MMSystemHelper getScreenWidth];
    CGFloat iconViewX = HOME_CONTENT_LEFT_PADDING;
    CGFloat iconViewWidth = 45;
    CGFloat iconViewHeight = 45;
    CGFloat iconViewY = 15;
    self.userIconF = CGRectMake(iconViewX, iconViewY , iconViewWidth, iconViewHeight);

    //nameF昵称
    CGFloat nameLabelX = CGRectGetMaxX(self.userIconF) + padding;
    CGSize nameLabelSize = [MMSystemHelper sizeWithString:trackComment.name font:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(MAXFLOAT,25)];
    CGFloat nameLabelY = iconViewY;
    CGFloat nameLabelWidth = nameLabelSize.width + 20;
    self.userNameF = CGRectMake(nameLabelX, nameLabelY, nameLabelWidth, 25);
    
    CGFloat contentLabelX = nameLabelX;
    CGFloat contentLabelY = CGRectGetMaxY(self.userNameF) + padding;
    CGSize contentLabelSize = [MMSystemHelper sizeWithString:trackComment.comment font:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(screenW - nameLabelX - HOME_CONTENT_LEFT_PADDING, MAXFLOAT)];
    CGFloat contentLabelWidth = screenW - nameLabelX - HOME_CONTENT_LEFT_PADDING;
    CGFloat contentLabelHeight = contentLabelSize.height;
    self.userCommentF = CGRectMake(contentLabelX, contentLabelY, contentLabelWidth, contentLabelHeight);
    
   self.cellHeight = CGRectGetMaxY(self.userCommentF) + padding/2;

    NSString* time = [MMSystemHelper compareCurrentTime:[NSString stringWithFormat:@"%lld", trackComment.pts]];
    CGSize timeLabelSize = [MMSystemHelper sizeWithString:time font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, 20)];
    self.timeF = CGRectMake(nameLabelX, self.cellHeight , timeLabelSize.width + 20, 20);
    self.replyBtnF = CGRectMake(nameLabelX + timeLabelSize.width + 10, self.cellHeight, 40, 20);
    
    self.cellHeight = CGRectGetMaxY(self.timeF) + padding + 5;

    //评论
    
    if([trackComment.replayComments count])
    {
//        CGFloat replyLabelX = nameLabelX + padding;
        for (int i = 0; i < [trackComment.replayComments count]; i++) {
            
            FansComment *item = [trackComment.replayComments objectAtIndex:i];
            CGRect pictureF = CGRectMake(nameLabelX, self.cellHeight - 5, 30, 30);
            CGSize size = [MMSystemHelper sizeWithString:item.name font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, 20)];
            CGRect nameF = CGRectMake(nameLabelX + 40, self.cellHeight, size.width, 20);
            size = [MMSystemHelper sizeWithString:item.comment font:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(screenW - 15 - nameLabelX - 40, MAXFLOAT)];
            CGRect commentF = CGRectMake(nameLabelX + 40, CGRectGetMaxY(nameF), screenW - 15 - nameLabelX - 40, size.height);
            self.cellHeight = CGRectGetMaxY(commentF) + padding;
            [self.replyIconF addObject:[NSValue valueWithCGRect:pictureF]];
            [self.replyNameF addObject:[NSValue valueWithCGRect:nameF]];
            [self.replyCommentF addObject:[NSValue valueWithCGRect:commentF]];
        }
        
        //评论的背景
        self.cellHeight = CGRectGetMaxY([(NSValue *)[self.replyCommentF lastObject] CGRectValue]) + padding;
    }
    self.articleBgF = CGRectMake(nameLabelX, self.cellHeight, screenW - 15 - nameLabelX, 92);
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(10, 10, screenW - 140 - nameLabelX - 15, 0);
    label.numberOfLines = 2;
    label.text = trackComment.article.context;
    label.font = [UIFont systemFontOfSize:16];
    CGSize size = [label sizeThatFits:CGSizeMake(screenW - nameLabelX - 15 - 140, MAXFLOAT)];
    CGRect frame = label.frame;
    frame.size.height = size.height;
    [label setFrame:frame];
    label.frame = frame;
    self.articleF = label.frame;
    self.photoF = CGRectMake(CGRectGetMaxX(self.articleF) + padding, 10, 120, 67);
    self.cellHeight = CGRectGetMaxY(self.articleBgF) + 3 * padding;
    self.lineF = CGRectMake(nameLabelX, self.cellHeight - 0.5, screenW - nameLabelX - 15, 0.5);
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
-(NSMutableArray *)replyCommentF
{
    if (!_replyCommentF) {
        _replyCommentF = [[NSMutableArray alloc]init];
    }
    return _replyCommentF;
}
@end
