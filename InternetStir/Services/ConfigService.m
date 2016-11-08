//
//  ConfigService.m
//  PoPoNews
//
//  Created by apple on 15/4/20.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConfigService.h"
#import "SettingService.h"
#import "MMSystemHelper.h"
#import "ITSAppConst.h"
#import "MMLogger.h"
#import "NewsService.h"
//#import "MMImageView.h"
//#import "NewsGridItem.h"
#import "UIImage+MultiFormat.h"
#import <CommonCrypto/CommonDigest.h>
#import "AppStyleConfiguration.h"

ConfigService* configInstance = nil;

@implementation ConfigService

@synthesize currentChannel;


+(ConfigService*) get{
    @synchronized(self){
        if (configInstance == nil){
            configInstance = [ConfigService alloc];
           // [configInstance getGridWidthWithHeight];
        }
    }
    
    return configInstance;
}

-(CGFloat) getPopoNewsHeaderBgHeight{
    return 40;
}

-(void) setChannel: (NSString*) ch{
    self.currentChannel = ch;
    
    SettingService* ss = [SettingService get];
    if (ss != nil){
        [ss setStringValue:POPONEWS_CHANNEL_KEY data:self.currentChannel];
    }
}

-(NSString*) getChannel{
    //return self.currentChannel;
    return @"238dc0b4-729d-4fa9-ac9c-9ba57c91c1e8";  // 肆一
    //return @"69db3157-f2b5-48b7-a237-0bb4dce16ea6"; // How Fun
    //return @"71ca0551-2d8b-4946-a15e-701c813ed537"; // 台湾妞韩国媳
    //return @"8c398a20-0394-4db0-be74-f6c1eba28796"; // 左撇子的电影博物馆
//    return @"d1ce6ba1-3636-4938-9614-7649058344b4";   // 我是马克
    //return @"017d8be4-8d03-4722-ae8e-6500c086f2ec";   // 菜啊嘎
    //return @"017d8be4-8d03-4722-ae8e-6500c086f2ec";     //测试
}

-(NSString*) getListArticleWidthHeight{
    return self.listArticleIconWidthHeight;
}

-(NSString*) getListImageWidthHeight{
    return self.listImageIconWidthHeight;
}
-(NSString *) getPinPhotoWidthHeight{
    return self.pinPhotoWidthHeight;
}
-(NSString*) getListHotImageWidthHeight{
    return self.listHotImageWidthHeight;
}

-(NSString*) getCelebCacheFolder{
    
    if (self.celebCacheFolderPath == nil){
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [path objectAtIndex:0];
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        // create   celebcache folder
        self.celebCacheFolderPath = [NSString stringWithFormat:@"%@/%@", documentPath, MM_CELEB_CACHE_FOLDER];
        BOOL isDir = NO;
        BOOL folderExist = [fileMgr fileExistsAtPath:self.celebCacheFolderPath isDirectory:&isDir];
        if (!(isDir == YES && folderExist == YES)){
            NSError* cfError = nil;
            [fileMgr createDirectoryAtPath:self.celebCacheFolderPath withIntermediateDirectories:YES attributes:nil error:&cfError];
        }
    }
    
    return self.celebCacheFolderPath;
}
-(NSString*) getlaunchFolder{
    
    if (self.launchFolderPath == nil){
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [path objectAtIndex:0];
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        // create   launch folder
        self.launchFolderPath = [NSString stringWithFormat:@"%@/%@", documentPath, MM_LAUNCH_FOLDER];
        BOOL isDir = NO;
        BOOL folderExist = [fileMgr fileExistsAtPath:self.launchFolderPath isDirectory:&isDir];
        if (!(isDir == YES && folderExist == YES)){
            NSError* cfError = nil;
            [fileMgr createDirectoryAtPath:self.launchFolderPath withIntermediateDirectories:YES attributes:nil error:&cfError];
        }
    }
    
    return self.launchFolderPath;
}

