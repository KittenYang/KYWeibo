//
//  CommentModel.m
//  KittenYang
//
//  Created by Kitten Yang on 14-8-12.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel
-(id)initWithCommentDataDic:(NSDictionary*)data{
    if (self = [super init]) {
        [self setAttributes:data];
    }
    return self;
}


- (void)_initWithCmtDic:(NSDictionary *)dataDic{
    self.created_at = [dataDic objectForKey:@"created_at"];
    self.weiboId = [dataDic objectForKey:@"id"];
    self.text = [dataDic objectForKey:@"text"];
    self.source = [dataDic objectForKey:@"source"];
    self.mid = [dataDic objectForKey:@"mid"];
    self.idstr = [dataDic objectForKey:@"idstr"];
}

- (void)setAttributes:(NSDictionary *)dataDic {
    
    [self _initWithCmtDic:dataDic];
    
    NSDictionary *userDic = [dataDic objectForKey:@"user"];
    NSDictionary *statusDic = [dataDic objectForKey:@"status"];

    UserModel *user = [[UserModel alloc] initWithDataDic:userDic];
    WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:statusDic];
    
    self.user = user;
    self.weibo = weibo;
    
}

@end
