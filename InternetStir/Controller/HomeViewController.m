
//
//  HomeViewController.m
//  InternetStir
//
//  Created by Apple on 16/8/18.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import "HomeViewController.h"
#import "MenuViewController.h"
#import "MMSystemHelper.h"
#import "HomeCommentCell.h"
#import "CommentViewController.h"
#import "UUInputAccessoryView.h"
#import "ITSAppConst.h"
#import "CommentFrame.h"
#import "AppStyleConfiguration.h"
#import "TestController.h"
#import "ITSApplication.h"
//#import "DetailCommentController.h"
#import "SettingService.h"
#import "WriteArticleController.h"
#import "ErrorController.h"
#import "MJRefresh.h"
#import "MMEventService.h"
#import "ConfigService.h"

#define screenW [MMSystemHelper getScreenWidth]
#define screenH [MMSystemHelper getScreenHeight]

NSString *const HomeCommentCellIdentifier = @"HomeCommentCell";
#define  WEAKSELF  __weak typeof(self) weakSelf = self;

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.screenName = @"comment";
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, 0, screenW, screenH);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[HomeCommentCell class] forCellReuseIdentifier:HomeCommentCellIdentifier];
    [self.view addSubview:self.tableView];

    NSString *str = @"Content with Facebook";
    CGSize size = [MMSystemHelper sizeWithString:str font:[UIFont systemFontOfSize:18] maxSize:CGSizeMake(MAXFLOAT, 45)];
    CGFloat width = size.width + 30 + 10 + 60;

    self.loginView = [[LoginView alloc] initWithFrame:CGRectMake(0, 0, width, 190)viewController:self];
    self.loginView.backgroundColor = [UIColor whiteColor];
    self.loginView.layer.masksToBounds = YES;
    self.loginView.layer.cornerRadius = 10;
    self.loginView.center = self.view.center;
    [self.loginView.effectView addSubview:self.loginView];
    
    [self setupRefresh];
    
    MMEventService* es = [MMEventService getInstance];
    [es addEventHandler:self eventName:EVENT_CELEB_COMMENT_DATA_REFRESH selector:@selector(celebCommentsDataRefreshListener:)];
    
    ITSApplication* poApp = [ITSApplication get];
    NSMutableDictionary* eParams = [NSMutableDictionary dictionaryWithCapacity:1];
    [poApp.reportSvr recordEvent:@"comment" params:eParams eventCategory:@"tabbar.click"];
}
- (void)passMessage {
    
    ITSApplication* itsApp = [ITSApplication get];
    CBUserService* us = itsApp.cbUserSvr;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (us.user.isCBADM == YES) {
            self.Btn.frame = CGRectMake(0, 20, 25, 23);
            [self.Btn setTitle:@"" forState:UIControlStateNormal];
            [self.Btn setBackgroundImage:[UIImage imageNamed:@"camera [#952]"] forState:UIControlStateNormal];
        }else {
            [self.Btn setTitle:@"" forState:UIControlStateNormal];
        }
    });
}

-(void)celebCommentsDataRefreshListener: (id) data{
    if (self.view.hidden == NO){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ITSApplication* itsApp = [ITSApplication get];
            NSArray* dataArr = itsApp.dataSvr.celebComments;
            
            for (NSInteger i = 0; i < dataArr.count; i++) {
                CelebComment *comment = [dataArr objectAtIndex:i];
                HomeCommentFrame *frame = [[HomeCommentFrame alloc] init];
                [frame initWithCommentData:comment];
                comment.uiFrame = frame;
            }
            
            [self.tableView reloadData];
            
            [self.tableView footerEndRefreshing];
            [self.tableView headerEndRefreshing];
            //ITSApplication* itsApp = [ITSApplication get];
            //[itsApp.reportSvr recordCategory:self.cid];
            
            // report event
//            NSMutableDictionary* eParams = [NSMutableDictionary dictionaryWithCapacity:1];
//            [eParams setObject:self.cid forKey:@"id"];
//            NewsCategory* cate = [poApp.dataSvr getCategoryByID:self.cid];
//            if (cate != nil) {
//                [eParams setObject:cate.name forKey:@"name"];
//                if (self.refreshType == NEWS_REFRESH_TYPE_BEFORE){
//                    [poApp.reportSvr recordEndTimedEvent:@"news.list.prev" params:eParams];
//                } else {
//                    [poApp.reportSvr recordEndTimedEvent:@"news.list.next" params:eParams];
//                }
//            }
            self.isRefreshing = NO;
        });
    }
}

