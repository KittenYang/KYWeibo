//
//  WeiboTableView.m
//  KittenYang
//
//  Created by Kitten Yang on 14-8-4.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "WeiboTableView.h"
#import "WeiboCell.h"
#import "WeiboModel.h"
#import "WeiboView.h"
#import "ModalViewController.h"


@implementation WeiboTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style ];
    if (self != nil) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadData) name:kReloadWeiboNotification object:nil];
        
    }
    return self;
    
}


#pragma mark - UITableView degelate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"WeiboCell";
    WeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[WeiboCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //取出来的是WeiboModel *weibo
    WeiboModel *weibo = [self.data objectAtIndex:indexPath.row];
    cell.weiboModel = weibo;

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeiboModel *weibo = [self.data objectAtIndex:indexPath.row];
    float height = [WeiboView getWeiboViewHeight:weibo isDetail:NO isRepost:NO];
    height += 80;
    return height;
}









@end
