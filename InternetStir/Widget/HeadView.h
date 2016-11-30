//
//  HeadView.h
//  Jacob
//
//  Created by Apple on 16/9/19.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CelebComment.h"

@interface HeadView : UIView
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *photo;

@property (nonatomic, strong) UIButton *favBtn;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, strong) UILabel *line;
@property (nonatomic, strong) UIImageView *like;
@property (nonatomic, strong) UILabel *likeNum;
//@property (nonatomic, strong) TQRichTextView *contentLabel;
@property (nonatomic, strong) UILabel *lineLabel;

- (instancetype)initWithFrame:(CGRect)frame CommentItem:(CelebComment*)item;
@end
