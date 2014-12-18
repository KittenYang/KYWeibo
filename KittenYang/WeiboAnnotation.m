//
//  WeiboAnnotation.m
//  KittenYang
//
//  Created by Kitten Yang on 14/11/4.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "WeiboAnnotation.h"

@implementation WeiboAnnotation


-(id)initWithWeibo:(WeiboModel *)weiboModel{
    self = [super init];
    if (self != nil) {
        
        self.weiboModel = weiboModel;
    }
    return  self;
}

-(void)setWeiboModel:(WeiboModel *)weiboModel{
    if (_weiboModel != weiboModel) {
        _weiboModel = weiboModel;
    }
    //
    NSDictionary *geo = weiboModel.geo;
    if ([geo isKindOfClass:[NSDictionary class]]) {
        NSArray *coord = [geo objectForKey:@"coordinates"];
        if (coord.count == 2) {
            float lat = [[coord objectAtIndex:0]floatValue];
            float lon = [[coord objectAtIndex:1]floatValue];
            _coordinate = CLLocationCoordinate2DMake(lat, lon);
        }
    }
    
    
}

@end
