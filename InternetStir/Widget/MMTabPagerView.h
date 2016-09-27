//
//  MMTabPagerView.h
//  PoPoNews
//
//  Created by apple on 15/4/14.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#ifndef PoPoNews_MMTabPagerView_h
#define PoPoNews_MMTabPagerView_h


#import <UIKit/UIKit.h>

@protocol MMTabPagerViewDataSource;
@protocol MMTabPagerViewDelegate;

@interface MMTabPagerView : UIViewController

@property NSMutableArray *tabs;
@property NSMutableArray *contents;

@property UIScrollView *tabsView;
@property UIView *contentView;

@property id<MMTabPagerViewDataSource> dataSource;
@property id<MMTabPagerViewDelegate> delegate;

-(void) setTableViewSelectIndex: (NSUInteger) index;

- (void)setActiveContentIndex:(NSInteger)activeContentIndex
                     animated:(BOOL) anim;

@property CGFloat heightOfTabView;
@property CGFloat yPositionOfTabView;
@property UIColor *tabsViewBackgroundColor;

-(void)resetTabView;
-(void)resetTabViewContent: (NSUInteger) index;
@end

#pragma mark MMTabPagerViewDataSource

@protocol MMTabPagerViewDataSource <NSObject>
- (NSUInteger)numberOfTabView;
- (UIView *)viewPager:(MMTabPagerView *)viewPager viewForTabAtIndex:(NSUInteger)index;
- (UIViewController *)viewPager:(MMTabPagerView *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index;
@end

#pragma mark MMTabPagerViewDelegate

@protocol MMTabPagerViewDelegate <NSObject>

@optional
- (void)viewPager:(MMTabPagerView *)viewPager didSwitchAtIndex:(NSInteger)index withTabs:(NSArray *)tabs;
- (void)viewPagerDidAddContentView;
@end



#endif