- (NSString *) getPhotoWidthHeight:(NewsImage*)photo{
    CGFloat screenW = [MMSystemHelper getScreenWidth];
    int photoW = screenW/2 - 15;
    self.Pin1PhotoWidthHeight = [[NSString alloc] initWithFormat:@"%dx%d", photoW*2, photo.h * photoW/photo.w*2];
    return self.Pin1PhotoWidthHeight;
}
-(NSString*) getGridImageWidthHeight:(int)type{
    
    int width, height;
    width = [self getGridPhotoWidth:type];
    height = [self getGridPhotoHeight:type];
    self.gridPhotoWithHeight = [[NSString alloc] initWithFormat:@"%dx%d",width*2, height*2];
    return  self.gridPhotoWithHeight;
}

-(void) initLocaleConfig{
    int width, height;
    width = [self getNewsIconWidth:NEWS_TYPE_ARTICLE];
    height = [self getNewsIconHeight:NEWS_TYPE_ARTICLE];
    
    self.listArticleIconWidthHeight = [[NSString alloc] initWithFormat:@"%dx%d", width*2, height*2];
    
    width = [self getNewsIconWidth:NEWS_TYPE_IMAGE];
    height = [self getNewsIconHeight:NEWS_TYPE_IMAGE];
    self.listImageIconWidthHeight = [[NSString alloc] initWithFormat:@"%dx%d", width*2, height*2];
    
    width = [self getNewsIconWidth:NEWS_TYPE_TOP_IMAGE];
    height = [self getNewsIconHeight:NEWS_TYPE_TOP_IMAGE];
    self.listHotImageWidthHeight = [[NSString alloc] initWithFormat:@"%dx%d", width*2, height*2];
    
    width =  [MMSystemHelper getScreenWidth];
    height = [self getPinPhotoHeight];
    self.pinPhotoWidthHeight = [[NSString alloc] initWithFormat:@"%dx%d", width*2, height*2];

    
    [self releaseDetailPageHtmlFiles];
    SettingService* ss = [SettingService get];
    if (ss != nil){
        self.currentChannel = [ss getStringValue:POPONEWS_CHANNEL_KEY defValue:nil];
        self.type = [ss getIntValue:CONFIG_DAY_NIGHT_MODE defValue:MODE_DAY];
    }
}

-(CGFloat) getNewsPin1IconHeight:(NSString*) type{
    CGFloat height = 80;
    //CGFloat screenH = [MMSystemHelper getScreenHeight];
    
    return height;
}
-(void) setTypeValue:(int)type{
    
    self.type = type;
    SettingService* ss = [SettingService get];
    [ss setIntValue:CONFIG_DAY_NIGHT_MODE data:type];
}

-(void) copyToLocaleFileSystem: (NSString*) dst
                        fromFile: (NSString*) src{
    if (src == nil || dst == nil)
        return;
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    BOOL bRet = [fileMgr fileExistsAtPath:dst];
    if (bRet) {
        NSError *err;
        [fileMgr removeItemAtPath:dst error:&err];
    }
    
    NSData* data = [NSData dataWithContentsOfFile:src];
    //MMLogDebug(@"copy file data %d", data == nil);
    if (data != nil){
        //[fileMgr createFileAtPath:dst contents:nil attributes:nil];
        BOOL ret = [data writeToFile:dst atomically:YES];
        MMLogDebug(@"copy file write data %d", ret);
        //NSFileHandle* fH = [NSFileHandle fileHandleForWritingAtPath:dst];
        //[fH writeData:data];
        //[fH closeFile];
    }
}

