//
//  ConfigService.h
//  PoPoNews
//
//  Created by apple on 15/4/20.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#ifndef PoPoNews_ConfigService_h
#define PoPoNews_ConfigService_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ITSAppConst.h"
#import "NewsImage.h"



@interface ConfigService: NSObject{
    NSString* currentChannel;
}

@property NSString* currentChannel;
@property NSString* listArticleIconWidthHeight;
@property NSString* listImageIconWidthHeight;
@property NSString* listHotImageWidthHeight;
@property NSString* pinPhotoWidthHeight;
@property NSString* gridPhotoWithHeight;
@property NSString* Pin1PhotoWidthHeight;
@property NSString* celebCacheFolderPath;
@property NSString* launchFolderPath;

@property (assign) int type;

+(ConfigService*) get;

-(void) initLocaleConfig;
-(void) setChannel: (NSString*) ch;
-(NSString*) getChannel;

-(CGFloat) getNewsListItemHeight: (NSString*) type;
-(CGFloat) getNewsIconWidth: (NSString*) type;
-(CGFloat) getNewsIconHeight: (NSString*) type;

-(NSString*) getListArticleWidthHeight;
-(NSString*) getListImageWidthHeight;
-(NSString*) getListHotImageWidthHeight;
-(NSString*) getGridImageWidthHeight:(int)type;
-(CGFloat) getPopoNewsHeaderBgHeight;
- (NSString *) getPhotoWidthHeight:(NewsImage*)photo;
-(CGFloat) getGridPhotoHeight:(int) type;
-(CGFloat) getGridPhotoWidth:(int) type;
-(CGFloat) getGridCellHeihet:(int)type;

-(CGFloat) getPinPhotoHeight;
-(NSString *) getPinPhotoWidthHeight;
-(NSString*) getImageCacheFolder;
-(NSString*) getArticleCacheFolder;

-(void) setTypeValue:(int)type;
//-(int) getType:(int)type;
//mode为1表示正常模式，为2表示夜间模式
//顶部试图
-(UIColor*) getTopBgViewRedColor:(int)mode;
-(UIColor*) getTopBgViewFontColor:(int)mode;
-(UIColor*) getScrollViewTitleColor:(int)mode;
//分类
-(UIColor*) getCategoryViewFontColor:(int)mode;
-(UIColor*) getCategoryViewYellowViewColor:(int)mode;

//图片上的字体
-(UIColor*) getPhotoCellFontColor:(int)mode;
//图片的背景
-(UIColor*) getPhotoCellBackground:(int)mode;
-(UIColor*) getTabBarColor:(int)mode;
//文章单元格上的字体 没有阅读
-(UIColor*) getNoReadArticleCellBigFontColor:(int)mode;
-(UIColor*) getArticleCellSmallFontColor:(int)mode;
-(UIColor*) getArticleCellBigFontColor:(int)mode;

-(UIColor*) getCommentBarColor:(int)mode;
//图片上的文字
-(UIColor*) getPhotoFontColor:(int)mode;
 //文章详情界面背景
-(UIColor*) getDetailArticleBackgroungColor:(int)mode;


//阅读
-(UIColor*) getReadArticleCellBigFontColor:(int)mode;
-(UIColor*) getArticleCellBackgroundColor:(int)mode;

//设置界面字体
-(UIColor*) getSettingFontColor:(int)mode;
-(UIColor*) getSettingBackgroundColor:(int)mode;

//收藏界面背景
//-(UIColor*) getFavoriteBackgroundColor:(int)mode;

//主界面黄色的视图
-(UIColor*) getYellowViewColor:(int)mode;
//滚动式图北京颜色
-(UIColor*) getScrollViewBgColor:(int)mode;

//图片详情界面的背景
-(UIColor*) getPhotoBackground;
//图片详情界面上的字体
-(UIColor*) getPhotoFontColor;
//图片详情界面顶部的线
-(UIColor*) getPhotoTopLineColor;
//right线的颜色
-(UIColor*) getRightViewLineColor;
//刷新提示字体颜色
-(UIColor*) getContentRefreshTextColor:(int)mode;

//进度条背景颜色
-(UIColor*) getPrgoressBackgroundColor;

//tableViewHeader
-(UIColor*) getTableViewHeaderBackgroundColor;

- (NSString *) cachedFileNameForKey:(NSString *)key;

-(NSString*) getlaunchFolder;
-(NSString*) getCelebCacheFolder;
@end

#endif
