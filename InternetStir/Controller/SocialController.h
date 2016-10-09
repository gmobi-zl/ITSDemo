//
//  SocialController.h
//  InternetStir
//
//  Created by Apple on 16/8/18.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "MMTabPagerView.h"
#import "GAITrackedViewController.h"

@interface SocialController : GAITrackedViewController<WKNavigationDelegate,WKUIDelegate,WKNavigationDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSArray *urlArr;
@property (nonatomic, strong) UIButton *btn;

@end
