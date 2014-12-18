//
//  WeiboAnnotation.h
//  KittenYang
//
//  Created by Kitten Yang on 14/11/4.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "WeiboModel.h"
@interface WeiboAnnotation : NSObject<MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic,retain)WeiboModel *weiboModel;


//---optional---------
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;


-(id)initWithWeibo:(WeiboModel *)weiboModel;

@end
