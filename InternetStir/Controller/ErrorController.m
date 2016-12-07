

//
//  ErrorController.m
//  Jacob
//
//  Created by Apple on 16/9/23.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import "ErrorController.h"
#import "MMSystemHelper.h"
#import "AppStyleConfiguration.h"
#import "ITSApplication.h"

#define screenW [MMSystemHelper getScreenWidth]
#define screenH [MMSystemHelper getScreenHeight]

@interface ErrorController ()

@end

@implementation ErrorController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Err", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;

    UIImageView *tomoto = [[UIImageView alloc] init];
    tomoto.frame = CGRectMake(screenW/2 - 100, screenH/2 - 150, 200, 200);
    tomoto.image = [UIImage imageNamed:@"P119_emptypage_error"];
    [self.view addSubview:tomoto];
    
    CGSize size = [MMSystemHelper sizeWithString:NSLocalizedString(@"NetErr", nil) font:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(screenW - 20, MAXFLOAT)];
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(10, screenH/2 + 50, screenW - 20, size.height);
    label.text = NSLocalizedString(@"NetErr", nil);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:label];
    
    CGSize btnSize = [MMSystemHelper sizeWithString:NSLocalizedString(@"Reconnect", nil) font:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    self.button.frame = CGRectMake(screenW/2 - btnSize.width/2, screenH/2 + 50 + size.height + 10, btnSize.width, btnSize.height);
    [self.button setTitle:NSLocalizedString(@"Reconnect", nil) forState:UIControlStateNormal];
    [self.button setTitleColor:[MMSystemHelper string2UIColor:HOME_VIPNAME_COLOR] forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    self.button.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:self.button];
    
}
- (void)btnClick {
    
    ITSApplication* itsApp = [ITSApplication get];
    DataService* ds = itsApp.dataSvr;
    if (self.type == 2) {
        [itsApp.remoteSvr replayFansComment:self.fid replayCommendId:self.cid comment:self.content callback:^(int status, int code, NSDictionary *resultData) {
            if (resultData != nil){
                NSNumber* retNum = [resultData objectForKey:@"success"];
                if (retNum != nil){
                    BOOL ret = [retNum boolValue];
                    if (ret == YES){
                        CelebUser* user = itsApp.cbUserSvr.user;
                        FansComment* sendComment = [FansComment alloc];
                        sendComment.name = user.userName;
                        sendComment.avator = user.avatar;
                        sendComment.comment = self.content;
                        NSString* retuuid = [resultData objectForKey:@"uuid"];
                        NSString* retfid = [resultData objectForKey:@"fid"];
                        NSString* retcid = [resultData objectForKey:@"cid"];
                        NSString* retrid = [resultData objectForKey:@"rid"];
                        sendComment.uuid = retuuid;
                        sendComment.fid = retfid;
                        sendComment.cid = retcid;
                        sendComment.rid = retrid;
                        sendComment.pts = [MMSystemHelper getMillisecondTimestamp];
                        sendComment.uts = sendComment.pts;
                        
                        [ds userInsertCurrentReplyCommentItem:sendComment];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.navigationController popViewControllerAnimated:YES];
                        });

                    }
                }
            }
        }];
    }else if (self.type == 1) {
        [itsApp.remoteSvr replayCelebComment:self.fid comment:self.content callback:^(int status, int code, NSDictionary *resultData) {
            
            if (resultData != nil){
                NSNumber* retNum = [resultData objectForKey:@"success"];
                if (retNum != nil){
                    BOOL ret = [retNum boolValue];
                    if (ret == YES){
                        CelebUser* user = itsApp.cbUserSvr.user;
                        FansComment* sendComment = [FansComment alloc];
                        sendComment.name = user.userName;
                        sendComment.avator = user.avatar;
                        sendComment.comment = self.content;
                        NSString* retuuid = [resultData objectForKey:@"uuid"];
                        NSString* retfid = [resultData objectForKey:@"fid"];
                        NSString* retcid = [resultData objectForKey:@"cid"];
                        
                        sendComment.uuid = retuuid;
                        sendComment.fid = retfid;
                        sendComment.cid = retcid;
                        sendComment.pts = [MMSystemHelper getMillisecondTimestamp];
                        sendComment.uts = sendComment.pts;
                        
                        CommentFrame* frame = [CommentFrame alloc];
                        [frame initWithCommentData:sendComment];
                        sendComment.uiFrame = frame;
                    
                        [ds userInsertCurrentReplyCommentItem:sendComment];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.navigationController popViewControllerAnimated:YES];
                        });
                    }
                }
            }
        }];
    }
}
- (void)clickBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:[UIColor grayColor]}];
    UIButton* Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    Btn.frame = CGRectMake(0, 20, 15, 20);
    [Btn setBackgroundImage:[UIImage imageNamed:@"icon"] forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(Back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:Btn];
    self.navigationItem.leftBarButtonItem = left;

}
- (void)Back {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
