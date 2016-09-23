
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
    [send setTitle:@"發布" forState:UIControlStateNormal];
    [send setTitleColor:[MMSystemHelper string2UIColor:HOME_VIPNAME_COLOR] forState:UIControlStateNormal];
    [send addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:send];
    self.navigationItem.rightBarButtonItem = right;
    
    self.photo = [[UIImageView alloc] init];
    self.photo.frame = CGRectMake(25, 90, 50, 50);
    self.photo.image = [UIImage imageWithData:self.data];
    self.photo.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.photo];
    
    self.textView = [[UITextView alloc] init];
    self.textView.frame = CGRectMake(85, 74, screenW - 100, 100);
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.delegate = self;
    self.textView.font = [UIFont systemFontOfSize:18];
    self.textView.returnKeyType = UIReturnKeyDone;//return键的类型
    self.textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    self.textView.textAlignment = NSTextAlignmentLeft; //文本显示的位置默认为居左
    self.textView.dataDetectorTypes = UIDataDetectorTypeAll; //显示数据类型的连接模式（如电话号码、网址、地址等）
    [self.view addSubview:self.textView];
    
    NSString *str = @"敘述這張照片...";
    CGSize size = [MMSystemHelper sizeWithString:str font:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(MAXFLOAT, 30)];
    self.label = [[UILabel alloc] init];
    self.label.textColor = [MMSystemHelper string2UIColor:HOME_TIME_COLOR];
    self.label.frame = CGRectMake(90, 74, size.width, 30);
    self.label.text = str;
    self.label.enabled = NO;
    self.label.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.label];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 174, screenW, 3);
    bgView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [self.view addSubview:bgView];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, 179, screenW, screenH - 179);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[WriteArticleCell class] forCellReuseIdentifier:WriteArticleCellIdentifier];
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
    tmpCell.icon.image = [UIImage imageNamed:menuItem.iconName];
    tmpCell.title.text = menuItem.actionName;
    tmpCell.photo.image = [UIImage imageNamed:menuItem.photo];
    return tmpCell;
}
#pragma mark TextViewDelegate
-(void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        self.label.text = @"敘述這張照片...";
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
