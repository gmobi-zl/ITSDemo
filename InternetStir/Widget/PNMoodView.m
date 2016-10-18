//
//  PNMoodView.m
//  PoPoNews
//
//  Created by apple on 15/6/4.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PNMoodView.h"
#import "MMSystemHelper.h"
#import "ITSAppConst.h"
#import "MMLogger.h"
#import "ITSApplication.h"

#define PI 3.14159265358979323846

#define SIN30 0.5
#define SIN60 0.866
#define COS30 0.866
#define COS60 0.5
#define SIN15 0.2588
#define SIN45 0.707
#define SIN75 0.9659
#define COS15 0.9659
#define COS45 0.707
#define COS75 0.2588
#define TAN30 0.5773
#define TAN60 1.7321

#define MOOD_TEXT_SIZE 9

static inline float radians(double degrees) {
    return degrees * PI / 180;
}

static inline void drawArc(CGContextRef ctx, CGPoint point, float radius, float angle_start, float angle_end, UIColor* color) {
    CGContextMoveToPoint(ctx, point.x, point.y);
    CGContextSetFillColor(ctx, CGColorGetComponents( [color CGColor]));
    CGContextAddArc(ctx, point.x, point.y, radius,  angle_start, angle_end, 0);
    //CGContextClosePath(ctx);
    CGContextFillPath(ctx);
}

//@implementation PNMoodVoteView
//
//
//- (id)initWithFrame:(CGRect)frame {
//    if (self = [super initWithFrame:frame]) {
//        
//    }
//    return self;
//}
//
//-(void) drawRect:(CGRect)rect{
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextClearRect(ctx, rect);
//    CGRect frameRect = self.frame;
//    self.centerPoint = CGPointMake(frameRect.size.width / 2, 0);
//    self.viewRadius = frameRect.size.width / 2;
//    
//    CGContextSetAlpha(ctx, 1.0f);
//    CGFloat startDegree = radians(0.0);
//    CGFloat endDegree = radians(180.0);
//    
//    drawArc(ctx, self.centerPoint, self.viewRadius, startDegree, endDegree, [MMSystemHelper string2UIColor:COLOR_BG_YELLOW]);
//}
//
//@end


@implementation PNMoodView

-(id) init{
    self = [super init];
    
    self.moodData = nil;
    self.canTap = NO;
    self.animFinishCount = 0;
    self.isShowAnimFinished = NO;
    
    self.userInteractionEnabled = YES;
    self.moodViewTaped =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapMoodView)];              
    [self addGestureRecognizer:self.moodViewTaped];
    
    return self;
}

-(void) setNewsMoodData: (NewsMood*) data{
    self.moodData = data;
}

-(void) onTapMoodView {
    if (self.canTap == NO)
        return;
    
    CGPoint tapPoint = [self.moodViewTaped locationInView:self];
    
   // MMLogDebug(@"tap point x = %f, y = %f", tapPoint.x, tapPoint.y);
    CGFloat ppDisSquare = (tapPoint.x - self.centerPoint.x)*(tapPoint.x - self.centerPoint.x) + (tapPoint.y - self.centerPoint.y) * (tapPoint.y - self.centerPoint.y);
    CGFloat radiusSquare = self.viewRadius * self.viewRadius;
    int voteRadius = self.viewRadius / 3;
    CGFloat voteRadiusSquare = voteRadius * voteRadius;
    
    if (ppDisSquare < radiusSquare){
        int tapIndex = 0;
        if (ppDisSquare > voteRadiusSquare){
            if (tapPoint.y == 0){
                if (tapPoint.x > self.centerPoint.x){
                    tapIndex = 1;
                } else {
                    tapIndex = 6;
                }
            } else {
                if (tapPoint.x > self.centerPoint.x){
                    CGFloat xDis = tapPoint.x - self.centerPoint.x;
                    CGFloat tanTapPoint = xDis / tapPoint.y;
                    if (tanTapPoint > TAN60)
                        tapIndex = 1;
                    else if (tanTapPoint >= TAN30 && tanTapPoint < TAN60){
                        tapIndex = 2;
                    } else
                        tapIndex = 3;
                } else if (tapPoint.x < self.centerPoint.x){
                    CGFloat xDis = self.centerPoint.x - tapPoint.x;
                    CGFloat tanTapPoint = tapPoint.y / xDis;
                    if (tanTapPoint > TAN60)
                        tapIndex = 4;
                    else if (tanTapPoint >= TAN30 && tanTapPoint < TAN60){
                        tapIndex = 5;
                    } else
                        tapIndex = 6;
                }
            }
        }
        
        if (tapIndex != 0 && self.selectedIndex == 0 && self.isShowAnimFinished == YES) {
            
            if ([self.moodViewClickedDelegate respondsToSelector:@selector(moodViewOnClicked:)]) {
                [self.moodViewClickedDelegate moodViewOnClicked:tapIndex];
            }
            
            self.selectedIndex = tapIndex;
            [self setNeedsDisplay];
        }
    } else {
        // close view
        [self closeView];
    }
}

