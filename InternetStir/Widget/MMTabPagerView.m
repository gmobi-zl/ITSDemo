//
//  MMTabPagerView.m
//  PoPoNews
//
//  Created by apple on 15/4/14.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMTabPagerView.h"
#import "MMLogger.h"
#import "ConfigService.h"
#import "SettingService.h"
#define MC_TAB_VIEW_TAG 100
#define MC_TAB_CONTENT_TAG 101

NSInteger num;
@interface MMTabPagerView () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property NSInteger tabCount;
@property UIPageViewController *pageViewController;

@property (nonatomic) NSInteger activeContentIndex;
@property (nonatomic) NSInteger activeTabIndex;

@property (getter=isAnimatingToTab, assign) BOOL animatingToTab;
@property (getter=isTapAnimatingToTab, assign) BOOL tapAnimatingToTab;
@property CGPoint movingOffset;
@property CGPoint startMoveingTabOffset;
@property UIView* tabIndicator;
@property UIScrollView* line;


//@property UIView* panMaskView;
//@property UIPanGestureRecognizer* panGestureRecognizer;

//@property UIPanGestureRecognizer* pvcPanGestureRecognizer;
//@property id<UIGestureRecognizerDelegate> pvcPanGestureRecognizerDelegate;

@end

@implementation MMTabPagerView

#pragma mark - Initialize

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self defaultSettings];
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self defaultSettings];
    }
    return self;
}

//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
////    for ( UIGestureRecognizer* recognizer in touch.gestureRecognizers )
////    {
////        if ( [recognizer isKindOfClass:[UIPanGestureRecognizer class]] )
////        {
////            _pvcPanGestureRecognizer = (UIPanGestureRecognizer*)recognizer;
////            _pvcPanGestureRecognizerDelegate = _pvcPanGestureRecognizer.delegate;
////            _pvcPanGestureRecognizer.delegate = self;
////            break;
////        }
////    }
//    
//    CGPoint localPos = [touch locationInView:self.view];
//    MMLogDebug(@"pan start pos %f, %f", localPos.x, localPos.y);
//    if (localPos.x < 32 || localPos.x > 290)
//        return NO;
//    
//    return YES;
//}

#pragma mark UIGestureRecognizerDelegate
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    // Check for horizontal pan gesture
//    if (gestureRecognizer == _panGestureRecognizer) {
//        UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer*)gestureRecognizer;
//        CGPoint translation = [panGesture translationInView:self.view];
//        CGPoint localPos = [panGesture locationInView:self.view];
//        MMLogDebug(@"pan start pos %f, %f", localPos.x, localPos.y);
//        //self.pageViewController.view
//        //if ([panGesture velocityInView:_baseView].x < 600 && ABS(translation.x)/ABS(translation.y)>1) {
//        //    return YES;
//        //}
//        self.panMaskView.hidden = NO;
//        return NO;
//    }
//    return YES;
//}
//- (void)mmTabPageViewPan:(UIPanGestureRecognizer*)pan{
//        if (_panGestureRecognizer.state==UIGestureRecognizerStateBegan) {
//                        return;
//        }
//        if (_panGestureRecognizer.state==UIGestureRecognizerStateEnded) {
//            
//        }else{
//            CGPoint velocity = [pan velocityInView:self.view];
//            if (velocity.x>0) {
//               
//            }else if(velocity.x<0){
//                
//            }
//        }
//}

- (void)defaultSettings
{
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
    [self addChildViewController:self.pageViewController];
    
    ((UIScrollView *)[self.pageViewController.view.subviews objectAtIndex:0]).delegate = self;
    
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    self.heightOfTabView = 40.0;
    self.yPositionOfTabView = 20.0;
    
    CGFloat r = 215.0 / 255.0;
    CGFloat g = 49.0 / 255.0;
    CGFloat b = 35.0 / 255.0;
    UIColor *color = [UIColor colorWithRed:r green:g blue:b alpha:1.0];
    self.tabsViewBackgroundColor = color;
    self.animatingToTab = NO;
}

