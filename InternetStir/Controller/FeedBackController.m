//
//  FeedBackController.m
//  PoPoNews
//
//  Created by apple on 15/6/10.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedBackController.h"
#import "ConfigService.h"
#import "MMSystemHelper.h"
#import "ITSApplication.h"
#import "AppStyleConfiguration.h"
//#import "WKAlertView.h"

static int height;
@implementation FeedBackController

-(void) viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    sel.screenName = @"me";
    [self initViews];
    UIButton* Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    Btn.frame = CGRectMake(0, 20, 15, 20);
    [Btn setBackgroundImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:Btn];
    self.navigationItem.leftBarButtonItem = left;

}
-(void) clickBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) initViews{
    self.headerBg = [[UIView alloc] init];
    //self.headerBg.backgroundColor = [UIColor redColor];
    
    ConfigService* cs = [ConfigService get];
    CGFloat screenTitleBarH = [MMSystemHelper getStatusBarHeight];
    CGFloat screenW = [MMSystemHelper getScreenWidth];
    CGFloat screenH = [MMSystemHelper getScreenHeight];
    CGFloat headerHeight = [cs getPopoNewsHeaderBgHeight];
    self.headerBg.frame = CGRectMake(0, 0, screenW, headerHeight + screenTitleBarH);
    
//    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, -20, screenW, 20)];
//    [self.navigationController.navigationBar addSubview:statusBarView];

    NSString *str = ITS_NSLocalizedString(@"SettingFeedBack",nil);
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGRect rect = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    
    UIButton* backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 20, 60 + rect.size.width, 60);
    [backBtn setTitle:ITS_NSLocalizedString(@"SettingFeedBack", nil) forState:UIControlStateNormal];
    //[backBtn setTitle:@"Categories" forState:UIControlStateNormal];
    
    backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 15);
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 30);
    UIImage* backIcon = [UIImage imageNamed:@"title_back"];
    [backBtn setImage:backIcon forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = back;
    CGFloat contentStartY = screenTitleBarH + headerHeight;
    UILabel* feedbackInfo = [[UILabel alloc] init];
    feedbackInfo.frame = CGRectMake(8, contentStartY + 10 , screenW - 16, 18);
    [feedbackInfo setText:ITS_NSLocalizedString(@"FeedBackInfo", nil)];
    feedbackInfo.textAlignment = NSTextAlignmentLeft;
    feedbackInfo.backgroundColor = [UIColor clearColor];
    feedbackInfo.font = [UIFont systemFontOfSize:16];
    [feedbackInfo setTextColor:[MMSystemHelper string2UIColor:COLOR_SPLASH_FT_TITLE]];
    [self.view addSubview:feedbackInfo];
    
    
    UIView* sepLine = [[UIView alloc] init];
    sepLine.backgroundColor = [MMSystemHelper string2UIColor:COLOR_NEWSLIST_LINE_GREY];
    sepLine.frame = CGRectMake(0, contentStartY + 10 + 20 + 10 , screenW, 1);
    [self.view addSubview:sepLine];
    
    self.feedbackMsg = [[UITextView alloc] init];
    if (screenH == 480) {
        self.feedbackMsg.frame = CGRectMake(8, contentStartY + 10 + 20 + 10 + 5, screenW - 16, 80);
    }else if (screenH == 568){
        self.feedbackMsg.frame = CGRectMake(8, contentStartY + 10 + 20 + 10 + 5, screenW - 16, 170);
    }else if (screenH == 667){
        self.feedbackMsg.frame = CGRectMake(8, contentStartY + 10 + 20 + 10 + 5, screenW - 16, 230);
    }else if (screenH == 736){
        self.feedbackMsg.frame = CGRectMake(8, contentStartY + 10 + 20 + 10 + 5, screenW - 16, 250);
    }
    self.feedbackMsg.backgroundColor = [UIColor clearColor];
    self.feedbackMsg.font = [UIFont systemFontOfSize:20];
    
    [self.feedbackMsg setEditable:YES];
    self.feedbackMsg.delegate = self;
    self.feedbackMsg.dataDetectorTypes = UIDataDetectorTypeAll;
    self.feedbackMsg.keyboardType = UIKeyboardTypeDefault;
    self.feedbackMsg.returnKeyType = UIReturnKeyDone;
    [self.feedbackMsg becomeFirstResponder];
    [self.view addSubview:self.feedbackMsg];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sendBtn.frame = CGRectMake(screenW/4, screenH - 100 + 64, screenW/2, 40);
    [self.sendBtn setTitle:ITS_NSLocalizedString(@"FeedBackSend", @"Send") forState:UIControlStateNormal];
    [self.sendBtn setBackgroundColor:[MMSystemHelper string2UIColor:HOME_VIPNAME_COLOR]];
    [self.sendBtn addTarget:self action:@selector(sendBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.sendBtn addTarget:self action:@selector(sendBtnTouchDown) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.sendBtn];
}
- (void)tapBack{
    [self.navigationController popViewControllerAnimated:YES];
}
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    CGFloat screenH = [MMSystemHelper getScreenHeight];
    CGFloat screenW = [MMSystemHelper getScreenWidth];
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    height = keyboardRect.size.height;
    self.sendBtn.frame = CGRectMake(screenW/4, screenH - height - 40, screenW/2, 40);

}
//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    CGFloat screenH = [MMSystemHelper getScreenHeight];
    CGFloat screenW = [MMSystemHelper getScreenWidth];
    self.sendBtn.frame = CGRectMake(screenW/4, screenH - height - 30, screenW/2, 40);
    [UIView animateWithDuration:0.1 animations:^{
        self.sendBtn.frame = CGRectMake(screenW/4, screenH - 100 + 64, screenW/2, 40);
    }];
}

//隐藏键盘
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
-(void) backBtnClicked{
    
    [self.navigationController popViewControllerAnimated:NO];
}
-(void) sendBtnClicked{
    
    [self.sendBtn setBackgroundColor:[MMSystemHelper string2UIColor:HOME_VIPNAME_COLOR]];
    NSString* msg = self.feedbackMsg.text;
    if (msg != nil && [msg length] >= 1){
        // send msg
        ITSApplication* app = [ITSApplication get];
        [app.reportSvr recordFeedback:msg];
        [self.feedbackMsg setText:@""];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ITS_NSLocalizedString(@"FeedBackSend", nil) message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    //    if([msg length] >= 1 ){
    ////        [self showAlertView :WKAlertViewStyleSuccess];
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:PPN_NSLocalizedString(@"FeedBackSend", nil) message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //        [alert show];
    //    }else
    if ([msg compare:@""] == NSOrderedSame){
        //       [self showAlertView :WKAlertViewStyleFail];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ITS_NSLocalizedString(@"FeedBackWrite", nil) message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
//    ITSApplication* poApp = [ITSApplication get];
//    NSMutableDictionary* eParams = [NSMutableDictionary dictionaryWithCapacity:1];
//    
//    [poApp.reportSvr recordEvent:@" " params:eParams eventCategory:@"me.settings.feedback.send"];
}

-(void) sendBtnTouchDown{
    [self.sendBtn setBackgroundColor:[UIColor grayColor]];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    ConfigService *cs = [ConfigService get];
    self.headerBg.backgroundColor = [cs getTopBgViewRedColor:cs.type];
}
@end