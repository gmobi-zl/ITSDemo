


//
//  ErrView.m
//  Celebrity
//
//  Created by Apple on 2016/12/5.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import "ErrView.h"
#import "MMSystemHelper.h"
#import "AppStyleConfiguration.h"

#define screenW [MMSystemHelper getScreenWidth]
#define screenH [MMSystemHelper getScreenHeight]

@implementation ErrView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        UIImageView *tomoto = [[UIImageView alloc] init];
        tomoto.frame = CGRectMake(screenW/2 - 100, screenH/2 - 150, 200, 200);
        tomoto.image = [UIImage imageNamed:@"P119_emptypage_error"];
        [self addSubview:tomoto];
        
        CGSize size = [MMSystemHelper sizeWithString:NSLocalizedString(@"NetErr", nil) font:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(screenW - 20, MAXFLOAT)];
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(10, screenH/2 + 50, screenW - 20, size.height);
        label.text = NSLocalizedString(@"NetErr", nil);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16];
        [self addSubview:label];
        
        CGSize btnSize = [MMSystemHelper sizeWithString:NSLocalizedString(@"Reconnect", nil) font:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        self.button = [UIButton buttonWithType:UIButtonTypeSystem];
        self.button.frame = CGRectMake(screenW/2 - btnSize.width/2, screenH/2 + 50 + size.height + 10, btnSize.width, btnSize.height);
        [self.button setTitle:NSLocalizedString(@"Reconnect", nil) forState:UIControlStateNormal];
        [self.button setTitleColor:[MMSystemHelper string2UIColor:HOME_VIPNAME_COLOR] forState:UIControlStateNormal];
        self.button.titleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:self.button];
    }
    return self;
}
@end
