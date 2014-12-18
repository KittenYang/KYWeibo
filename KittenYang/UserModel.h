//
//  UserModel.h
//  KittenYang
//
//  Created by Kitten Yang on 14-7-20.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject


@property(nonatomic,copy)NSString *idstr;           //字符串型的用户UID
@property(nonatomic,copy)NSString *screen_name;     //用户昵称
@property(nonatomic,copy)NSString *name;            //友好显示名称
@property(nonatomic,copy)NSString *location;        //用户所在地
@property(nonatomic,copy)NSString *user_description;     //用户个人描述
@property(nonatomic,copy)NSString *url;             //用户博客地址
@property(nonatomic,copy)NSString * profile_image_url;  //用户头像地址，50×50像素
@property(nonatomic,copy)NSString * avatar_large;  //用户大头像地址
@property(nonatomic,copy)NSString * gender;             //性别，m：男、f：女、n：未知
@property(nonatomic,retain)NSNumber * followers_count;    //粉丝数
@property(nonatomic,retain)NSNumber * friends_count;   //关注数
@property(nonatomic,retain)NSNumber * statuses_count;   //微博数
@property(nonatomic,retain)NSNumber * favourites_count;   //收藏数
@property(nonatomic,retain)NSNumber * verified;   //是否是微博认证用户，即加V用户，true：是，false：否




-(id)initWithDataDic:(NSDictionary*)data;
- (void)_initWithDic:(NSDictionary *)dataDic;
- (void)setAttributes:(NSDictionary *)dataDic;



@end