- (void)defaultSetUp
{
    // Empty tabs and contents
    for (UIView *tabView in self.tabs) {
        [tabView removeFromSuperview];
    }
    self.tabsView.contentSize = CGSizeZero;
    
    [self.tabs removeAllObjects];
    [self.contents removeAllObjects];
    
    // Initializes
    self.tabCount = [self.dataSource numberOfTabView];
    self.tabs = [NSMutableArray array];
    self.contents = [NSMutableArray array];
    
    // Add tabsView in Superview
    if (!self.tabsView) {
        
        self.tabsView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, self.yPositionOfTabView, CGRectGetWidth(self.view.frame), self.heightOfTabView)];
        self.tabsView.userInteractionEnabled = YES;
        self.tabsView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
       
        //self.tabsView.backgroundColor = [UIColor cyanColor];
        self.tabsView.scrollsToTop = NO;
        self.tabsView.showsHorizontalScrollIndicator = NO;
        self.tabsView.showsVerticalScrollIndicator = NO;
        self.tabsView.tag = MC_TAB_VIEW_TAG;
        self.tabsView.delegate = self;
        self.tabsView.bounces = NO;
        self.tabsView.scrollEnabled = YES;
        
        [self.view insertSubview:self.tabsView atIndex:0];
    }
    NSInteger contentSizeWidth = 0;
    CGRect firstItemRect;
    for (NSUInteger i = 0; i < self.tabCount; i++) {
        if (self.tabs.count >= self.tabCount) {
            continue;
        }
        UIView *tabView = [self.dataSource viewPager:self viewForTabAtIndex:i];
        tabView.tag = i;
        CGRect frame = tabView.frame;
        frame.origin.x = contentSizeWidth;
        if (i == 0){
            firstItemRect = frame;
            UILabel *label = (UILabel*)tabView;
            ConfigService* cs = [ConfigService get];
            label.textColor = [cs getYellowViewColor:MODE_DAY];//[UIColor redColor];
        }
        tabView.frame = frame;
        tabView.userInteractionEnabled = YES;
        
        [self.tabsView addSubview:tabView];
        [self.tabs addObject:tabView];

        contentSizeWidth += CGRectGetWidth(tabView.frame);
        
        // To capture tap events
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [tabView addGestureRecognizer:tapGestureRecognizer];
        
        // view controller
        [self.contents addObject:[self.dataSource viewPager:self contentViewControllerForTabAtIndex:i]];
    }
    self.tabsView.contentSize = CGSizeMake(contentSizeWidth, self.heightOfTabView);
    
    // Positioning
    self.tabsView.contentOffset = CGPointMake(0, 0);
    // Add contentView in Superview
    self.contentView = [self.view viewWithTag:MC_TAB_CONTENT_TAG];
    if (!self.contentView) {
        
        // Populate pageViewController.view in contentView
        self.contentView = self.pageViewController.view;
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.bounds = self.view.bounds;
        //self.contentView.bounds = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height-self.heightOfTabView-self.yPositionOfTabView);
        //CGRect tmpBounds = self.view.bounds;
        self.contentView.tag = MC_TAB_CONTENT_TAG;
        [self.view insertSubview:self.contentView atIndex:0];
        
        // constraints
        if ([self.delegate respondsToSelector:@selector(viewPagerDidAddContentView)]) {
            [self.delegate viewPagerDidAddContentView];
        } else {
            self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
            NSDictionary *views = @{ @"contentView" : self.contentView };
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[contentView]-0-|" options:0 metrics:nil views:views]];
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-40-[contentView]-0-|" options:0 metrics:nil views:views]];
        }
    }
    
    // Setting Active Index
    [self selectTabAtIndex:0];
    
    self.tabIndicator = [[UIView alloc] init];
   
    self.tabIndicator.frame = CGRectMake(0, firstItemRect.origin.y + 36, firstItemRect.size.width, 4);
    [self.tabIndicator setTag:989];
    [self.tabsView addSubview:self.tabIndicator];
    ConfigService *cs = [ConfigService get];
    self.tabIndicator.backgroundColor = [cs getYellowViewColor:cs.type];
    //self.tabsView.backgroundColor = [UIColor blackColor];
    
    // Default Design
    if ([self.delegate respondsToSelector:@selector(viewPager:didSwitchAtIndex:withTabs:)]) {
        [self.delegate viewPager:self didSwitchAtIndex:self.activeContentIndex withTabs:self.tabs];
    }
    