-(void) releaseDetailPageHtmlFiles{
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    // create cache folder
    NSString* cacheFolder = [NSString stringWithFormat:@"%@/%@", documentPath, CACHE_FILES_FOLDER];
    BOOL isDir = NO;
    BOOL cacheFolderExist = [fileMgr fileExistsAtPath:cacheFolder isDirectory:&isDir];
    if (!(isDir == YES && cacheFolderExist == YES)){
        NSError* cfError = nil;
        [fileMgr createDirectoryAtPath:cacheFolder withIntermediateDirectories:YES attributes:nil error:&cfError];
    }
    
    // create cache/detail folder
    NSString* detailFolder = [NSString stringWithFormat:@"%@/%@/%@", documentPath, CACHE_FILES_FOLDER, DETAIL_PAGE_FOLDER];
    BOOL detailFolderExist = [fileMgr fileExistsAtPath:detailFolder isDirectory:&isDir];
    if (!(isDir == YES && detailFolderExist == YES)){
        NSError* cfError = nil;
        [fileMgr createDirectoryAtPath:detailFolder withIntermediateDirectories:YES attributes:nil error:&cfError];
    }
    
    NSString* zeptoPath = [NSString stringWithFormat:@"%@/%@/%@/zepto.min.js", documentPath, CACHE_FILES_FOLDER, DETAIL_PAGE_FOLDER];
    NSBundle* bundle = [NSBundle mainBundle];
    NSString* resZeptoPath = [bundle pathForResource:@"zepto.min" ofType:@"js"];
    [self copyToLocaleFileSystem:zeptoPath fromFile:resZeptoPath];

    NSString* tempHtmlPath = [NSString stringWithFormat:@"%@/%@/%@/template_regular.html", documentPath, CACHE_FILES_FOLDER, DETAIL_PAGE_FOLDER];
    NSString* resTempHtmlPath = [bundle pathForResource:@"template_regular" ofType:@"html"];
    [self copyToLocaleFileSystem:tempHtmlPath fromFile:resTempHtmlPath];
    
    NSString* stylePath = [NSString stringWithFormat:@"%@/%@/%@/style.css", documentPath, CACHE_FILES_FOLDER, DETAIL_PAGE_FOLDER];
    NSString* resStylePath = [bundle pathForResource:@"style" ofType:@"css"];
    [self copyToLocaleFileSystem:stylePath fromFile:resStylePath];
    
    NSString* mainPath = [NSString stringWithFormat:@"%@/%@/%@/main.js", documentPath, CACHE_FILES_FOLDER, DETAIL_PAGE_FOLDER];
    NSString* resMainPath = [bundle pathForResource:@"main" ofType:@"js"];
    [self copyToLocaleFileSystem:mainPath fromFile:resMainPath];
    
    NSString* js2nPath = [NSString stringWithFormat:@"%@/%@/%@/JSToNativeService.js", documentPath, CACHE_FILES_FOLDER, DETAIL_PAGE_FOLDER];
    NSString* resJs2NPath = [bundle pathForResource:@"JSToNativeService" ofType:@"js"];
    [self copyToLocaleFileSystem:js2nPath fromFile:resJs2NPath];
    
    NSString* handlebarPath = [NSString stringWithFormat:@"%@/%@/%@/handlebars-v2.0.0.js", documentPath, CACHE_FILES_FOLDER, DETAIL_PAGE_FOLDER];
    NSString* resHandlebarPath = [bundle pathForResource:@"handlebars-v2.0.0" ofType:@"js"];
    [self copyToLocaleFileSystem:handlebarPath fromFile:resHandlebarPath];
    
    NSString* flipsnapPath = [NSString stringWithFormat:@"%@/%@/%@/flipsnap.js", documentPath, CACHE_FILES_FOLDER, DETAIL_PAGE_FOLDER];
    NSString* resFlipsnapPath = [bundle pathForResource:@"flipsnap" ofType:@"js"];
    [self copyToLocaleFileSystem:flipsnapPath fromFile:resFlipsnapPath];
    
    // ad.png
    NSString* tempAdPath = [NSString stringWithFormat:@"%@/%@/%@/ad.png", documentPath, CACHE_FILES_FOLDER, DETAIL_PAGE_FOLDER];
    NSString* resAdPath = [bundle pathForResource:@"ad" ofType:@"png"];
    [self copyToLocaleFileSystem:tempAdPath fromFile:resAdPath];
    
    // create cache/detail/temp folder
    NSString* detailTempFolder = [NSString stringWithFormat:@"%@/%@/%@/temp", documentPath, CACHE_FILES_FOLDER, DETAIL_PAGE_FOLDER];
    BOOL detailTempFolderExist = [fileMgr fileExistsAtPath:detailTempFolder isDirectory:&isDir];
    if (!(isDir == YES && detailTempFolderExist == YES)){
        NSError* cfError = nil;
        [fileMgr createDirectoryAtPath:detailTempFolder withIntermediateDirectories:YES attributes:nil error:&cfError];
    }
}

