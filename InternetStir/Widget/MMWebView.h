//
//  MMWebView.h
//  PoPoNews
//
//  Created by apple on 15/5/14.
//  Copyright (c) 2015年 Gmobi. All rights reserved.
//

#ifndef PoPoNews_MMWebView_h
#define PoPoNews_MMWebView_h

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@protocol MMWebViewDelegate;

typedef void (^MMWebViewActionCallback)(NSString* cbId, NSString* status, NSString* resultData);


@interface MMWebView : UIWebView<UIWebViewDelegate>


@property id<MMWebViewDelegate> webViewDelegate;

-(void) initMMWebView;

@end


@protocol MMWebViewDelegate <NSObject>

@optional
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)webViewDidStartLoad:(UIWebView *)webView;
- (void)webViewDidFinishLoad:(UIWebView *)webView;
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;

- (void)webViewAtion: (NSString*) action actionId: (NSString*) aId arguments: (NSString*) data cb:(MMWebViewActionCallback) actionCB;

@end


#endif
