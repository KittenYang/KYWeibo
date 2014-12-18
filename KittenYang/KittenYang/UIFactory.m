//
//  UIFactory.m
//  KittenYang
//
//  Created by Kitten Yang on 14-5-23.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "UIFactory.h"

@implementation UIFactory

+(ThemeButton *)createButton:(NSString *)imageName highlighted:(NSString *)highlightedName selected:(NSString *)selectedName{
    ThemeButton *button = [[ThemeButton alloc]initWithNormalImage:imageName withHighlightImage:highlightedName withSelectedImage:selectedName];
    return button;
}

+(ThemeButton *)createBkgButton:(NSString *)bkgImageName highlighted:(NSString *)bkgHighlightedName{
    ThemeButton *button = [[ThemeButton alloc]initWithBgd_NormalImage:bkgImageName withBgd_HighlightImage:bkgHighlightedName];
    return button;
}

+(UIButton *)createNavigationButton:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)selector{
   ThemeButton *button = [self createBkgButton:@"navigationbar_button_background.png" highlighted:@"navigationbar_button_delete_background.png"];
    
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    button.leftCapWidth = 3;
    
    return button;
        
}

+(ThemeImageView *)createImageView:(NSString *)imageName{
    ThemeImageView *imageView = [[ThemeImageView alloc]initWithImageName:imageName];
    return imageView;
}

@end
