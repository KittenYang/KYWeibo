//
//  NearWeiboMapViewController.h
//  KittenYang
//
//  Created by Kitten Yang on 14/11/4.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface NearWeiboMapViewController : BaseViewController<CLLocationManagerDelegate,WBHttpRequestDelegate,MKMapViewDelegate>

@property(nonatomic,retain)NSArray *data;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end