-(void) drawRect:(CGRect)rect{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);
    CGRect frameRect = self.frame;
    self.centerPoint = CGPointMake(frameRect.origin.x + frameRect.size.width / 2, 0);
    self.viewRadius = frameRect.size.width / 2 - 10;
    self.imageCenterRadius = self.viewRadius - 40;
    
    CGContextSetAlpha(ctx, 0.8f);
    
    CGFloat startDegree = radians(0.0);
    CGFloat endDegree = radians(180.0);
    if (self.selectedIndex == 0){
        drawArc(ctx, self.centerPoint, self.viewRadius, startDegree, endDegree, [MMSystemHelper string2UIColor:COLOR_BLACK]);
    } else {
        CGFloat selEndDegree = radians(30.0 * self.selectedIndex);
        CGFloat selStartDegree = radians(30.0 * self.selectedIndex - 30.0);
        
        CGFloat bgStartDegree1 = radians(0.0);
        CGFloat bgEndDegree1 = selStartDegree;
        
        CGFloat bgStartDegree2 = selEndDegree;
        CGFloat bgEndDegree2 = radians(180.0);
        
        if (bgStartDegree1 != bgEndDegree1){
            drawArc(ctx, self.centerPoint, self.viewRadius, bgStartDegree1, bgEndDegree1, [MMSystemHelper string2UIColor:COLOR_BLACK]);
        }
        
        if (bgStartDegree2 != bgEndDegree2){
            drawArc(ctx, self.centerPoint, self.viewRadius, bgStartDegree2, bgEndDegree2, [MMSystemHelper string2UIColor:COLOR_BLACK]);
        }
        
        drawArc(ctx, self.centerPoint, self.viewRadius + 10, selStartDegree, selEndDegree, [MMSystemHelper string2UIColor:COLOR_BG_RED]);
    }
    
    [self drawSepLines:ctx];
    
    CGContextSetAlpha(ctx, 1.0f);
    drawArc(ctx, self.centerPoint, self.viewRadius/3, startDegree, endDegree, [MMSystemHelper string2UIColor:COLOR_BG_YELLOW]);
    
    if (self.isInit == NO){
        self.isInit = YES;
        CGFloat sw = [MMSystemHelper getScreenWidth];
//        if(sw >= 414){
//            self.iconSize = 32;
//        } else if (sw >= 375){
//            self.iconSize = 28;
//        } else {
//            self.iconSize = 22 * 320 / sw;
//        }
        self.iconSize = 22 * sw / 320;
        
        CGPoint startPos;

        // amazing
        self.amazingPercent = [[UILabel alloc] init];
        self.amazingPercent.textColor = [UIColor whiteColor];
        startPos.x = self.centerPoint.x + (COS15 * self.imageCenterRadius) - self.iconSize;
        startPos.y = SIN15 * self.imageCenterRadius - (self.iconSize / 2) - 5;
        self.amazingPercent.frame = CGRectMake(startPos.x - 30, startPos.y, 45, 14);
        [self.amazingPercent setText:@"100%"];
        self.amazingPercent.textAlignment = NSTextAlignmentCenter;
        self.amazingPercent.backgroundColor = [UIColor clearColor];
        self.amazingPercent.font = [UIFont systemFontOfSize:10];//[UIFont fontWithName:@"Arial" size:12];
        self.amazingPercent.hidden = YES;
        [self addSubview:self.amazingPercent];

        UIImage* amazingImg = [UIImage imageNamed:@"mood_amazing_normal.png"];
        self.amazingImage = [[UIImageView alloc] init];
        [self.amazingImage setImage:amazingImg];
        CGFloat amazingImgX = self.centerPoint.x + (COS15 * self.imageCenterRadius) - (self.iconSize / 2);
        CGFloat amazingImgY = SIN15 * self.imageCenterRadius - (self.iconSize / 2);
        self.amazingImage.frame = CGRectMake(amazingImgX, amazingImgY, self.iconSize, self.iconSize);
        //self.amazingImage.hidden = YES;
        [self addSubview:self.amazingImage];
        
        self.amazingText = [[UILabel alloc] init];
        self.amazingText.textColor = [UIColor whiteColor];
        startPos.x = self.amazingImage.frame.origin.x - 6;
        startPos.y = self.amazingImage.frame.origin.y + self.amazingImage.frame.size.height + 2;
        self.amazingText.frame = CGRectMake(startPos.x, startPos.y, 50, 14);
        [self.amazingText setText:NSLocalizedString(@"LabelAmazing", nil)];
        self.amazingText.textAlignment = NSTextAlignmentCenter;
        self.amazingText.backgroundColor = [UIColor clearColor];
        self.amazingText.font = [UIFont systemFontOfSize:MOOD_TEXT_SIZE];//[UIFont fontWithName:@"Arial" size:12];
        self.amazingText.hidden = YES;
        [self addSubview:self.amazingText];
        
        // moved
        self.movingPercent = [[UILabel alloc] init];
        self.movingPercent.textColor = [UIColor whiteColor];
        startPos.x = self.centerPoint.x + (COS45 * self.imageCenterRadius) - self.iconSize;
        startPos.y = SIN45 * self.imageCenterRadius - self.iconSize - 8;
        self.movingPercent.frame = CGRectMake(startPos.x - 10, startPos.y, 45, 14);
        //[self.amazingPercent setText:PPN_NSLocalizedString(@"HomeTitle", @"POPONEWS")];
        [self.movingPercent setText:@"100%"];
        self.movingPercent.textAlignment = NSTextAlignmentCenter;
        self.movingPercent.backgroundColor = [UIColor clearColor];
        self.movingPercent.font = [UIFont systemFontOfSize:10];//[UIFont fontWithName:@"Arial" size:12];
        self.movingPercent.hidden = YES;
        [self addSubview:self.movingPercent];
        
        UIImage* movingImg = [UIImage imageNamed:@"mood_moving_normal.png"];
        self.movingImage = [[UIImageView alloc] init];
        [self.movingImage setImage:movingImg];
        CGFloat movingImgX = self.centerPoint.x + (COS45 * self.imageCenterRadius) - (self.iconSize / 2);
        CGFloat movingImgY = SIN45 * self.imageCenterRadius - (self.iconSize / 2);
        self.movingImage.frame = CGRectMake(movingImgX, movingImgY, self.iconSize, self.iconSize);
        //self.movingImage.hidden = YES;
        [self addSubview:self.movingImage];
        
        self.movingText = [[UILabel alloc] init];
        self.movingText.textColor = [UIColor whiteColor];
        startPos.x = self.movingImage.frame.origin.x - 10;
        startPos.y = self.movingImage.frame.origin.y + self.movingImage.frame.size.height + 3;
        self.movingText.frame = CGRectMake(startPos.x, startPos.y, 55, 14);
        [self.movingText setText:NSLocalizedString(@"LabelMoved", nil)];
        self.movingText.textAlignment = NSTextAlignmentCenter;
        self.movingText.backgroundColor = [UIColor clearColor];
        self.movingText.font = [UIFont systemFontOfSize:MOOD_TEXT_SIZE];//[UIFont fontWithName:@"Arial" size:12];
        self.movingText.hidden = YES;
        [self addSubview:self.movingText];
        
        
        // sad
        self.sadPercent = [[UILabel alloc] init];
        self.sadPercent.textColor = [UIColor whiteColor];
        startPos.x = self.centerPoint.x + (COS75 * self.imageCenterRadius) - self.iconSize;
        startPos.y = SIN75 * self.imageCenterRadius - self.iconSize - 10;
        self.sadPercent.frame = CGRectMake(startPos.x, startPos.y, 45, 14);
        [self.sadPercent setText:@"100%"];
        self.sadPercent.textAlignment = NSTextAlignmentCenter;
        self.sadPercent.backgroundColor = [UIColor clearColor];
        self.sadPercent.font = [UIFont systemFontOfSize:10];//[UIFont fontWithName:@"Arial" size:12];
        self.sadPercent.hidden = YES;
        [self addSubview:self.sadPercent];
        
        UIImage* sadImg = [UIImage imageNamed:@"mood_sad_normal.png"];
        self.sadImage = [[UIImageView alloc] init];
        [self.sadImage setImage:sadImg];
        CGFloat sadImgX = self.centerPoint.x + (COS75 * self.imageCenterRadius) - (self.iconSize / 2);
        CGFloat sadImgY = SIN75 * self.imageCenterRadius - (self.iconSize / 2);
        self.sadImage.frame = CGRectMake(sadImgX, sadImgY, self.iconSize, self.iconSize);
        //self.sadImage.hidden = YES;
        [self addSubview:self.sadImage];
        
        self.sadText = [[UILabel alloc] init];
        self.sadText.textColor = [UIColor whiteColor];
        startPos.x = self.sadImage.frame.origin.x - 10;
        startPos.y = self.sadImage.frame.origin.y + self.sadImage.frame.size.height + 3;
        self.sadText.frame = CGRectMake(startPos.x, startPos.y, 30, 14);
        [self.sadText setText:NSLocalizedString(@"LabelSad", nil)];
        self.sadText.textAlignment = NSTextAlignmentCenter;
        self.sadText.backgroundColor = [UIColor clearColor];
        self.sadText.font = [UIFont systemFontOfSize:MOOD_TEXT_SIZE];//[UIFont fontWithName:@"Arial" size:12];
        self.sadText.hidden = YES;
        [self addSubview:self.sadText];
        
        
        // angry
        self.angryPercent = [[UILabel alloc] init];
        self.angryPercent.textColor = [UIColor whiteColor];
        startPos.x = self.centerPoint.x - (COS75 * self.imageCenterRadius) - self.iconSize;
        startPos.y = SIN75 * self.imageCenterRadius - self.iconSize - 10;
        self.angryPercent.frame = CGRectMake(startPos.x + 5, startPos.y, 45, 14);
        [self.angryPercent setText:@"100%"];
        self.angryPercent.textAlignment = NSTextAlignmentCenter;
        self.angryPercent.backgroundColor = [UIColor clearColor];
        self.angryPercent.font = [UIFont systemFontOfSize:10];//[UIFont fontWithName:@"Arial" size:12];
        self.angryPercent.hidden = YES;
        [self addSubview:self.angryPercent];
        
        UIImage* angryImg = [UIImage imageNamed:@"mood_angry_normal.png"];
        self.angryImage = [[UIImageView alloc] init];
        [self.angryImage setImage:angryImg];
        CGFloat angryImgX = self.centerPoint.x - (COS75 * self.imageCenterRadius) - (self.iconSize / 2);
        CGFloat angryImgY = SIN75 * self.imageCenterRadius - (self.iconSize / 2);
        self.angryImage.frame = CGRectMake(angryImgX, angryImgY, self.iconSize, self.iconSize);
        //self.angryImage.hidden = YES;
        [self addSubview:self.angryImage];
        
        self.angryText = [[UILabel alloc] init];
        self.angryText.textColor = [UIColor whiteColor];
        startPos.x = self.angryImage.frame.origin.x - 10;
        startPos.y = self.angryImage.frame.origin.y + self.angryImage.frame.size.height + 3;
        self.angryText.frame = CGRectMake(startPos.x, startPos.y, 30, 14);
        [self.angryText setText:NSLocalizedString(@"LabelAngry", nil)];
        self.angryText.textAlignment = NSTextAlignmentCenter;
        self.angryText.backgroundColor = [UIColor clearColor];
        self.angryText.font = [UIFont systemFontOfSize:MOOD_TEXT_SIZE];//[UIFont fontWithName:@"Arial" size:12];
        self.angryText.hidden = YES;
        [self addSubview:self.angryText];
        
        
        // happy
        self.happyPercent = [[UILabel alloc] init];
        self.happyPercent.textColor = [UIColor whiteColor];
        startPos.x = self.centerPoint.x - (COS45 * self.imageCenterRadius) - self.iconSize;
        startPos.y = SIN45 * self.imageCenterRadius - self.iconSize - 10;
        self.happyPercent.frame = CGRectMake(startPos.x + 15, startPos.y, 45, 14);
        [self.happyPercent setText:@"100%"];
        self.happyPercent.textAlignment = NSTextAlignmentCenter;
        self.happyPercent.backgroundColor = [UIColor clearColor];
        self.happyPercent.font = [UIFont systemFontOfSize:10];//[UIFont fontWithName:@"Arial" size:12];
        self.happyPercent.hidden = YES;
        [self addSubview:self.happyPercent];
        
        UIImage* happyImg = [UIImage imageNamed:@"mood_happy_normal.png"];
        self.happyImage = [[UIImageView alloc] init];
        [self.happyImage setImage:happyImg];
        CGFloat happyImgX = self.centerPoint.x - (COS45 * self.imageCenterRadius) - (self.iconSize / 2);
        CGFloat happyImgY = SIN45 * self.imageCenterRadius - (self.iconSize / 2);
        self.happyImage.frame = CGRectMake(happyImgX, happyImgY, self.iconSize, self.iconSize);
        //self.happyImage.hidden = YES;
        [self addSubview:self.happyImage];
        
        self.happyText = [[UILabel alloc] init];
        self.happyText.textColor = [UIColor whiteColor];
        startPos.x = self.happyImage.frame.origin.x - 10;
        startPos.y = self.happyImage.frame.origin.y + self.happyImage.frame.size.height + 3;
        self.happyText.frame = CGRectMake(startPos.x, startPos.y, 40, 14);
        [self.happyText setText:NSLocalizedString(@"LabelHappy", nil)];
        self.happyText.textAlignment = NSTextAlignmentCenter;
        self.happyText.backgroundColor = [UIColor clearColor];
        self.happyText.font = [UIFont systemFontOfSize:MOOD_TEXT_SIZE];//[UIFont fontWithName:@"Arial" size:12];
        self.happyText.hidden = YES;
        [self addSubview:self.happyText];
        
        
        // worry
        self.worryPercent = [[UILabel alloc] init];
        self.worryPercent.textColor = [UIColor whiteColor];
        startPos.x = self.centerPoint.x - (COS15 * self.imageCenterRadius) + self.iconSize;
        startPos.y = SIN15 * self.imageCenterRadius - (self.iconSize / 2);
        self.worryPercent.frame = CGRectMake(startPos.x - 15, startPos.y, 45, 14);
        [self.worryPercent setText:@"100%"];
        self.worryPercent.textAlignment = NSTextAlignmentCenter;
        self.worryPercent.backgroundColor = [UIColor clearColor];
        self.worryPercent.font = [UIFont systemFontOfSize:10];//[[UIFont fontWithName:@"Arial" size:12];
        self.worryPercent.hidden = YES;
        [self addSubview:self.worryPercent];
        
        UIImage* worryImg = [UIImage imageNamed:@"mood_worry_normal.png"];
        self.worryImage = [[UIImageView alloc] init];
        [self.worryImage setImage:worryImg];
        CGFloat worryImgX = self.centerPoint.x - (COS15 * self.imageCenterRadius) - (self.iconSize / 2);
        CGFloat worryImgY = SIN15 * self.imageCenterRadius - (self.iconSize / 2);
        self.worryImage.frame = CGRectMake(worryImgX, worryImgY, self.iconSize, self.iconSize);
        //self.worryImage.hidden = YES;
        [self addSubview:self.worryImage];
        
        self.worryText = [[UILabel alloc] init];
        self.worryText.textColor = [UIColor whiteColor];
        startPos.x = self.worryImage.frame.origin.x - 20;
        startPos.y = self.worryImage.frame.origin.y + self.worryImage.frame.size.height + 3;
        self.worryText.frame = CGRectMake(startPos.x, startPos.y, 45, 14);
        [self.worryText setText:NSLocalizedString(@"LabelWorry", nil)];
        self.worryText.textAlignment = NSTextAlignmentCenter;
        self.worryText.backgroundColor = [UIColor clearColor];
        self.worryText.font = [UIFont systemFontOfSize:MOOD_TEXT_SIZE];//[[UIFont fontWithName:@"Arial" size:12];
        self.worryText.hidden = YES;
        [self addSubview:self.worryText];
        
        
        self.voteNumber = [[UILabel alloc] init];
        self.voteNumber.textColor = [UIColor blackColor];
        startPos.x = self.centerPoint.x - 42;
        startPos.y = self.centerPoint.y + 5;
        self.voteNumber.frame = CGRectMake(startPos.x, startPos.y, 84, 16);
        [self.voteNumber setText:NSLocalizedString(@"LabelPlease", nil)];
        self.voteNumber.textAlignment = NSTextAlignmentCenter;
        self.voteNumber.backgroundColor = [UIColor clearColor];
        self.voteNumber.font = [UIFont systemFontOfSize:14];//[UIFont fontWithName:@"Arial" size:12];
        [self addSubview:self.voteNumber];
        
        self.voteLabel = [[UILabel alloc] init];
        self.voteLabel.textColor = [UIColor blackColor];
        startPos.x = self.centerPoint.x - 35;
        startPos.y = self.centerPoint.y + 5 + 16 + 2;
        self.voteLabel.frame = CGRectMake(startPos.x, startPos.y, 70, 16);
        [self.voteLabel setText:NSLocalizedString(@"LabelVote", nil)];
        self.voteLabel.textAlignment = NSTextAlignmentCenter;
        self.voteLabel.backgroundColor = [UIColor clearColor];
        self.voteLabel.font = [UIFont systemFontOfSize:14];//[UIFont fontWithName:@"Arial" size:12];
        [self addSubview:self.voteLabel];
    } else {
        if (self.selectedIndex == 1){
            UIImage* amazingImg = [UIImage imageNamed:@"mood_amazing_sel.png"];
            [self.amazingImage setImage:amazingImg];
        } else if (self.selectedIndex == 2){
            UIImage* movingImage = [UIImage imageNamed:@"mood_moving_sel.png"];
            [self.movingImage setImage:movingImage];
        } else if (self.selectedIndex == 3){
            UIImage* sadImage = [UIImage imageNamed:@"mood_sad_sel.png"];
            [self.sadImage setImage:sadImage];
        } else if (self.selectedIndex == 4){
            UIImage* angryImage = [UIImage imageNamed:@"mood_angry_sel.png"];
            [self.angryImage setImage:angryImage];
        } else if (self.selectedIndex == 5){
            UIImage* happyImage = [UIImage imageNamed:@"mood_happy_sel.png"];
            [self.happyImage setImage:happyImage];
        } else if (self.selectedIndex == 6){
            UIImage* worryImage = [UIImage imageNamed:@"mood_worry_sel.png"];
            [self.worryImage setImage:worryImage];
        }
        
        if (self.selectedIndex != 0){
            if (self.moodData != nil){
                
                NSString* type = [self.moodData getMyMoodType];
                if (type != nil){
                    NSString* voteCountStr = [NSString stringWithFormat:@"%d", [self.moodData getTotalCount]];
                    [self.voteNumber setText:voteCountStr];
                    [self.voteLabel setText:NSLocalizedString(@"LabelVotes", nil)];
                } else {
                    [self.voteNumber setText:NSLocalizedString(@"LabelPlease", nil)];
                    [self.voteLabel setText:NSLocalizedString(@"LabelVote", nil)];
                }
                
                int tP = [self.moodData getPercentByType:NEWS_ITEM_MOOD_AMAZE];
                NSString* tpStr = [NSString stringWithFormat:@"%d%%", tP];
                [self.amazingPercent setText:tpStr];
                
                tP = [self.moodData getPercentByType:NEWS_ITEM_MOOD_MOVE];
                tpStr = [NSString stringWithFormat:@"%d%%", tP];
                [self.movingPercent setText:tpStr];
                
                tP = [self.moodData getPercentByType:NEWS_ITEM_MOOD_SAD];
                tpStr = [NSString stringWithFormat:@"%d%%", tP];
                [self.sadPercent setText:tpStr];
                
                tP = [self.moodData getPercentByType:NEWS_ITEM_MOOD_ANGRY];
                tpStr = [NSString stringWithFormat:@"%d%%", tP];
                [self.angryPercent setText:tpStr];
                
                tP = [self.moodData getPercentByType:NEWS_ITEM_MOOD_HAPPY];
                tpStr = [NSString stringWithFormat:@"%d%%", tP];
                [self.happyPercent setText:tpStr];
                
                tP = [self.moodData getPercentByType:NEWS_ITEM_MOOD_WORRY];
                tpStr = [NSString stringWithFormat:@"%d%%", tP];
                [self.worryPercent setText:tpStr];
            }
            self.amazingPercent.hidden = NO;
            self.sadPercent.hidden = NO;
            self.movingPercent.hidden = NO;
            self.angryPercent.hidden = NO;
            self.worryPercent.hidden = NO;
            self.happyPercent.hidden = NO;
        }
    }
}