-(CGFloat) getNewsListItemHeight: (NSString*) type{
    CGFloat height = 80;
    CGFloat screenH = [MMSystemHelper getScreenHeight];
    
    // rightPhoto             h = 10 + 70 + 10 + 20 + 5;
    // three   CGFloat width = (screenW - 34)/3; h = 10 + 30 + 20 + 5 + 9 * width/16
    //bigPhoto h = 10 + 30 +  9 * (screenW - 30)/16 + 20 + 5
    
    if ([type compare:NEWS_TYPE_ARTICLE] == NSOrderedSame)
        height = screenH / 7;
    else if ([type compare:NEWS_TYPE_IMAGE] == NSOrderedSame)
        height = screenH / 5;
    else if ([type compare:NEWS_TYPE_TOP_IMAGE] == NSOrderedSame)
        height = screenH / 3;
    
    return height;
}
-(CGFloat) getGridPhotoHeight:(int) type{
    CGFloat height = 80;
    CGFloat screenH = [MMSystemHelper getScreenHeight];
    if (type == 1 || type == 2) {
        height = screenH/6 - 10;
    }else if (type == 3){
        height = screenH/3 - 50;
    }else if (type == 4){
        height = screenH/3 - 10 - 90;
    }
    return height;
}
-(CGFloat) getGridPhotoWidth:(int) type{
    CGFloat w = 74;
    CGFloat screenW = [MMSystemHelper getScreenWidth];
    if (type == 1 || type == 2) {
        w = screenW/3 - 20;
    }else if (type == 3){
        w = (screenW - 20)/2;
    }else if (type == 4){
        w = (screenW - 30)/3;
    }
    return w;
}
-(CGFloat) getNewsIconWidth: (NSString*) type{
    CGFloat w = 74;
    
    CGFloat screenW = [MMSystemHelper getScreenWidth];
    
    if ([type compare:NEWS_TYPE_ARTICLE] == NSOrderedSame)
        w = (screenW * 2 / 7);
    else if ([type compare:NEWS_TYPE_IMAGE] == NSOrderedSame)
        w = ((screenW - 32) / 3);
    else if ([type compare:NEWS_TYPE_TOP_IMAGE] == NSOrderedSame)
        w = (screenW);
    
    return w;
}

