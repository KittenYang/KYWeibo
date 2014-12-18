//
//  EmotionScrollView.h
//  KittenYang
//
//  Created by Kitten Yang on 14/10/29.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmotionView.h"

@interface EmotionScrollView : UIView<UIScrollViewDelegate>{
    UIScrollView     *scrollView;
    EmotionView      *emotionView;
    UIPageControl    *pageControl;
}
-(id)initWithSelectBlock:(SelectBlock)block;

@end
