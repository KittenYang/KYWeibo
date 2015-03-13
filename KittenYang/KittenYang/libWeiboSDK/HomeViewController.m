//
//  HomeViewController.m
//  KittenYang
//
//  Created by Kitten Yang on 14-5-23.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "HomeViewController.h"
#import "CONSTS.h"
#import "WeiboSDK.h"
#import "WeiboModel.h"
#import "WeiboTableView.h"
#import "UIFactory.h"
#import <AudioToolbox/AudioToolbox.h>
#import "MainViewController.h"
#import "ZFModalTransitionAnimator.h"
#import "ModalViewController.h"


@interface HomeViewController ()
@property (nonatomic, strong) ZFModalTransitionAnimator *animator;

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"首页";

        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Get) name:kReciveAuthorizeResponse object:nil];
       
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    _myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    //绑定按钮
    UIBarButtonItem *bindItem = [[UIBarButtonItem alloc]initWithTitle:@"绑定账号" style:UIBarButtonItemStylePlain target:self action:@selector(bindAction:)];
    self.navigationItem.rightBarButtonItem = bindItem;

    
    //注销按钮
    UIBarButtonItem *logOutItem = [[UIBarButtonItem alloc]initWithTitle:@"注销账号" style:UIBarButtonItemStylePlain target:self action:@selector(logOutAction:)];
    self.navigationItem.leftBarButtonItem = logOutItem;
    
    _tableView = [[WeiboTableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    _tableView.eventDelegate = self;
    _tableView.hidden = YES;
    [self.view addSubview:_tableView];
    
    [self Get];
    
}

#pragma mark - UI
- (void)showNewWeiboCount:(int)count{
    if (barView == nil) {
        
        barView = [UIFactory createImageView:@"timeline_new_status_background.png"];
        UIImage *image = [barView.image stretchableImageWithLeftCapWidth:5 topCapHeight:5];
        barView.image = image;
        barView.leftCapWidth = 5;
        barView.topCapHeight = 5;
        barView.frame = CGRectMake(5, -120, ScreenWidth-10, 40);
        [self.view addSubview:barView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.tag = 2013;
        label.font = [UIFont systemFontOfSize:16.0f];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        [barView addSubview:label];
    }
    if (count > 0 ) {
        UILabel *label = (UILabel *)[barView viewWithTag:2013];
        label.text = [NSString stringWithFormat:@"%d条新微博",count];
        [label sizeToFit];
        CGRect frame = label.frame;
        frame.origin = CGPointMake((barView.frame.size.width - frame.size.width)/2, (barView.frame.size.height - frame.size.height)/2);
        label.frame = frame;
        [self performSelector:@selector(updateUI) withObject:nil afterDelay:0.0];
    }
}

- (void)updateUI {
    [UIView animateWithDuration:0.6 animations:^{
        CGRect frame = barView.frame;
        frame.origin.y = 5;
        barView.frame = frame;
    } completion:^(BOOL finished){
        if (finished) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:1.0];
            [UIView setAnimationDuration:0.6];
            CGRect frame = barView.frame;
            frame.origin.y = -120;
            barView.frame = frame;
            [UIView commitAnimations];
        }
    }];
  
    NSString *path = [[NSBundle mainBundle] pathForResource:@"msgcome" ofType:@"wav"];
    NSURL *url = [NSURL fileURLWithPath:path];
    SystemSoundID soundId;
    AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(url), &soundId);
    AudioServicesPlaySystemSound(soundId);
    
//    [_tableView reloadData];
    
    //隐藏未读微博的角标
    MainViewController *mainCtrl = (MainViewController *)self.tabBarController;
    [mainCtrl showBadge:NO];
}


#pragma mark - load Data

- (void) loadWeiboData {

    [super showHUD:@"卖力加载中..." isDim:NO];

    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:@"50" forKey:@"count"];
    
    [WBHttpRequest requestWithAccessToken:[self getToken] url:WB_home  httpMethod:@"GET" params:params delegate:self withTag:@"load"];
    
}

//下拉加载 /*最新微博*/
- (void)pullDownData{
    if (self.topWeiboId.length == 0) {
        NSLog(@"微博id为空");
        return;
    }
    /*
     * since_id :若指定此参数,则返回ID比since_id大的微博(即比since_id时间晚的微博),默认为0.
     * count:    单页返回的记录条数，最大不超过100, 默认为20;
     */
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"25",@"count",self.topWeiboId,@"since_id",nil];
    [WBHttpRequest requestWithAccessToken:[self getToken] url:WB_home  httpMethod:@"GET" params:params delegate:self withTag:@"pullDown"];
}

