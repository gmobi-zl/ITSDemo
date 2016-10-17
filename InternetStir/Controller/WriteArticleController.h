//
//  WriteArticleController.h
//  Jacob
//
//  Created by Apple on 16/9/21.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface WriteArticleController : UIViewController<UIGestureRecognizerDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>
@property (strong, nonatomic) MBProgressHUD *hud;
@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) UIImageView *photo;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSString *labelStr;

@property (nonatomic, assign) int type;
@property (nonatomic, copy) NSString *photoStr;
@end