- (void)setupRefresh
{
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    self.tableView.headerPullToRefreshText = NSLocalizedString(@"Pull2Load", STR_PULL_REFRESH_PULL);
    self.tableView.headerReleaseToRefreshText = NSLocalizedString(@"Release2Refresh", STR_PULL_REFRESH_RELEASE);
    self.tableView.headerRefreshingText = NSLocalizedString(@"Loading", STR_PULL_REFRESH_LOADING);
    
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    self.tableView.footerPullToRefreshText = NSLocalizedString (@"Pull2Load", STR_PULL_REFRESH_PULL);
    self.tableView.footerReleaseToRefreshText = NSLocalizedString(@"Release2Refresh", STR_PULL_REFRESH_RELEASE);
    self.tableView.footerRefreshingText = NSLocalizedString(@"Loading", STR_PULL_REFRESH_LOADING);
}
#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    ITSApplication* poApp = [ITSApplication get];
    NSMutableDictionary* eParams = [NSMutableDictionary dictionaryWithCapacity:1];
    [poApp.reportSvr recordEvent:@"list.loading.up" params:eParams eventCategory:@"comment.view"];
    
    if (self.isRefreshing == NO){
        self.refreshType = CB_COMMENT_REFRESH_TYPE_AFTER;
        ITSApplication* itsApp = [ITSApplication get];
        DataService* ds = itsApp.dataSvr;
        [ds refreshCelebComments:CB_COMMENT_REFRESH_TYPE_AFTER];
        
//        NSMutableDictionary* eParams = [NSMutableDictionary dictionaryWithCapacity:1];
//        [eParams setObject:self.cid forKey:@"id"];
//        NewsCategory* cate = [poApp.dataSvr getCategoryByID:self.cid];
//        [eParams setObject:cate.name forKey:@"name"];
//        [poApp.reportSvr recordEvent:cate.name params:eParams timed:YES eventCategory:@"news.list.next"];
        
        self.isRefreshing = YES;
    }
    //self.goTopButton.hidden = YES;
}