//上拉加载  /*最久微博*/
- (void)pullupData{
    if (self.lastWeiboId.length == 0) {
        NSLog(@"微博id为空");
        return;
    } 
    /*
     * max_id :若指定此参数,则返回ID小于等于max_id的微博,默认为0.
     * count:    单页返回的记录条数，最大不超过100, 默认为20;
     */
    NSLog(@"%@",self.lastWeiboId);
    NSMutableDictionary  *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"25",@"count",self.lastWeiboId,@"max_id", nil];
    [WBHttpRequest requestWithAccessToken:[self getToken] url:WB_home httpMethod:@"GET" params:params delegate:self withTag:@"pullUp"];
}

//调用accessToken和ExpirationDate
- (NSString *)getToken
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"WeiboAuthData"] objectForKey:@"accessToken"];
}
- (NSDate *)getExpirationDate
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"WeiboAuthData"] objectForKey:@"expirationDate"];
}

//获取微博
- (void)Get{
    
    if ([self getToken] == nil || [[self getToken] isEqualToString:@""]) {
    }else{
        
        NSDate *nowDate = [NSDate date];
        if([nowDate compare:[self getExpirationDate]] == NSOrderedAscending){
            //今天比token失效时间小，令牌有效
            [self loadWeiboData];
            
        }else{
            //令牌失效
        }
        
    }
}

#pragma mark - BaseTableViewEventDelegate
//下拉
- (void)pullDown:(BaseTableView *)tableView{
    //请求网络数据
    [self pullDownData];
}
//上拉
- (void)pullUp:(BaseTableView *)tableView{
    [self pullupData];
}
//点击cell
- (void)tableView:(BaseTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ModalViewController *modalVC = [[ModalViewController alloc]init];
    modalVC.modalPresentationStyle = UIModalPresentationCustom;

    WeiboModel *model = [self.weibos objectAtIndex:indexPath.row];
    modalVC.weiboModel = model;
    
    self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:modalVC];
    self.animator.dragable = YES;
    self.animator.bounces = YES;
    self.animator.direction = ZFModalTransitonDirectionBottom;
    [self.animator setContentScrollView:modalVC.tableView];
    
    modalVC.transitioningDelegate = self.animator;
    [self.view.window.rootViewController presentViewController:modalVC animated:YES completion:nil];
    [modalVC loadData];
}


#pragma mark - actions
// ----------登录按钮-----------
- (void)bindAction:(UIBarButtonItem *)buttonItem{
    _request = [WBAuthorizeRequest request];
    _request.redirectURI = kRedirectURI;
    _request.scope = @"all";
    _request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                          @"Other_Info_1": [NSNumber numberWithInt:123],
                          @"Other_Info_2": @[@"obj1", @"obj2"],
                          @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:_request];
    
}


// -----------注销按钮-----------
- (void)logOutAction:(UIBarButtonItem *)buttonItem{
    [WeiboSDK logOutWithToken:[self getToken] delegate:nil withTag:@"user1"];
}



