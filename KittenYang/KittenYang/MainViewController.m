//
//  MainViewController.m
//  KittenYang
//
//  Created by Kitten Yang on 14-5-23.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "MainViewController.h"
#import "HomeViewController.h"
#import "MessageViewController.h"
#import "ProfileModalViewController.h"
#import "DiscoverViewController.h"
#import "MoreViewController.h"
#import "BaseNavigationController.h"
#import "UIFactory.h"
#import "ThemeButton.h"
#import "ThemeManager.h"
#import "WeiboSDK.h"
@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        //tabItem选中的颜色

        self.tabBar.tintColor = [UIColor whiteColor];
        self.tabBar.translucent = YES;
        self.tabBar.barStyle = UIBarStyleBlack;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:kThemeDidChangeNotification object:nil];
        
    }
    return self;
}


- (void)viewDidLoad
{

    [self _initViewController];
    [self _initTabbarView];
    
    [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showBadge:(BOOL)show{
    _badgeView.hidden = !show;
}


#pragma mark - UI
//初始化子控制器，因为是类里面自己调用，所以是私有的，最好加个‘_’来区分
- (void)_initViewController{
    HomeViewController *home = [[HomeViewController alloc]init];
    MessageViewController *message = [[MessageViewController alloc]init];
    ProfileModalViewController *profile = [[ProfileModalViewController alloc]init];
    DiscoverViewController *discover = [[DiscoverViewController alloc]init];
    MoreViewController *more = [[MoreViewController alloc]init];
    
    profile.hidesBottomBarWhenPushed = NO;
    profile.showLoginUser = YES;
//        profile.userName = @"_AppleGeeker";
    
    //用循环将5个视图控制器分别装在5个导航控制器上
    NSArray *viewCtrArray = @[home,message,profile,discover,more];
    NSMutableArray * navArray = [NSMutableArray arrayWithCapacity:5];
    
    for (UIViewController *viewController in viewCtrArray) {
        BaseNavigationController * nav = [[BaseNavigationController alloc]initWithRootViewController:viewController];
        
        [navArray addObject:nav];
    }
    
    
    //全局统领 ———— 5个导航控制器再装在一个tabBar控制器上
    [self setViewControllers:navArray animated:YES];
    
}


- (void)_initTabbarView {
    
    //自己创建一个UIView代替原来的tabBar
//    _tabBarView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 49, 320, 49)];
    
//    _tabBarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_background.png"]];
//    [self.view addSubview:_tabBarView];
    

    NSArray *tabBarItem = @[@"tabbar_home.png",@"tabbar_message_center.png",@"tabbar_profile.png",@"tabbar_discover.png",@"tabbar_more.png"];
    
    NSArray *highLightTabbarItem =  @[@"tabbar_home_highlighted.png",@"tabbar_message_center_highlighted.png",@"tabbar_profile_highlighted.png",@"tabbar_discover_highlighted.png",@"tabbar_more_highlighted.png"];
    
    NSArray *selectedTabbarItem = @[@"tabbar_home_selected.png",@"tabbar_message_center_selected.png",@"tabbar_profile_selected.png",@"tabbar_discover_selected.png",@"tabbar_more_selected.png"];
    
    //用循环设置5个button
    for (int i = 0; i < tabBarItem.count; i++) {
        NSString * backImage = tabBarItem[i];
    
        NSString * highlightedBackImage = highLightTabbarItem[i];
        NSString * selectedBackImage    = selectedTabbarItem[i];
        
        UIButton *button = [UIFactory createButton:backImage highlighted:highlightedBackImage selected:selectedBackImage];

        //要看一倍大小的图片的尺寸(30*30),因为一倍大小和物理大小一样
        //这里的y为什么是(49 - 30)/2 ?因为以加到哪个view上为基准，这些button是加到_tabBarView上，所以是以tabBarView为基准。
        button.frame = CGRectMake((64 - 30)/2 + (i*64), (49 - 30)/2, 30, 30);
        button.tag = i;
//        [button setImage:[UIImage imageNamed:backImage] forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:highlightedBackImage] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBar addSubview:button];
    }
    
    
    _sliderView = [UIFactory createImageView:@"tabbar_slider.png"];
    _sliderView.frame = CGRectMake((64-15)/2, 5, 15, 44);
    _sliderView.backgroundColor = [UIColor clearColor];

    [self.tabBar addSubview:_sliderView];
    
    
}



#pragma mark  - Actions

- (void) selectedTab:(UIButton *)button {
    
    [UIView animateWithDuration:0.2 animations:^{   
        _sliderView.frame = CGRectMake((64-15)/2 + 64*button.tag, 5, 15, 44) ;
    }];
    
    if (button.tag == self.selectedIndex && button.tag == 0) {
        UINavigationController *homeNav = [self.viewControllers objectAtIndex:0];
        HomeViewController *homeCtrl = [homeNav.viewControllers objectAtIndex:0];
        [homeCtrl.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [homeCtrl refreshWeibo];
    }
    self.selectedIndex = button.tag;
    button.selected = YES;
    

//    NSLog(@"%ld",self.selectedIndex);

    
}

- (void)timerAction:(NSTimer *)timer{
    

    [WBHttpRequest requestWithAccessToken:[self getToken] url:WB_unRead httpMethod:@"GET" params:nil delegate:self withTag:@"unRead"];
}

- (NSString *)getToken
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"WeiboAuthData"] objectForKey:@"accessToken"];
}

- (void)notification:(NSNotification *)notification{

    if ( [notification.object isEqual: @"blue"]) {
        self.tabBar.tintColor = [UIColor colorWithRed:66.0/255.0 green:96.0/255.0 blue:153/255.0 alpha:1.0f];
        self.tabBar.translucent = YES;
    }else if ([notification.object isEqual: @"pink"]) {
        self.tabBar.tintColor = [UIColor clearColor];
        self.tabBar.translucent = YES;
    }else if ([notification.object isEqual:@"默认"]){
        self.tabBar.tintColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0f];

        self.tabBar.translucent = YES;
    }
}


#pragma mark - WBHttpRequest degelate
- (void)request:(WBHttpRequest *)request didFinishLoadingWithDataResult:(NSData *)data{
    if ([request.tag isEqual:@"unRead"]) {
        
        NSError *error;
        NSDictionary *weiboDIC = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"%@",weiboDIC);
        NSNumber *status = [weiboDIC objectForKey:@"status"];  //未读微博
        
        
        if (_badgeView == nil) {
            _badgeView = [UIFactory createImageView:@"main_badge.png"];
            _badgeView.frame = CGRectMake(64 - 25, 5, 20, 20);
            [self.tabBar addSubview:_badgeView];
            
            UILabel *badgeLabel = [[UILabel alloc]initWithFrame:_badgeView.bounds];
            badgeLabel.textAlignment = NSTextAlignmentCenter;
            badgeLabel.backgroundColor = [UIColor clearColor];
            badgeLabel.font = [UIFont boldSystemFontOfSize:13.0f];
            badgeLabel.textColor = [UIColor purpleColor];
            badgeLabel.tag = 100;
            [_badgeView addSubview:badgeLabel];
        }
        int n = [status intValue];
        if (n > 0) {
            UILabel *badgeLabel = (UILabel *)[_badgeView viewWithTag:100];
            if (n > 99) {
                n = 99;
            }
            badgeLabel.text = [NSString stringWithFormat:@"%d",n];
            _badgeView.hidden = NO;
        }else{
            _badgeView.hidden = YES;
        }
        
    }
}




@end
