//
//  ThemeImageView.m
//  Weibo_KY
//
//  Created by Kitten Yang on 14-5-25.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "ThemeImageView.h"
#import "ThemeManager.h"

@implementation ThemeImageView

//如果是用xib创建了一个ThemeImageView的对象，那么程序会调用这个awakeFromNib的初始化方法
- (void) awakeFromNib{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeImageViweNotification:) name:kThemeDidChangeNotification object:nil];

}

- (id) initWithImageName:(NSString *)imageName{
    self = [self init];
    if (self != nil) {
        self.imageName = imageName;
    }
    return self;
}

- (void) setImageName:(NSString *)imageName{
    if (_imageName != imageName) {
        _imageName =  [imageName copy];
    }
    [self loadImage];
    
}

- (id) init{
    self  =[super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeImageViweNotification:) name:kThemeDidChangeNotification object:nil];
        
    }
    return self;
}


- (void)loadImage{
    if (self.imageName == nil) {
        return;
    }
    UIImage *image = [[ThemeManager shareInstance]getThemeImage:_imageName];
    image = [image stretchableImageWithLeftCapWidth:self.leftCapWidth topCapHeight:self.topCapHeight];
    self.image = image;
    
}

#pragma mark - NSNotification
- (void)themeImageViweNotification:(NSNotification *)notification{
    [self loadImage];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
