
//
//  DetailCommentFrame.m
//  InternetStir
//
//  Created by Apple on 16/8/16.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import "CommentFrame.h"
#import "MMSystemHelper.h"
#import "ITSApplication.h"
#import "DataService.h"
#import "AppStyleConfiguration.h"
#import "FansComment.h"

#define padding 8

@implementation CommentFrame
/*
- (void)setItem:(ReplyItem *)item{
    _item = item;
    CGFloat screenW = [MMSystemHelper getScreenWidth];
    CGFloat iconViewX = padding + 5;
    CGFloat iconViewY = padding + 5;
    CGFloat iconViewWidth = 40;
    CGFloat iconViewHeight = 40;
    self.iconF = CGRectMake(iconViewX, iconViewY , iconViewWidth, iconViewHeight);
    
    //nameF昵称
    CGFloat nameLabelX = CGRectGetMaxX(self.iconF) + padding;
    CGSize nameLabelSize = [MMSystemHelper sizeWithString:self.item.name font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT,MAXFLOAT)];
    CGFloat nameLabelY = iconViewY;
    CGFloat nameLabelWidth = nameLabelSize.width;
    CGFloat nameLabelHeight = nameLabelSize.height;
    self.nameF = CGRectMake(nameLabelX, nameLabelY, nameLabelWidth, nameLabelHeight);
    
    //正文
    CGFloat contentLabelX = nameLabelX;
    CGFloat contentLabelY = CGRectGetMaxY(self.nameF) + padding/2;
    CGSize contentLabelSize = [MMSystemHelper sizeWithString:self.item.comment font:[UIFont systemFontOfSize:12 ] maxSize:CGSizeMake(screenW - nameLabelX - padding, MAXFLOAT)];
    CGFloat contentLabelWidth = contentLabelSize.width;
    CGFloat contentLabelHeight = contentLabelSize.height;
    self.contentF = CGRectMake(contentLabelX, contentLabelY, contentLabelWidth, contentLabelHeight);
    
    self.cellHeight = CGRectGetMaxY(self.contentF) + padding;

    self.lineF = CGRectMake(0, self.cellHeight - 0.5, screenW, 0.5);
}*/
- (void)setDetailCommentItem:(CommentItem *)detailCommentItem{
#ifdef DEMO_DATA
    _detailCommentItem = detailCommentItem;

//    ITSApplication* poApp = [ITSApplication get];
//    DataService* ds = poApp.dataSvr;

    CGFloat screenW = [MMSystemHelper getScreenWidth];
    CGFloat iconViewX = HOME_CONTENT_LEFT_PADDING;
    CGFloat iconViewY = padding + 5;
    CGFloat iconViewWidth = 40;
    CGFloat iconViewHeight = 40;
    self.iconF = CGRectMake(iconViewX, iconViewY , iconViewWidth, iconViewHeight);
    
    //nameF昵称
    CGFloat nameLabelX = CGRectGetMaxX(self.iconF) + padding;
    CGSize nameLabelSize = [MMSystemHelper sizeWithString:self.detailCommentItem.name font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT,MAXFLOAT)];
    CGFloat nameLabelY = iconViewY;
    CGFloat nameLabelWidth = nameLabelSize.width;
    CGFloat nameLabelHeight = nameLabelSize.height;
    self.nameF = CGRectMake(nameLabelX, nameLabelY, nameLabelWidth, nameLabelHeight);
    