//    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(mmTabPageViewPan:)];
//    //[self.maskView addGestureRecognizer:self.panGestureRecognizer];
//    self.panMaskView.userInteractionEnabled = YES;
//    [self.view addGestureRecognizer:_panGestureRecognizer];
//    [_panGestureRecognizer setDelegate:self];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   // ConfigService *cs = [ConfigService get];
   // self.tabsView.backgroundColor = [cs getScrollViewBgColor:cs.type];
}
  - (void)viewWillAppear:(BOOL)animated{
      [super viewWillAppear:animated];
      ConfigService *cs = [ConfigService get];
      self.tabsView.backgroundColor = [cs getScrollViewBgColor:cs.type];;
      //self.tabsView.backgroundColor = [UIColor cyanColor];
     // self.tabsView.backgroundColor = [cs getScrollViewBgColor:cs.type];
      //self.tabIndicator.backgroundColor = [cs getYellowViewColor:cs.type];
      //self.tabsViewBackgroundColor = [cs getTopBgViewRedColor:type];
     // self.tabsView.backgroundColor = [cs getScrollViewBgColor:cs.type];
     // self.tabIndicator.backgroundColor = [cs getYellowViewColor:cs.type];
     // self.tabsView.backgroundColor = [cs getScrollViewBgColor:cs.type];
}

-(void)resetTabViewContent: (NSUInteger) index{
    if (self.contents == nil) return;
    if (index >= [self.contents count]) return;
    
    [self.contents removeAllObjects];
    self.contents = [NSMutableArray array];
    for (NSUInteger i = 0; i < self.tabCount; i++) {
        // view controller
        [self.contents addObject:[self.dataSource viewPager:self contentViewControllerForTabAtIndex:i]];
    }
    
    // Add contentView in Superview
    self.contentView = [self.view viewWithTag:MC_TAB_CONTENT_TAG];
    if (!self.contentView) {
        
        // Populate pageViewController.view in contentView
        self.contentView = self.pageViewController.view;
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.bounds = self.view.bounds;
        //self.contentView.bounds = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height-self.heightOfTabView-self.yPositionOfTabView);
        //CGRect tmpBounds = self.view.bounds;
        self.contentView.tag = MC_TAB_CONTENT_TAG;
        [self.view insertSubview:self.contentView atIndex:0];
        
        // constraints
        if ([self.delegate respondsToSelector:@selector(viewPagerDidAddContentView)]) {
            [self.delegate viewPagerDidAddContentView];
        } else {
            self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
            NSDictionary *views = @{ @"contentView" : self.contentView };
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[contentView]-0-|" options:0 metrics:nil views:views]];
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-40-[contentView]-0-|" options:0 metrics:nil views:views]];
        }
    }
    
    // Setting Active Index
    [self setActiveContentIndex:index animated:NO];
}

- (void)resetTabView{
    // Empty tabs and contents
    for (UIView *tabView in self.tabs) {
        [tabView removeFromSuperview];
    }
    self.tabsView.contentSize = CGSizeZero;
    
    [self.tabs removeAllObjects];
    [self.contents removeAllObjects];
    self.tabs = nil;
    self.contents = nil;
    
    // Initializes
    self.tabCount = [self.dataSource numberOfTabView];
    self.tabs = [NSMutableArray array];
    self.contents = [NSMutableArray array];
    
    // Add tabsView in Superview
    if (!self.tabsView) {
        
        self.tabsView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, self.yPositionOfTabView, CGRectGetWidth(self.view.frame), self.heightOfTabView)];
        self.tabsView.userInteractionEnabled = YES;
        self.tabsView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.tabsView.scrollsToTop = NO;
        self.tabsView.showsHorizontalScrollIndicator = NO;
        self.tabsView.showsVerticalScrollIndicator = NO;
        self.tabsView.tag = MC_TAB_VIEW_TAG;
        self.tabsView.delegate = self;
        self.tabsView.bounces = NO;
        self.tabsView.scrollEnabled = YES;
        
        [self.view insertSubview:self.tabsView atIndex:0];
    }
    
    NSInteger contentSizeWidth = 0;
    CGRect firstItemRect;
    for (NSUInteger i = 0; i < self.tabCount; i++) {
        
        if (self.tabs.count >= self.tabCount) {
            continue;
        }
        
        UIView *tabView = [self.dataSource viewPager:self viewForTabAtIndex:i];
        tabView.tag = i;
        CGRect frame = tabView.frame;
        frame.origin.x = contentSizeWidth;
        //frame.size.width = 80 + (arc4random()%80);
        
        if (i == 0){
            firstItemRect = frame;
        }
        tabView.frame = frame;
        tabView.userInteractionEnabled = YES;
        
        [self.tabsView addSubview:tabView];
        [self.tabs addObject:tabView];
        
        contentSizeWidth += CGRectGetWidth(tabView.frame);
        
        // To capture tap events
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [tabView addGestureRecognizer:tapGestureRecognizer];
        
        // view controller
        [self.contents addObject:[self.dataSource viewPager:self contentViewControllerForTabAtIndex:i]];
    }
    self.tabsView.contentSize = CGSizeMake(contentSizeWidth, self.heightOfTabView);
    
    
   
    // Add contentView in Superview
    self.contentView = [self.view viewWithTag:MC_TAB_CONTENT_TAG];
    if (!self.contentView) {
        
        // Populate pageViewController.view in contentView
        self.contentView = self.pageViewController.view;
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.bounds = self.view.bounds;
        //self.contentView.bounds = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height-self.heightOfTabView-self.yPositionOfTabView);
        //CGRect tmpBounds = self.view.bounds;
        self.contentView.tag = MC_TAB_CONTENT_TAG;
        [self.view insertSubview:self.contentView atIndex:0];
        
        // constraints
        if ([self.delegate respondsToSelector:@selector(viewPagerDidAddContentView)]) {
            [self.delegate viewPagerDidAddContentView];
        } else {
            self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
            NSDictionary *views = @{ @"contentView" : self.contentView };
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[contentView]-0-|" options:0 metrics:nil views:views]];
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-50-[contentView]-0-|" options:0 metrics:nil views:views]];
        }
    }
    
    self.activeContentIndex = 0;
    self.activeTabIndex = 0;
    
    // Setting Active Index
    [self selectTabAtIndex:0];
    
    // Positioning
    self.tabsView.contentOffset = CGPointMake(0, 20);
    
