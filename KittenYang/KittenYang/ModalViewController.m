//
//  ModalViewController.m
//  KittenYang
//
//  Created by Kitten Yang on 14-8-10.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "ModalViewController.h"
#import "UIImageView+WebCache.h"



@interface ModalViewController ()

@end

@implementation ModalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
 
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _initView];
    [self loadData];
}


-(void)_initView{
    
    UIView *tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    
    tableHeaderView.tag = kModalView;
    
    //---------------用户栏视图---------------
    self.userImageView.layer.cornerRadius  = 5;
    self.userImageView.layer.borderWidth   = 0.2;
    self.userImageView.layer.masksToBounds = YES;
    NSString *userImageURL =  _weiboModel.user.profile_image_url;
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:userImageURL]];
    
    //昵称
    self.nickLabel.text = _weiboModel.user.screen_name;
    
    //点击用户栏push到当前用户的主页
    self.userBarView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushUser)];
    [_userBarView addGestureRecognizer:tap];
    
    [tableHeaderView addSubview:_userBarView];
    tableHeaderView.height += 60;
    
    //-------------创建微博视图--------------
    float h = [WeiboView getWeiboViewHeight:self.weiboModel isDetail:YES isRepost:NO];
    _weiboView = [[WeiboView alloc]initWithFrame:CGRectMake(10, _userBarView.bottom + 10, ScreenWidth - 20, h)];
    _weiboView.isDetail = YES;
    _weiboView.weiboModel = _weiboModel;
    
    [tableHeaderView addSubview:_weiboView];
    tableHeaderView.height += (h +30);
    self.tableView.tableHeaderView = tableHeaderView;

    self.tableView.eventDelegate = self;
    
    //评论界面不显示refresh的视图
    self.tableView.refreshHeader = NO;
    

}


- (void)loadData{
    NSString *weiboID = [_weiboModel.weiboId stringValue];
    if (weiboID.length == 0) {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:weiboID,@"id",@"25",@"count",nil];
    [WBHttpRequest requestWithAccessToken:[self getToken] url:WB_Comments httpMethod:@"GET" params:params delegate:self withTag:@"comment"];
}



- (NSString *)getToken
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"WeiboAuthData"] objectForKey:@"accessToken"];
}



#pragma mark - UITableViewEventDelegate
//下拉
- (void)pullDown:(BaseTableView *)tableView{
    
}
//上拉
- (void)pullUp:(BaseTableView *)tableView{
    NSString *weiboID = [_weiboModel.weiboId stringValue];
    if (weiboID.length == 0) {
        return;
    }
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:weiboID,@"id",@"25",@"count",self.lastWeiboID,@"max_id",nil];
    [WBHttpRequest requestWithAccessToken:[self getToken] url:WB_Comments httpMethod:@"GET" params:params delegate:self withTag:@"pullUp"];
    
}
//选中cell
- (void)tableView:(BaseTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}




#pragma mark - WBHttpRequest Delegate
- (void)request:(WBHttpRequest *)request didFinishLoadingWithDataResult:(NSData *)data{
    if ([request.tag isEqual:@"comment"]) {
        NSError *error;
        NSDictionary *JSONDIC = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        self.tableView.totalCommentNumber =  [JSONDIC objectForKey:@"total_number"];
        NSDictionary *commentsDic = [JSONDIC objectForKey:@"comments"];
        
        NSMutableArray *comments = [NSMutableArray arrayWithCapacity:commentsDic.count];
        for (NSDictionary *dic in commentsDic) {
            CommentModel *commentModel = [[CommentModel alloc]initWithCommentDataDic:dic];
            [comments addObject:commentModel];
        }
        
        self.tableView.data = self.comments;
        self.comments = comments;

        if (commentsDic.count > 0) {
            CommentModel *commentModel = [comments lastObject];
            self.lastWeiboID = [commentModel.weiboId stringValue];
        }
        
        //刷新tableView
        [self.tableView reloadData];
    }
    
    if ([request.tag isEqual:@"pullUp"]) {

        NSError *error;
        NSDictionary *JSONDIC = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];

        NSDictionary *commentsDic = [JSONDIC objectForKey:@"comments"];
        NSMutableArray *comments = [NSMutableArray arrayWithCapacity:commentsDic.count];
        for (NSDictionary *dic in commentsDic) {
            CommentModel *commentModel = [[CommentModel alloc]initWithCommentDataDic:dic];
            [comments addObject:commentModel];
        }
        //移除重复的那条微博
        [comments removeObject:[comments firstObject]];
        
        if (comments.count > 0) {
            CommentModel *commentModel = [comments lastObject];
            self.lastWeiboID = [commentModel.weiboId stringValue];
            
        }

        [self.comments addObjectsFromArray:comments];
        NSLog(@"%lu",(unsigned long)self.comments.count);
        self.tableView.data = self.comments;
        
        //判断剩余是否大于一页
        if (commentsDic.count < 25) {
            self.tableView.isMore = NO;
        }else {
            self.tableView.isMore = YES;
        }
        
        [self.tableView reloadData];
    }
    
}


#pragma mark - pushUser   点击用户头像加一个push的动作
- (void)pushUser{
    ProfileModalViewController *modalVC = [[ProfileModalViewController alloc]init];
    modalVC.userName = self.weiboModel.user.screen_name;
    
    //在详细页面点击
    modalVC.modalPresentationStyle = UIModalPresentationCustom;
    
    self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:modalVC];
    self.animator.dragable = YES;
    self.animator.direction = ZFModalTransitonDirectionRight;
    
    modalVC.transitioningDelegate = self.animator;
    
    [self presentViewController:modalVC animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
