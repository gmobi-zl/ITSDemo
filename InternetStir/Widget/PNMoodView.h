//
//  PNMoodView.h
//  PoPoNews
//
//  Created by apple on 15/6/4.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#ifndef PoPoNews_PNMoodView_h
#define PoPoNews_PNMoodView_h

#import <UIKit/UIKit.h>
#import "NewsMood.h"

//@interface PNMoodVoteView : UIView
//
//@property (assign) CGFloat viewRadius;
//@property (assign) CGPoint centerPoint;
//
//@end

@protocol PNMoodViewDelegate <NSObject>

@optional
- (void)moodViewOnClicked:(int)index;

@end


@interface PNMoodView : UIView

@property (assign) int selectedIndex;
@property (assign) CGFloat viewRadius;
@property (assign) CGFloat imageCenterRadius;
@property (assign) CGPoint centerPoint;
@property (assign) int iconSize;
@property UITapGestureRecognizer *moodViewTaped;
@property (assign) BOOL isInit;

@property (strong, nonatomic) UIImageView* worryImage;
@property (strong, nonatomic) UILabel* worryText;
@property (strong, nonatomic) UILabel* worryPercent;

@property (strong, nonatomic) UIImageView* happyImage;
@property (strong, nonatomic) UILabel* happyText;
@property (strong, nonatomic) UILabel* happyPercent;

@property (strong, nonatomic) UIImageView* angryImage;
@property (strong, nonatomic) UILabel* angryText;
@property (strong, nonatomic) UILabel* angryPercent;

@property (strong, nonatomic) UIImageView* sadImage;
@property (strong, nonatomic) UILabel* sadText;
@property (strong, nonatomic) UILabel* sadPercent;

@property (strong, nonatomic) UIImageView* movingImage;
@property (strong, nonatomic) UILabel* movingText;
@property (strong, nonatomic) UILabel* movingPercent;

@property (strong, nonatomic) UIImageView* amazingImage;
@property (strong, nonatomic) UILabel* amazingText;
@property (strong, nonatomic) UILabel* amazingPercent;

//@property (strong, nonatomic) PNMoodVoteView* voteView;
@property (strong, nonatomic) UILabel* voteNumber;
@property (strong, nonatomic) UILabel* voteLabel;

@property (retain) NewsMood* moodData;
@property (assign) BOOL canTap;
@property (assign) int animFinishCount;
@property (assign) BOOL isShowAnimFinished;

@property id <PNMoodViewDelegate> moodViewClickedDelegate;

-(void) setNewsMoodData: (NewsMood*) data;
-(void) showView;
-(void) closeView;

@end

#endif
