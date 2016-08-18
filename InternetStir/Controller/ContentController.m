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
    self.tableView.frame = CGRectMake(0, 0, screenW, screenH);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[ContentViewCell class] forCellReuseIdentifier:ContentCellIdentifier];
    [self.view addSubview:self.tableView];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 280;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:ContentCellIdentifier forIndexPath:indexPath];
    if (cell == nil){
        cell = [[ContentViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ContentCellIdentifier];
    }
    ContentViewCell* tmpCell = (ContentViewCell*)cell;
    [tmpCell showDataWithModel];
    
    return tmpCell;
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
