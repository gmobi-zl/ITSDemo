//
//  SettingController.h
//  InternetStir
//
//  Created by Apple on 16/8/17.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingController : UIViewController<UITableViewDataSource, UITableViewDelegate,UIGestureRecognizerDelegate>
@property UITableView* tableView;
@property UIView* cleanMask;
@property UIView* cleanPanel;
@property UIActivityIndicatorView* cleanLoad;
@property UIView* headerBg;
@property UILabel* titleLabel;
@property BOOL showClearFinish;
@property BOOL clearFinish;
@end
