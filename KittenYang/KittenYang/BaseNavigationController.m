//
//  BaseNavigationController.m
//  KittenYang
//
//  Created by Kitten Yang on 14-5-23.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "BaseNavigationController.h"
#import "ThemeManager.h"


@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        self.navigationBar.barTintColor = [UIColor blackColor];
        self.navigationBar.barStyle = UIBarStyleBlack;
        self.navigationBar.translucent = YES; // 导航栏透明
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NavBarnotification) name:kThemeDidChangeNotification object:nil];
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;


    //设置navigationbar的barItem的颜色
    self.navigationBar.tintColor = [UIColor whiteColor];

    //设置navigation中间大字颜色
    UIColor * cc = [UIColor whiteColor];
    
    //设置navigation中间大字阴影
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(1, 1);
    
    //最后把属性都添加上去
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,
        [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, cc,NSForegroundColorAttributeName,nil]];

    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark  -  Notification

-(void)NavBarnotification{
    ThemeManager *themeManger = [ThemeManager shareInstance];
    if ([themeManger.themeName isEqualToString:@"默认"]) {
        self.navigationBar.barTintColor = [UIColor blackColor];
        self.tabBarController.tabBar.tintColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0f];
        self.navigationBar.translucent = YES;
    }
    if ([themeManger.themeName isEqualToString:@"blue"]) {
        self.navigationBar.barTintColor = [UIColor colorWithRed:66.0/255.0 green:96.0/255.0 blue:153/255.0 alpha:1.0f];
        self.navigationBar.translucent = YES;

    }else if([themeManger.themeName isEqualToString:@"pink"]){
        self.navigationBar.barTintColor = [UIColor colorWithRed:198.0/255.0 green:50.0/255.0 blue:53.0/255.0 alpha:1.0f];
        self.navigationBar.translucent = YES;
    }
    
}




@end
