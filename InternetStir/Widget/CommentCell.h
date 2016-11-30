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
#import "CelebComment.h"
#import "HomeCommentFrame.h"
//#import "TQRichTextView.h"

@protocol ViewCellDelegate <NSObject>

-(void)viewCellInitial:(NSIndexPath *)indepath index:(NSInteger)tag frame:(CGRect)frame;

@end

@interface CommentCell : UITableViewCell<UIScrollViewDelegate>

@property (nonatomic, strong) HomeCommentFrame *TopCommentFrame;
@property (nonatomic, strong) CommentFrame *detailCommentFrame;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) NSMutableArray *replysView;
@property (nonatomic, strong) NSMutableArray *replyIconView;
@property (nonatomic, strong) NSMutableArray *replyNameView;
@property (nonatomic, strong) NSMutableArray *replyScrollView;
@property (nonatomic, strong) NSMutableArray *replyDel;

@property (nonatomic, strong) UIScrollView *otherScroll;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) int type;
@property (nonatomic, assign) NSInteger tag;

@property (nonatomic, strong) UIButton *delImage;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *replyLabel;
@property (nonatomic, strong) UILabel *replyNameLabel;
@property (nonatomic, strong) UIImageView *replyIcon;
@property (nonatomic, strong) UIImageView *replyBackgroundView;
@property (nonatomic, strong) UILabel *line;
@property (nonatomic, strong) UIButton *bgButton;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *replyButton;
@property (nonatomic, strong) UIButton *iconBtn;
@property (nonatomic, strong) UIScrollView *bgView;
@property (nonatomic, strong) UIButton *delButton;
@property (nonatomic, strong) NSIndexPath *myIndexPath;
@property (nonatomic, assign) id<ViewCellDelegate>delegate;


-(void) setShowData: (id) comment;

@end