//    self.tabIndicator = [[UIView alloc] init];
//    self.tabIndicator.backgroundColor = [UIColor yellowColor];
    self.tabIndicator.frame = CGRectMake(0, firstItemRect.origin.y + 36, firstItemRect.size.width, 4);
    
//    [self.tabIndicator setTag:989];
    [self.tabsView addSubview:self.tabIndicator];
    // Default Design
    if ([self.delegate respondsToSelector:@selector(viewPager:didSwitchAtIndex:withTabs:)]) {
        [self.delegate viewPager:self didSwitchAtIndex:self.activeContentIndex withTabs:self.tabs];
    }
}

- (void)viewWillLayoutSubviews
{
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self defaultSetUp];
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Gesture

- (void)handleTapGesture:(UITapGestureRecognizer *)sender
{
    //[self trasitionTabViewWithView:sender.view];
    [self selectTabAtIndex:sender.view.tag];
    [self trasitionOffsetTabViewWithView:sender.view :sender.view.tag];
}

- (void)trasitionOffsetTabViewWithView:(UIView *)view :(NSInteger)tag{
    self.tapAnimatingToTab = YES;
    num = tag;
    for (UIView *view in self.tabs) {
            if (view.tag == tag) {
                UILabel *label = (UILabel*)view;
                //label.textColor = [UIColor redColor];
                
                ConfigService* cs = [ConfigService get];
                label.textColor = [cs getYellowViewColor:MODE_DAY];
            }else{
                UILabel *label = (UILabel*)view;
                label.textColor = [UIColor blackColor];
            }
    }
    UIView* tabInd = [self.tabsView viewWithTag:989];
    UILabel *label = (UILabel*)view;
    //label.textColor = [UIColor redColor];
    ConfigService* cs = [ConfigService get];
    label.textColor = [cs getYellowViewColor:MODE_DAY];
    CGFloat screenWidth = CGRectGetWidth(self.view.frame);
    CGFloat offset = self.tabsView.contentOffset.x;
    CGFloat showOffsetX = screenWidth / 10;
    CGFloat itemOffsetX = 0;
    CGFloat tabWidth = 0;
    CGRect itemRect;
    CGFloat newOffsetX = 0;
    int i = 0;
    CGFloat tempOffsetX = 0;
    
    
    for (i = 0; i < [self.tabs count]; i++) {
        UIView *tmpView = (UIView*)[self.tabs objectAtIndex:i];
        CGFloat btnSize = tmpView.frame.size.width;
        
        tempOffsetX += btnSize;
        
        if (i == view.tag){
            itemOffsetX = tempOffsetX - btnSize;
            itemRect = tmpView.frame;
        }
        
        tabWidth += btnSize;
    }
    
    int maxLeftOffset = tabWidth - screenWidth;
    
    if (offset > showOffsetX)
        offset -= showOffsetX;
    
    if (offset < itemOffsetX){
        CGFloat leftRightWidth = tabWidth - offset - screenWidth;
        newOffsetX = itemOffsetX - offset - showOffsetX;
        
        if (newOffsetX > leftRightWidth)
            newOffsetX = leftRightWidth;
    } else {
        if (itemOffsetX != 0){
            newOffsetX = 0 - (offset - itemOffsetX + showOffsetX);
        } else
            newOffsetX = 0 - offset;
    }
    
    int endOffset = offset + newOffsetX;
    if (endOffset < 0)
        newOffsetX = 0 - offset;
    else if (endOffset > maxLeftOffset)
        newOffsetX = maxLeftOffset - offset;
    
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         if (tabWidth < screenWidth)
                             self.tabsView.contentOffset = CGPointMake(0, 0);
                         else
                             self.tabsView.contentOffset = CGPointMake(offset + newOffsetX, 0);
                         tabInd.frame = CGRectMake(itemOffsetX, self.tabIndicator.frame.origin.y
                                                   , itemRect.size.width, self.tabIndicator.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         self.tapAnimatingToTab = NO;
                     }];
}

