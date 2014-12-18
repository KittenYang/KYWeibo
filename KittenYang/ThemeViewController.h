//
//  ThemeViewController.h
//  KittenYang
//
//  Created by Kitten Yang on 14-5-23.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "BaseViewController.h"

@interface ThemeViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>{
    NSArray *themes;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end
