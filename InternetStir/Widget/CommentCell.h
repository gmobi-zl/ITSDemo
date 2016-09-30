//
//  DetailCommentCell.h
//  InternetStir
//
//  Created by Apple on 16/8/15.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentFrame.h"
#import "FansComment.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface CommentCell : UITableViewCell

@property (nonatomic, strong) CommentFrame *detailCommentFrame;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) NSMutableArray *replysView;
@property (nonatomic, strong) NSMutableArray *replyIconView;
@property (nonatomic, strong) NSMutableArray *replyNameView;
@property (nonatomic, strong) UILabel *replyLabel;
@property (nonatomic, strong) UILabel *replyNameLabel;
@property (nonatomic, strong) UIImageView *replyIcon;
@property (nonatomic, strong) UIImageView *replyBackgroundView;
@property (nonatomic, strong) UILabel *line;
@property (nonatomic, strong) UIButton *bgButton;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *replyButton;
@property (nonatomic, strong) UIButton *iconBtn;

-(void) setShowData: (FansComment*) data;

@end
