
//
//  WriteArticleController.m
//  Jacob
//
//  Created by Apple on 16/9/21.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import "WriteArticleController.h"
#import "MMSystemHelper.h"
#import "AppStyleConfiguration.h"
#import "WriteArticleCell.h"
#import "ITSApplication.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "MMEventService.h"
#import "ConfigService.h"

#define screenW [MMSystemHelper getScreenWidth]
#define screenH [MMSystemHelper getScreenHeight]

NSString *const WriteArticleCellIdentifier = @"WriteArticleCell";

@interface WriteArticleController ()

@end

@implementation WriteArticleController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    UIButton* Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    Btn.frame = CGRectMake(0, 20, 15, 20);
    [Btn setBackgroundImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:Btn];
    self.navigationItem.leftBarButtonItem = left;
    
    UIButton* send = [UIButton buttonWithType:UIButtonTypeCustom];
    send.frame = CGRectMake(0, 20, 40, 20);
//    [send setTitle:@"發布" forState:UIControlStateNormal];
    [send setTitleColor:[MMSystemHelper string2UIColor:HOME_VIPNAME_COLOR] forState:UIControlStateNormal];
    [send addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:send];
    self.navigationItem.rightBarButtonItem = right;
    
    self.photo = [[UIImageView alloc] init];
    self.photo.frame = CGRectMake(25, 90, 50, 50);
    if (self.type == 1) {
        self.photo.image = [UIImage imageWithData:self.data];
        [send setTitle:@"發布" forState:UIControlStateNormal];
    }else {
        if (self.photoStr != nil) {
            self.photo.contentMode = UIViewContentModeScaleAspectFill;
            self.photo.layer.masksToBounds = YES;
            [self.photo sd_setImageWithURL:[NSURL URLWithString:self.photoStr] placeholderImage:[UIImage imageNamed:@"loader_post"] options:SDWebImageRefreshCached];
            [send setTitle:NSLocalizedString(@"save", nil) forState:UIControlStateNormal];
        }
    }
    [self.view addSubview:self.photo];
    
    self.textView = [[UITextView alloc] init];
    self.textView.frame = CGRectMake(85, 74, screenW - 100, 90);
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.delegate = self;
    self.textView.font = [UIFont systemFontOfSize:18];
    self.textView.returnKeyType = UIReturnKeyDone;//return键的类型
    self.textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    self.textView.textAlignment = NSTextAlignmentLeft; //文本显示的位置默认为居左
    self.textView.dataDetectorTypes = UIDataDetectorTypeAll; //显示数据类型的连接模式（如电话号码、网址、地址等）
    [self.view addSubview:self.textView];
    
    NSString *str;
    if (self.labelStr != nil) {
        str = self.labelStr;
    }else {
        str = NSLocalizedString(@"narrated_img", nil);
    }
    
    CGSize size = [MMSystemHelper sizeWithString:str font:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(MAXFLOAT, 30)];
    self.label = [[UILabel alloc] init];
    self.label.textColor = [MMSystemHelper string2UIColor:HOME_TIME_COLOR];
    self.label.frame = CGRectMake(90, 74, size.width, 30);
    self.label.text = str;
    self.label.font = [UIFont systemFontOfSize:16];
    self.label.enabled = NO;
    self.label.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.label];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 174, screenW, 3);
    bgView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [self.view addSubview:bgView];
    
    MMEventService* es = [MMEventService getInstance];
    [es addEventHandler:self eventName:EVENT_CELEB_COMMENT_UPLOAD_FILE_RESULT selector:@selector(celebUploadFileListener:)];
    [es addEventHandler:self eventName:EVENT_CELEB_COMMENT_SEND_RESULT selector:@selector(celebSendCommentsListener:)];
    [es addEventHandler:self eventName:EVENT_CELEB_COMMENT_UPDATE_RESULT selector:@selector(celebUpdateCommentsListener:)];
    
    
