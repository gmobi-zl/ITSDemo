//
//  AppDelegate.m
//  InternetStir
//
//  Created by apple on 16/8/9.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import "AppDelegate.h"
#import "ITSApplication.h"
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>

#import "UIKit/UIKit.h"
//#import "Firebase.h"
#import <Google/Analytics.h>
#import "SettingService.h"

@import FirebaseAnalytics;

@interface AppDelegate ()

@end

@implementation AppDelegate

static NSString * const kClientID =
@"1052945573217-6mlkd00jdq31bq4u28dijtp72hokgvmq.apps.googleusercontent.com";
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Override point for customization after application launch.
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    [ITSApplication start];
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    [Fabric with:@[[Twitter class]]];
    [[Twitter sharedInstance] startWithConsumerKey:@"lbF0Iu1RuUHbLxft64xbFeuFW" consumerSecret:@"DHzSxiPD5C0TvLvJkivgj3VsJyPBdbuzT7ZktaNSNEQljKuzpJ"];

    [Fabric with:@[[Twitter sharedInstance]]];
    
    //[FIRApp configure];
    
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configuring Google services : %@", configureError);

    GAI *gai = [GAI sharedInstance];
    gai.trackUncaughtExceptions = YES;
    gai.logger.logLevel = kGAILogLevelVerbose;
    
    
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//    
//    // ios push
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
//        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
//        
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//    } else {
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)];
//    }
//    
//    NSLog(@"launchOption==%@",[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]);
//    if ([launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey] != nil) {
//        
//        NSMutableDictionary* notifiDic = [NSMutableDictionary dictionaryWithCapacity:1];
//        if (notifiDic.count != 0) {
//            [notifiDic removeAllObjects];
//        }
//        [notifiDic setDictionary:(NSDictionary *)[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]];
//        
//        if (notifiDic != nil){
//            NSLog(@"poponews off click push message  : %@", notifiDic);
//            NSString* msg = [[notifiDic objectForKey:@"aps"] objectForKey:@"alert"];
//            NSLog(@"poponews off push message : %@", msg);
//            
//            if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive){
//                NSString* pushNewsItemId = [[notifiDic objectForKey:@"aps"] objectForKey:@"itemId"];
//                
//                if (pushNewsItemId != nil){
//                    ITSApplication* poApp = [ITSApplication get];
//                    [poApp.dataSvr setOffPushNewsId:pushNewsItemId];
//                    //[poApp.dataSvr getPushNewsDetail:pushNewsItemId];
//                }
//            }
//        }
//    }
    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL success = NO;
//    if ([[GIDSignIn sharedInstance] handleURL:url
//                            sourceApplication:sourceApplication
//                                   annotation:annotation]){
//        success = YES;
//    }
//   else
    if ( [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation]){
        success = YES;
    }
    return success;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
/* ios push delegate */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString* token = [NSString stringWithFormat:@"%@", deviceToken];
    NSLog(@"push device token : %@", token);
    
    NSString* tmpTokenStr1 = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    NSString* tmpTokenStr2 = [tmpTokenStr1 stringByReplacingOccurrencesOfString:@">" withString:@""];
    NSString* tmpTokenStr = [tmpTokenStr2 stringByReplacingOccurrencesOfString:@" " withString:@""];
    MMLogDebug(@"push device token : %@", tmpTokenStr);
    SettingService* ss = [SettingService get];
    if (ss != nil){
        [ss setStringValue:POPO_IOS_PUSH_DEVICE_TOKEN data:tmpTokenStr];
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"push register failed : %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"userinfo : %@", userInfo);
    NSString* msg = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    NSLog(@"push message : %@", msg);
    
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive){
        NSString* pushNewsItemId = [[userInfo objectForKey:@"aps"] objectForKey:@"itemId"];
        NSLog(@"click push message id : %@", pushNewsItemId);
        if (pushNewsItemId != nil){
            ITSApplication* poApp = [ITSApplication get];
            //[poApp.dataSvr getPushNewsDetail:pushNewsItemId isShowDetailPage:YES];
            
            [poApp.reportSvr recordPushMsgReceived:pushNewsItemId];
            [poApp.reportSvr recordPushMsgClicked:pushNewsItemId];
        }
    } else {
        NSString* pushNewsItemId = [[userInfo objectForKey:@"aps"] objectForKey:@"itemId"];
        NSLog(@"click push message id : %@", pushNewsItemId);
        if (pushNewsItemId != nil){
            ITSApplication* poApp = [ITSApplication get];
            
            //            BOOL isReceived = [poApp.dataSvr checkPushNewsId:pushNewsItemId];
            //            if (isReceived == YES){
            //                [poApp.reportSvr recordPushMsgClicked:pushNewsItemId];
            //            } else {
            [poApp.reportSvr recordPushMsgReceived:pushNewsItemId];
            //}
            
            //[poApp.dataSvr getPushNewsDetail:pushNewsItemId isShowDetailPage:NO];
        }
    }
    
    //[[[UIAlertView alloc] initWithTitle:@"push" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

@end
