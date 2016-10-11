//
//  MyCommentController.h
//  Jacob
//
//  Created by Apple on 16/9/20.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface MyCommentController : GAITrackedViewController<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;


@end
