//
//  CommentOneCell.h
//  Celebrity
//
//  Created by Apple on 16/11/9.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQRichTextView.h"


@interface CommentOneCell : UITableViewCell<TQRichTextViewDelegate>
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) TQRichTextView *commentLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *replyButton;
@property (nonatomic, strong) UILabel *line;
-(void) setShowData: (id) comment;
@end
