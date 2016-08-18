//
//  SettingCell.h
//  PoPoNews
//
//  Created by apple on 15/6/10.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#ifndef PoPoNews_SettingCell_h
#define PoPoNews_SettingCell_h
#import <UIKit/UIKit.h>

@interface SettingCell : UITableViewCell

@property (strong, nonatomic) UIImageView* icon;
@property (strong, nonatomic) UILabel* title;
@property (strong, nonatomic) UILabel* desc;
@property (strong, nonatomic) UIButton* detailImage;
@property (strong, nonatomic) UIView* sepLine;

@end

#endif
