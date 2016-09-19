//
//  CommentCell.h
//  InternetStir
//
//  Created by Apple on 16/8/12.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeCommentFrame.h"
@interface HomeCommentCell : UITableViewCell
@property (nonatomic, strong) HomeCommentFrame *commentFrame;
@property (nonatomic, strong) UIImageView *imageview;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *photo;
@property (nonatomic, strong) NSMutableArray *replyNameView;
@property (nonatomic, strong) NSMutableArray *replysView;
//@property (nonatomic, strong) NSMutableArray *replyIconView;
//@property (nonatomic, strong) UIImageView *replyIcon;
@property (nonatomic, strong) UILabel *replyName;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UILabel *replyLabel;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIButton *btn;
//@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIButton *favBtn;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, strong) UILabel *line;
@property (nonatomic, strong) UIImageView *like;
@property (nonatomic, strong) UILabel *likeNum;

@end
