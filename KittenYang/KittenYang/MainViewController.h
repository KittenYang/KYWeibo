//
//  MainViewController.h
//  KittenYang
//
//  Created by Kitten Yang on 14-5-23.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboSDK.h"
#import "UIFactory.h"

@interface MainViewController : UITabBarController<WBHttpRequestDelegate>{
    UIView * _tabBarView;
    ThemeImageView *_badgeView;
    ThemeImageView *_sliderView;
}

@property (strong, nonatomic) NSString *userid;

- (void)showBadge:(BOOL)show;

@end
