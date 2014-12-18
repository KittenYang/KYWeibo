//
//  MoreViewController.m
//  KittenYang
//
//  Created by Kitten Yang on 14-5-23.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "MoreViewController.h"
#import "ThemeViewController.h"
#import "BrowseModeController.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"更多";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"主题";
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"浏览模式";
    }
    return cell;
}

//push过去
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        ThemeViewController *view = [[ThemeViewController alloc]init];
        [self.navigationController pushViewController:view animated:YES];
    }else if (indexPath.row == 1){
        BrowseModeController *view = [[BrowseModeController alloc]init];
        [self.navigationController pushViewController:view animated:YES];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    UIButton *bt = [self.tabBarController.tabBar.subviews objectAtIndex:10];
    bt.selected = NO;
}

@end
