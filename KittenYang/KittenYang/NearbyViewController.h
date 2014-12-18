//
//  NearbyViewController.h
//  KittenYang
//
//  Created by Kitten Yang on 14/10/6.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "BaseTableView.h"


typedef void(^SelectDoneBlock)(NSDictionary *);

@interface NearbyViewController : BaseViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,WBHttpRequestDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic,copy)SelectDoneBlock selectBlock;
@property (nonatomic,retain)NSArray *data;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end