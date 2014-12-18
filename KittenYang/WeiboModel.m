//
//  WeiboModel.m
//  KittenYang
//
//  Created by Kitten Yang on 14-7-20.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "WeiboModel.h"


@implementation WeiboModel

-(id)initWithDataDic:(NSDictionary*)data{
	if (self = [super init]) {
		[self setAttributes:data];
	}
	return self;
}


- (void)_initWithDic:(NSDictionary *)dataDic
{
    self.createDate = [dataDic objectForKey:@"created_at"];
    self.weiboId = [dataDic objectForKey:@"id"];
    self.text = [dataDic objectForKey:@"text"];
    self.source = [dataDic objectForKey:@"source"];
    self.favorited = [dataDic objectForKey:@"favorited"];
    self.thumbnailImage = [dataDic objectForKey:@"thumbnail_pic"];
    self.bmiddleImage = [dataDic objectForKey:@"bmiddle_pic"];
    self.originalImage = [dataDic objectForKey:@"original_pic"];
    self.geo = [dataDic objectForKey:@"geo"];
    self.repostsCount = [dataDic objectForKey:@"reposts_count"];
    self.commentsCount = [dataDic objectForKey:@"comments_count"];
}


- (void)setAttributes:(NSDictionary *)dataDic {
    //将字典数据根据映射关系填充到当前对象的属性上。
    [self _initWithDic:dataDic];
    
    
    NSDictionary *retweetDic = [dataDic objectForKey:@"retweeted_status"];
    if (retweetDic != nil) {
        WeiboModel *relWeibo = [[WeiboModel alloc] initWithDataDic:retweetDic];
        self.relWeibo = relWeibo;
    }
    
    NSDictionary *userDic = [dataDic objectForKey:@"user"];
    if (userDic != nil) {
        UserModel *user = [[UserModel alloc] initWithDataDic:userDic];
        self.user = user;
    }
    
}
@end


