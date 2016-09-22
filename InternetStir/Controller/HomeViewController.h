//
//  HomeViewController.h
//  InternetStir
//
//  Created by Apple on 16/8/18.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginView.h"
#import "PickerImageTools.h"

@interface HomeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *commentData;
@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, strong) LoginView *loginView;
@property (nonatomic, strong) UIButton* Btn;

@property (nonatomic, strong) UIActionSheet *photoSheet;
@property (nonatomic, strong) UIActionSheet *sheet;

@end
