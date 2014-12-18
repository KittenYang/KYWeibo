//
//  ProfileModalViewController.m
//  KittenYang
//
//  Created by Kitten Yang on 14-8-26.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "ProfileModalViewController.h"
#import "UserInfoView.h"
#import "ModalViewController.h"


@interface ProfileModalViewController ()

@end

@implementation ProfileModalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"个人";
        [self setHidesBottomBarWhenPushed:YES];
        
    }
    return self;
}

- (void)viewDidLoad
{
    if(self.showLoginUser){
         self.userid = [[[NSUserDefaults standardUserDefaults]objectForKey:@"WeiboAuthData"] objectForKey:@"HostUserID"];
    }
        
    [super viewDidLoad];
    _userInfoView = [[UserInfoView alloc]initWithFrame:CGRectMake(0, 0, 320, 200)];
    self.tableView.eventDelegate = self;
    [self loadUserData];
    [self loadUserWeibo];
    
}


#pragma mark -- 加载用户信息
//获取当前用户的信息
- (void)loadUserData{

    if (self.userName.length == 0 && self.userid.length == 0 ) {
        NSLog(@"error:用户昵称为空");
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.userid.length != 0) {
        [params setObject:self.userid forKey:@"uid"];
    }else {
        [params setObject:self.userName forKey:@"screen_name"];
    }
    
    [WBHttpRequest requestWithAccessToken:[self getToken] url:WB_loadUserData  httpMethod:@"GET" params:params delegate:self withTag:@"loadUserData"];
    
}

- (NSString *)getToken
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"WeiboAuthData"] objectForKey:@"accessToken"];
}


//获取当前用户的所有微博
- (void)loadUserWeibo{
    if (self.userName.length == 0 && self.userid.length == 0) {
        NSLog(@"error:用户名称为空");
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.userid.length != 0) {
        [params setObject:self.userid forKey:@"uid"];
    }else{
        [params setObject:self.userName forKey:@"screen_name"];
    }
    
    [WBHttpRequest requestWithAccessToken:[self getToken] url:WB_loadUserWeibo httpMethod:@"GET" params:params delegate:self withTag:@"loadUserWeibo"];
    
}



#pragma mark - 这里是system method

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - WBHttpRequest
//网络加载完成
- (void)request:(WBHttpRequest *)request didFinishLoadingWithDataResult:(NSData *)data{
    
    //-------------------loadUserData----------------------------
    if ([request.tag isEqual:@"loadUserData"]) {
        NSError *error;
        NSDictionary *userDIC = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        
        UserModel *userModel = [[UserModel alloc]initWithDataDic:userDIC];
        self.userInfoView.user = userModel;
    
        
        self.tableView.tableHeaderView = _userInfoView;
        
    }else if([request.tag isEqual:@"loadUserWeibo"]){
        NSError *error;
        NSDictionary *userWeiboDIC = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        NSDictionary *userWeiboInfo = [userWeiboDIC objectForKey:@"statuses"];
        
        NSMutableArray *weibos = [NSMutableArray arrayWithCapacity:userWeiboInfo.count];
        
        for (NSDictionary *statuesDic in userWeiboInfo) {
            WeiboModel *weibo = [[WeiboModel alloc]initWithDataDic:statuesDic];
            [weibos addObject:weibo];

        }
        
        if (weibos.count > 0) {
            WeiboModel *topWeibo= [weibos objectAtIndex:0];     //取出最新的一条微博
            self.topWeiboId = [topWeibo.weiboId stringValue];   //把最新的微博ID赋值给我们定义的这个topWeiboId变量
            //同理，记下最久的微博ID
            WeiboModel *lastWeibo = [weibos lastObject];  //取出最久的一条微博
            self.lastWeiboId = [lastWeibo.weiboId stringValue];//把最久的微博ID复制给我们定义的这个lastWeiboId变量
        }
        
        self.tableView.data = weibos;
        self.weibos = weibos;
        [self.tableView reloadData];
    }
    
    
    //-------------------pullDown----------------------------
    if ([request.tag isEqual:@"pullDown"]) {
        NSError *error;
        NSDictionary *WeiboDIC  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        NSDictionary *WeiboInfo = [WeiboDIC objectForKey:@"statuses"];
        
        NSMutableArray *weibos = [NSMutableArray arrayWithCapacity:WeiboInfo.count];
    
        for (NSDictionary *dic in WeiboInfo) {
            WeiboModel *weiboModel = [[WeiboModel alloc]initWithDataDic:dic];
            [weibos addObject:weiboModel];
        }
        if (weibos.count > 0 ) {
            WeiboModel *weiboModel = [weibos firstObject];
            self.topWeiboId = [weiboModel.weiboId stringValue];
        }
        
        [weibos addObjectsFromArray:self.weibos];
        self.weibos = weibos;
        
        self.tableView.data = self.weibos;
        [self.tableView reloadData];
        [self.tableView doneLoadingTableViewData];
    }
    
    
    //----------------------pullUp-----------------------------
    if ([request.tag isEqual:@"pullUp"]) {
        NSError *error;
        //首先我需要解析这100个json，并保存为字典
        NSDictionary *JSONDIC = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        
        NSDictionary *statuses = [JSONDIC objectForKey:@"statuses"];
        NSLog(@"%@",statuses);
        
        NSMutableArray *weibos = [NSMutableArray arrayWithCapacity:statuses.count];
        for (NSDictionary *dic in statuses) {
            WeiboModel *weibo = [[WeiboModel alloc]initWithDataDic:dic];
            [weibos addObject:weibo];
        }
        //移除重复的那一条微博
        [weibos removeObject:[weibos firstObject]];
        
        if (weibos.count > 0) {
            WeiboModel *lastWeibo = [weibos lastObject];
            self.lastWeiboId = [lastWeibo.weiboId stringValue];
        }
        
        [self.weibos addObjectsFromArray:weibos];
        self.tableView.data = self.weibos;
        
        
        //判断剩余是否大于一页
        if (statuses.count >= 25) {
            self.tableView.isMore = YES;
        }else {
            self.tableView.isMore = NO;
        }
        
        
        [self.tableView reloadData];
    }

    
}


#pragma mark -  UITableViewEventDelegate
//下拉
- (void)pullDown:(BaseTableView *)tableView{
   
    if(self.topWeiboId.length == 0){
        NSLog(@"微博ID为空");
        return;
    }
     NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"25",@"count",self.topWeiboId,@"since_id",nil];
    [WBHttpRequest requestWithAccessToken:[self getToken] url:WB_loadUserWeibo httpMethod:@"GET" params:params delegate:self withTag:@"pullDown"];
    
}

//上拉
- (void)pullUp:(BaseTableView *)tableView{
    if (self.lastWeiboId.length == 0) {
        NSLog(@"微博id为空");
        return;
    }
        
    NSMutableDictionary  *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"25",@"count",self.lastWeiboId,@"max_id",self.userName,@"screen_name", nil];
    [WBHttpRequest requestWithAccessToken:[self getToken] url:WB_loadUserWeibo httpMethod:@"GET" params:params delegate:self withTag:@"pullUp"];
}

//选中cell
- (void)tableView:(BaseTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ModalViewController *modalView = [[ModalViewController alloc]init];
}


- (void)viewDidDisappear:(BOOL)animated{
    UIButton *bt = [self.tabBarController.tabBar.subviews objectAtIndex:8];
    bt.selected = NO;
}


@end