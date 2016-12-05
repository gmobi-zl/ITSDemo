//
//  ShareView.h
//  Celebrity
//
//  Created by Apple on 16/11/10.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShareViewDelegate <NSObject>

-(void)shareView:(NSInteger *)tag;

@end

@interface ShareView : UIView

@property (nonatomic, strong) UILabel *shareLabel;
@property (nonatomic, strong) UILabel *topline;
@property (nonatomic, strong) UIButton *iconButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UILabel *line;
@property (nonatomic, strong) UIButton *bgView;
@property (nonatomic, strong) UIButton *iconBtn;
@property (nonatomic, strong) NSMutableArray *arrImage;
@property (nonatomic, assign) id<ShareViewDelegate>delegate;

@end
