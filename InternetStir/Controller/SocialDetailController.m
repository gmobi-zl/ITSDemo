
//
//  SocialDetailController.m
//  Jacob
//
//  Created by Apple on 16/10/26.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import "SocialDetailController.h"
#import "MMSystemHelper.h"
#import "ConfigService.h"
#import "SocialWebController.h"
#import "ITSApplication.h"
#import "MMHttpSession.h"
#import "DetailContentController.h"


@interface SocialDetailController ()

@end

@implementation SocialDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat screenW = [MMSystemHelper getScreenWidth];
    CGFloat screenH = [MMSystemHelper getScreenHeight];

    CGRect webFrame = CGRectMake(0.0, 0, screenW, screenH);
    self.webView = [[MMWebView alloc] initWithFrame:webFrame];
    [self.webView initMMWebView];
    self.webView.scalesPageToFit = YES;//适应屏幕大小
    [self.webView setUserInteractionEnabled: YES];  //是否支持交互
    [self.webView setWebViewDelegate:self];
    [self.webView setOpaque: NO];  //透明
    [self.view addSubview:self.webView];
}
-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.hidden = NO;

    UIButton* Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    Btn.frame = CGRectMake(0, 20, 15, 20);
    [Btn setBackgroundImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:Btn];
    self.navigationItem.leftBarButtonItem = left;

}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        return YES;
    }
    return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    BOOL result = NO;
    
    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        result = YES;
    }
    
    return result;
}

-(void) clickBack {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self prepareDetailHtmlFile];
}
// download detail file
-(void) checkCacheFolder{
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
}

-(void) downloadDetailFile : (NSString*) downloadUrl
                  localFile: (NSString*) filePath {
    //download file
    MMHttpSession* httpSession = [MMHttpSession alloc];
    [httpSession download:downloadUrl reqHeader:nil filePath:filePath callback:^(int status, int code, NSDictionary *resultData) {
        
        if (code == 200){
            [self makeIndexHtml:filePath];
        } else {
            self.downloadFailedCount++;
            if (self.downloadFailedCount < 3)
                [self downloadDetailFile:downloadUrl localFile:filePath];
        }
    } progressCallback:nil];
}

-(void) prepareDetailHtmlFile {
    ITSApplication* poApp = [ITSApplication get];
    DataService* ds = poApp.dataSvr;
    CelebRecommend* item = [ds getCurrentDetailNewsItem];
    
    [self checkCacheFolder];
    
    self.cid = item.cid;
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    NSString* articlesCacheFile = [NSString stringWithFormat:@"%@/%@/%@/%@", documentPath, CACHE_FILES_FOLDER, ARTICLE_CACHE_FOLDER, item.body];
    
    BOOL isDir = NO;
    BOOL fileExist = [fileMgr fileExistsAtPath:articlesCacheFile isDirectory:&isDir];
    if (fileExist == NO){
        ITSApplication* itsApp = [ITSApplication get];
        NSString* fileBaseUrl = [itsApp.remoteSvr getBaseFileUrl];

        NSString* fileUrl = [[NSString alloc] initWithFormat:@"%@/%@", fileBaseUrl, item.body];
        
        [self downloadDetailFile:fileUrl localFile:articlesCacheFile];
    } else {
        [self makeIndexHtml:articlesCacheFile];
    }
}

