//
//  LoginView.h
//  Jacob
//
//  Created by Apple on 16/9/20.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookService.h"

@interface LoginView : UIView<FacebookDelegate>
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, strong) UIViewController *viewController;
- (instancetype)initWithFrame:(CGRect)frame viewController:(UIViewController*)view;
@end
