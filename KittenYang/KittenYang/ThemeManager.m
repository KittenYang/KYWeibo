//
//  ThemeManager.m
//  KittenYang
//
//  Created by Kitten Yang on 14-5-23.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "ThemeManager.h"

@implementation ThemeManager

static ThemeManager *singleton = nil;

+ (ThemeManager *)shareInstance{
    if (singleton == nil) {
        @synchronized(self){
            singleton = [[ThemeManager alloc] init];
        }
        
    }
    return singleton;
}



//初始化的时候读入theme.plist;设置主题名称为空;
- (id)init{
    self = [super init];
    if (self) {
        NSString *themePlistPath = [[NSBundle mainBundle]pathForResource:@"theme" ofType:@"plist"];
        self.themesPlist = [NSDictionary dictionaryWithContentsOfFile:themePlistPath];
        
        //初始化的时候主题名称为空
        self.themeName = nil;
    }
    return self;
    
}


- (NSString *)getThemePath{
    //如果没有选择主题，这默认会返回程序包根目录
    if (self.themeName == nil) {
        NSString *resourcePath =  [[NSBundle mainBundle]resourcePath];
        return resourcePath;
    }else{
        
        //从plist文件里面读取，例如:Skins/blue
        //就是这一句解释了为什么ThemeViewController.m里面要有
        //[ThemeManager shareInstance].themeName = themeName;   这一句
        //因为如果不传如主题名称，就没办法形成后缀名：Skin/blue 还是  Skin/pink
        
        NSString *themePlistPath = [self.themesPlist objectForKey:_themeName];
        //程序包的根路径
        NSString *resourcePath = [[NSBundle mainBundle]resourcePath];
        //拼在一起,获得完整的主题包路径
        NSString *path = [resourcePath stringByAppendingPathComponent:themePlistPath];
        
        return path;
        
    }
}


- (UIImage *)getThemeImage:(NSString *)imageName{
    if (imageName.length == 0) {
        return nil;
    }
    //这就是把完整的主题路径path取出来赋值给一个新变量themePath
    NSString *themePath = [self getThemePath];
    NSString *imagePath = [themePath stringByAppendingPathComponent:imageName];
    
    
    //注意，不能用imageNamed，imageNamed是通过@“1.png”从程序包根路径去找，就像黄色文件夹images里的图片.
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    
    return  image;
}


- (UIColor *)changeNavbarColor:(UIColor *)color{
    return color;
}

//限制当前对象创建多实例
#pragma mark - sengleton setting
+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (singleton == nil) {
            singleton = [super allocWithZone:zone];
        }
    }
    return singleton;
}

+ (id)copyWithZone:(NSZone *)zone {
    return self;
}






@end
