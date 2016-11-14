
//
//  ShareView.m
//  Celebrity
//
//  Created by Apple on 16/11/10.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import "ShareView.h"
#import "MMSystemHelper.h"

#define screenW [MMSystemHelper getScreenWidth]
#define screenH [MMSystemHelper getScreenHeight]

@implementation ShareView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
//        self.backgroundColor = [MMSystemHelper string2UIColor:@"#FFFFFF"];
        
        

        self.shareLabel = [[UILabel alloc] init];
        self.shareLabel.frame = CGRectMake(20, 0, screenW, 36);
        self.shareLabel.text = @"分享至:";
        [self addSubview:self.shareLabel];

    }
    return self;
}
@end
