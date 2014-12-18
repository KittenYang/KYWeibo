//
//  NearWeiboMapViewController.m
//  KittenYang
//
//  Created by Kitten Yang on 14/11/4.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "NearWeiboMapViewController.h"
#import "WeiboModel.h"
#import "WeiboAnnotation.h"
#import "WeiboAnnotationView.h"

@interface NearWeiboMapViewController ()

@end

@implementation NearWeiboMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager  = [[CLLocationManager alloc]init];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    self.locationManager.delegate = self;
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma  mark - CLLocationDelegate
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{
    [manager stopUpdatingLocation];
    CLLocation *newLocation = [locations lastObject];

    MKCoordinateSpan span = {0.1,0.2};
    MKCoordinateRegion region = {newLocation.coordinate,span};
    [self.mapView setRegion:region animated:YES];
    
    
    
    if (self.data == nil) {
        float longitude = newLocation.coordinate.longitude;
        float latitude  = newLocation.coordinate.latitude;
        
        NSString *longitudeString = [NSString stringWithFormat:@"%f",longitude];
        NSString *latitudeString  = [NSString stringWithFormat:@"%f",latitude];
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:longitudeString ,@"long" ,latitudeString ,@"lat",nil];
        [WBHttpRequest requestWithAccessToken:[self getToken] url:WB_nearByWeibo httpMethod:@"GET" params:params delegate:self withTag:@"nearByWeibo"];
    }
}


- (NSString *)getToken
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"WeiboAuthData"] objectForKey:@"accessToken"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -
- (void)request:(WBHttpRequest *)request didFinishLoadingWithDataResult:(NSData *)data{
    NSError *error;
    NSDictionary *weiboDIC = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    NSDictionary *WeiboInfo = [weiboDIC objectForKey:@"statuses"];
    
    NSMutableArray *weibos = [ NSMutableArray arrayWithCapacity:WeiboInfo.count];
    int i = 0;
    for (NSDictionary *statuesDic in WeiboInfo) {
        i ++;
        WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:statuesDic];
        [weibos addObject:weibo];
        
        //创建Anatation对象，添加到地图上去
        WeiboAnnotation *weiboAnnotation = [[WeiboAnnotation alloc]initWithWeibo:weibo];
        [self.mapView performSelector:@selector(addAnnotation:) withObject:weiboAnnotation afterDelay:i*0.1];
        [self.mapView addAnnotation:weiboAnnotation];
        
    }
    
}

#pragma mark - MKAnnotationView delegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    static NSString *identity = @"WeiboAnnotationView";
    WeiboAnnotationView *annotationView = (WeiboAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identity];
    if (annotationView == nil) {
        annotationView = [[WeiboAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identity];
    }
    
    return annotationView;
}

-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    for (UIView *annotationView in views) {
        CGAffineTransform transform = annotationView.transform;
        annotationView.transform = CGAffineTransformScale(transform, 0.7, 0.7);
        annotationView.alpha = 0;
        
        [UIView animateWithDuration:0.3 animations:^{
            annotationView.transform = CGAffineTransformScale(transform, 1.2, 1.2);
            annotationView.alpha = 1;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                annotationView.transform = CGAffineTransformIdentity;
            }];
        }];
    }
    
    
    
    
}
@end







