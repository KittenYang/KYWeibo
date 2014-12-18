//
//  ProfileModalViewController.h
//  KittenYang
//
//  Created by Kitten Yang on 14-8-26.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoView.h"
#import "WeiboTableView.h"

@interface ProfileModalViewController : UIViewController<WBHttpRequestDelegate,UITableViewEventDelegate>

@property (strong, nonatomic) IBOutlet WeiboTableView *tableView;

@property (nonatomic,copy)NSString *topWeiboId;
@property (nonatomic,copy)NSString *lastWeiboId;
@property (nonatomic,copy)NSString *userName;
@property (nonatomic,copy)NSString *userid;

@property (nonatomic,assign)BOOL showLoginUser;
@property (nonatomic,copy)UserInfoView *userInfoView;
@property (nonatomic,retain)NSMutableArray *weibos;




@end
