//
//  BrowseModeController.h
//  KittenYang
//
//  Created by Kitten Yang on 14-8-14.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "BaseViewController.h"

@interface BrowseModeController :BaseViewController<UITableViewDataSource,UITableViewDelegate>;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
