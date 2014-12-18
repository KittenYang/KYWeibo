//
//  MessageViewController.m
//  KittenYang
//
//  Created by Kitten Yang on 14-5-23.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "MessageViewController.h"
#import "EmotionScrollView.h"
#import "WeiboModel.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"消息";
    }
    return self;
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _initViews];
    [self loadAtWeiboData];
}

- (void)_initViews{
    

    
    tableView = [[WeiboTableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    tableView.eventDelegate = self;
    [self.view addSubview:tableView];
    tableView.hidden = YES;
    NSArray *messageButton = [NSArray arrayWithObjects:@"navigationbar_mentions.png",@"navigationbar_comments.png",@"navigationbar_messages.png",@"navigationbar_notice.png",nil];
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    for (int i =0; i < messageButton.count; i++) {
        NSString *imageName = [messageButton objectAtIndex:i];
        UIButton *button = [UIFactory createButton:imageName highlighted:imageName selected:nil];
        button.showsTouchWhenHighlighted = YES;
        button.frame = CGRectMake(50*i + 20, 10, 22, 22);
        [button addTarget:self action:@selector(messageAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i+2010;
        [titleView addSubview:button];
        
    }
    
    self.navigationItem.titleView = titleView;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)messageAction:(UIButton *)button {
    if (button.tag == 2010) {
        NSLog(@"2010");
    }else if (button.tag == 2011){
        
    }else if (button.tag == 2012){
        
    }else if (button.tag == 2013){
        
    }
}

-(void)loadAtWeiboData{
    [super showHUD:@"卖力加载中...." isDim:NO];
//    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:<#(id), ...#>, nil]
    [WBHttpRequest requestWithAccessToken:[self getToken] url:WB_AtMe httpMethod:@"GET" params:nil delegate:self withTag:@"WB_AtMe"];
}

- (NSString *)getToken
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"WeiboAuthData"] objectForKey:@"accessToken"];
}



- (void)viewDidDisappear:(BOOL)animated{
    UIButton *bt = [self.tabBarController.tabBar.subviews objectAtIndex:7];
    bt.selected = NO;
}


#pragma mark  -WBHttpDelegate
- (void)request:(WBHttpRequest *)request didFinishLoadingWithDataResult:(NSData *)data{
    NSError *error;
    NSDictionary *weiboDIC = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    NSDictionary *WeiboInfo = [weiboDIC objectForKey:@"statuses"];
    
    NSMutableArray *weibos = [ NSMutableArray arrayWithCapacity:WeiboInfo.count];
    for (NSDictionary *statuesDic in WeiboInfo) {
        WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:statuesDic];
        [weibos addObject:weibo];
    }
    
    [super.hud hide:YES afterDelay:0];
    tableView.hidden = NO;
    tableView.data = weibos;
    [tableView reloadData];
    
}




#pragma mark - UITableViewEventDegelate
- (void)pullDown:(BaseTableView *)tableView{
    
}
//上拉
- (void)pullUp:(BaseTableView *)tableView{
    
}
//选中cell
- (void)tableView:(BaseTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
