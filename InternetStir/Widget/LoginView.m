
//
//  LoginView.m
//  Jacob
//
//  Created by Apple on 16/9/20.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import "LoginView.h"
#import "ITSApplication.h"
#import "MMSystemHelper.h"
#import "SettingService.h"

#define screenW [MMSystemHelper getScreenWidth]
#define screenH [MMSystemHelper getScreenHeight]

@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame viewController:(UIViewController *)view{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.viewController = view;
        
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        self.effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        self.effectView.frame = CGRectMake(0, 0, screenW, screenH);
        self.effectView.hidden = YES;
        [[UIApplication sharedApplication].keyWindow addSubview:self.effectView];
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.effectView.bounds;
        UIColor *oneColor = [UIColor colorWithRed:246/255.0 green:123/255.0 blue:226/255.0 alpha:0.36];
        UIColor *twoColor = [UIColor colorWithRed:209/255.0 green:74/255.0 blue:138/255.0 alpha:0.34];
        UIColor *threeColor = [UIColor colorWithRed:45/255.0 green:65/255.0 blue:213/255.0 alpha:0.36];
        gradient.colors = [NSArray arrayWithObjects:(id)oneColor.CGColor, (id)twoColor.CGColor, (id)threeColor.CGColor, nil];
        [self.effectView.layer insertSublayer:gradient atIndex:0];

        self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.loginButton.frame = CGRectMake(15, 20, frame.size.width - 30, 45);
        self.loginButton.layer.masksToBounds = YES;
        self.loginButton.layer.cornerRadius = 20;
        self.loginButton.layer.borderWidth = 2;
        self.loginButton.titleLabel.font = [UIFont systemFontOfSize:18];
        self.loginButton.layer.borderColor = [UIColor grayColor].CGColor;
        [self.loginButton setTitle:@"Content with Facebook" forState:UIControlStateNormal];
        [self.loginButton setImage:[UIImage imageNamed:@"icon_fb"] forState:UIControlStateNormal];
        self.loginButton.titleEdgeInsets = UIEdgeInsetsMake(0, -12, 0, 0);
        self.loginButton.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
//        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.loginButton addTarget:self action:@selector(loginFB) forControlEvents:UIControlEventTouchUpInside];

        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"Content with Facebook"];
        
        NSRange Range = NSMakeRange(0, [[str string] rangeOfString:@"Facebook"].location);
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:Range];
        Range = NSMakeRange([[str string] rangeOfString:@"Facebook"].location, [[str string] rangeOfString:@"Content with Facebook"].length - [[str string] rangeOfString:@"Facebook"].location);
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:Range];
        [self.loginButton setAttributedTitle:str forState:(UIControlStateNormal)];
        [self addSubview:self.loginButton];
        
        self.label = [[UILabel alloc] init];
        self.label.frame = CGRectMake(15, 80, frame.size.width - 30, 20);
        self.label.text = @"未經允許，我們不會發布至您的塗鴉牆";
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.textColor = [MMSystemHelper string2UIColor:@"#4A4A4A"];
        self.label.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.label];
        
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelButton.frame = CGRectMake(15, 120, frame.size.width - 30, 45);
        self.cancelButton.backgroundColor = [MMSystemHelper string2UIColor:@"#ADACAC"];
        [self.cancelButton setTitle:@"稍後" forState:UIControlStateNormal];
        self.cancelButton.layer.masksToBounds = YES;
        self.cancelButton.layer.cornerRadius = 15;
        [self.cancelButton addTarget:self action:@selector(cancelBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self addSubview:self.cancelButton];
    }
    return self;
}
- (void)cancelBtn {
    self.effectView.hidden = YES;
}
- (void)loginFB {
    
    ITSApplication* poApp = [ITSApplication get];
    FacebookService *faceBook = poApp.fbSvr;
    self.effectView.hidden = YES;
    faceBook.delegate = self.viewController;
    [faceBook facebookLogin:^(int resultCode) {
        if (resultCode == ITS_FB_LOGIN_SUCCESS) {
            [faceBook facebookUserInfo];
        } else {
            
            UIAlertView *al = [[UIAlertView alloc] initWithTitle:nil message:@"登陸超時" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
            [al show];
        }
        
    } viewController:self.viewController];
}

@end
