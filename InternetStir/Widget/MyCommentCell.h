//
//  MyCommentCell.h
//  Jacob
//
//  Created by Apple on 16/9/20.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCommentCell : UITableViewCell
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *readImage;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *replyIcon;
@property (nonatomic, strong) UILabel *replyName;
@property (nonatomic, strong) UILabel *replyContent;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *photo;
@property (nonatomic, strong) UIButton *replyButton;

@end