-(void) drawSepLines: (CGContextRef) ctx{
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    
    CGPoint line1Points[2];
    line1Points[0] = self.centerPoint;
    line1Points[1].x = self.centerPoint.x + COS30 * self.viewRadius;
    line1Points[1].y = SIN30 * self.viewRadius;
    CGContextAddLines(ctx, line1Points, 2);
    CGContextDrawPath(ctx, kCGPathStroke);
    
    CGPoint line2Points[2];
    line2Points[0] = self.centerPoint;
    line2Points[1].x = self.centerPoint.x + COS60 * self.viewRadius;
    line2Points[1].y = SIN60 * self.viewRadius;
    CGContextAddLines(ctx, line2Points, 2);
    CGContextDrawPath(ctx, kCGPathStroke);
    
    CGPoint line3Points[2];
    line3Points[0] = self.centerPoint;
    line3Points[1].x = self.centerPoint.x;
    line3Points[1].y = self.viewRadius;
    CGContextAddLines(ctx, line3Points, 2);
    CGContextDrawPath(ctx, kCGPathStroke);
    
    CGPoint line4Points[2];
    line4Points[0] = self.centerPoint;
    line4Points[1].x = self.centerPoint.x - COS60 * self.viewRadius;
    line4Points[1].y = SIN60 * self.viewRadius;
    CGContextAddLines(ctx, line4Points, 2);
    CGContextDrawPath(ctx, kCGPathStroke);
    
    CGPoint line5Points[2];
    line5Points[0] = self.centerPoint;
    line5Points[1].x = self.centerPoint.x - COS30 * self.viewRadius;
    line5Points[1].y = SIN30 * self.viewRadius;
    CGContextAddLines(ctx, line5Points, 2);
    CGContextDrawPath(ctx, kCGPathStroke);
}

