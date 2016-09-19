
//
//  CommentView.m
//  InternetStir
//
//  Created by Apple on 16/8/16.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import "CommentView.h"
#import "MMSystemHelper.h"
#import "AppStyleConfiguration.h"

@implementation CommentView
- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    
    CGFloat screenW = [MMSystemHelper getScreenWidth];
    UILabel *line = [[UILabel alloc] init];
    line.frame = CGRectMake(0, 0, screenW, 0.5);
    line.backgroundColor = [UIColor grayColor];
    line.alpha = 0.3;
    [self addSubview:line];
    
    self.icon = [UIButton buttonWithType:UIButtonTypeCustom];
    self.icon.frame = CGRectMake(15, 10, 20, 20);
    [self.icon setBackgroundImage:[UIImage imageNamed:@"sticker"] forState:UIControlStateNormal];
//    [self.icon setBackgroundImage:[UIImage imageNamed:@"icon_Photo_sel"] forState:UIControlStateHighlighted];
    [self addSubview:self.icon];
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button setTitle:@"留言訊息..." forState:UIControlStateNormal];
    self.button.frame = CGRectMake(50, 5, screenW - 114, 30);
    self.button.layer.masksToBounds = YES;
    self.button.layer.cornerRadius = 10;
    self.button.layer.borderWidth = 1;
    self.button.layer.borderColor = [MMSystemHelper string2UIColor:COMMENT_BOTTOM_BUTTON_LINE_COLOR].CGColor;
    self.button.backgroundColor = [MMSystemHelper string2UIColor:COMMENT_BOTTOM_BUTTON_BG_COLOR];
    [self.button setTitleColor:[MMSystemHelper string2UIColor:@"#ececec"]forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(pushKeyboard) forControlEvents:UIControlEventTouchUpInside];
    self.button.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    self.button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    self.button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 25);
    self.button.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 30);
    UIImage* backIcon = [UIImage imageNamed:@"icon_Edit"];
    [self.button setImage:backIcon forState:UIControlStateNormal];
    [self addSubview:self.button];
    [self addSubview:self.button];

    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(screenW - 50, 10, 50, 20);
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"發佈";
    label.textColor = [MMSystemHelper string2UIColor:HOME_VIPNAME_COLOR];
    [self addSubview:label];
}
- (void)pushKeyboard{
    if ([self.delegate respondsToSelector:@selector(writeNewComment)]) {
        [self.delegate writeNewComment];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
