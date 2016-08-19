
//
//  LoginViewController.m
//  InternetStir
//
//  Created by Apple on 16/8/17.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import "LoginViewController.h"
#import "MMSystemHelper.h"
#import "AboutController.h"
#import "EditionController.h"
#import "FeedBackController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    

    self.title = @"登入帳號";
    [self creatUI];
}
- (void)creatUI{
    CGFloat screenW = [MMSystemHelper getScreenWidth];
    
    NSArray *titleArr = @[@"Facebook",@"Twitter",@"Google"];
    for (int i = 0; i < titleArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.masksToBounds = YES;
        button.tag = i + 1;
        button.layer.cornerRadius = 6;
        button.frame = CGRectMake(70, 150 + i * 100, screenW - 140, 40);
        [button setTitle:[titleArr objectAtIndex:i] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor cyanColor];
        [button addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
    CGSize size = [MMSystemHelper sizeWithString:@"未經允許，我們不會發布至您的Facebook,Twitter,Google" font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(screenW - 140, MAXFLOAT)];
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(70, 400, screenW - 140, size.height);
    label.text = @"未經允許，我們不會發布至您的Facebook,Twitter,Google";
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:label];
}
//login
- (void)login:(UIButton*)button{

}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor grayColor];

    UIButton* Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    Btn.frame = CGRectMake(0, 20, 30, 30);
    [Btn setBackgroundImage:[UIImage imageNamed:@"icon_Back"] forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:Btn];
    self.navigationItem.leftBarButtonItem = left;
}
- (void)clickBack{
    
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
