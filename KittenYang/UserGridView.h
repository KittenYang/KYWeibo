//
//  UserGridView.h
//  KittenYang
//
//  Created by Kitten Yang on 14/11/1.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface UserGridView : UIView


@property (nonatomic,retain) UserModel *userModel;
@property (strong, nonatomic) IBOutlet UILabel *nickLabel;
@property (strong, nonatomic) IBOutlet UILabel *fansLabel;
@property (strong, nonatomic) IBOutlet UIButton *imageButton;

- (IBAction)userImageAction:(id)sender;
@end
