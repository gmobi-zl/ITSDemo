//
//  MMWebView.m
//  PoPoNews
//
//  Created by apple on 15/5/14.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMWebView.h"
#import "MMLogger.h"
#import "MMSystemHelper.h"

#define MMWEBVIEW_ACTION_PREFIX @"mmwebviewaction://"
#define MMWEBVIEW_ACTION_MMLOG @"loggerDebug"

@implementation MMWebView

-(void) initMMWebView {
    //self.mmDelegate = [[MMWebViewDelegate alloc] init];
    
    
    [self setDelegate:self];
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

-(void) doWebJSCommand: (NSString*) aId
              acStatus: (NSString*) status
                acData: (NSString*) data{
    NSString* jsCommand;
    if (data != nil)
        jsCommand = [[NSString alloc] initWithFormat:@"try { callJsCallback(\"%@\",\"%@\",%@); }catch(e){console.log('android callback error!');}", aId, status, data];
    else
        jsCommand = [[NSString alloc] initWithFormat:@"try { callJsCallback(\"%@\",\"%@\",null); }catch(e){console.log('android callback error!');}", aId, status];
    
    if ([[NSThread currentThread] isMainThread]) {
        [self stringByEvaluatingJavaScriptFromString:jsCommand];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self stringByEvaluatingJavaScriptFromString:jsCommand];
        });
    }
}

- (BOOL) doWebViewActionCommand{
    NSString* messageStr = [self stringByEvaluatingJavaScriptFromString:@"objcGetJsCommands();"];
    if (messageStr != nil && !([messageStr compare:@""] == NSOrderedSame)){
        NSInteger startPos = [MMWEBVIEW_ACTION_PREFIX length];
        NSString* tActionIdStr = [messageStr substringFromIndex:startPos];
        
        NSRange idEndRange = [tActionIdStr rangeOfString:@"/"];
        NSString* actionId = [tActionIdStr substringToIndex:idEndRange.location];
        NSString* tActionStr = [tActionIdStr substringFromIndex:idEndRange.location+1];
        
        NSRange actionEndRange = [tActionStr rangeOfString:@"/"];
        NSString* action = [tActionStr substringToIndex:actionEndRange.location];
        NSString* tDataStr = [tActionStr substringFromIndex:actionEndRange.location+1];
        
        NSString* dataDecodeStr = [MMSystemHelper decodeString:tDataStr];
        
        if ([action compare:MMWEBVIEW_ACTION_MMLOG] == NSOrderedSame && tDataStr != nil){
            
            if (dataDecodeStr != nil){
                NSData* tmpData = [dataDecodeStr dataUsingEncoding:NSUTF8StringEncoding];
                NSError* nError = nil;
                id jsonObject = [NSJSONSerialization JSONObjectWithData:tmpData options:NSJSONReadingAllowFragments error:&nError];
                NSString* logStr = @"";
                if ([jsonObject isKindOfClass:[NSArray class]]){
                    logStr = [jsonObject objectAtIndex:0];
                }
                
                MMLogDebug(@"MMWebView Log: %@", logStr);
            } else {
                MMLogDebug(@"MMWebView Log: %@", tDataStr);
            }
        } else {
            if ([self.webViewDelegate respondsToSelector:@selector(webViewAtion:actionId:arguments:cb:)]) {
                [self.webViewDelegate webViewAtion:action actionId:actionId arguments:dataDecodeStr cb:^(NSString *cbId, NSString *status, NSString *resultData) {
                    [self doWebJSCommand:cbId acStatus:status acData:resultData];
                }];
            }
        }
        return YES;
    }
    
    return NO;
}

#pragma mark UIWebViewDelegate implementation
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString* url = [NSString stringWithFormat:@"%@", [[request URL] absoluteString]];
    
    MMLogDebug(@"shouldStartLoadWithRequest url : %@", url);
    
    BOOL iswebAction = [url hasPrefix:MMWEBVIEW_ACTION_PREFIX];
    if (iswebAction == YES){
        BOOL doActionRet = YES;
        while (doActionRet) {
            doActionRet = [self doWebViewActionCommand];
        }
        return NO;
    }
    
    //BOOL facebookLoginRet = [self strMatchCheck:url parten:@"^login://.*?"];
    
    if ([self.webViewDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        return [self.webViewDelegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSURL* url = [webView.request URL];
    NSString* urlStr = [url absoluteString];
    
    MMLogDebug(@"webViewDidStartLoad url : %@", urlStr);
    
    if ([self.webViewDelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        return [self.webViewDelegate webViewDidStartLoad:webView];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSURL* url = [webView.request URL];
    NSString* urlStr = [url absoluteString];
    MMLogDebug(@"webViewDidFinishLoad url : %@", urlStr);
    
    if ([self.webViewDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        return [self.webViewDelegate webViewDidFinishLoad:webView];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSURL* url = [webView.request URL];
    NSString* urlStr = [url absoluteString];
    MMLogDebug(@"didFailLoadWithError url : %@", urlStr);
    
    if ([self.webViewDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        return [self.webViewDelegate webView:webView didFailLoadWithError:error];
    }
}

@end