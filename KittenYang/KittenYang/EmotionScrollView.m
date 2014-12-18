//
//  EmotionScrollView.m
//  KittenYang
//
//  Created by Kitten Yang on 14/10/29.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "EmotionScrollView.h"

@implementation EmotionScrollView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}
-(id)initWithSelectBlock:(SelectBlock)block{
    self = [self initWithFrame:CGRectZero];
    if (self != nil) {
        emotionView.block = block;
    }
    return self;
}

- (void)initViews{
    emotionView  = [[EmotionView alloc]initWithFrame:CGRectZero];
    scrollView   = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, emotionView.height)];
    NSLog(@"emotionView.height:%f",emotionView.height);
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.contentSize = CGSizeMake(emotionView.width, 0);
    scrollView.alwaysBounceVertical = NO;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.clipsToBounds = NO;
    scrollView.delegate = self;
    
    [scrollView addSubview:emotionView];
    [self addSubview:scrollView];

    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(-15, scrollView.bottom, 40, 20)];
    pageControl.backgroundColor = [UIColor clearColor];
    pageControl.numberOfPages   = emotionView.pageNumber;
    pageControl.currentPage     = 0;
    [self addSubview:pageControl];
    
    
    self.height = scrollView.height + pageControl.height;
    self.width  = scrollView.width;

}


- (void)drawRect:(CGRect)rect {
    [[UIImage imageNamed:@"emoticon_keyboard_background.png"]drawInRect:rect];
}




#pragma  mark  - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)_scrollView{
    int pageNumber = _scrollView.contentOffset.x/ScreenWidth;
    pageControl.currentPage = pageNumber;
    
    
}
@end
