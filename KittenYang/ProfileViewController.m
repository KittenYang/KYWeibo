//
//  ProfileViewController.m
//  KittenYang
//
//  Created by Kitten Yang on 14-5-23.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileModalViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"个人";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    ProfileModalViewController *profileModalView = [[ProfileModalViewController alloc]init];
//    [self.view addSubview:profileModalView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated{
    UIButton *bt = [self.tabBarController.tabBar.subviews objectAtIndex:8];
    bt.selected = NO;
}
@end
