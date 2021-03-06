//
//  ContentViewCell.h
//  segment
//
//  Created by Apple on 16/8/11.
//  Copyright © 2016年 gmobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CelebRecommend.h"
#import "UCZProgressView.h"
@interface ContentViewCell : UITableViewCell
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIImageView *icon;
@property (nonatomic, strong)UILabel *sourceLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UILabel *line;
@property (nonatomic, strong)UIView *bgView;
@property (nonatomic, strong)UIImageView *photo;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) UCZProgressView *progressView;
-(void)showDataWithModel:(CelebRecommend*)item;

@end
