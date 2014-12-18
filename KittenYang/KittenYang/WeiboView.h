//
//  WeiboView.h
//  KittenYang
//
//  Created by Kitten Yang on 14-7-22.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
#import "WebModalViewController.h"
#import "topicModalViewController.h"


#define kWeibo_width_List (320 - 60)   //微博在列表中的宽度
#define kWeibo_width_Detail 300        //微博在detail里面的宽度

@class  WeiboModel;

@interface WeiboView : UIView<RTLabelDelegate>{
@private
    RTLabel         *_textLabel;            //微博内容
    UIImageView     *_image;                //微博图片
    UIImageView     *_repostBackgroundView; //转发微博的背景
    WeiboView       *_repostView;           //转发的微博视图
    NSMutableString  *_parseText;
    
}

//微博数据模型对象
//注：@property是供外部访问的
@property(nonatomic,retain)WeiboModel *weiboModel;
//当前微博视图是否是转发的
@property(nonatomic,assign)BOOL isRepost;
//是否是在显示详情页面
@property(nonatomic,assign)BOOL isDetail;


//计算微博视图高度
+(CGFloat)getWeiboViewHeight:(WeiboModel *)weiboModel  isDetail:(BOOL)isDetail isRepost:(BOOL)isRepost;
//获取微博字体大小
+(float)getFontSize:(BOOL)isDetail isRepost:(BOOL)isRepost;



@end
