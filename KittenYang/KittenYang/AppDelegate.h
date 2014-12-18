//
//  AppDelegate.h
//  KittenYang
//
//  Created by Kitten Yang on 14-5-5.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "DDMenuController.h"

@class MainViewController;
@class DDMenuController;
@interface AppDelegate : UIResponder <UIApplicationDelegate,WeiboSDKDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) MainViewController * mainCtrl;
@property (strong,nonatomic) DDMenuController * menu;
@property (strong, nonatomic) NSString *wbtoken;
@property (strong,nonatomic) NSDate  *wbexpirationDate;
@property (strong,nonatomic) NSString  *HostUserID;


@end
