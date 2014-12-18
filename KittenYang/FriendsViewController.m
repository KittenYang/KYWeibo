//
//  FriendsViewController.m
//  KittenYang
//
//  Created by Kitten Yang on 14/11/2.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "FriendsViewController.h"
#import "UserModel.h"

@interface FriendsViewController ()

@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.data = [NSMutableArray array];
    self.tableView.eventDelegate = self;
    
    if (self.friendType == Fans) {
        self.title = @"粉丝数";
        [self loadData:WB_fans];
    }else if(self.friendType == Follows){
        self.title = @"关注数";
        [self loadData:WB_friends];
    }
    
    
}
- (void)loadData:(NSString *)url{
    if (self.userName.length == 0) {
        NSLog(@"用户ID为空");
        return;
    }
    
    NSMutableDictionary *params  = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.userName,@"screen_name", nil];
    if (self.cursor.length > 0 ) {
        [params setObject:self.cursor  forKey:@"cursor"];
    }
    [WBHttpRequest requestWithAccessToken:[self getToken] url:url httpMethod:@"GET" params:params delegate:self withTag:nil];
}



- (NSString *)getToken
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"WeiboAuthData"] objectForKey:@"accessToken"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark  -- WBHttpDelegate
//网络加载完成
- (void)request:(WBHttpRequest *)request didFinishLoadingWithDataResult:(NSData *)data{

    NSError *error;
    NSDictionary *userDIC = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    NSArray *usersArray = [userDIC objectForKey:@"users"];
    
    /*
     *[
     ["用户1","用户2","用户3"];  一个cell显示3个
     ["用户1","用户2","用户3"];  再个cell显示3个
     ....
     ];
     *
     */
    
    NSMutableArray *array2D = nil;
    for (int i=0; i <usersArray.count; i++) {
        
        array2D = [self.data lastObject];
        
        //每次判断最后一个数组是否填满数据
        if (array2D.count == 3 || array2D == nil) {
            array2D = [NSMutableArray arrayWithCapacity:3];
            [self.data addObject:array2D];
        }
        NSDictionary *userDic = [usersArray objectAtIndex:i];
        UserModel *userModel = [[UserModel alloc]initWithDataDic:userDic];
        [array2D addObject:userModel];
    }
    
    if (usersArray.count < 40 ) {
        self.tableView.isMore = NO;
    }else{
        self.tableView.isMore = YES;
    }
    
    self.tableView.data = self.data;
    [self.tableView reloadData];
    
    //收起下拉
    if (self.cursor == nil) {
        [self.tableView doneLoadingTableViewData];
    }
    
    //记录下一页游标值
    self.cursor = [[userDIC objectForKey:@"next_cursor"]stringValue];
    
}

#pragma mark  - UITableViewEventDegelate
//下拉
- (void)pullDown:(BaseTableView *)tableView{
    self.cursor = nil;
    [self.data removeAllObjects];
    if (self.friendType == Fans) {
        [self loadData:WB_fans];
    }else if (self.friendType == Follows){
        [self loadData:WB_friends];
    }
}

//上拉
- (void)pullUp:(BaseTableView *)tableView{
    if (self.friendType == Fans) {
        [self loadData:WB_fans];
    }else if (self.friendType == Follows){
        [self loadData:WB_friends];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
