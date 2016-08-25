//
//  LoginViewController.h
//  InternetStir
//
//  Created by Apple on 16/8/17.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
@interface LoginViewController : UIViewController<UIGestureRecognizerDelegate,GIDSignInDelegate,GIDSignInUIDelegate>

@end