//    //时间戳
//    CGFloat timeLabelWidth = 200;
//    CGFloat timeLabelHeight = 15;
//    CGFloat timeLabelX = nameLabelX;
//    CGFloat timeLabelY = nameLabelY + nameLabelHeight;
//    self.timeF = CGRectMake(timeLabelX, timeLabelY, timeLabelWidth, timeLabelHeight);
//    
    //shuoshuotextF正文
    CGFloat contentLabelX = nameLabelX;
    CGFloat contentLabelY = CGRectGetMaxY(self.nameF) + padding/2;
    CGSize contentLabelSize = [MMSystemHelper sizeWithString:self.detailCommentItem.comment font:[UIFont systemFontOfSize:16 ] maxSize:CGSizeMake(screenW - nameLabelX - HOME_CONTENT_LEFT_PADDING, MAXFLOAT)];
    CGFloat contentLabelWidth = contentLabelSize.width;
    CGFloat contentLabelHeight = contentLabelSize.height;
    self.contentF = CGRectMake(contentLabelX, contentLabelY, contentLabelWidth, contentLabelHeight);
    
    self.cellHeight = CGRectGetMaxY(self.contentF) + padding/2;
    
    CGSize timeLabelSize = [MMSystemHelper sizeWithString:@"2016-7-9 " font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, 20)];
    self.timeF = CGRectMake(nameLabelX, self.cellHeight , timeLabelSize.width, 20);
    self.replyBtnF = CGRectMake(nameLabelX + timeLabelSize.width + 10, self.cellHeight, 40, 20);
    
    self.cellHeight = CGRectGetMaxY(self.timeF) + padding + 5;
    
    //评论
    if([self.detailCommentItem.replys count])
    {
        CGFloat replyLabelX = nameLabelX + padding/2;
        for (int i = 0; i < [self.detailCommentItem.replys count]; i++) {
            
            ReplyItem *item = [self.detailCommentItem.replys objectAtIndex:i];
            CGRect pictureF = CGRectMake(nameLabelX, self.cellHeight - 5, 30, 30);
            CGRect nameF = CGRectMake(nameLabelX + 40, self.cellHeight, 100, 20);
            self.cellHeight += 30 + padding/2;
            CGSize replyLabelSize;
            if (item.type == 1) {
                replyLabelSize = [MMSystemHelper sizeWithString:item.comment font:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(screenW - 2*padding - nameLabelX, MAXFLOAT)];
            }else{
               replyLabelSize   = [MMSystemHelper sizeWithString:[NSString stringWithFormat:@"%@回复啊%@：%@",item.name,item.name,item.comment ] font:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(screenW - 2*padding - nameLabelX, MAXFLOAT)];
            }
            
            CGFloat replyLabelY = self.cellHeight;
            CGFloat replyLabelWidth = replyLabelSize.width;
            CGFloat replyLabelHeight = replyLabelSize.height;
            self.cellHeight += padding +replyLabelHeight;
            CGRect replyF = CGRectMake(replyLabelX, replyLabelY, replyLabelWidth, replyLabelHeight);
            [self.replysF addObject:[NSValue valueWithCGRect:replyF]];
            [self.replyPictureF addObject:[NSValue valueWithCGRect:pictureF]];
            [self.replyNameF addObject:[NSValue valueWithCGRect:nameF]];
        }
        
        //评论的背景
        self.cellHeight = CGRectGetMaxY([(NSValue *)[self.replysF lastObject] CGRectValue]) + padding;
        CGFloat replyBackgroundWidth = screenW - 1.5*padding -nameLabelX;
        CGFloat replyBackgroundHeight = self.cellHeight - padding*2 - CGRectGetMaxY(self.contentF);
        self.replyBackgroundF = CGRectMake(nameLabelX, CGRectGetMaxY(self.contentF) + padding, replyBackgroundWidth, replyBackgroundHeight);

    }
    self.lineF = CGRectMake(nameLabelX, self.cellHeight - 0.5, screenW - nameLabelX - 10, 0.5);
#endif
}
-(NSMutableArray *)replyNameF{
    if (!_replyNameF) {
        _replyNameF = [[NSMutableArray alloc] init];
    }
    return _replyNameF;
}
-(NSMutableArray *)replyPictureF{

    if (!_replyPictureF) {
        _replyPictureF = [[NSMutableArray alloc] init];
    }
    return _replyPictureF;
}
-(NSMutableArray *)replysF
{
    if (!_replysF) {
        _replysF = [[NSMutableArray alloc]init];
    }
    return _replysF;
}

