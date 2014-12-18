//
//  ThemeButton.h
//  KittenYang
//
//  Created by Kitten Yang on 14-5-23.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeButton : UIButton

@property (nonatomic,copy)NSString *normal_ImageName;
@property (nonatomic,copy)NSString *highlight_ImageName;
@property (nonatomic,copy)NSString *selected_ImageName;

@property (nonatomic,copy)NSString *normal_bgdImageName;
@property (nonatomic,copy)NSString *highlight_bgdImageName;

@property (nonatomic,assign)int leftCapWidth;
@property (nonatomic,assign)int topCapHeight;


- (id)initWithNormalImage:(NSString *)normal_ImageName withHighlightImage:(NSString *)highlight_ImageName withSelectedImage:(NSString *)selected_ImageName;

- (id)initWithBgd_NormalImage:(NSString *)normal_bgdImageName withBgd_HighlightImage:(NSString *)highlight_bgdImageName;

@end
