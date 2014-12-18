//
//  UIUtils.h
//
//
//  Created by KittenYang on 14-8-3.
//  Copyright (c) 2014年 KittenYang All rights reserved.


#import <Foundation/Foundation.h>
#import "CONSTS.h"

@interface UIUtils : NSObject

//获取documents下的文件路径
+ (NSString *)getDocumentsPath:(NSString *)fileName;
// date 格式化为 string
+ (NSString*) stringFromFomate:(NSDate*)date formate:(NSString*)formate;
// string 格式化为 date
+ (NSDate *) dateFromFomate:(NSString *)datestring formate:(NSString*)formate;
//格式化日期
+ (NSString *)fomateString:(NSString *)datestring;

+ (NSString *)parseLink:(NSString *)text;

@end
