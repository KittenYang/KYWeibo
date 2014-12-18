//
//  UIUtils.m
//  
//
//  Created by KittenYang on 14-8-3.
//  Copyright (c) 2014年 KittenYang All rights reserved.
//

#import "UIUtils.h"
#import <CommonCrypto/CommonDigest.h>
#import "RegexKitLite.h"
#import "NSString+URLEncoding.h"

@implementation UIUtils

+ (NSString *)getDocumentsPath:(NSString *)fileName {
    
    //两种获取document路径的方式
//    NSString *documents = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documents = [paths objectAtIndex:0];
    NSString *path = [documents stringByAppendingPathComponent:fileName];
    
    return path;
}

+ (NSString*) stringFromFomate:(NSDate*) date formate:(NSString*)formate {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:formate];
	NSString *str = [formatter stringFromDate:date];
	return str;
}

+ (NSDate *) dateFromFomate:(NSString *)datestring formate:(NSString*)formate {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
    NSDate *date = [formatter dateFromString:datestring];
    return date;
}

//Sat Jan 12 11:50:16 +0800 2013
+ (NSString *)fomateString:(NSString *)datestring {
    NSString *formate = @"E M d HH:mm:ss Z yyyy";
    NSDate *createDate = [UIUtils dateFromFomate:datestring formate:formate];
    NSString *text = [UIUtils stringFromFomate:createDate formate:@"MM-dd HH:mm"];
    return text;
}

//正则表达式
+ (NSString *)parseLink:(NSString *)text{
    NSString *regex = @"(@[\\u4e00-\\u9fa5\\w\\-]+)|(http(s)?://([a-zA-Z|\\d]+\\.)+[a-zA-Z|\\d]+(/[a-zA-Z|\\d|\\-|\\+|_./?%&=]*)?)|(#([^\\#|.]+)#)|(\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\])";
    NSArray *matchArray = [text componentsMatchedByRegex:regex];
    for (NSString *linkString in matchArray) {
        
        NSString *replacing = nil;
        if ([linkString hasPrefix:@"@"]) {   //hasPrefix 方法作用：判断以哪个字符串开头
            replacing = [NSString stringWithFormat:@"<a href='user://%@'>%@</a>",[linkString URLEncodedString],linkString];
        }else if([linkString hasPrefix:@"http"]){
            replacing = [NSString stringWithFormat:@"<a href='%@'>%@</a>",linkString,linkString];
        }else if([linkString hasPrefix:@"#"]){
            replacing = [NSString stringWithFormat:@"<a href='topic://%@'>%@</a>",[linkString URLEncodedString],linkString];
        }
        if (replacing != nil) {
            text = [text stringByReplacingOccurrencesOfString:linkString withString:replacing];
        }
    }
    return text;
}

@end
