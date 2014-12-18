//
//  BaseViewController.m
//  KittenYang
//
//  Created by Kitten Yang on 14-5-23.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "BaseViewController.h"
#import "ThemeManager.h"
#import "MBProgressHUD.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

-(AppDelegate *)appDelegate{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return appDelegate;
}

-(void)showHUD:(NSString*)title isDim:(BOOL)isDim{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.dimBackground = isDim;
    self.hud.animationType = MBProgressHUDAnimationZoom;

    self.hud.labelText = title;
    self.hud.labelColor = [UIColor grayColor];
}

-(void)showCompleteHUD:(NSString *)title{
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    
    self.hud.mode = MBProgressHUDModeCustomView;
    if (title.length > 0) {
        self.hud.labelText = title;
    }
    [self.hud show:YES];
    [self.hud hide:YES afterDelay:2.0];
}

-(void)showStatusTip:(BOOL)show title:(NSString *)title{
    if (tipWindow == nil) {
        tipWindow = [[UIWindow alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        tipWindow.windowLevel = UIWindowLevelStatusBar;
        tipWindow.backgroundColor = [UIColor blackColor];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.tag = 2014;
        [tipWindow addSubview:label];
        
        UIImageView *progress = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"queue_statusbar_progress.png"]];
        progress.frame = CGRectMake(0, 20-6, 100, 6);
        progress.tag = 2013;
        [tipWindow addSubview:progress];
        
    }
    
    UILabel *label = (UILabel *)[tipWindow viewWithTag:2014];
    UIImageView *progress = (UIImageView *)[tipWindow viewWithTag:2013];
    
    if (show) {
        label.text = title;
        tipWindow.hidden = NO;

        //发送进度的动画
        progress.left = 0;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:2];
        [UIView setAnimationRepeatCount:1000];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];//匀速移动
        progress.left = ScreenWidth;
        [UIView commitAnimations];
    }else{
        progress.hidden = YES;
        label.text = title;
        [self performSelector:@selector(removeTipWindow) withObject:nil  afterDelay:1.5];
    }
}

-(void)multipleValue:(NSArray *)array{
    [self showStatusTip:[array firstObject] title:[array lastObject]];
}

-(void) removeTipWindow{
    tipWindow.hidden = YES;
    tipWindow = nil;
}


#pragma mark-
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