-(CAAnimationGroup*) createImageViewAnim: (UIImageView*) imageView
                              imageIndex: (int) index {
    
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.fromValue = [NSNumber numberWithFloat:0.0];
    rotation.toValue = [NSNumber numberWithFloat:M_PI*2*1];
    rotation.duration = 0.5f;
    rotation.repeatCount = 1;
    rotation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CGPoint startPos;
    if (index == 1){
        startPos.x = self.centerPoint.x + (COS15 * (self.viewRadius / 3)) + (self.iconSize / 2);
        startPos.y = SIN15 * (self.viewRadius / 3) + (self.iconSize / 2);
    } else if (index == 2){
        startPos.x = self.centerPoint.x + (COS45 * (self.viewRadius / 3)) + (self.iconSize / 2);
        startPos.y = SIN45 * (self.viewRadius / 3) + (self.iconSize / 2);
    } else if (index == 3){
        startPos.x = self.centerPoint.x + (COS75 * (self.viewRadius / 3)) + (self.iconSize / 2);
        startPos.y = SIN75 * (self.viewRadius / 3) + (self.iconSize / 2);
    } else if (index == 4){
        startPos.x = self.centerPoint.x - (COS75 * (self.viewRadius / 3)) + (self.iconSize / 2);
        startPos.y = SIN75 * (self.viewRadius / 3) + (self.iconSize / 2);
    } else if (index == 5){
        startPos.x = self.centerPoint.x - (COS45 * (self.viewRadius / 3)) + (self.iconSize / 2);
        startPos.y = SIN45 * (self.viewRadius / 3) + (self.iconSize / 2);
    } else if (index == 6){
        startPos.x = self.centerPoint.x - (COS15 * (self.viewRadius / 3)) + (self.iconSize / 2);
        startPos.y = SIN15 * (self.viewRadius / 3) + (self.iconSize / 2);
    }
    
    CABasicAnimation *posAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    posAnimation.fromValue = [NSValue valueWithCGRect:CGRectMake(startPos.x, startPos.y, imageView.frame.size.width, imageView.frame.size.height)];
    posAnimation.toValue = [NSValue valueWithCGRect:imageView.frame];
    posAnimation.duration = 0.5f;
    posAnimation.fillMode=kCAFillModeForwards;
    posAnimation.removedOnCompletion=YES;
    [posAnimation setDelegate:self];
    posAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 0.5f;
    animationGroup.autoreverses = NO;
    animationGroup.repeatCount = 1;
    [animationGroup setAnimations:[NSArray arrayWithObjects:rotation, posAnimation, nil]];
    
    [animationGroup setDelegate:self];
    [animationGroup setValue:[NSNumber numberWithInt:index] forKey:@"anim_type"];
    
    return animationGroup;
}


