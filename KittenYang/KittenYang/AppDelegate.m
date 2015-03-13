//
//  AppDelegate.m
//  KittenYang
//
//  Created by Kitten Yang on 14-5-5.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "DDMenuController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "CONSTS.h"
#import "WeiboSDK.h"


#import "HomeViewController.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAppKey];
    
//    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.window.backgroundColor = [UIColor blackColor];
//    [self.window makeKeyAndVisible];
//    
//    
//    _mainCtrl = [[MainViewController alloc]init];
//    LeftViewController  * leftCtrl  = [[LeftViewController alloc]init];
//    RightViewController * rightCtrl = [[RightViewController alloc]init];
//    
//    _menu = [[DDMenuController alloc]initWithRootViewController:_mainCtrl];
//    _menu.leftViewController  = leftCtrl;
//    _menu.rightViewController = rightCtrl;
//    
//    self.window.rootViewController = _menu;
    
    

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - delegate
//- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
//    if ([request isKindOfClass:WBProvideMessageForWeiboRequest.class])
//    {
//        HomeViewController *home = [[HomeViewController alloc]init];
//        [self.menu presentModalViewController:home animated:YES];
//    }
//
//}



- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class]){
        NSString *title = @"发送结果";
        NSString *message = [NSString stringWithFormat:@"响应状态: %d\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode, response.userInfo, response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
        self.wbexpirationDate = [(WBAuthorizeResponse *)response expirationDate];
        [alert show];
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
//        NSString *title = @"认证结果";
//        NSString *message = [NSString stringWithFormat:@"响应状态: %d\nresponse.userId: %@\nresponse.accessToken: %@\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken], response.userInfo, response.requestUserInfo];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//      [alert show];
        self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
        self.wbexpirationDate = [(WBAuthorizeResponse *)response expirationDate];
         self.HostUserID =  [(WBAuthorizeResponse *)response userID];
        
        
        //保存认证的数据到本地
        NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                                  self.wbtoken, @"accessToken",
                                  self.wbexpirationDate, @"expirationDate",
                                  self.HostUserID,@"HostUserID",
                                  nil];
        [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"WeiboAuthData"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kReciveAuthorizeResponse object:nil];
//        NSDictionary *weiboInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"WeiboAuthData"];
//        NSString *accessToken= [weiboInfo objectForKey:@"accessToken"];
//        NSDate  *expirationDate = [weiboInfo objectForKey:@"expirationDate"];
//        NSLog(@"accessToken====%@,expirationDate====%@",accessToken,expirationDate);
        
    }
}



#pragma mark  -  openURL

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WeiboSDK handleOpenURL:url delegate:self];
}

//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
//    return [WeiboSDK handleOpenURL:url delegate:self];
//}


@end
