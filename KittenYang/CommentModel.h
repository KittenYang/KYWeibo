//
//  CommentModel.h
//  KittenYang
//
//  Created by Kitten Yang on 14-8-12.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "WeiboModel.h"
#import "UserModel.h"

//评论返回的数据


@interface CommentModel : NSObject

@property(nonatomic,copy)NSString *created_at;
@property(nonatomic,retain)NSNumber *weiboId;
@property(nonatomic,copy)NSString *text;
@property(nonatomic,copy)NSString *source;
@property(nonatomic,copy)NSString *mid;
@property(nonatomic,copy)NSString *idstr;
@property(nonatomic,retain)UserModel *user;
@property(nonatomic,retain)WeiboModel *weibo;

-(id)initWithCommentDataDic:(NSDictionary*)data;

@end
