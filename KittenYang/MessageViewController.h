//
//  MessageViewController.h
//  KittenYang
//
//  Created by Kitten Yang on 14-5-23.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "BaseViewController.h"
#import "WeiboTableView.h"

@interface MessageViewController : BaseViewController<UITableViewEventDelegate,WBHttpRequestDelegate>{
    WeiboTableView *tableView;
}


@end
