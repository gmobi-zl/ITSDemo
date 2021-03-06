//
//  DetailCommentCell.h
//  Jacob
//
//  Created by Apple on 16/9/19.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailCommentItem.h"
#import "DetailCommentFrame.h"
@interface DetailCommentCell : UITableViewCell
@property (nonatomic, strong) DetailCommentFrame *detailCommentFrame;

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
@end
