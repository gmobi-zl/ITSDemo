//
//  ContentViewCell.m
//  segment
//
//  Created by Apple on 16/8/11.
//  Copyright © 2016年 gmobi. All rights reserved.
//

#import "ContentViewCell.h"
#import "MMSystemHelper.h"
#import "ITSAppConst.h"
#import "UIImageView+WebCache.h"
#import "ITSApplication.h"

#define screenW [MMSystemHelper getScreenWidth]

@implementation ContentViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;   //cell选中时的颜色，无色
        self.icon = [[UIImageView alloc] init];
        [self.contentView addSubview:self.icon];
        
        self.bgView = [[UIView alloc] init];
//        self.bgView.backgroundColor = [MMSystemHelper string2UIColor:NAV_BGCOLOR];
        [self.contentView addSubview:self.bgView];

        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:18];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.bgView addSubview:self.titleLabel];
        
        self.sourceLabel = [[UILabel alloc] init];
        self.sourceLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.sourceLabel];
        
        self.timeLabel = [[UILabel alloc]init];
        self.timeLabel.font = [UIFont systemFontOfSize:10];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.timeLabel];
        
        self.line = [[UILabel alloc]init];
        self.line.backgroundColor = [UIColor grayColor];
        self.line.alpha = 0.5;
        [self.contentView addSubview:self.line];
        
        self.photo = [[UIImageView alloc] init];
        self.photo.layer.cornerRadius = 20;
        self.photo.layer.masksToBounds = YES;
        [self.bgView addSubview:self.photo];
        
        CGRect frame = CGRectMake(screenW/2 - 50, 21, 100, 100);
        self.progressView = [[UCZProgressView alloc] initWithFrame:frame];
        self.progressView.radius = 40.0;
        self.progressView.progress = 0;
      
        [self.contentView addSubview:self.progressView];
       
    }
    return self;
}
-(void)showDataWithModel:(CelebRecommend*)item{
    
    ITSApplication* app = [ITSApplication get];
    NSString* baseUrl = [app.remoteSvr getBaseUrl];
    
//    self.bgView.frame = CGRectMake(0, 10, screenW, 40);
    
    self.titleLabel.frame = CGRectMake(15, 10, self.bounds.size.width - 30, 0);
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    self.titleLabel.textColor = [MMSystemHelper string2UIColor:@"#4A4A4A"];
    self.titleLabel.text = item.title;
    self.titleLabel.numberOfLines = 2;
    CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(self.titleLabel.bounds.size.width, MAXFLOAT)];
    CGRect frame = self.titleLabel.frame;
    frame.size.height = size.height;
    [self.titleLabel setFrame:frame];
    self.titleLabel.frame = frame;
    
    self.icon.contentMode = UIViewContentModeScaleAspectFill;
    self.icon.layer.masksToBounds = YES;
    NewsImage *image = [item.images objectAtIndex:0];
    CGFloat height;
    height = image.h * screenW / image.w;
    self.icon.frame = CGRectMake(0, frame.size.height + 10 , screenW, height);
    self.icon.contentMode = UIViewContentModeScaleAspectFill;
    self.icon.layer.masksToBounds = YES;
    
    self.progressView.center = self.icon.center;
    
    NSString* imageUrl = [NSString stringWithFormat:@"%@v0/files/%@", baseUrl, image.image];
//    [self.icon sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"loader_post"] options:SDWebImageRefreshCached];
    
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil options:SDWebImageRefreshCached  progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        if (expectedSize!=-1) {
            CGFloat value = (CGFloat)receivedSize/expectedSize;
            [self.progressView setProgress:value];
        }
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.progressView setProgress:1.0];
    }];

    self.sourceLabel.frame = CGRectMake(15,self.icon.frame.size.height + self.icon.frame.origin.y + 5, 150, 10);
//    self.sourceLabel.backgroundColor = [UIColor redColor];
    self.sourceLabel.font = [UIFont systemFontOfSize:10];
    self.sourceLabel.text = item.pdomain;
    
//    self.timeLabel.frame = CGRectMake(self.sourceLabel.frame.size.width + self.sourceLabel.frame.origin.x + 10, self.sourceLabel.frame.origin.y, 40, 20);
//    self.timeLabel.text = @"4小时前";
    
    self.line.frame = CGRectMake(0, self.sourceLabel.frame.origin.y + self.sourceLabel.frame.size.height + 10, screenW, 0.5);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
