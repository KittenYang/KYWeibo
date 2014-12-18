//
//  RightViewController.m
//  KittenYang
//
//  Created by Kitten Yang on 14-5-23.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "RightViewController.h"

@interface RightViewController ()

@end

@implementation RightViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendAction:(UIButton *)sender {
    if (sender.tag == 100 ) {
        SendViewController *sendCtrl = [[SendViewController alloc]init];
        BaseNavigationController *sendNav = [[BaseNavigationController alloc]initWithRootViewController:sendCtrl];
//        [self presentViewController:sendNav animated:YES completion:NULL];
        [self.appDelegate.menu presentViewController:sendNav animated:YES completion:NULL];
    }
}

@end
