//
//  EmotionView.h
//  KittenYang
//
//  Created by Kitten Yang on 14/10/27.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SelectBlock)(NSString *emotionName);

@interface EmotionView : UIView{
@private
    NSMutableArray *items;
    UIImageView    *magnifierView;
}

@property(nonatomic,copy)NSString     *selectedEmotion;
@property(nonatomic,assign)NSInteger  pageNumber;
@property(nonatomic,copy)SelectBlock  block;
@end


