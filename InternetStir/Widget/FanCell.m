
//
//  FanCell.m
//  Jacob
//
//  Created by Apple on 16/9/18.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import "FanCell.h"
#import "MMSystemHelper.h"
#import "AppStyleConfiguration.h"

#define screenW [MMSystemHelper getScreenWidth]
#define screenH [MMSystemHelper getScreenHeight]

@implementation FanCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.icon = [[UIImageView alloc] init];
        self.icon.frame = CGRectMake(FAN_ICON_LEFT_PADDING, 10, FAN_ICON_HEIGHT, FAN_ICON_HEIGHT);
        self.icon.image = [UIImage imageNamed:@"b-12.jpg"];
        self.icon.layer.masksToBounds = YES;
        self.icon.layer.cornerRadius = FAN_ICON_HEIGHT/2;
        [self.contentView addSubview:self.icon];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.frame = CGRectMake(self.icon.frame.origin.x + self.icon.frame.size.width + FAN_ICON_NAME_PADDING, 15, 200, 25);
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.text = @"hdhdhdh oaoheoi";
        self.nameLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView  addSubview:self.nameLabel];
        
        self.line = [[UILabel alloc] init];
        self.line.frame = CGRectMake(self.nameLabel.frame.origin.x, 61, screenW - self.nameLabel.frame.origin.x - FAN_ICON_LEFT_PADDING, 1);
        self.line.backgroundColor = [MMSystemHelper string2UIColor:HOME_MORE_COMMENT_COLOR];
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