//- (void)trasitionTabViewWithView:(UIView *)view
//{
//    self.animatingToTab = YES;
//    
//    //CGFloat buttonSize = [self.dataSource widthOfTabView];
//    //CGFloat sizeSpace = 0;//([[UIScreen mainScreen] bounds].size.width - buttonSize) / 2;
//    
//    [UIView animateWithDuration:0.5
//                     animations:^{
//                         //self.tabsView.contentOffset = CGPointMake(view.frame.origin.x - sizeSpace, 0);
//                     }
//                     completion:^(BOOL finished) {
//                         //if ([self.delegate respondsToSelector:@selector(viewPager:didSwitchAtIndex:withTabs:)]) {
//                         //    [self.delegate viewPager:self didSwitchAtIndex:self.activeContentIndex withTabs:self.tabs];
//                         //}
//                         self.animatingToTab = NO;
//                     }];
//}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexForViewController:viewController];
    index++;
    
    if (index >= [self.contents count]) {
        index = [self.contents count];
    }
    
    return [self viewControllerAtIndex:index];
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexForViewController:viewController];
    index--;
    
    if (index <= 0) {
        index = 0;
    }
    
    return [self viewControllerAtIndex:index];
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed
{
    UIViewController *viewController = self.pageViewController.viewControllers[0];
    
    // Select tab
    NSUInteger index = [self indexForViewController:viewController];
    _activeContentIndex = index;
    
    if ([self.delegate respondsToSelector:@selector(viewPager:didSwitchAtIndex:withTabs:)]) {
        [self.delegate viewPager:self didSwitchAtIndex:self.activeContentIndex withTabs:self.tabs];
    }
}

#pragma mark - UIScrollViewDelegate

