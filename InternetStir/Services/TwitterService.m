//
//  TwitterService.m
//  InternetStir
//
//  Created by Apple on 16/8/23.
//  Copyright © 2016年 Gmobi. All rights reserved.
//

#import "TwitterService.h"

@implementation TwitterService

-(void) getUserInfo{
    NSError *clientError;
    NSDictionary *params = @{@"screen_name" : self.name};
//    self.APIClient = [TWTRAPIClient clientWithCurrentUser];
    self.APIClient = [[TWTRAPIClient alloc]init];
    NSURLRequest *request1 = [self.APIClient  URLRequestWithMethod:@"GET" URL:@"https://api.twitter.com/1.1/users/show.json?" parameters:params error:&clientError];
    if (request1) {
        [self.APIClient sendTwitterRequest:request1 completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (data) {
                NSError *jsonError;//profile_image_url
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                self.icon = [dic objectForKey:@"profile_image_url"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"getTwitterUserInfo" object:self];
//                NSLog(@"%@ --------image:%@",dic,self.icon);
            }
        }];
    }
}
-(void) loginOut{
    
    TWTRSessionStore *store = [[Twitter sharedInstance] sessionStore];
    NSString *userID = store.session.userID;
    
    [store logOutUserID:userID];
}
-(void) twitterLogin:(PoPoTWLoginCallback) cb{
    
    if ([TWTRAPIClient clientWithCurrentUser]) {
        NSLog(@"%@",[TWTRAPIClient clientWithCurrentUser]);
    }
    if (self.name.length > 0) {
        cb(ITS_TW_LOGIN_SUCCESS);
        return;
    }
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (session.userName == nil){
            // process error
            cb(ITS_TW_LOGIN_ERROR);
        } else if(session.userName) {
            // login success
            NSLog(@"signed in as %@", [session userName]);
            self.name = session.userName;
            self.uId = session.userID;
            cb(ITS_TW_LOGIN_SUCCESS);
        }
    }];
}
- (void)systemAccountTypeIdentifier {
    
//    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
//    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
//    
//    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (error) {
//                NSLog(@"System account access request denied: %@", error.localizedDescription);
//            }
//        });
//    }];
}

@end