-(void) initWithCommentData: (id) data{

    FansComment* fansComment = data;
    //    ITSApplication* poApp = [ITSApplication get];
    //    DataService* ds = poApp.dataSvr;
    
    CGFloat screenW = [MMSystemHelper getScreenWidth];
    CGFloat iconViewX = HOME_CONTENT_LEFT_PADDING;
    CGFloat iconViewY = padding + 5;
    CGFloat iconViewWidth = 40;
    CGFloat iconViewHeight = 40;
    self.iconF = CGRectMake(iconViewX, iconViewY , iconViewWidth, iconViewHeight);
    
    //nameF昵称
    CGFloat nameLabelX = CGRectGetMaxX(self.iconF) + padding;
    CGSize nameLabelSize = [MMSystemHelper sizeWithString:fansComment.name font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT,MAXFLOAT)];
    CGFloat nameLabelY = iconViewY;
    CGFloat nameLabelWidth = nameLabelSize.width;
    CGFloat nameLabelHeight = nameLabelSize.height;
    self.nameF = CGRectMake(nameLabelX, nameLabelY, nameLabelWidth, nameLabelHeight);
    
    //    //时间戳
    //    CGFloat timeLabelWidth = 200;
    //    CGFloat timeLabelHeight = 15;
    //    CGFloat timeLabelX = nameLabelX;
    //    CGFloat timeLabelY = nameLabelY + nameLabelHeight;
    //    self.timeF = CGRectMake(timeLabelX, timeLabelY, timeLabelWidth, timeLabelHeight);
    //
    //shuoshuotextF正文
    CGFloat contentLabelX = nameLabelX;
    CGFloat contentLabelY = CGRectGetMaxY(self.nameF) + padding/2;
    CGSize contentLabelSize = [MMSystemHelper sizeWithString:fansComment.comment font:[UIFont systemFontOfSize:16 ] maxSize:CGSizeMake(screenW - nameLabelX - HOME_CONTENT_LEFT_PADDING, MAXFLOAT)];
    CGFloat contentLabelWidth = contentLabelSize.width;
    CGFloat contentLabelHeight = contentLabelSize.height;
    self.contentF = CGRectMake(contentLabelX, contentLabelY, contentLabelWidth, contentLabelHeight);
    
    self.cellHeight = CGRectGetMaxY(self.contentF) + padding/2;
    
    NSString* time = [MMSystemHelper compareCurrentTime:[NSString stringWithFormat:@"%lld", fansComment.pts]];
    CGSize timeLabelSize = [MMSystemHelper sizeWithString:time font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, 20)];
    self.timeF = CGRectMake(nameLabelX, self.cellHeight , timeLabelSize.width, 20);
    self.replyBtnF = CGRectMake(nameLabelX + timeLabelSize.width + 10, self.cellHeight, 40, 20);
    
    self.cellHeight = CGRectGetMaxY(self.timeF) + padding + 5;
    
    //评论
    /*
    if([self.detailCommentItem.replys count])
    {
        CGFloat replyLabelX = nameLabelX + padding/2;
        for (int i = 0; i < [self.detailCommentItem.replys count]; i++) {
            
            ReplyItem *item = [self.detailCommentItem.replys objectAtIndex:i];
            CGRect pictureF = CGRectMake(nameLabelX, self.cellHeight - 5, 30, 30);
            CGRect nameF = CGRectMake(nameLabelX + 40, self.cellHeight, 100, 20);
            self.cellHeight += 30 + padding/2;
            CGSize replyLabelSize;
            if (item.type == 1) {
                replyLabelSize = [MMSystemHelper sizeWithString:item.comment font:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(screenW - 2*padding - nameLabelX, MAXFLOAT)];
            }else{
                replyLabelSize   = [MMSystemHelper sizeWithString:[NSString stringWithFormat:@"%@回复啊%@：%@",item.name,item.name,item.comment ] font:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(screenW - 2*padding - nameLabelX, MAXFLOAT)];
            }
            
            CGFloat replyLabelY = self.cellHeight;
            CGFloat replyLabelWidth = replyLabelSize.width;
            CGFloat replyLabelHeight = replyLabelSize.height;
            self.cellHeight += padding +replyLabelHeight;
            CGRect replyF = CGRectMake(replyLabelX, replyLabelY, replyLabelWidth, replyLabelHeight);
            [self.replysF addObject:[NSValue valueWithCGRect:replyF]];
            [self.replyPictureF addObject:[NSValue valueWithCGRect:pictureF]];
            [self.replyNameF addObject:[NSValue valueWithCGRect:nameF]];
        }
        
        //评论的背景
        self.cellHeight = CGRectGetMaxY([(NSValue *)[self.replysF lastObject] CGRectValue]) + padding;
        CGFloat replyBackgroundWidth = screenW - 1.5*padding -nameLabelX;
        CGFloat replyBackgroundHeight = self.cellHeight - padding*2 - CGRectGetMaxY(self.contentF);
        self.replyBackgroundF = CGRectMake(nameLabelX, CGRectGetMaxY(self.contentF) + padding, replyBackgroundWidth, replyBackgroundHeight);
        
    }
     */
    self.lineF = CGRectMake(nameLabelX, self.cellHeight - 0.5, screenW - nameLabelX - 10, 0.5);
}
@end
