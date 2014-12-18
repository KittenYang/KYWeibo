//
//  ThemeViewController.m
//  KittenYang
//
//  Created by Kitten Yang on 14-5-23.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "ThemeViewController.h"
#import "ThemeManager.h"

@interface ThemeViewController ()

@end

@implementation ThemeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        themes = [[ThemeManager shareInstance].themesPlist allKeys];
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



#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return themes.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify = @"themeCell";
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    cell.textLabel.text = themes[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *themeName = themes[indexPath.row];
//    if ([themeName isEqualToString:@"默认"]){
//        themeName = nil;
//    }
    
    //就差了这一句。
    [ThemeManager shareInstance].themeName = themeName;
    [[NSNotificationCenter defaultCenter]postNotificationName:kThemeDidChangeNotification object:themeName];
    
}



@end