-(void) startMoodAnimation{
    CAAnimationGroup* amazingAnim = [self createImageViewAnim:self.amazingImage imageIndex:1];
    CAAnimationGroup* movingAnim = [self createImageViewAnim:self.movingImage imageIndex:2];
    CAAnimationGroup* sadAnim = [self createImageViewAnim:self.sadImage imageIndex:3];
    CAAnimationGroup* angryAnim = [self createImageViewAnim:self.angryImage imageIndex:4];
    CAAnimationGroup* happyAnim = [self createImageViewAnim:self.happyImage imageIndex:5];
    CAAnimationGroup* worryAnim = [self createImageViewAnim:self.worryImage imageIndex:6];
    
    [self.amazingImage.layer addAnimation:amazingAnim forKey:@"anim_roate_pos"];
    [self.movingImage.layer addAnimation:movingAnim forKey:@"anim_roate_pos"];
    [self.sadImage.layer addAnimation:sadAnim forKey:@"anim_roate_pos"];
    [self.angryImage.layer addAnimation:angryAnim forKey:@"anim_roate_pos"];
    [self.happyImage.layer addAnimation:happyAnim forKey:@"anim_roate_pos"];
    [self.worryImage.layer addAnimation:worryAnim forKey:@"anim_roate_pos"];
}

