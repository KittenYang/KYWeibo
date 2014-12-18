//
//  HomeViewController.h
//  KittenYang
//
//  Created by Kitten Yang on 14-5-23.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "BaseViewController.h"
#import "WeiboSDK.h"
#import "AppDelegate.h"
#import "WeiboTableView.h"

#define kPullDown @"kPullDown"

@class ThemeImageView;
//@class WeiboTableView;
@interface HomeViewController : BaseViewController<WBHttpRequestDelegate,UITableViewEventDelegate >{
    ThemeImageView *barView;
}

@property (retain,nonatomic)WeiboTableView *tableView;
@property (nonatomic ,strong)WBAuthorizeRequest *request;
@property (nonatomic,strong)    AppDelegate *myDelegate;

@property (nonatomic,copy)NSString *topWeiboId; 
@property (nonatomic,copy)NSString *lastWeiboId;
@property (nonatomic,retain)NSMutableArray *weibos;

- (void)refreshWeibo;
- (void)Get;
@end