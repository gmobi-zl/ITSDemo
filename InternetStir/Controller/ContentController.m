//
//  ContentController.m
//  InternetStir
//
//  Created by Apple on 16/8/18.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import "ContentController.h"
#import "ContentViewCell.h"
#import "MMSystemHelper.h"
#import "DetailContentController.h"
#import "ITSAppConst.h"
#import "MenuViewController.h"

#define screenW [MMSystemHelper getScreenWidth]
#define screenH [MMSystemHelper getScreenHeight]

NSString *const ContentCellIdentifier = @"ContentCell";

@interface ContentController ()

@end

@implementation ContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, 0, screenW, screenH - 64);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ContentViewCell class] forCellReuseIdentifier:ContentCellIdentifier];
    [self.view addSubview:self.tableView];
    
    self.urlArr = @[@"https://www.youtube.com/watch?v=QqPtEB9rxg4",
                    @"https://www.youtube.com/watch?v=iDXgBkIeZG0",
                    @"https://www.youtube.com/watch?v=VCkL3AsnHTo",
                    @"https://www.youtube.com/watch?v=veBjTuLDzF0",
                    @"https://www.youtube.com/watch?v=i_Z_j-U4yK4"];
    
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, -20, screenW, 20)];
    statusBarView.backgroundColor = [MMSystemHelper string2UIColor:NAV_BGCOLOR];
    [self.navigationController.navigationBar addSubview:statusBarView];
    
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    UIButton* Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    Btn.frame = CGRectMake(0, 20, 30, 30);
    [Btn setBackgroundImage:[UIImage imageNamed:@"icon_Menu"] forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(pushMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:Btn];
    self.navigationItem.leftBarButtonItem = left;
    
}
- (void)pushMenu{
    
    MenuViewController *menu = [[MenuViewController alloc] init];
    menu.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:menu animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 0.5 + 20 + 5 + 40 + 10 + 3 * (screenW - 30)/4 + 10;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:ContentCellIdentifier forIndexPath:indexPath];
    if (cell == nil){
        cell = [[ContentViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ContentCellIdentifier];
    }
    ContentViewCell* tmpCell = (ContentViewCell*)cell;
    [tmpCell showDataWithModel:indexPath.row];
    
    return tmpCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    DetailContentController *detail = [[DetailContentController alloc] init];
    detail.path = self.urlArr[indexPath.row];
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
    
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