-(void) makeIndexHtml: (NSString*) localFile {
    if (self.view.hidden == YES)
        return;
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    NSString* indexFile = [[NSString alloc] initWithFormat:@"%@/%@/%@/index.html", documentPath, CACHE_FILES_FOLDER,  DETAIL_PAGE_FOLDER];
    NSString* templatesFile = [[NSString alloc] initWithFormat:@"%@/%@/%@/template_regular.html", documentPath, CACHE_FILES_FOLDER, DETAIL_PAGE_FOLDER];
    
    // delete index.html
    BOOL bRet = [fileMgr fileExistsAtPath:indexFile];
    if (bRet) {
        NSError *err;
        [fileMgr removeItemAtPath:indexFile error:&err];
    }
    
    NSError* tError;
    // read templates file
    NSString* templatesStr = [NSString stringWithContentsOfFile:templatesFile encoding:NSUTF8StringEncoding error:&tError];
    
    // read locale detail file
    NSString* detailStr = [NSString stringWithContentsOfFile:localFile encoding:NSUTF8StringEncoding error:&tError];
    
    // replace key string
    NSString* indexStr = [templatesStr stringByReplacingOccurrencesOfString:@"{{content}}" withString:detailStr];
    
    // create index.html
    [indexStr writeToFile:indexFile atomically:YES encoding:NSUTF8StringEncoding error:&tError];
    
    // webview load index.html
    NSString* localUrl = [[NSString alloc] initWithFormat:@"%@?nid=%@", indexFile, self.cid];
    [self loadUrlInWebView:localUrl];
}

-(void)loadUrlInWebView:(NSString *)uri{
    if (self == nil)
        return;
    
    if (self.view.hidden == YES)
        return;
    
//    [self stopLoadingView];
    
    if (self.webView != nil) {
        NSURL* url = [NSURL URLWithString:uri];
        NSURLRequest* request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
}

-(BOOL)strMatchCheck: (NSString*)srcStr
              parten: (NSString*)partenStr {
    
    if (srcStr == nil || partenStr == nil)
        return NO;
    
    NSError* error = NULL;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:partenStr options:0 error:&error];
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:srcStr options:0 range:NSMakeRange(0, [srcStr length])];
        
        if (firstMatch) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark UIWebViewDelegate implementation

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString* url = [NSString stringWithFormat:@"%@", [[request URL] absoluteString]];
    
    MMLogDebug(@"shouldStartLoadWithRequest url : %@", url);
    
    //BOOL facebookLoginRet = [self strMatchCheck:url parten:@"^login://.*?"];
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSURL* url = [webView.request URL];
    NSString* urlStr = [url absoluteString];
    
    MMLogDebug(@"webViewDidStartLoad url : %@", urlStr);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    self.webView.hidden = NO;
    //   [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#ff000000'"];
//    [self stopLoadingView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

-(BOOL) moveOfflineImageFile: (NSString*) fileName{
    if (fileName == nil) return NO;
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString* detailTempFolder = [NSString stringWithFormat:@"%@/%@/%@/temp", documentPath, CACHE_FILES_FOLDER, DETAIL_PAGE_FOLDER];
    NSError *err;
    NSString* srcPath = [NSString stringWithFormat:@"%@/%@/%@", documentPath, MM_WEB_IMAGE_CACHE_FOLDER, fileName];
    
    BOOL srcExist = [fileMgr fileExistsAtPath:srcPath];
    if (srcExist == YES){
        NSString* toPath = [NSString stringWithFormat:@"%@/%@", detailTempFolder, fileName];
        [fileMgr copyItemAtPath:srcPath toPath:toPath error:&err];
        return YES;
    }
    
    return NO;
}