-(void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSNumber* type = [anim valueForKey:@"anim_type"];
    
    if (type.intValue == 1){
        self.animFinishCount++;
        [self.amazingImage.layer removeAllAnimations];
        self.amazingText.hidden = NO;
    } else if (type.intValue == 2) {
        self.animFinishCount++;
        [self.movingImage.layer removeAllAnimations];
        self.movingText.hidden = NO;
    } else if (type.intValue == 3) {
        self.animFinishCount++;
        [self.sadImage.layer removeAllAnimations];
        self.sadText.hidden = NO;
    } else if (type.intValue == 4) {
        self.animFinishCount++;
        [self.angryImage.layer removeAllAnimations];
        self.angryText.hidden = NO;
    } else if (type.intValue == 5) {
        self.animFinishCount++;
        [self.happyImage.layer removeAllAnimations];
        self.happyText.hidden = NO;
    } else if (type.intValue == 6) {
        self.animFinishCount++;
        [self.worryImage.layer removeAllAnimations];
        self.worryText.hidden = NO;
    }
    
    if (self.animFinishCount >= 6){
        if (self.moodData != nil){
            NSString* type = [self.moodData getMyMoodType];
            if (type != nil){
                if ([type compare:NEWS_ITEM_MOOD_AMAZE] == NSOrderedSame){
                    self.selectedIndex = 1;
                } else if ([type compare:NEWS_ITEM_MOOD_MOVE] == NSOrderedSame){
                    self.selectedIndex = 2;
                } else if ([type compare:NEWS_ITEM_MOOD_SAD] == NSOrderedSame){
                    self.selectedIndex = 3;
                } else if ([type compare:NEWS_ITEM_MOOD_ANGRY] == NSOrderedSame){
                    self.selectedIndex = 4;
                } else if ([type compare:NEWS_ITEM_MOOD_HAPPY] == NSOrderedSame){
                    self.selectedIndex = 5;
                } else if ([type compare:NEWS_ITEM_MOOD_WORRY] == NSOrderedSame){
                    self.selectedIndex = 6;
                } else
                    self.selectedIndex = 0;
            }
        }
        
        if (self.selectedIndex != 0)
            [self setNeedsDisplay];
        self.canTap = YES;
        self.isShowAnimFinished = YES;
    }
}

