//
//  BaseViewController.h
//  KittenYang
//
//  Created by Kitten Yang on 14-5-23.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "AppDelegate.h"
@class  AppDelegate;
@class  MBProgressHUD;
@interface BaseViewController : UIViewController<MBProgressHUDDelegate>{
    UIWindow *tipWindow;
}

@property (nonatomic,retain)MBProgressHUD *hud;


-(AppDelegate *)appDelegate;
-(void)showHUD:(NSString *)title isDim:(BOOL)isDim;
-(void)showCompleteHUD:(NSString *)title;

//状态栏上的提示
-(void)showStatusTip:(BOOL)show title:(NSString *)title;
-(void)multipleValue:(NSArray *)array;

@end
