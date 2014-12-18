//
//  FriendsViewController.h
//  KittenYang
//
//  Created by Kitten Yang on 14/11/2.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "BaseViewController.h"
#import "FriendTableView.h"

//typedef enum {
//    Follows,  //关注列表
//    Fans,     //粉丝列表
//}FriendsType;

typedef NS_ENUM(NSInteger, FriendsType) {
    Follows = 100,
    Fans,
};

@interface FriendsViewController : BaseViewController<WBHttpRequestDelegate,UITableViewEventDelegate>

@property (nonatomic,copy)NSString *userName;
@property (nonatomic,retain)NSMutableArray *data;
@property (strong, nonatomic) IBOutlet FriendTableView *tableView;

@property (nonatomic,assign)FriendsType friendType;

@property (nonatomic,copy)NSString *cursor;// 下一页游标


@end
