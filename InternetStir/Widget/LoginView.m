
//
//  LoginView.m
//  Jacob
//
//  Created by Apple on 16/9/20.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.loginButton.frame = CGRectMake(25, 15, frame.size.width - 50, 35);
        [self.loginButton setTitle:@"Content with Facebook" forState:UIControlStateNormal];
        self.loginButton.layer.masksToBounds = YES;
        self.loginButton.layer.cornerRadius = 15;
        self.loginButton.backgroundColor = [UIColor blueColor];
        [self addSubview:self.loginButton];
        
        self.label = [[UILabel alloc] init];
        self.label.frame = CGRectMake(25, 60, frame.size.width - 50, 20);
        self.label.text = @"未經允許，我們不會發布至您的塗鴉牆";
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.label];
        
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelButton.frame = CGRectMake(25, 100, frame.size.width - 50, 35);
        self.cancelButton.backgroundColor = [UIColor colorWithRed:15/255 green:15/255 blue:15/255 alpha:1];
        [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        self.cancelButton.layer.masksToBounds = YES;
        self.cancelButton.layer.cornerRadius = 15;
        [self.cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self addSubview:self.cancelButton];

    }
    return self;
}

@end
