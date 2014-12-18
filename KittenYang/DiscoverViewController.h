//
//  DiscoverViewController.h
//  KittenYang
//
//  Created by Kitten Yang on 14-5-23.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "BaseViewController.h"

@interface DiscoverViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UIButton *nearUser;
@property (strong, nonatomic) IBOutlet UIButton *nearWeibo;


- (IBAction)nearUser:(id)sender;
- (IBAction)nearWeibo:(id)sender;
@end
