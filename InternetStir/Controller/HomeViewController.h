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
#import "FacebookService.h"
#import "ITSAppConst.h"
#import "GAITrackedViewController.h"

@interface HomeViewController : GAITrackedViewController<FacebookDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
@property (nonatomic, strong) UITableView *tableView;
#ifdef DEMO_DATA
@property (nonatomic,strong)NSMutableArray *commentData;
#endif
//@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, strong) LoginView *loginView;
@property (nonatomic, strong) UIButton* Btn;

@property (nonatomic, strong) UIActionSheet *photoSheet;
@property (nonatomic, strong) UIActionSheet *sheet;

@property (nonatomic, assign) NSInteger index;//编辑的第几行的文章

@property (assign) int refreshType;
@property (assign) BOOL isRefreshing;

@end