//    self.tableView = [[UITableView alloc] init];
//    self.tableView.frame = CGRectMake(0, 179, screenW, screenH - 179);
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    self.tableView.rowHeight = 50;
//    self.tableView.scrollEnabled = NO;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.view addSubview:self.tableView];
//    [self.tableView registerClass:[WriteArticleCell class] forCellReuseIdentifier:WriteArticleCellIdentifier];
}
#pragma mark TableViewDelegate
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    ITSApplication* itsApp = [ITSApplication get];
    DataService* ds = itsApp.dataSvr;
    NSMutableArray* menuList = [ds getWriteArticleMenuList];
    return menuList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:WriteArticleCellIdentifier forIndexPath:indexPath];
    ITSApplication* itsApp = [ITSApplication get];
    DataService* ds = itsApp.dataSvr;
    NSMutableArray* menuList = [ds getWriteArticleMenuList];
    WriteArticleMenuItem* menuItem = [menuList objectAtIndex:indexPath.row];

    if (cell == nil) {
        cell = [[WriteArticleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WriteArticleCellIdentifier];
    }
    WriteArticleCell *tmpCell = (WriteArticleCell*)cell;
    if (indexPath.row == 0 || indexPath.row == 1) {
        tmpCell.photo.hidden = NO;
    }else {
        tmpCell.switchView.hidden = NO;
        [tmpCell.switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        tmpCell.tag = indexPath.row;
    }
    tmpCell.icon.image = [UIImage imageNamed:menuItem.iconName];
    tmpCell.title.text = menuItem.actionName;
    tmpCell.photo.image = [UIImage imageNamed:menuItem.photo];
    return tmpCell;
}
- (void)switchAction:(id)sender {
    
}
#pragma mark TextViewDelegate
-(void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        
        self.label.text = NSLocalizedString(@"narrated_img", nil);
    }else {
        self.label.hidden = YES;
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)clickBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)sendClick {
    
    [self.textView resignFirstResponder];
    if (self.type == 1) {
        // 发送
        if (self.data != nil && self.textView.text.length > 0) {
            self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            [self.view addSubview:self.hud];
            self.hud.mode = MBProgressHUDModeIndeterminate;
            self.hud.label.text = NSLocalizedString(@"load_message", nil);
            self.hud.label.font = [UIFont systemFontOfSize:17];
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                ITSApplication* app = [ITSApplication get];
                NSString* fileName = app.dataSvr.selectUploadFile;
                [app.remoteSvr uploadFileToServer:fileName];
            });
//            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
//                [self doSomeWork];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self.hud hideAnimated:YES];
//                });
//            });
            
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"say_something", nil) message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
            [alert show];
        }
    }else {
        // 保存
        if (self.photoStr != nil && self.textView.text.length > 0) {
            self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            [self.view addSubview:self.hud];
            self.hud.mode = MBProgressHUDModeIndeterminate;
            self.hud.label.text = NSLocalizedString(@"load_message", nil);
            self.hud.label.font = [UIFont systemFontOfSize:17];
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                ITSApplication* app = [ITSApplication get];
                CelebComment* comment = app.dataSvr.selectUpdateComment;
                NSString* context = self.textView.text;
                
                //comment.attachments
                NSMutableArray* updateAttachments = [NSMutableArray arrayWithCapacity:1];
                for (int i = 0; i < [comment.attachments count]; i++) {
                    CelebAttachment* cbAtt = [comment.attachments objectAtIndex:i];
                    NSDictionary* tmp = [NSDictionary dictionaryWithObjectsAndKeys:cbAtt.fd, @"fd",
                                         [[NSNumber alloc] initWithInteger:cbAtt.w], @"width",
                                         [[NSNumber alloc] initWithInteger:cbAtt.h], @"height",nil];
                    [updateAttachments addObject:tmp];
                }
                
                [app.remoteSvr celebUpdateComment:comment.fid context:context attachment:updateAttachments];
            });
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"say_something", nil) message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
            [alert show];
        }
        
    }
}
- (void)doSomeWork {
    // Simulate by just waiting.
    sleep(3.);
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

-(void)celebUploadFileListener: (id) data{
    if (data != nil && [data isKindOfClass:[NSMutableDictionary class]]){
        NSDictionary* dic = (NSDictionary*)data;
        NSNumber* tmpNum = [dic objectForKey:@"success"];
        NSString* fd = [dic objectForKey:@"fd"];
        NSNumber* fileW = [dic objectForKey:@"width"];
        NSNumber* fileH = [dic objectForKey:@"height"];
        BOOL succ = [tmpNum boolValue];
        if (YES == succ && nil != fd){
            // del cache file
            ITSApplication* app = [ITSApplication get];
            NSString* fileName = app.dataSvr.selectUploadFile;
            ConfigService* cs = [ConfigService get];
            NSString* cacheFolder = [cs getCelebCacheFolder];
            NSString* filePath = [NSString stringWithFormat:@"%@/%@", cacheFolder, fileName];
            [MMSystemHelper removeFileForDir:filePath];
            
            // send to server comment
            NSString* context = self.textView.text;
            NSMutableDictionary* cbAtt = [NSMutableDictionary dictionaryWithCapacity:1];
            [cbAtt setValue:fd forKey:@"fd"];
            [cbAtt setValue:fileW forKey:@"width"];
            [cbAtt setValue:fileH forKey:@"height"];
            
            NSArray* attachment = [[NSArray alloc] initWithObjects:cbAtt, nil];
            [app.remoteSvr celebSendComment:context attachment:attachment];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.hud hideAnimated:YES];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"發文失敗" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
                [alert show];
            });
        }
    }
}

-(void)celebSendCommentsListener: (id) data{
    if (data != nil){
        NSString* ret = (NSString*)data;
        if ([ret isEqualToString:CELEB_SEND_COMMENT_SUCCESS]){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.hud hideAnimated:YES];
                
                [[self navigationController] popViewControllerAnimated:YES];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.hud hideAnimated:YES];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"發文失敗" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
                [alert show];
            });

        }
    }
}


-(void)celebUpdateCommentsListener: (id) data{
    if (data != nil){
        NSString* ret = (NSString*)data;
        if ([ret isEqualToString:CELEB_SUCCESS]){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.hud hideAnimated:YES];
                
                [[self navigationController] popViewControllerAnimated:YES];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.hud hideAnimated:YES];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"儲存失敗" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
                [alert show];
            });
            
        }
    }
}


@end