- (CGFloat) getMinValue: (CGFloat)v1
                 value2: (CGFloat)v2{
    if (v1 <= v2)
        return v1;
    else
        return v2;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.movingOffset = scrollView.contentOffset;
    self.startMoveingTabOffset = self.tabsView.contentOffset;
 
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    for (NSInteger i = 0; i < self.tabs.count; i++) {
        UIView *view = [self.tabs objectAtIndex:i];
        UILabel *label = (UILabel*)view;

        if (i == self.activeContentIndex) {
            //label.textColor = [UIColor redColor];
            ConfigService* cs = [ConfigService get];
            label.textColor = [cs getYellowViewColor:MODE_DAY];
        }else{
            label.textColor = [UIColor blackColor];
        }
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 0) { // To move menutab
        CGPoint contentOffset = self.tabsView.contentOffset;
        CGFloat screenWidth = CGRectGetWidth(self.view.frame);
        CGFloat movingX = scrollView.contentOffset.x;
        //CGFloat oldX = self.movingOffset.x;
        //CGFloat scWid = scrollView.frame.size.width;
        //UIView *tmpView = (UIView*)[self.tabs objectAtIndex:self.activeContentIndex];
        //CGFloat btnSize = tmpView.frame.size.width;
        

        if (self.isAnimatingToTab) {
            return;
        }
        
        if (self.isTapAnimatingToTab)
            return;
        
        if (movingX == screenWidth)
            return;
        
        // Because the coordinates become negative...
        if (scrollView.contentOffset.y < 0) {
            self.movingOffset = scrollView.contentOffset;
            return;
        }
        
        CGFloat offset = 0;
        CGFloat showOffsetX = screenWidth / 10;
        CGFloat lItemOffsetX = 0, itemOffsetX = 0, rItemOffsetX = 0;
        CGFloat tabWidth = 0;
        CGRect tmpZeroRect = CGRectMake(0, 0, 0, 0);
        CGRect lItemRect, itemRect, rItemRect;
        lItemRect = tmpZeroRect;
        rItemRect = tmpZeroRect;
        int i = 0;
        CGFloat tempOffsetX = 0;
        for (i = 0; i < [self.tabs count]; i++) {
            UIView *tmpView = (UIView*)[self.tabs objectAtIndex:i];
            CGFloat btnSize = tmpView.frame.size.width;
            
            tempOffsetX += btnSize;
            
            if (i == self.activeContentIndex - 1){
                lItemOffsetX = tempOffsetX - btnSize;
                lItemRect = tmpView.frame;
            } else if (i == self.activeContentIndex){
                itemOffsetX = tempOffsetX - btnSize;
                itemRect = tmpView.frame;
                if (i != ([self.tabs count] -1)){
                    rItemOffsetX = tempOffsetX;
                }
            } else if (i == self.activeContentIndex + 1){
                rItemRect = tmpView.frame;
            }
            
            tabWidth += btnSize;
        }
        
        CGFloat maxRightMoveOffsetX = tabWidth - screenWidth;
        //CGFloat maxLeftMoveOffsetX = 0;
        
        
        if (movingX > screenWidth){
            CGFloat acOffsetX = movingX - screenWidth;
            CGFloat goalOffsetX = rItemOffsetX - self.startMoveingTabOffset.x - showOffsetX; //0 - (contentOffset.x - rItemOffsetX + showOffsetX);
            if (rItemOffsetX == 0)
                goalOffsetX = 0;
            CGFloat leftMaxOffsetX = maxRightMoveOffsetX - self.startMoveingTabOffset.x;
            
            offset = ([self getMinValue:goalOffsetX value2:leftMaxOffsetX] * acOffsetX) / screenWidth;
            
            if (rItemRect.size.width != 0){
                CGFloat inOffsetX = itemRect.size.width * acOffsetX / screenWidth;
                CGFloat inOffsetW = (rItemRect.size.width - itemRect.size.width) * acOffsetX / screenWidth;
                
                self.tabIndicator.frame = CGRectMake(itemOffsetX + inOffsetX, self.tabIndicator.frame.origin.y
                                                     , itemRect.size.width + inOffsetW, self.tabIndicator.frame.size.height);
            }
        } else if (movingX < screenWidth){
            if (self.activeContentIndex <= 1)
                showOffsetX = 0;
            
            CGFloat acOffsetX = screenWidth - movingX;
            CGFloat goalOffsetX = 0 - (self.startMoveingTabOffset.x - lItemOffsetX + showOffsetX);
            if (lItemOffsetX < 0)
                goalOffsetX = 0;
            if (goalOffsetX >= 0)
                goalOffsetX = 0;
            
            //CGFloat leftMaxOffsetX = maxLeftMoveOffsetX - self.startMoveingTabOffset.x;
            offset = (goalOffsetX * acOffsetX) / screenWidth;
            
            if (lItemRect.size.width != 0){
                CGFloat inOffsetX = lItemRect.size.width * acOffsetX / screenWidth;
                CGFloat inOffsetW = (lItemRect.size.width - itemRect.size.width) * acOffsetX / screenWidth;
                
                self.tabIndicator.frame = CGRectMake(itemOffsetX - inOffsetX, self.tabIndicator.frame.origin.y
                                                     , itemRect.size.width + inOffsetW, self.tabIndicator.frame.size.height);
                
            }
        }
  
        contentOffset.x = self.startMoveingTabOffset.x + offset;
        if (self.tabsView.contentSize.width < screenWidth)
            contentOffset.x = 0;
        
        self.tabsView.contentOffset = contentOffset;
        self.movingOffset = scrollView.contentOffset;
    } else if (scrollView.tag == MC_TAB_VIEW_TAG) { // To scroll
        // do nothing
    }
    
}