- (void)footerRereshing
{
    
    ITSApplication* poApp = [ITSApplication get];
    NSMutableDictionary* eParams = [NSMutableDictionary dictionaryWithCapacity:1];
    [poApp.reportSvr recordEvent:@"list.loading.down" params:eParams eventCategory:@"comment.view"];

    if (self.isRefreshing == NO){
        self.refreshType = CB_COMMENT_REFRESH_TYPE_BEFORE;
        ITSApplication* itsApp = [ITSApplication get];
        DataService* ds = itsApp.dataSvr;
        [ds refreshCelebComments:CB_COMMENT_REFRESH_TYPE_BEFORE];
        self.isRefreshing = YES;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height;
#ifdef DEMO_DATA
    HomeCommentFrame *frame = self.commentData[indexPath.row];
    height = frame.cellHeight;
#else
    
    ITSApplication* itsApp = [ITSApplication get];
    NSArray* dataArr = itsApp.dataSvr.celebComments;
    if (dataArr != nil){
        CelebComment* cbComment = [dataArr objectAtIndex:indexPath.row];
        height = cbComment.uiFrame.cellHeight;
//        if (cbComment.uiFrame == nil){
//            HomeCommentFrame* frame = [HomeCommentFrame alloc];
//            [frame initWithCommentData:cbComment];
//            cbComment.uiFrame = frame;
//            height = frame.cellHeight;
//        }
    }
#endif
    return height;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

#ifdef DEMO_DATA
    return self.commentData.count;
#else
    
    ITSApplication* itsApp = [ITSApplication get];
    NSArray* dataArr = itsApp.dataSvr.celebComments;
    NSInteger count = 0;
    if (dataArr != nil)
        count = [dataArr count];
    
    return count;
#endif
    
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:HomeCommentCellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[HomeCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HomeCommentCellIdentifier];
    }
    HomeCommentCell *tmpCell = (HomeCommentCell*)cell;
    
#ifdef DEMO_DATA
    tmpCell.commentFrame = self.commentData[indexPath.row];
#else
    ITSApplication* itsApp = [ITSApplication get];
    NSArray* dataArr = itsApp.dataSvr.celebComments;
    CelebComment *item = [dataArr objectAtIndex:indexPath.row];
    
    if (dataArr != nil){
        CelebComment* cbComment = [dataArr objectAtIndex:indexPath.row];
        HomeCommentFrame* frame = [HomeCommentFrame alloc];
        [frame initWithCommentData:cbComment];
        cbComment.uiFrame = frame;

        [tmpCell setShowData:cbComment];
        tmpCell.commentFrame = cbComment.uiFrame;
    }
#endif
    SettingService* ss = [SettingService get];
    BOOL isFav = [ss getBooleanValue:item.fid defValue:NO];

    if (isFav == YES) {
        //        self.zanImageView.image = self.zanImage;
        [tmpCell.favBtn setBackgroundImage:[UIImage imageNamed:@"like_slected"] forState:UIControlStateNormal];
    }else{
        [tmpCell.favBtn setBackgroundImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    }
    
    tmpCell.button.tag = indexPath.row;
    [tmpCell.button addTarget:self action:@selector(pushComment:) forControlEvents:UIControlEventTouchUpInside];
    [tmpCell.commentBtn addTarget:self action:@selector(pushNextVc:) forControlEvents:UIControlEventTouchUpInside];
    tmpCell.commentBtn.tag = indexPath.row;
//    [tmpCell.btn addTarget:self action:@selector(pushDetailVc:) forControlEvents:UIControlEventTouchUpInside];
    [tmpCell.favBtn addTarget:self action:@selector(favBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    tmpCell.favBtn.tag = indexPath.row;
    [tmpCell.shareBtn addTarget:self action:@selector(shareBtn:) forControlEvents:UIControlEventTouchUpInside];
    tmpCell.shareBtn.tag = indexPath.row;
    tmpCell.btn.tag = indexPath.row;
    [tmpCell.delBtn addTarget:self action:@selector(pushSheet:) forControlEvents:UIControlEventTouchUpInside];
    tmpCell.delBtn.tag = indexPath.row;
    for (int i = 0; i < [tmpCell.replysView count]; i++) {
        ((UILabel *)[tmpCell.replysView objectAtIndex:i]).frame = [(NSValue *)[tmpCell.commentFrame.replysF objectAtIndex:i] CGRectValue];
        tmpCell.replyLabel = [tmpCell.replysView objectAtIndex:i];
        tmpCell.replyLabel.userInteractionEnabled = YES;
    }
    
    return cell;
}
- (void)pushSheet:(UIButton *)button {
    
    self.index = button.tag;
     self.sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"set_cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"set_top", nil),NSLocalizedString(@"set_editor", nil),NSLocalizedString(@"set_delete", nil), nil];
    self.sheet.tag = 80;
    [self.sheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
   

    WEAKSELF
    if (actionSheet.tag == 80) {
        
        ITSApplication* itsApp = [ITSApplication get];
        NSArray* dataArr = itsApp.dataSvr.celebComments;
        CelebComment *item = [dataArr objectAtIndex:self.index];

        NSString* fileBaseUrl = [itsApp.remoteSvr getBaseFileUrl];
        //NSString* image = [item.attachments objectAtIndex:0];
        CelebAttachment* cbAtt = [item.attachments objectAtIndex:0];
        NSString* image = cbAtt.fd;
        NSString* imageUrl = [[NSString alloc] initWithFormat:@"%@/%@", fileBaseUrl, image];
        
        if (buttonIndex == 0) {
            
        }else if (buttonIndex == 1) {
            itsApp.dataSvr.selectUpdateComment = item;
            
            WriteArticleController *vc = [[WriteArticleController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.type = 2;
            vc.photoStr = imageUrl;
            vc.labelStr = item.context;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (buttonIndex == 2) {
            itsApp.dataSvr.selectUpdateComment = item;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"set_delete", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"set_cancel", nil) otherButtonTitles:NSLocalizedString(@"sure", nil), nil];
            alert.tag = 1001;
            [alert show];
        }
    }else {
        if (buttonIndex == 0) {
            [[PickerImageTools ShareInstance] selectImageToolsWith:weakSelf];
        }else if (buttonIndex == 1) {
            [[PickerImageTools ShareInstance] selectPhotograph:weakSelf];
        }
        [PickerImageTools ShareInstance].pickerImageCameraBlock = ^(NSData *pickerImage){
            WriteArticleController *vc = [[WriteArticleController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.type = 1;
            // 1 在 document 下面创建目录  celebcache
            /*
             2 把图片的uiimage 对象转存为 图片文件，名称用 md5
             3 上传
             */
            ConfigService* cs = [ConfigService get];
            NSString* celebCacheFolder = [cs getCelebCacheFolder];
    
            NSString *encodedImageStr = [pickerImage base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            NSString *name = [NSString stringWithFormat:@"%@.jpg", [MMSystemHelper getMd5String:encodedImageStr]];
            [MMSystemHelper writeImage:[UIImage imageWithData:pickerImage] toFileAtPath:[NSString stringWithFormat:@"%@/%@",celebCacheFolder,name]];
            
            ITSApplication* app = [ITSApplication get];
            app.dataSvr.selectUploadFile = name;
            
            vc.data = pickerImage;
            [self.navigationController pushViewController:vc animated:YES];
        };
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1001){
        if (buttonIndex == 1) {
            ITSApplication* itsApp = [ITSApplication get];
            if (itsApp.dataSvr.selectUpdateComment != nil){
                [itsApp.remoteSvr celebRemoveComment:itsApp.dataSvr.selectUpdateComment.fid];
                itsApp.dataSvr.selectUpdateComment = nil;
            }
        }
    }
}

- (void)shareBtn: (UIButton *)button {
    
    ITSApplication* itsApp = [ITSApplication get];
    NSArray* dataArr = itsApp.dataSvr.celebComments;
    CelebComment *item = [dataArr objectAtIndex:button.tag];
    NSString *content = item.context;
    
    NSMutableDictionary* eParams = [NSMutableDictionary dictionaryWithCapacity:1];
    [eParams setObject:@"forumid" forKey:@"fid"];
    [eParams setObject:content forKey:@"context"];
    [itsApp.reportSvr recordEvent:@"share" params:eParams eventCategory:@"comment.click"];
}
- (void)favBtnClick:(UIButton *)button {
    
    HomeCommentCell *cell = (HomeCommentCell *)button.superview.superview;
    ITSApplication* poApp = [ITSApplication get];

    NSArray* dataArr = poApp.dataSvr.celebComments;
    CelebComment *item = [dataArr objectAtIndex:button.tag];
    NSString *content = item.context;

    SettingService* ss = [SettingService get];
    BOOL isFav = [ss getBooleanValue:item.fid defValue:NO];
    ITSApplication* itsApp = [ITSApplication get];
    CBUserService* us = itsApp.cbUserSvr;
    if (us.user.isLogin == NO) {
        [UIView animateWithDuration:0.5 animations:^{
            self.loginView.effectView.alpha = 1;
        }];
    }else {
        // fav
        if (isFav == NO) {
            item.likes ++;
            cell.likeNum.text = [NSString stringWithFormat:@"%ld",item.likes];
            [cell.favBtn setBackgroundImage:[UIImage imageNamed:@"like_slected"] forState:UIControlStateNormal];
            cell.commentFrame.commentItem.isFavour = YES;
            [ss setBooleanValue:item.fid data:YES];
            NSMutableDictionary* eParams = [NSMutableDictionary dictionaryWithCapacity:1];
            [eParams setObject:@"forumid" forKey:@"fid"];
            [eParams setObject:content forKey:@"context"];
            [poApp.reportSvr recordEvent:@"+heart" params:eParams eventCategory:@"comment.click"];
            
            [poApp.remoteSvr userLike:item.fid ];
        }else {
            item.likes--;
            cell.likeNum.text = [NSString stringWithFormat:@"%ld",item.likes];
            [cell.favBtn setBackgroundImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
            cell.commentFrame.commentItem.isFavour = YES;
            [ss setBooleanValue:item.fid data:NO];
            [poApp.remoteSvr userUnlike:item.fid ];
            NSMutableDictionary* eParams = [NSMutableDictionary dictionaryWithCapacity:1];
            [eParams setObject:@"forumid" forKey:@"fid"];
            [eParams setObject:content forKey:@"context"];
            [poApp.reportSvr recordEvent:@"-heart" params:eParams eventCategory:@"comment.click"];
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    DetailCommentController *vc = [[DetailCommentController alloc] init];
//    HomeCommentFrame *frame = self.commentData[indexPath.row];
//    vc.headHeight = frame.headH;
//    vc.item = frame.commentItem;
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
}
//- (void)pushDetailVc:(UIButton *)button {
//#ifdef DEMO_DATA
//    DetailCommentController *detail = [[DetailCommentController alloc] init];
//    HomeCommentFrame *frame = self.commentData[button.tag];
//    detail.hidesBottomBarWhenPushed = YES;
//    detail.index = button.tag;
//    detail.headHeight = frame.headH;
//    detail.item = frame.commentItem;
//    [self.navigationController pushViewController:detail animated:YES];
//#else
//    
//    ITSApplication* itsApp = [ITSApplication get];
//    NSArray* dataArr = itsApp.dataSvr.celebComments;
//    
//    if (dataArr != nil){
//        CelebComment* cbComment = [dataArr objectAtIndex:button.tag];
//        [itsApp.dataSvr setCurrentCelebComment:cbComment];
//        DetailCommentController *detail = [[DetailCommentController alloc] init];
//        detail.hidesBottomBarWhenPushed = YES;
//        detail.headHeight = cbComment.uiFrame.headH;
//        [self.navigationController pushViewController:detail animated:YES];
//    }
//    
//#endif
//}
- (void)pushNextVc:(UIButton *)button{
    ITSApplication* itsApp = [ITSApplication get];
    NSArray* dataArr = itsApp.dataSvr.celebComments;
    CelebComment *item = [dataArr objectAtIndex:button.tag];
    NSString *content = item.context;

    NSMutableDictionary* eParams = [NSMutableDictionary dictionaryWithCapacity:1];
    [eParams setObject:@"forumid" forKey:@"fid"];
    [eParams setObject:content forKey:@"context"];
    [itsApp.reportSvr recordEvent:@"reply" params:eParams eventCategory:@"comment.click"];
    
    CBUserService* us = itsApp.cbUserSvr;
    if (us.user.isLogin == NO) {
        [UIView animateWithDuration:0.5 animations:^{
            self.loginView.effectView.alpha = 1;
        }];
    }else {
#ifdef DEMO_DATA
        CommentViewController *vc = [[CommentViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.index = button.tag;
        vc.type = 1;
        [self.navigationController pushViewController:vc animated:YES];
#else
        ITSApplication* itsApp = [ITSApplication get];
        NSArray* dataArr = itsApp.dataSvr.celebComments;
        
        if (dataArr != nil){
            CelebComment* cbComment = [dataArr objectAtIndex:button.tag];
            [itsApp.dataSvr setCurrentCelebComment:cbComment];
            CommentViewController *vc = [[CommentViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.index = button.tag;
            vc.type = 1;
            vc.context = cbComment.context;
            [self.navigationController pushViewController:vc animated:YES];
        }
#endif
    }
}
//more
- (void)pushComment:(UIButton*)button{
    ITSApplication* itsApp = [ITSApplication get];
    CBUserService* us = itsApp.cbUserSvr;
    
    NSArray* dataArr = itsApp.dataSvr.celebComments;
    CelebComment *item = [dataArr objectAtIndex:button.tag];
    NSString *content = item.context;
    
    NSMutableDictionary* eParams = [NSMutableDictionary dictionaryWithCapacity:1];
    [eParams setObject:@"forumid" forKey:@"fid"];
    [eParams setObject:content forKey:@"context"];
    [itsApp.reportSvr recordEvent:@"more" params:eParams eventCategory:@"comment.click"];

    
    if (us.user.isLogin == NO) {
        [UIView animateWithDuration:0.5 animations:^{
            self.loginView.effectView.alpha = 1;
        }];
    }else {
#ifdef DEMO_DATA
        CommentViewController *vc = [[CommentViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.index = button.tag;
        vc.type = 2;
        [self.navigationController pushViewController:vc animated:YES];
    
#else
        ITSApplication* itsApp = [ITSApplication get];
        NSArray* dataArr = itsApp.dataSvr.celebComments;
        
        if (dataArr != nil){
            CelebComment* cbComment = [dataArr objectAtIndex:button.tag];
            [itsApp.dataSvr setCurrentCelebComment:cbComment];
            CommentViewController *vc = [[CommentViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.index = button.tag;
            vc.context = cbComment.context;
            vc.type = 2;
            [self.navigationController pushViewController:vc animated:YES];
        }
#endif
    }
}
- (void)tapReply:(UIButton *)button{
    
//    CommentViewController *vc = [[CommentViewController alloc] init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    
//    [UUInputAccessoryView showKeyboardType:UIKeyboardTypeDefault
//                                   content:@""
//                                      name:@""
//                                     Block:^(NSString *contentStr)
//     {
//         
//         
//         
//     }];
}

#ifdef DEMO_DATA
-(NSMutableArray *)commentData
{
    if (!_commentData) {
        SettingService* ss = [SettingService get];

        NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"FamilyGroup.plist" ofType:nil];
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:fullPath];
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:[dictArray count]];
        NSInteger count = 0;
        for (NSDictionary *dict in dictArray) {
            HomeCommentItem *commentItem = [[HomeCommentItem alloc] init];
            HomeCommentFrame *commentFrame = [[HomeCommentFrame alloc]init];
            commentItem.replys = [[NSMutableArray alloc] init];
            commentItem.name = [dict objectForKey:@"name"];
            commentItem.icon = [dict objectForKey:@"icon"];
            commentItem.pictures = [dict objectForKey:@"pictures"];
            commentItem.shuoshuoText = [dict objectForKey:@"shuoshuoText"];
            commentItem.time = [dict objectForKey:@"time"];
            NSMutableArray *reply = [dict objectForKey:@"replys"];
            for (NSDictionary *dic in reply) {
                ReplyItem *item = [[ReplyItem alloc] init];
                item.name = [dic objectForKey:@"name"];
                item.comment = [dic objectForKey:@"comment"];
                item.icon = [dic objectForKey:@"icon"];
                [item setValuesForKeysWithDictionary:dic];
                commentItem.item = item;
                [commentItem.replys addObject:item];
            }
            commentFrame.commentItem = commentItem;
            commentItem.isFavour = [ss getBooleanValue:[NSString stringWithFormat:@"%ld",count++] defValue:NO];

            [models addObject:commentFrame];
        }
        _commentData = [models copy];
    }
    return _commentData;
}
#endif

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    ITSApplication* poApp = [ITSApplication get];
    NSMutableDictionary* eParams = [NSMutableDictionary dictionaryWithCapacity:1];
    [poApp.reportSvr recordEvent:@"list" params:eParams eventCategory:@"comment.view"];
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:[MMSystemHelper string2UIColor:HOME_COMMENT_COLOR]}];
    self.Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.Btn.frame = CGRectMake(0, 20, 25, 23);
    [self.Btn setTitleColor:[MMSystemHelper string2UIColor:HOME_VIPNAME_COLOR] forState:UIControlStateNormal];
    [self.Btn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    
    ITSApplication* itsApp = [ITSApplication get];
    CBUserService* us = itsApp.cbUserSvr;
    
    if (us.user.isCBADM == YES) {
        [self.Btn setBackgroundImage:[UIImage imageNamed:@"camera [#952]"] forState:UIControlStateNormal];
    }else {
        self.Btn.frame = CGRectMake(0, 20, 50, 30);
        if (us.user.isLogin == NO) {
            [self.Btn setTitle:NSLocalizedString(@"login_in", nil) forState:UIControlStateNormal];
        }
    }
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:self.Btn];
    self.navigationItem.rightBarButtonItem = right;
    
    if (itsApp.dataSvr.celebComments == nil){
        [self headerRereshing];
        //[self.tableView headerBeginRefreshing];
    }
    [self.tableView reloadData];
    //[itsApp.dataSvr refreshCelebComments:NEWS_REFRESH_TYPE_BEFORE];

}
- (void)login {
    ITSApplication* itsApp = [ITSApplication get];
    CBUserService* us = itsApp.cbUserSvr;
    if (us.user.isCBADM == YES) {
        self.photoSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"set_cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"take_photo", nil),NSLocalizedString(@"select_photo", nil), nil];
        [self.photoSheet showInView:self.view];

    }else {
        if (us.user.isLogin == NO) {
            [UIView animateWithDuration:0.5 animations:^{
                self.loginView.effectView.alpha = 1;
            }];
        }
    }
//
//    ErrorController *error = [[ErrorController alloc] init];
//    error.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:error animated:YES];
//
}
- (void)push {
    
    TestController *test = [[TestController alloc] init];
    [self.navigationController pushViewController:test animated:YES];
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