#pragma mark  - WBHttpRequestDelegate
//网络加载完成
- (void)request:(WBHttpRequest *)request didFinishLoadingWithDataResult:(NSData *)data{
    
    //--------------------load----------------------------
    if ([request.tag isEqual:@"load"]) {
        [super.hud hide:YES afterDelay:0];
        
        self.tableView.hidden = NO;
//一个json就是一条微博
//1. 然后比如当我要请求首页的100条微博的时候，就会获取100个json，自然就会有100个statuses。
/*JSON 示例
{
    "statuses": [{
         "created_at": "Tue May 31 17:46:55 +0800 2011",
         "id": 11488058246,
         "text": "求关注。",
         "source": "<a href="http://weibo.com" rel="nofollow">新浪微博</a>",
         "favorited": false,
         "truncated": false,
         "in_reply_to_status_id": "",
         "in_reply_to_user_id": "",
         "in_reply_to_screen_name": "",
         "geo": null,
         "mid": "5612814510546515491",
         "reposts_count": 8,
         "comments_count": 9,
         "annotations": [],
         "user": {
             "id": 1404376560,
             "screen_name": "zaku",
             "name": "zaku",
             "province": "11",
             "city": "5",
             "location": "北京 朝阳区",
             "description": "人生五十年，乃如梦如幻；有生斯有死，壮士复何憾。",
             "url": "http://blog.sina.com.cn/zaku",
             "profile_image_url": "http://tp1.sinaimg.cn/1404376560/50/0/1",
             "domain": "zaku",
             "gender": "m",
             "followers_count": 1204,
             "friends_count": 447,
             "statuses_count": 2908,
             "favourites_count": 0,
             "created_at": "Fri Aug 28 00:00:00 +0800 2009",
             "following": false,
             "allow_all_act_msg": false,
             "remark": "",
             "geo_enabled": true,
             "verified": false,
             "allow_all_comment": true,
             "avatar_large": "http://tp1.sinaimg.cn/1404376560/180/0/1",
             "verified_reason": "",
             "follow_me": false,
             "online_status": 0,
             "bi_followers_count": 215
          }
      }],
    
    "ad": [{
         "id": 3366614911586452,
         "mark": "AB21321XDFJJK"
    }],
    
    "previous_cursor": 0,          // 暂未支持
    "next_cursor": 11488013766,    // 暂未支持
    "total_number": 81655
}
*/
       
        NSError *error;
        NSDictionary *weiboDIC = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        NSDictionary *WeiboInfo = [weiboDIC objectForKey:@"statuses"];
        
        NSMutableArray *weibos = [NSMutableArray arrayWithCapacity:WeiboInfo.count];
        for (NSDictionary *statuesDic in WeiboInfo) {
            WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:statuesDic];
            [weibos addObject:weibo];
        }
        self.tableView.data = weibos;
        self.weibos = weibos;

        if (weibos.count > 0) {
            //记下最新的微博ID
            WeiboModel *topWeibo= [weibos objectAtIndex:0];     //取出最新的一条微博
            self.topWeiboId = [topWeibo.weiboId stringValue];   //把最新的微博ID赋值给我们定义的这个topWeiboId变量
            //同理，记下最久的微博ID
            WeiboModel *lastWeibo = [weibos lastObject];  //取出最久的一条微博
            self.lastWeiboId = [lastWeibo.weiboId stringValue];//把最久的微博ID复制给我们定义的这个lastWeiboId变量
            
        }
        
        //刷新tableView
        [_tableView reloadData];
        
    }
    
    
    //--------------------pullDown----------------------------
    if([request.tag isEqual: @"pullDown"]){
        NSError *error;
        NSDictionary *weiboDIC = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        NSDictionary *WeiboInfo = [weiboDIC objectForKey:@"statuses"];
        
        NSMutableArray *weibos = [ NSMutableArray arrayWithCapacity:WeiboInfo.count];
        for (NSDictionary *statuesDic in WeiboInfo) {
            WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:statuesDic];
            [weibos addObject:weibo];
        }
        
        if (weibos.count > 0) {
            WeiboModel *topWeibo = [weibos objectAtIndex:0];
            self.topWeiboId = [topWeibo.weiboId stringValue];
            
        }
        
        [weibos addObjectsFromArray:self.weibos];//前面的加到后面

        self.weibos = weibos;
        self.tableView.data = self.weibos;
        
        [self.tableView reloadData];
        [self.tableView doneLoadingTableViewData];//下拉回弹
        
        //显示更新微博数目
        int updateCount = (int)[WeiboInfo count];
        NSLog(@"更新%ld条微博",(long)updateCount);
        [self showNewWeiboCount:updateCount];
        
        [super.hud hide:YES afterDelay:0.5];
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:updateCount inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    
    
    //--------------------pullUp----------------------------
    if ([request.tag isEqual:@"pullUp"]) {
        NSError *error;
        //首先我需要解析这100个json，并保存为字典
        NSDictionary *JSONDIC = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];

        NSDictionary *statuses = [JSONDIC objectForKey:@"statuses"];//2.  把所有json里面的所有statuses取出来放在一个字典里面，此时一个statues代表一份微博数据，注意此时只是原始数据，还不是真正的微博

        
        //3.把100条原始微博数据封装成真正的微博，真正的微博是WeiboModel,就是说一个WeiboModel代表一个真实的微博.把所有微博放在一个数组里。注意：最新的微博放在最上面，最新的微博ID最大
        //4.【总结】：Json -->(NSDictionary *)statuses ---> (NSMutableArray *)微博
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

//网络加载失败
- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"网络请求失败:%@",error);
    
}

- (void)refreshWeibo{
    //使UI显示下拉
//    [self.tableView baseTableViewRefreshData];
    //取数据
     [super showHUD:@"卖力加载中..." isDim:NO];
    
    [self pullDownData];
}


#pragma mark - Memory Manage
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)viewDidDisappear:(BOOL)animated{
//    UIButton *bt = [self.tabBarController.tabBar.subviews objectAtIndex:6];
//    bt.selected = NO;
//}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}




@end
