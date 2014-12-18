//
//  WeiboCell.h
//  KittenYang
//  自定义微博cell
//  Created by Kitten Yang on 14-7-22.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFModalTransitionAnimator.h"
@class WeiboModel;
@class WeiboView;
@interface WeiboCell : UITableViewCell{
    UIImageView *_userImage;     //用户头像
    UILabel     *_nickLabel;     //昵称
    UILabel     *_repostLabel;   //转发数
    UILabel     *_commentLabel;  //回复数
    UILabel     *_sourceLabel;   //发布来源
    UILabel     *_createLabel;   //发布时间
    
}


//微博数据模型对象
@property(nonatomic,retain)WeiboModel *weiboModel;
//微博视图
@property(nonatomic,retain)WeiboView  *weiboView;

@property (nonatomic, strong) ZFModalTransitionAnimator *animator;

@end
