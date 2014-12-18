//
//  ThemeImageView.h
//  Weibo_KY
//
//  Created by Kitten Yang on 14-5-25.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeImageView : UIImageView

@property (nonatomic ,copy)NSString *imageName;

@property(nonatomic,assign)int leftCapWidth;
@property(nonatomic,assign)int topCapHeight;

- (id) initWithImageName:(NSString *)imageName;


@end
