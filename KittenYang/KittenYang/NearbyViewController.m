//
//  NearbyViewController.m
//  KittenYang
//
//  Created by Kitten Yang on 14/10/6.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "NearbyViewController.h"
#import "UIImageView+WebCache.h"


@interface NearbyViewController (){

}

@end

@implementation NearbyViewController{
    
    UILabel *headerLabel;
}

- (void)_initView{

    headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, -80, ScreenWidth, 80)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.text = @"继续下拉关闭";
    headerLabel.font = [UIFont systemFontOfSize:16.0f];
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    [self.tableView addSubview:headerLabel];
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    footView.backgroundColor = [UIColor clearColor];
    
    self.tableView.tableFooterView = footView;
    
}


- (void)viewDidLoad {
    self.tableView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    [super viewDidLoad];
    [self _initView];
    self.title = @"我在这里";
    self.tableView.hidden = YES;
    [super showHUD:@"卖力加载中..." isDim:NO];
    
    if (nil == self.locationManager) {
        self.locationManager = [[CLLocationManager alloc]init];
    }
    
    self.locationManager.delegate = self;
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
    
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{
    CLLocation *newLocation = [locations lastObject];
    NSLog(@"开始定位:%@",newLocation);
    [manager stopUpdatingHeading];
    if (self.data == nil) {
        float longitude = newLocation.coordinate.longitude;
        float latitude =  newLocation.coordinate.latitude;
        
        NSString *longitudeString = [NSString stringWithFormat:@"%f",longitude];
        NSString *latitudeString  = [NSString stringWithFormat:@"%f",latitude];
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:longitudeString,@"long",latitudeString,@"lat",@"20",@"count",nil];
        [WBHttpRequest requestWithAccessToken:[self getToken] url:WB_nearBy httpMethod:@"GET" params:params delegate:self withTag:@"nearBy"];
    }
}



- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    NSLog(@"定位错误");
}


- (NSString *)getToken
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"WeiboAuthData"] objectForKey:@"accessToken"];
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identity = @"cell";
    UITableViewCell *cell =[ tableView dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identity];
        
    }
    
    NSDictionary *dic = [self.data objectAtIndex:indexPath.row];
    NSString *title = [dic objectForKey:@"title"];
    NSString *subTitle= [dic objectForKey:@"address"];
    NSString *icon = [dic objectForKey:@"icon"];
    
    if (![title isKindOfClass:[NSNull class]]) {
        cell.textLabel.text = title;
    }
    
    if (![subTitle isKindOfClass:[NSNull class]]) {
        cell.detailTextLabel.text = subTitle;
    }
    if (![icon isKindOfClass:[NSNull class]]) {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:[UIImage imageNamed:@"page_image_loading.png"]];
    }
    
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectBlock != nil) {
        NSDictionary *dic = [self.data objectAtIndex:indexPath.row];
        _selectBlock(dic);
    }
    [self dismissViewControllerAnimated:YES completion: nil];
}


#pragma mark - WBHttpRequestDelegate
//获得请求数据
- (void)request:(WBHttpRequest *)request didFinishLoadingWithDataResult:(NSData *)data{
    NSError * error;
    NSDictionary *JSONDIC = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    NSArray *pois =[JSONDIC objectForKey:@"pois"];
    self.data = pois;
    [self refreshUI];
}

#pragma mark - UI
- (void)refreshUI{
    [super.hud hide:YES afterDelay:0];
    self.tableView.hidden = NO;
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float offset = self.tableView.contentOffset.y;
    if (offset < -160) {
        headerLabel.text = @"可以松手了";
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    float offset = self.tableView.contentOffset.y;
    if (offset < -160) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        headerLabel.text = @"继续下拉关闭";
    }
}






@end
