//
//  ThemeButton.m
//  KittenYang
//
//  Created by Kitten Yang on 14-5-23.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "ThemeButton.h"
#import "ThemeManager.h"

@implementation ThemeButton


- (id)initWithNormalImage:(NSString *)normal_ImageName withHighlightImage:(NSString *)highlight_ImageName withSelectedImage:(NSString *)selected_ImageName{
    self = [self init];
    if (self) {
        self.normal_ImageName    = normal_ImageName;
        self.highlight_ImageName = highlight_ImageName;
        self.selected_ImageName  = selected_ImageName;
    }
    return  self;
    
}

- (void)setLeftCapWidth:(int)leftCapWidth{
    _leftCapWidth = leftCapWidth;
    [self loadImage];
}

- (void)setTopCapHeight:(int)topCapHeight{
    _topCapHeight = topCapHeight;
    [self loadImage];
    
}

- (id)initWithBgd_NormalImage:(NSString *)normal_bgdImageName withBgd_HighlightImage:(NSString *)highlight_bgdImageName{
    self = [self init];
    if (self) {
        self.normal_bgdImageName    = normal_bgdImageName;
        self.highlight_bgdImageName = highlight_bgdImageName;
    }
    return  self;
}

//在初始化里面监听通知
- (id)init{
    self =  [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNotification object:nil];
    }
    return self;
}

- (void)themeNotification:(NSNotification *)notification{
    [self loadImage];
    
}


- (void)loadImage{
    ThemeManager *themeManager =  [ThemeManager shareInstance];
    
    UIImage * normalImg        = [themeManager getThemeImage:_normal_ImageName];
    normalImg = [normalImg stretchableImageWithLeftCapWidth:self.leftCapWidth topCapHeight:self.topCapHeight];
    UIImage * highlightImg     = [themeManager getThemeImage:_highlight_ImageName];
    highlightImg = [normalImg stretchableImageWithLeftCapWidth:self.leftCapWidth topCapHeight:self.topCapHeight];
    UIImage * selectedImg      = [themeManager getThemeImage:_selected_ImageName];
    
    [self setImage:normalImg forState:UIControlStateNormal];
    [self setImage:highlightImg forState:UIControlStateHighlighted];
    [self setImage:selectedImg forState:UIControlStateSelected];


    UIImage * normal_bgdImg    = [themeManager getThemeImage:_normal_bgdImageName];
    UIImage * highlight_bgdImg = [themeManager getThemeImage:_highlight_bgdImageName];
    normal_bgdImg = [normalImg stretchableImageWithLeftCapWidth:self.leftCapWidth topCapHeight:self.topCapHeight];
    highlight_bgdImg = [normalImg stretchableImageWithLeftCapWidth:self.leftCapWidth topCapHeight:self.topCapHeight];
    
    [self setBackgroundImage:normal_bgdImg forState:UIControlStateNormal];
    [self setBackgroundImage:highlight_bgdImg forState:UIControlStateHighlighted];
}


#pragma mark - setter
- (void)setNormal_ImageName:(NSString *)normal_ImageName{
    if (_normal_ImageName != normal_ImageName) {
        _normal_ImageName = [normal_ImageName copy];
    }
    [self loadImage];
}

- (void)setHighlight_ImageName:(NSString *)highlight_ImageName{
    if (_highlight_ImageName != highlight_ImageName) {
        _highlight_ImageName = [highlight_ImageName copy];
    }
    [self loadImage];
}

-(void)setSelected_ImageName:(NSString *)selected_ImageName{
    if (_selected_ImageName != selected_ImageName) {
        _selected_ImageName = [selected_ImageName copy];
    }
    [self loadImage];
}
    

- (void)setNormal_bgdImageName:(NSString *)normal_bgdImageName{
    if (_normal_bgdImageName != normal_bgdImageName) {
        _normal_bgdImageName = [normal_bgdImageName copy];
    }
    [self loadImage];
}

- (void)setHighlight_bgdImageName:(NSString *)highlight_bgdImageName{
    if (_highlight_bgdImageName != highlight_bgdImageName) {
        _highlight_bgdImageName = [highlight_bgdImageName copy];
    }
    [self loadImage];
}







@end
