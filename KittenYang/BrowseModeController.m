//
//  BrowseModeController.m
//  KittenYang
//
//  Created by Kitten Yang on 14-8-14.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "BrowseModeController.h"
#import "CONSTS.h"

@interface BrowseModeController ()

@end

@implementation BrowseModeController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"图片浏览模式";
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


#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify = @"themeCell";
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"大图";
        cell.detailTextLabel.text = @"所有网络加载大图";
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"小图";
        cell.detailTextLabel.text = @"所有网络加载小图";
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int mode = -1;
    if (indexPath.row == 0) {
        mode = LargeBrowseMode;
    }else if(indexPath.row == 1){
        mode = SmallBrowseMode;
    }
    
    //将浏览模式存储到本地
    [[NSUserDefaults standardUserDefaults]setInteger:mode forKey:kBrowseMode];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    //发送刷新微博的通知
    [[NSNotificationCenter defaultCenter]postNotificationName:kReloadWeiboNotification object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



@end
