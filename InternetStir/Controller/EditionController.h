//
//  EditionController.h
//  PoPoNews
//
//  Created by apple on 15/6/10.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#ifndef PoPoNews_EditionController_h
#define PoPoNews_EditionController_h

#import <UIKit/UIKit.h>
@interface EditionController : UIViewController<UITableViewDataSource, UITableViewDelegate,UIGestureRecognizerDelegate>

@property UITableView* tableView;
@property UIView* headerBg;
@end


#endif
