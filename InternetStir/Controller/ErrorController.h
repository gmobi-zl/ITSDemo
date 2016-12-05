//
//  ErrorController.h
//  Jacob
//
//  Created by Apple on 16/9/23.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ErrorController : UIViewController<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, copy) NSString *cid;
@property (nonatomic, copy) NSString *fid;
@property (nonatomic, assign) int type;
@property (nonatomic, copy) NSString *content;
@end
