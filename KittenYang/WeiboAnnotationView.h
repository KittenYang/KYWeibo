//
//  WeiboAnnotationView.h
//  KittenYang
//
//  Created by Kitten Yang on 14/11/4.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface WeiboAnnotationView : MKAnnotationView{
    UIImageView *userImage;  //用户头像
    UIImageView *weiboImage; //微博图片视图
    UILabel  *textLabel;     //微博内容
}



@end
