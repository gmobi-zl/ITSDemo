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
#import "CommentItem.h"
#import "GAITrackedViewController.h"
#import "LoginView.h"
#import "CommentCell.h"
@interface CommentViewController : GAITrackedViewController<UITableViewDataSource,UITableViewDelegate,CommentViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ViewCellDelegate,TQRichTextViewDelegate>
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CommentView *commentView;
#ifdef DEMO_DATA
@property (nonatomic, strong) NSMutableArray *commentData;
@property (nonatomic, strong) NSMutableArray *replyData;
@property (nonatomic, strong) CommentItem *item;
#endif
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *context;
@property (nonatomic, assign) int page;

@property (assign) int refreshType;
@property (assign) BOOL isRefreshing;
@property (nonatomic, strong) LoginView *loginView;

@property (nonatomic, assign) CGFloat replyViewDraw;
//@property (assign) BOOL isTrackComment;

@property NSThread* checkReadThread;
@property (nonatomic, strong) NSMutableArray *currentShowItem;
@property (nonatomic, assign) UInt64 currentShowDataCount;
@property (nonatomic, assign) NSUInteger sleepTimeCount;
@property (nonatomic, assign) NSUInteger readZeroCount;


@end
