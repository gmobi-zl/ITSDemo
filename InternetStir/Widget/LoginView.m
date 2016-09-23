
//
//  LoginView.m
//  Jacob
//
//  Created by Apple on 16/9/20.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import "LoginView.h"
#import "MMSystemHelper.h"

@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.loginButton.frame = CGRectMake(20, 20, frame.size.width - 40, 45);
//        [self.loginButton setTitle:@"Content with Facebook" forState:UIControlStateNormal];
        self.loginButton.layer.masksToBounds = YES;
        self.loginButton.layer.cornerRadius = 15;
        self.loginButton.backgroundColor = [UIColor blueColor];
        [self addSubview:self.loginButton];
        
        UILabel *label = [[UILabel alloc] init];
        CGSize size = [MMSystemHelper sizeWithString:@"Content with Facebook" font:[UIFont systemFontOfSize:18] maxSize:CGSizeMake(MAXFLOAT, 20)];
        label.frame = CGRectMake(55, 33, size.width, 20);
        label.center = self.loginButton.center;
        label.text = @"Content with Facebook";
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:18];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(label.frame.origin.x - 22, 33, 20, 20);
        view.backgroundColor = [UIColor whiteColor];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 10;
        [self addSubview:view];
        
        UIImageView *imageview = [[UIImageView alloc] init];
        imageview.frame = CGRectMake(label.frame.origin.x - 22, 33, 20, 20);
        imageview.layer.masksToBounds = YES;
        imageview.layer.cornerRadius = 10;
        imageview.image = [UIImage imageNamed:@"Fb"];
        [self addSubview:imageview];
        
        self.label = [[UILabel alloc] init];
        self.label.frame = CGRectMake(20, 80, frame.size.width - 40, 20);
        self.label.text = @"未經允許，我們不會發布至您的塗鴉牆";
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.label];
        
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelButton.frame = CGRectMake(20, 120, frame.size.width - 40, 45);
        self.cancelButton.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        [self.cancelButton setTitle:@"稍後" forState:UIControlStateNormal];
        self.cancelButton.layer.masksToBounds = YES;
        self.cancelButton.layer.cornerRadius = 15;
        [self.cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self addSubview:self.cancelButton];

    }
    return self;
}

@end
