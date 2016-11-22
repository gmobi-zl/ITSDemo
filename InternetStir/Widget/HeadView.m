
//
//  HeadView.m
//  Jacob
//
//  Created by Apple on 16/9/19.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import "HeadView.h"
#import "AppStyleConfiguration.h"
#import "MMSystemHelper.h"
#import "UIImageView+WebCache.h"
#import "ITSApplication.h"
#define screenW [MMSystemHelper getScreenWidth]
#define screenH [MMSystemHelper getScreenHeight]

@implementation HeadView

- (instancetype)initWithFrame:(CGRect)frame CommentItem:(CelebComment *)item {

    self = [super initWithFrame:frame];
    if (self) {
        self.icon = [[UIImageView alloc] init];
        self.icon.frame = CGRectMake(HOME_CONTENT_LEFT_PADDING, 10, 36, 36);
        [self.icon sd_setImageWithURL:[NSURL URLWithString:item.avator] placeholderImage:[UIImage imageNamed:@"Bitmap"] options:SDWebImageRefreshCached];
//        self.icon.image = [UIImage imageNamed:item.avator];
        self.icon.layer.masksToBounds = YES;
        self.icon.layer.cornerRadius = 18;
        [self addSubview:self.icon];
        
        CGFloat nameLabelX = CGRectGetMaxX(self.icon.frame) + 10;
        CGSize nameLabelSize = [MMSystemHelper sizeWithString:item.name font:[UIFont systemFontOfSize:HOME_USER_NAME_FONT_SIZE] maxSize:CGSizeMake(MAXFLOAT,30)];
        CGFloat nameLabelWidth = nameLabelSize.width;
        CGFloat nameLabelHeight = nameLabelSize.height;
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.frame = CGRectMake(nameLabelX, 5, nameLabelWidth, 30);
        self.nameLabel.text = item.name;
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.textColor = [MMSystemHelper string2UIColor:HOME_VIPNAME_COLOR];
        self.nameLabel.font = [UIFont systemFontOfSize:HOME_USER_NAME_FONT_SIZE];
        [self addSubview:self.nameLabel];
        
        NSString* time = [MMSystemHelper compareCurrentTime:[NSString stringWithFormat:@"%lld", item.pts]];
        CGSize timeLabelSize = [MMSystemHelper sizeWithString:time font:[UIFont systemFontOfSize :HOME_TIME_FONT_SIEZ] maxSize:CGSizeMake(MAXFLOAT, 20)];
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.frame = CGRectMake(nameLabelX, 10 + nameLabelHeight, timeLabelSize.width, 20);
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        self.timeLabel.text = time;
        self.timeLabel.textColor = [MMSystemHelper string2UIColor:HOME_TIME_COLOR];
        self.timeLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.timeLabel];
        
        ITSApplication* itsApp = [ITSApplication get];
        NSString* fileBaseUrl = [itsApp.remoteSvr getBaseFileUrl];
        CelebAttachment* cbAtt = [item.attachments objectAtIndex:0];
        NSString* image = cbAtt.fd;
        
        self.photo = [[UIImageView alloc] init];
        self.photo.frame = CGRectMake(0, 36 + 10 + HOME_ICON_PHOTO_PADDING, screenW, cbAtt.h * screenW / cbAtt.w);
        NSString* imageUrl = [[NSString alloc] initWithFormat:@"%@/%@", fileBaseUrl, image];
        self.photo.contentMode = UIViewContentModeScaleAspectFill;
        self.photo.clipsToBounds = YES;
        [self.photo sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"loader_post"] options:SDWebImageRefreshCached];
        [self addSubview:self.photo];
        
        self.favBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.favBtn.frame = CGRectMake(HOME_CONTENT_LEFT_PADDING, CGRectGetMaxY(self.photo.frame) + 10, 25, 25);
        [self.favBtn setBackgroundImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        [self addSubview:self.favBtn];
        
        self.commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.commentBtn.frame = CGRectMake(HOME_CONTENT_LEFT_PADDING + 25 + HOME_ICON_PADDING, self.favBtn.frame.origin.y, 25, 25);
        [self.commentBtn setBackgroundImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
        [self addSubview:self.commentBtn];
        
        self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.shareBtn.frame = CGRectMake(self.commentBtn.frame.origin.x + 2 * HOME_ICON_PADDING, self.favBtn.frame.origin.y, 25, 25);
        [self.shareBtn setBackgroundImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
        [self addSubview:self.shareBtn];
        
        self.line = [[UILabel alloc] init];
        self.line.frame = CGRectMake(HOME_CONTENT_LEFT_PADDING, CGRectGetMaxY(self.photo.frame) + 50, screenW - 2*HOME_CONTENT_LEFT_PADDING, 1);
        self.line.backgroundColor = [UIColor grayColor];
        self.line.alpha = 0.8;
        [self addSubview:self.line];
        
        self.like = [[UIImageView alloc] init];
        self.like.frame = CGRectMake(HOME_CONTENT_LEFT_PADDING, CGRectGetMaxY(self.line.frame) + 10, 20, 20);
        self.like.image = [UIImage imageNamed:@"like_slected"];
        [self addSubview:self.like];
        
        self.likeNum = [[UILabel alloc] init];
        self.likeNum.frame = CGRectMake(HOME_CONTENT_LEFT_PADDING + 20 + 5, CGRectGetMaxY(self.line.frame) + 10, 200, 20);
        self.likeNum.textAlignment = NSTextAlignmentLeft;
        self.likeNum.text = @"9999";
        self.likeNum.textColor = [MMSystemHelper string2UIColor:HOME_VIPNAME_COLOR];
        [self addSubview:self.likeNum];
        
        NSString *str = [NSString stringWithFormat:@"%@   %@",item.name,item.context];

        CGRect rect = [TQRichTextView boundingRectWithSize:CGSizeMake([MMSystemHelper getScreenWidth] - 50, MAXFLOAT) font:[UIFont systemFontOfSize:14] string: str lineSpace:0.5 type:1];

        self.contentLabel = [[TQRichTextView alloc] init];
        self.contentLabel.frame = CGRectMake(HOME_CONTENT_LEFT_PADDING, CGRectGetMaxY(self.like.frame) + 10, screenW - 50, rect.size.height);
        self.contentLabel.font = [UIFont systemFontOfSize:HOME_VIPNAME_FONT_SIZE];
        self.contentLabel.lineSpace = 0.5;
        self.contentLabel.type = 1;
        self.contentLabel.text = str;
        self.contentLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.contentLabel];
        

        
//        self.contentLabel = [[TQRichTextView alloc] init];
//        CGSize size = [MMSystemHelper sizeWithString:[NSString stringWithFormat:@"%@  %@",item.name,item.shuoshuoText] font:[UIFont systemFontOfSize:HOME_VIPNAME_FONT_SIZE] maxSize:CGSizeMake(screenW - 50, MAXFLOAT)];
//        self.contentLabel.frame = CGRectMake(HOME_CONTENT_LEFT_PADDING, CGRectGetMaxY(self.like.frame) + 10, screenW - 50, size.height);
//        self.contentLabel.numberOfLines = 0;
//        self.contentLabel.font = [UIFont systemFontOfSize:HOME_VIPNAME_FONT_SIZE];
//        self.contentLabel.text = [NSString stringWithFormat:@"%@   %@",item.name,item.shuoshuoText];
//        self.contentLabel.backgroundColor = [UIColor redColor];
//        [self addSubview:self.contentLabel];
        
//        NSString *str = [NSString stringWithFormat:@"%@   %@",item.name,item.shuoshuoText];
//        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:str];
//        NSRange Range = NSMakeRange(0, [[noteStr string] rangeOfString:@"   "].location);
//        [noteStr addAttribute:NSForegroundColorAttributeName value:[MMSystemHelper string2UIColor:HOME_VIPNAME_COLOR] range:Range];
//        
//        NSRange replyRange = NSMakeRange([[noteStr string] rangeOfString:@"   "].location, [[noteStr string] rangeOfString:str].length - [[noteStr string] rangeOfString:@" "].location);
//        [noteStr addAttribute:NSForegroundColorAttributeName value:[MMSystemHelper string2UIColor:HOME_REPLY_COLOR] range:replyRange];
//        [self.contentLabel setAttributedText:noteStr] ;
//        [self.contentLabel sizeToFit];
        
        self.lineLabel = [[UILabel alloc] init];
        self.lineLabel.frame = CGRectMake(HOME_CONTENT_LEFT_PADDING, CGRectGetMaxY(self.contentLabel.frame) + 14, screenW - 2 * HOME_CONTENT_LEFT_PADDING, 1);
        self.lineLabel.backgroundColor = [UIColor grayColor];
        self.lineLabel.alpha = 0.6;
        [self addSubview:self.lineLabel];
    }
    return self;
}
@end
