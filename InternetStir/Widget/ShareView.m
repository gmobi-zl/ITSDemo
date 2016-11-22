
//
//  ShareView.m
//  Celebrity
//
//  Created by Apple on 16/11/10.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import "ShareView.h"
#import "MMSystemHelper.h"

#define screenW [MMSystemHelper getScreenWidth]
#define screenH [MMSystemHelper getScreenHeight]

@implementation ShareView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.bgView = [UIButton buttonWithType:UIButtonTypeCustom];
        self.bgView.frame = CGRectMake(0, 0, screenW - 192, screenH);
        self.bgView.backgroundColor = [UIColor clearColor];
        self.bgView.hidden = YES;
        [[UIApplication sharedApplication].keyWindow addSubview:self.bgView];
        
        self.backgroundColor = [UIColor clearColor];
        
//        self.backgroundColor = [MMSystemHelper string2UIColor:@"#FFFFFF"];
//        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        self.shareLabel = [[UILabel alloc] init];
        self.shareLabel.frame = CGRectMake(20, 0, screenW, 36);
        self.shareLabel.text = @"分享至:";
        self.shareLabel.textColor = [UIColor blackColor];
        [self addSubview:self.shareLabel];
        
        self.topline = [[UILabel alloc] init];
        self.topline.frame = CGRectMake(0, 36, screenW, 1);
        self.topline.backgroundColor = [UIColor grayColor];
        self.topline.alpha = 0.5;
        [self addSubview:self.topline];
        
        self.line = [[UILabel alloc] init];
        self.line.frame = CGRectMake(0, 155, screenW, 1);
        self.line.backgroundColor = [UIColor grayColor];
        self.line.alpha = 0.5;
        [self addSubview:self.line];
        
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelButton.frame = CGRectMake(screenW/2 - 50, 156, 100, 36);
        [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:self.cancelButton];
        
        self.iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.iconBtn.frame = CGRectMake(screenW/2 - 30, 50, 60, 60);
        [self.iconBtn setImage:[UIImage imageNamed:@"icon_Facebook"] forState:UIControlStateNormal];
        [self addSubview:self.iconBtn];
    }
    return self;
}
//- (void)cancelBtn {
//    
//}
@end
