//
//  CommentViewController.h
//  InternetStir
//
//  Created by Apple on 16/8/15.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentView.h"
#import "PNMoodView.h"
#import "DetailCommentItem.h"
@interface CommentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CommentViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, assign) int index;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CommentView *commentView;
@property (nonatomic, strong) NSMutableArray *commentData;
@property (nonatomic, strong) NSMutableArray *replyData;
@property (nonatomic, strong) DetailCommentItem *item;

@end
