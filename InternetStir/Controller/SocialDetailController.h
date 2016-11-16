//
//  SocialDetailController.h
//  Jacob
//
//  Created by Apple on 16/10/26.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMWebView.h"
#import "CelebRecommend.h"

@interface SocialDetailController : UIViewController<MMWebViewDelegate,UIGestureRecognizerDelegate>
@property (strong, nonatomic) MMWebView* webView;
@property (assign) int downloadFailedCount;
@property (copy) NSString* cid;
@property (nonatomic, strong) UIActivityIndicatorView *testActivityIndicato;


@end