#pragma mark - Private Methods
-(void) setTableViewSelectIndex: (NSUInteger) index{
    if (self.tabs == nil) return;
    if ([self.tabs count] <= index) return;
    
    UIView* tabView = [self.tabs objectAtIndex:index];
    if (tabView != nil){
        [self trasitionOffsetTabViewWithView:tabView :index];
        [self setActiveContentIndex:index animated:NO];
    }
}

- (void)setActiveContentIndex:(NSInteger)activeContentIndex
                     animated:(BOOL) anim
{
    
    UIViewController *viewController = [self viewControllerAtIndex:activeContentIndex];
    
    if (!viewController) {
        viewController = [[UIViewController alloc] init];
        viewController.view = [[UIView alloc] init];
        viewController.view.backgroundColor = [UIColor redColor];
    }
    
    if (activeContentIndex == _activeContentIndex) {
        
        [self.pageViewController setViewControllers:@[ viewController ]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:NO
                                         completion:^(BOOL completed){// none
                                         }];
        
    } else {
        
        NSInteger direction = 0;
       // int changedPageCount = (int)labs(activeContentIndex - _activeContentIndex);
        int step = 1;
       // int startIndex = (int)_activeContentIndex;
        
        if (activeContentIndex > _activeContentIndex){
            direction = UIPageViewControllerNavigationDirectionForward;
        } else {
            direction = UIPageViewControllerNavigationDirectionReverse;
            step = -1;
        }
        
        if (self.pageViewController != nil)
            
            [self.pageViewController setViewControllers:[NSArray arrayWithObject:[self viewControllerAtIndex:activeContentIndex]]
                                          direction:direction
                                           animated:anim
                                         completion:^(BOOL completed){// none
                                             MMLogDebug(@"step view controller completed: %d", completed);
                                         }];
        
            if ([self.delegate respondsToSelector:@selector(viewPager:didSwitchAtIndex:withTabs:)]) {
                [self.delegate viewPager:self didSwitchAtIndex:self.activeContentIndex withTabs:self.tabs];
            }
        

//        if (startIndex < 0)
//            startIndex = 0;
//        if (startIndex >= self.contents.count)
//            startIndex = (int)self.contents.count - 1;
//        
//        for (int i = 0; i < changedPageCount; i++) {
//            
//            startIndex += step;
//            if (startIndex < 0)
//                startIndex = 0;
//            if (startIndex >= self.contents.count)
//                startIndex = (int)self.contents.count - 1;
//            UIViewController *stepViewController = [self viewControllerAtIndex:startIndex];
//            
//            [self.pageViewController setViewControllers:@[ stepViewController ]
//                                              direction:direction
//                                               animated:YES
//                                             completion:^(BOOL completed){// none
//                                                 MMLogDebug(@"step view controller completed: %d : %d", startIndex, completed);
//                                             }];
//        }
        
        
    }
    
    _activeContentIndex = activeContentIndex;
}

- (void)selectTabAtIndex:(NSUInteger)index
{
    if (index >= self.tabCount) {
        return;
    }
    
    [self setActiveContentIndex:index animated:YES];
}

- (UIView *)tabViewAtIndex:(NSUInteger)index
{
    return [self.tabs objectAtIndex:index];
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (index >= self.tabCount) {
        return nil;
    }
    
    return [self.contents objectAtIndex:index];
}

- (NSUInteger)indexForViewController:(UIViewController *)viewController
{
    return [self.contents indexOfObject:viewController];
}

- (void)scrollWithDirection:(NSInteger)direction
{
    //CGFloat buttonSize = [self.dataSource widthOfTabView];
    
    if (direction == 0) {
        UIView *firstView = [self.tabs objectAtIndex:0];
        [self.tabs removeObjectAtIndex:0];
        [self.tabs addObject:firstView];
    } else {
        UIView *lastView = [self.tabs lastObject];
        [self.tabs removeLastObject];
        [self.tabs insertObject:lastView atIndex:0];
    }
    
    //NSUInteger index = 0;
    //NSUInteger contentSizeWidth = 0;

}

- (void)scrollViewDidEndDirection:(NSNumber *)direction
{
    [self scrollWithDirection:[direction integerValue]];
}


@end