-(void) showView{
    self.hidden = NO;
    self.canTap = NO;
    self.animFinishCount = 0;
    self.isShowAnimFinished = NO;
    
    UIImage* amazingImg = [UIImage imageNamed:@"mood_amazing_normal.png"];
    [self.amazingImage setImage:amazingImg];
    UIImage* movingImage = [UIImage imageNamed:@"mood_moving_normal.png"];
    [self.movingImage setImage:movingImage];
    UIImage* sadImage = [UIImage imageNamed:@"mood_sad_normal.png"];
    [self.sadImage setImage:sadImage];
    UIImage* angryImage = [UIImage imageNamed:@"mood_angry_normal.png"];
    [self.angryImage setImage:angryImage];
    UIImage* happyImage = [UIImage imageNamed:@"mood_happy_normal.png"];
    [self.happyImage setImage:happyImage];
    UIImage* worryImage = [UIImage imageNamed:@"mood_worry_normal.png"];
    [self.worryImage setImage:worryImage];
    
    if (self.moodData != nil){
        NSString* type = [self.moodData getMyMoodType];
        if (type != nil){
            NSString* voteCountStr = [NSString stringWithFormat:@"%d", [self.moodData getTotalCount]];
            [self.voteNumber setText:voteCountStr];
            [self.voteLabel setText:NSLocalizedString(@"LabelVotes", nil)];
        } else {
            [self.voteNumber setText:NSLocalizedString(@"LabelPlease", nil)];
            [self.voteLabel setText:NSLocalizedString(@"LabelVote", nil)];
        }
    }
    
    [self startMoodAnimation];
}

-(void) closeView{
    self.isShowAnimFinished = NO;
    self.selectedIndex = 0;
    
    self.amazingPercent.hidden = YES;
    self.amazingText.hidden = YES;
    self.sadPercent.hidden = YES;
    self.sadText.hidden = YES;
    self.movingPercent.hidden = YES;
    self.movingText.hidden = YES;
    self.angryPercent.hidden = YES;
    self.angryText.hidden = YES;
    self.worryPercent.hidden = YES;
    self.worryText.hidden = YES;
    self.happyPercent.hidden = YES;
    self.happyText.hidden = YES;
    
    self.hidden = YES;
    [self setNeedsDisplay];
}

@end