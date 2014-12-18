//
//  DiscoverViewController.m
//  KittenYang
//
//  Created by Kitten Yang on 14-5-23.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "DiscoverViewController.h"
#import "NearWeiboMapViewController.h"

@interface DiscoverViewController ()

@end

@implementation DiscoverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"广场";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    for(int i= 100;i<=101;i++){
        UIButton *button =  (UIButton *)[self.view viewWithTag:i];
        button.layer.shadowColor =  [UIColor blackColor].CGColor;
        button.layer.shadowOffset = CGSizeMake(2, 2); //阴影的大小
        button.layer.shadowOpacity =  1;  //不透明
        button.layer.shadowRadius =  3;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidDisappear:(BOOL)animated{
    UIButton *bt = [self.tabBarController.tabBar.subviews objectAtIndex:9];
    bt.selected = NO;
}

- (IBAction)nearUser:(id)sender {
   
}

- (IBAction)nearWeibo:(id)sender {
    NearWeiboMapViewController *nearWeibo = [[NearWeiboMapViewController alloc]init];
    [self.navigationController pushViewController:nearWeibo animated:YES];
}
@end
