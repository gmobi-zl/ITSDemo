//
//  MenuViewController.h
//  segment
//
//  Created by Apple on 16/8/11.
//  Copyright © 2016年 gmobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginView.h"
#import "FacebookService.h"

@interface MenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate,FacebookDelegate>

@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerBg;
@property (nonatomic, strong) UILabel *line;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *userEmailLabel;
@property (nonatomic, strong) UIButton *but;
@property (nonatomic, strong) UIButton *otherButton;
@property (nonatomic, strong) UIImageView *imageview;
@property (nonatomic, strong) UIButton *loginOut;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) LoginView *loginView;
//@property (nonatomic, strong) UIVisualEffectView *effectView;
@end