-(CGFloat) getNewsIconHeight: (NSString*) type {
    CGFloat h = 64;
    CGFloat itemH = [self getNewsListItemHeight:type];
    
    if ([type compare:NEWS_TYPE_ARTICLE] == NSOrderedSame)
        h = (itemH - 16);
    else if ([type compare:NEWS_TYPE_IMAGE] == NSOrderedSame)
        h = (itemH - 40);
    else if ([type compare:NEWS_TYPE_TOP_IMAGE] == NSOrderedSame)
        h = itemH;
    
    return h;
}
-(CGFloat) getPinPhotoHeight{
    
    CGFloat screenH = [MMSystemHelper getScreenHeight];
    CGFloat sysTitleBarH = [MMSystemHelper getStatusBarHeight];
    ConfigService* cs = [ConfigService get];
    CGFloat headerHeight = [cs getPopoNewsHeaderBgHeight];
    return (screenH - sysTitleBarH - headerHeight)/2 - 40;
}
- (CGFloat)getGridCellHeihet:(int)type{
   
    CGFloat screenH = [MMSystemHelper getScreenHeight];
    CGFloat H;
    if (type == 1 ){
        H = screenH/6;
    } else if (type == 2) {
        H = screenH/6;
    }else if (type == 3){
        H = screenH/3 + 30;
    }else if (type == 4){
       H = screenH/3 - 10;
    }
    return H;
}
-(NSString*) getImageCacheFolder{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    // create mmimage cache folder
    NSString* mmimageCacheFolder = [NSString stringWithFormat:@"%@/%@", documentPath, MM_WEB_IMAGE_CACHE_FOLDER];
    BOOL isDir = NO;
    BOOL folderExist = [fileMgr fileExistsAtPath:mmimageCacheFolder isDirectory:&isDir];
    if (!(isDir == YES && folderExist == YES)){
        NSError* cfError = nil;
        [fileMgr createDirectoryAtPath:mmimageCacheFolder withIntermediateDirectories:YES attributes:nil error:&cfError];
    }
    
    return mmimageCacheFolder;
}
- (NSString *)cachedFileNameForKey:(NSString *)key {
    const char *str = [key UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return filename;
}
-(NSString*) getArticleCacheFolder{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    // create articles cache folder
    NSString* articlesCacheFolder = [NSString stringWithFormat:@"%@/%@/%@", documentPath, CACHE_FILES_FOLDER, ARTICLE_CACHE_FOLDER];
    BOOL isDir = NO;
    BOOL folderExist = [fileMgr fileExistsAtPath:articlesCacheFolder isDirectory:&isDir];
    if (!(isDir == YES && folderExist == YES)){
        NSError* cfError = nil;
        [fileMgr createDirectoryAtPath:articlesCacheFolder withIntermediateDirectories:YES attributes:nil error:&cfError];
    }
    return articlesCacheFolder;
}
-(UIColor*) getTopBgViewRedColor:(int)mode{
    UIColor *color;
    if (mode == MODE_DAY) {
      color = [MMSystemHelper string2UIColor:COLOR_BG_RED];
    }
    if (mode == MODE_NIGHT){//1
      color = [MMSystemHelper string2UIColor:COLOR_BG_RED_NIGHT];
    }
    return color;
}
-(UIColor*) getTopBgViewFontColor:(int)mode{
    UIColor *color;
    if (mode == MODE_DAY) {
        color = [MMSystemHelper string2UIColor:COLOR_BG_WHITE];
       //color = [MMSystemHelper string2UIColor:COLOR_BG_GREY];
    }
    if (mode == MODE_NIGHT){
        color = [MMSystemHelper string2UIColor:COLOR_BG_WHITE_NIGHT];
    }
    return color;
}
- (UIColor*) getScrollViewTitleColor:(int)mode{
    UIColor *color;
    if (mode == MODE_DAY) {
       // color = [MMSystemHelper string2UIColor:COLOR_BG_WHITE];
        color = [MMSystemHelper string2UIColor:COLOR_BG_BLACK];
    }
    if (mode == MODE_NIGHT){
        color = [MMSystemHelper string2UIColor:COLOR_BG_WHITE_NIGHT];
    }
    return color;
}

-(UIColor*) getArticleCellBigFontColor:(int)mode{
    UIColor *color;
    if (mode == MODE_DAY) {
        color = [MMSystemHelper string2UIColor:COLOR_BG_GREY];
    }
    if (mode == MODE_NIGHT){
        color = [MMSystemHelper string2UIColor:COLOR_BG_WHITE_NIGHT];
    }
    return color;
}
-(UIColor*) getPhotoFontColor:(int)mode{
    UIColor *color;
    if (mode == MODE_DAY) {
        color = [MMSystemHelper string2UIColor:COLOR_BG_WHITE];
    }
    if (mode == MODE_NIGHT){
        color = [MMSystemHelper string2UIColor:COLOR_BG_WHITE_NIGHT];
    }
    return color;

}
//滚动视图
-(UIColor*) getScrollViewBgColor:(int)mode{

    UIColor *color;
    if (mode == MODE_DAY) {
//        CGFloat r = 215.0 / 255.0;
//        CGFloat g = 49.0 / 255.0;
//        CGFloat b = 35.0 / 255.0;
        //color = [UIColor colorWithRed:r green:g blue:b alpha:1.0];
        color = [MMSystemHelper string2UIColor:COLOR_CATEGORY_BG];
    }
    if (mode == MODE_NIGHT) {
        color = [MMSystemHelper string2UIColor:COLOR_BG_RED_NIGHT];
    }
    return color;
}
//分类
-(UIColor*) getCategoryViewFontColor:(int)mode{
    UIColor *color;
    if (mode == MODE_DAY) {
        color = [MMSystemHelper string2UIColor:COLOR_BG_WHITE];
    }
    if (mode == MODE_NIGHT){
        color = [MMSystemHelper string2UIColor:COLOR_BG_WHITE_NIGHT];
    }
    return color;
}

-(UIColor*) getCategoryViewYellowViewColor:(int)mode{
    UIColor *color;
    if (mode == MODE_DAY) {
        color = [MMSystemHelper string2UIColor:COLOR_BG_YELLOW];
    }
    if (mode == MODE_NIGHT){
        color = [MMSystemHelper string2UIColor:COLOR_BG_YELLOW_NIGHT];
    }
    return color;
}

//图片上的字体
-(UIColor*) getPhotoCellFontColor:(int)mode{
    UIColor *color;
    if (mode == MODE_DAY) {
        color = [MMSystemHelper string2UIColor:COLOR_BG_WHITE];
    }
    if (mode == MODE_NIGHT){
        color = [MMSystemHelper string2UIColor:COLOR_BG_WHITE_NIGHT];
    }
    return color;     
}
-(UIColor*) getTabBarColor:(int)mode{
    UIColor *color;
    if (mode == MODE_DAY) {
        color = [MMSystemHelper string2UIColor:COLOR_BG_WHITE];
    }
    if (mode == MODE_NIGHT){
        color = [UIColor blackColor];
        //color = [MMSystemHelper string2UIColor:COLOR_CELL_BACKGROUND_NIGHT];
    }
    return color;

}
-(UIColor*) getPhotoCellBackground:(int)mode{
    UIColor *color;
    if (mode == MODE_DAY) {
        color = [MMSystemHelper string2UIColor:COLOR_BG_WHITE];
    }
    if (mode == MODE_NIGHT){
        color = [MMSystemHelper string2UIColor:COLOR_CELL_BACKGROUND_NIGHT];
    }
    return color;
}
//文章单元格上的字体
-(UIColor*) getNoReadArticleCellBigFontColor:(int)mode{
    UIColor *color;
    if (mode == MODE_DAY) {
        color = [MMSystemHelper string2UIColor:COLOR_BG_BLACK];
    }
    if (mode == MODE_NIGHT){
        color = [MMSystemHelper string2UIColor:COLOR_BG_WHITE_NIGHT];
    }
    
    return color;
}
-(UIColor*) getDetailArticleBackgroungColor:(int)mode{
    UIColor *color;
    if (mode == MODE_DAY) {
        color = [MMSystemHelper string2UIColor:COLOR_BG_WHITE];
    }
    if (mode == MODE_NIGHT){
        color = [MMSystemHelper string2UIColor:COLOR_BG_BLACK];
    }
    
    return color;
}
-(UIColor*) getCommentBarColor:(int)mode{
    UIColor *color;
    if (mode == MODE_DAY) {
        color = [MMSystemHelper string2UIColor:COLOR_BG_WHITE];
    }
    if (mode == MODE_NIGHT){
        color = [UIColor grayColor];
    }
    return color;
}
-(UIColor*) getArticleCellSmallFontColor:(int)mode{
    UIColor *color;
    if (mode == MODE_DAY) {
        color = [MMSystemHelper string2UIColor:COLOR_BG_GREY];
    }
    if (mode == MODE_NIGHT){
        color = [MMSystemHelper string2UIColor:COLOR_BG_GREY_NIGHT];
    }
    return color;
}
-(UIColor*) getReadArticleCellBigFontColor:(int)mode{
    UIColor *color;
    if (mode == MODE_DAY) {
        color = [MMSystemHelper string2UIColor:COLOR_BG_GREY];
    }
    if (mode == MODE_NIGHT){
        color = [MMSystemHelper string2UIColor:COLOR_BG_WHITE_NIGHT];
    }
    return color;
}
-(UIColor*) getArticleCellBackgroundColor:(int)mode{
    UIColor *color;
    if (mode == MODE_DAY) {
        color = [MMSystemHelper string2UIColor:COLOR_BG_WHITE];
    }
    if (mode == MODE_NIGHT){
        color = [MMSystemHelper string2UIColor:COLOR_CELL_BACKGROUND_NIGHT];
    }
    return color;
}
//黄色视图
-(UIColor*) getYellowViewColor:(int)mode{
    UIColor *color;
//    if (mode == MODE_DAY) {
///[MMSystemHelper string2UIColor:COLOR_BG_YELLOW];
//    }
//    if (mode == MODE_NIGHT){
//        color = [MMSystemHelper string2UIColor:COLOR_BG_RED];//[MMSystemHelper string2UIColor:COLOR_BG_YELLOW_NIGHT];
//    }
    color = [MMSystemHelper string2UIColor:HOME_VIPNAME_COLOR];
    return color;
}

//设置界面字体
-(UIColor*) getSettingFontColor:(int)mode{
    UIColor *color;
    if (mode == MODE_DAY) {
        color = [UIColor blackColor];
        //color = [MMSystemHelper string2UIColor:COLOR_BG_BLACK];
    }
    if (mode == MODE_NIGHT){
        //color = [MMSystemHelper string2UIColor:COLOR_BG_WHITE_NIGHT];
        color = [UIColor lightGrayColor];
    }
    return color;

}
-(UIColor*) getSettingBackgroundColor:(int)mode{
    UIColor *color;
    if (mode == MODE_DAY) {
        color = [UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0f alpha:1];
    }
    if (mode == MODE_NIGHT){
        color = [MMSystemHelper string2UIColor:COLOR_BG_BLACK];
    }
    return color;

}
-(UIColor*) getPhotoBackground{
    UIColor *color = [MMSystemHelper string2UIColor:COLOR_BG_BLACK];
    return color;
}
-(UIColor*) getPhotoFontColor{
    UIColor *color = [MMSystemHelper string2UIColor:COLOR_BG_WHITE];
    return color;
}
-(UIColor*) getPhotoTopLineColor{
    UIColor *color = [MMSystemHelper string2UIColor:COLOR_BG_WHITE];
    return color;
}
-(UIColor*) getRightViewLineColor{
    UIColor *color = [MMSystemHelper string2UIColor:COLOR_BG_RED];
    return color;
}
-(UIColor*) getContentRefreshTextColor:(int)mode{
    UIColor *color;
    if (mode == MODE_DAY) {
        color = [MMSystemHelper string2UIColor:COLOR_BG_BLACK];
    }
    if (mode == MODE_NIGHT){
        color = [MMSystemHelper string2UIColor:COLOR_BG_GREY_NIGHT];
    }
    return color;
}
// 进度条
-(UIColor*) getPrgoressBackgroundColor{
    UIColor *color = [MMSystemHelper string2UIColor:COLOR_PROGRESS_BG];
    return color;
}
-(UIColor*) getTableViewHeaderBackgroundColor{
    UIColor *color = [MMSystemHelper string2UIColor:COLOR_TABLEVIEWHEADER_BG];
    return color;
}
@end