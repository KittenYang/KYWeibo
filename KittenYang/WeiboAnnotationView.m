//
//  WeiboAnnotationView.m
//  KittenYang
//
//  Created by Kitten Yang on 14/11/4.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "WeiboAnnotationView.h"
#import "WeiboAnnotation.h"
#import "UIImageView+WebCache.h"

@implementation WeiboAnnotationView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initViews];
    }
    return self;
}

-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self =  [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        [self _initViews];
    }
    return  self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)_initViews{
    userImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    userImage.layer.borderColor = [UIColor whiteColor].CGColor;
    userImage.layer.borderWidth = 1;
    
    weiboImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    weiboImage.backgroundColor = [UIColor blackColor];
    weiboImage.contentMode = UIViewContentModeScaleAspectFit;//不会被拉伸
    
    textLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    textLabel.font = [UIFont systemFontOfSize:16.0f];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.numberOfLines = 3;
    
    [self addSubview:weiboImage];
    [self addSubview:textLabel];
    [self addSubview:userImage];
    
}


- (void)layoutSubviews{
    [super layoutSubviews];
    WeiboAnnotation *annotation =  self.annotation;
    WeiboModel *weiboModel = nil;
    if ([annotation isKindOfClass:[WeiboAnnotation class]]) {
        weiboModel = annotation.weiboModel;
    }
    
    NSString *thumbnailImage = weiboModel.thumbnailImage;
    if (thumbnailImage.length > 0) {  //带微博图片
        self.image  = [UIImage imageNamed:@"nearby_map_photo_bg.png"];
        //
        weiboImage.frame = CGRectMake(15, 15, 90, 85);
        [weiboImage sd_setImageWithURL:[NSURL URLWithString:thumbnailImage]];

        //
        userImage.frame = CGRectMake(70, 70, 30, 30);
        NSString *userURL = weiboModel.user.profile_image_url;
        [userImage sd_setImageWithURL:[NSURL URLWithString:userURL]];
        
        weiboImage.hidden = NO;
        textLabel.hidden = YES;
    }else{     //不带微博图片
        self.image = [UIImage imageNamed:@"nearby_map_content.png"];
        userImage.frame = CGRectMake(20, 20, 45, 45);
        NSString *userURL = weiboModel.user.profile_image_url;
        [userImage sd_setImageWithURL:[NSURL URLWithString:userURL]];

        textLabel.frame = CGRectMake(userImage.right + 5, userImage.top, 110, 45);
        textLabel.text = weiboModel.text;
        
        weiboImage.hidden = YES;
        textLabel.hidden = NO;
        
        
    }
    
}










@end
