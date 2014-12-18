//
//  UserGridView.m
//  KittenYang
//
//  Created by Kitten Yang on 14/11/1.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "UserGridView.h"
#import "UIButton+WebCache.h"
#import "ProfileModalViewController.h"

@implementation UserGridView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * gridView = [[[NSBundle mainBundle]loadNibNamed:@"UserGridView" owner:self options:nil]lastObject];
        gridView.backgroundColor = [UIColor clearColor];
        self.size = gridView.size;
        [self addSubview:gridView];
        
        UIImage *image = [UIImage imageNamed:@"profile_button3_1.png"];
        UIImageView *backgroundView = [[UIImageView alloc]initWithImage:image];
        backgroundView.frame = self.bounds;
        [self insertSubview:backgroundView atIndex:0];//0是底部
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    //昵称
    self.nickLabel.text = self.userModel.screen_name;
    
    //粉丝
    long follower = [self.userModel.followers_count longValue];
    NSString *followerString = [NSString stringWithFormat:@"%ld",follower];
    if (follower > 10000) {
        followerString = [NSString stringWithFormat:@"%ld万",follower/10000];
    }
    self.fansLabel.text = followerString;
    
    
    NSString *url = self.userModel.profile_image_url;
    NSURL *stringUrl = [NSURL URLWithString:url];
    [self.imageButton sd_setImageWithURL:stringUrl forState:UIControlStateNormal];
    
}




- (IBAction)userImageAction:(id)sender {
    
    ProfileModalViewController *profileViewCtrl = [[ProfileModalViewController alloc]init];
    profileViewCtrl.userName = self.userModel.screen_name;
    
    [self.viewController.navigationController pushViewController:profileViewCtrl animated:YES];
     
    
}
@end
