//
//  UserModel.m
//  KittenYang
//
//  Created by Kitten Yang on 14-7-20.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel


-(id)initWithDataDic:(NSDictionary*)data{
    if (self = [super init]) {
		[self setAttributes:data];
	}
	return self;
}

- (void)_initWithDic:(NSDictionary *)dataDic{
    self.idstr = [dataDic objectForKey:@"idstr"];
    self.screen_name = [dataDic objectForKey:@"screen_name"];
    self.name = [dataDic objectForKey:@"name"];
    self.location = [dataDic objectForKey:@"location"];
    self.user_description = [dataDic objectForKey:@"description"];
    self.url = [dataDic objectForKey:@"url"];
    self.profile_image_url = [dataDic objectForKey:@"profile_image_url"];
    self.avatar_large = [dataDic objectForKey:@"avatar_large"];
    self.gender = [dataDic objectForKey:@"gender"];
    self.followers_count = [dataDic objectForKey:@"followers_count"];
    self.friends_count = [dataDic objectForKey:@"friends_count"];
    self.statuses_count = [dataDic objectForKey:@"statuses_count"];
    self.favourites_count = [dataDic objectForKey:@"favourites_count"];
    self.verified = [dataDic objectForKey:@"verified"];
}

- (void)setAttributes:(NSDictionary *)dataDic{
    [self _initWithDic:dataDic];
}

@end
