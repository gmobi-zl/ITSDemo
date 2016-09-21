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
#import "Firebase.h"

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
    
    [FIRApp configure];

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

@end
