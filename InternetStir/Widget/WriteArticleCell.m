//
//  WriteArticleCell.m
//  Jacob
//
//  Created by Apple on 16/9/22.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import "WriteArticleCell.h"
#import "MMSystemHelper.h"

#define screenW [MMSystemHelper getScreenWidth]
#define screenH [MMSystemHelper getScreenHeight]

@implementation WriteArticleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.icon = [[UIImageView alloc] init];
        self.icon.frame = CGRectMake(20, 12, 25, 25);
        [self.contentView addSubview:self.icon];
        
        self.title = [[UILabel alloc] init];
        self.title.frame = CGRectMake(75, 10, 150, 30);
        self.title.textAlignment = NSTextAlignmentLeft;
        self.title.font = [UIFont systemFontOfSize:16];
        self.title.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.title];
        
//        self.photo = [[UIImageView alloc] init];
//        self.photo.frame = CGRectMake(screenW - 60, 5, 40, 40);
//        [self.contentView addSubview:self.photo];
        
        self.line = [[UILabel alloc] init];
        self.line.frame = CGRectMake(75, 49, screenW - 75, 1);
        self.line.backgroundColor = [UIColor grayColor];
        self.line.alpha = 0.8;
        [self.contentView addSubview:self.line];
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
