//
//  UserInfoView.m
//  KittenYang
//
//  Created by Kitten Yang on 14-8-29.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "UserInfoView.h"
#import "UIImageView+WebCache.h"
#import "FriendsViewController.h"


@implementation UserInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        UIView *view = [[[NSBundle mainBundle]loadNibNamed:@"UserInfoView" owner:self options:nil]lastObject];
        
        [self addSubview:view];
        self.size = view.size;
        
    }
    return self;
}

//经验：layoutSubViews是用来布局和填充子视图数据，布局我们已经在xib里面完成了，所以这里只需要填充数据即可
- (void)layoutSubviews{
    [super layoutSubviews];

    //头像
    NSString *urlString = self.user.avatar_large;
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:urlString]];
    
    //昵称
    self.nameLabel.text = self.user.screen_name;
    
    //信息
    //---------性别
    NSString *sexName = @"未知";
    NSString *gender = self.user.gender;
    if ([gender isEqualToString:@"m"]) {
        sexName = @"男";
    }else if([gender isEqualToString:@"f"]){
        sexName = @"女";
    }
    
    //---------地理
    NSString *location = self.user.location;
    if (location == nil) {
        location = @"";
    }
    self.addressLabel.text = [NSString stringWithFormat:@"%@  %@",sexName,location];
    
    
    //简介（三目运算符）
    self.infoLabel.text = (self.user.user_description==nil)?@"":self.user.user_description;
    
    
    //微博数
    NSString *WeiboCount = [self.user.statuses_count stringValue];
    self.countLabel.text = [NSString stringWithFormat:@"共%@条微博",WeiboCount];
    NSLog(@"这里是微博数:%@",self.user.statuses_count);
    
    
    //关注数
    self.addButton.title =@"关注";
    self.addButton.subtitle=[self.user.friends_count stringValue];

    //粉丝数
    long follower = [self.user.followers_count longValue];
    NSString *followerString = [NSString stringWithFormat:@"%ld",follower];
    if (follower > 10000) { 
        followerString = [NSString stringWithFormat:@"%ld万",follower/10000];
    }
    self.fansButton.title = @"粉丝";
    self.fansButton.subtitle = followerString;

    

}


- (IBAction)followAction:(id)sender {
    FriendsViewController *friendViewCtrl = [[FriendsViewController alloc]init];
    friendViewCtrl.userName = self.user.screen_name;
    friendViewCtrl.friendType = Follows;
    [self.viewController.navigationController pushViewController:friendViewCtrl animated:YES];
}

- (IBAction)fansAction:(id)sender {
    FriendsViewController *friendViewCtrl = [[FriendsViewController alloc]init];
    friendViewCtrl.userName = self.user.screen_name;
    friendViewCtrl.friendType = Fans;
    [self.viewController.navigationController pushViewController:friendViewCtrl animated:YES];
}

@end




