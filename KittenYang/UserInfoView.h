//
//  UserInfoView.h
//  KittenYang
//
//  Created by Kitten Yang on 14-8-29.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
#import "RectButton.h"
#import "WeiboModel.h"
@interface UserInfoView : UIView

@property (nonatomic,retain)UserModel *user;


@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet RectButton *addButton;
@property (strong, nonatomic) IBOutlet RectButton *fansButton;


- (IBAction)followAction:(id)sender;
- (IBAction)fansAction:(id)sender;

@end
