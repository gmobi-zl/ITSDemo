//
//  DetailCommentController.h
//  Jacob
//
//  Created by Apple on 16/9/18.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeCommentItem.h"
#import "HeadView.h"
#import "DetailCommentFrame.h"
#import "CommentView.h"

@interface DetailCommentController : UIViewController<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,CommentViewDelegate>

@property (nonatomic, strong) CommentView *commentView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *commentData;
@property (assign) CGFloat headHeight;
@property (nonatomic, strong) HeadView *headView;
@property (nonatomic, strong) HomeCommentItem *item;
@property (nonatomic, assign) NSInteger index;
@end