- (void)webViewAtion: (NSString*) action actionId: (NSString*) aId arguments: (NSString*) data cb:(MMWebViewActionCallback) actionCB{
    if ([action compare:@"getNewsData"] == NSOrderedSame){
        ITSApplication* poApp = [ITSApplication get];
        DataService* ds = poApp.dataSvr;
        CelebRecommend* item = [ds getCurrentDetailNewsItem];
        
        NSString* timeStr = [NSString stringWithFormat:@"發布日期: %@",[MMSystemHelper dateFormatStr:item.releaseTime/1000 format:nil]];
        
        //保存每一次选中的字体  设置默认的字体

        NSMutableDictionary* rspDataDic = [NSMutableDictionary dictionaryWithCapacity:2];
        [rspDataDic setObject:item.title == nil ? @"" : item.title forKey:@"title"];
        [rspDataDic setObject:timeStr == nil ? @"" : timeStr forKey:@"time"];
//        [rspDataDic setObject:item.pdomain == nil ? @"" : item.pdomain forKey:@"pname"];
        [rspDataDic setObject:item.source == nil ? @"" : item.source forKey:@"source"];
        [rspDataDic setObject:NSLocalizedString (@"WebViewReadSrc", @"READ THIS ARTICLE ON THE WEB") forKey:@"readsource"];
        
//        int modeType = [ss getIntValue:CONFIG_DAY_NIGHT_MODE defValue:MODE_DAY];
//        NSNumber* dayNightMode = [NSNumber numberWithInt:modeType];
//        [rspDataDic setObject:dayNightMode forKey:@"nightmode"];
        [rspDataDic setObject:poApp.baseUrl forKey:@"entryurl"];
        
        NSString* appId = [MMSystemHelper getAppPackageId];
        [rspDataDic setObject:appId forKey:@"pakname"];
        
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [path objectAtIndex:0];
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSString* tempFolder = [[NSString alloc] initWithFormat:@"%@/%@/%@/temp", documentPath, CACHE_FILES_FOLDER, DETAIL_PAGE_FOLDER];
        [MMSystemHelper removeFileForDir:tempFolder];
        
        // create cache/detail/temp folder
        BOOL isDir = NO;
        BOOL detailTempFolderExist = [fileMgr fileExistsAtPath:tempFolder isDirectory:&isDir];
        if (!(isDir == YES && detailTempFolderExist == YES)){
            NSError* cfError = nil;
            [fileMgr createDirectoryAtPath:tempFolder withIntermediateDirectories:YES attributes:nil error:&cfError];
        }
        
        BOOL isUsedLocalImg = NO;
        NSMutableArray* mms = [NSMutableArray arrayWithCapacity:1];
        for (int i = 0; i < [item.images count]; i++) {
            NewsImage* imgItem = [item.images objectAtIndex:i];
            NSMutableDictionary* webItem = [NSMutableDictionary dictionaryWithCapacity:4];
            [webItem setObject:imgItem.image forKey:@"id"];
            [webItem setObject:[NSNumber numberWithInt:imgItem.w] forKey:@"w"];
            [webItem setObject:[NSNumber numberWithInt:imgItem.h] forKey:@"h"];
            [webItem setObject:imgItem.desc == nil ? @"" : imgItem.desc forKey:@"desc"];
            
            [mms addObject:webItem];
            
            BOOL copyRet = [self moveOfflineImageFile:imgItem.image];
            if (copyRet == YES)
                isUsedLocalImg = YES;
        }
        [rspDataDic setObject:mms forKey:@"mms"];
        if (isUsedLocalImg == YES) {
            [rspDataDic setObject:[NSNumber numberWithInt:1] forKey:@"local"];
        } else {
            [rspDataDic setObject:[NSNumber numberWithInt:0] forKey:@"local"];
        }

        
//        if (item.isOfflineDL == YES && isUsedLocalImg == YES){
//            [rspDataDic setObject:[NSNumber numberWithInt:1] forKey:@"local"];
//        } else {
//            [rspDataDic setObject:[NSNumber numberWithInt:0] forKey:@"local"];
//        }
//        
        NSError *error;
        NSData* transData = [NSJSONSerialization dataWithJSONObject:rspDataDic options:NSJSONWritingPrettyPrinted error:&error];
        NSString* transStr = [[NSString alloc] initWithData:transData encoding:NSUTF8StringEncoding];
        
        actionCB(aId, @"success", transStr);
    } else if ([action compare:@"webOpenSrc"] == NSOrderedSame){
        [self goToReadSourcePage];
    }
}

-(void) goToReadSourcePage{
    
    dispatch_async(dispatch_get_main_queue(), ^{

        ITSApplication* poApp = [ITSApplication get];
        DataService* ds = poApp.dataSvr;
        CelebRecommend* item = [ds getCurrentDetailNewsItem];
    
        DetailContentController *readSourcePage = [[DetailContentController alloc] init];
        readSourcePage.path = item.source;
        readSourcePage.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:readSourcePage animated:YES];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
