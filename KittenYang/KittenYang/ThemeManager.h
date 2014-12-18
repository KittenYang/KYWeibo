//
//  ThemeManager.h
//  KittenYang
//
//  Created by Kitten Yang on 14-5-23.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kThemeDidChangeNotification  @"kThemeDidChangeNotification"

@interface ThemeManager : NSObject

//当前使用的主题名称
@property (nonatomic,retain)NSString *themeName;
//字典——读取theme.plist文件
@property (nonatomic,retain)NSDictionary *themesPlist;



+ (ThemeManager *)shareInstance;

//返回当前主题下，图片名对应的图片
- (UIImage *)getThemeImage:(NSString *)imageName;
- (UIColor *)changeNavbarColor:(UIColor *)color;



@end
