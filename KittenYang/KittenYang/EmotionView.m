//
//  EmotionView.m
//  KittenYang
//
//  Created by Kitten Yang on 14/10/27.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "EmotionView.h"
#import "DDMenuController.h"

#define item_width   42
#define item_height  45

@implementation EmotionView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        self.pageNumber = items.count;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

/**
 *  行   row: 4
 *  列   colum: 7
 *  表情尺寸  30*30
 **/
/*
 *items = [
            [表情1,表情2,表情3,.....,表情28]; // 第一页
            [表情1,表情2,表情3,.....,表情28]; // 第二页
            ...
          ];
 */
-(void)initData{
    items = [[NSMutableArray alloc]init];
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"emoticons" ofType:@"plist"]; //"emoticons.plist"是个数组
    NSArray *fileArray = [NSArray arrayWithContentsOfFile:filePath]; //目前这个fileArray有没有分类的104个表情，现在我们需要把它分类成上面注释中items的形式
    
    //----------整理表情，整理成一个二维数组----------
    NSMutableArray *item2D = nil;
    for (int i=0; i < fileArray.count; i++) {
        NSDictionary *item = [fileArray objectAtIndex:i];
        if (i % 28 == 0) {
            item2D  = [NSMutableArray arrayWithCapacity:28];
            [items addObject:item2D];
        }
        [item2D addObject:item];
    }
    
    //----------设置尺寸---------------
    self.width  =  items.count *ScreenWidth;
    self.height =  4 * item_height;
    
    //----------放大镜---------------
    magnifierView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 64, 92)];
    magnifierView.image = [UIImage imageNamed:@"emoticon_keyboard_magnifier.png"];
    magnifierView.hidden = YES;
    magnifierView.backgroundColor = [UIColor clearColor];
    [self addSubview:magnifierView];

    
    UIImageView *bigFace = [[UIImageView alloc]initWithFrame:CGRectMake((64-30)/2, 15, 30, 30)];
    bigFace.tag = 11111;
    bigFace.backgroundColor = [UIColor clearColor];
    [magnifierView addSubview:bigFace];
    
    
}

//画图
- (void)drawRect:(CGRect)rect {
    int row = 0,colum = 0;  //定义行、列
    for (int i = 0; i < items.count; i++) {
        NSArray *items2D = [items objectAtIndex:i];
        for (int j = 0; j < items2D.count; j++) {
            NSDictionary *item = [items2D objectAtIndex:j];
            NSString *emotionName   = [item objectForKey:@"png"];
            UIImage  *emotionImage  = [UIImage imageNamed:emotionName];
            CGRect   emotionFrame   = CGRectMake(colum*item_width + 15, row*item_height +15, 30, 30);
            
            //考虑页数，需要加上前面一页的宽度
            float x = (i*ScreenWidth) + emotionFrame.origin.x;
            emotionFrame.origin.x = x;
            
            [emotionImage drawInRect:emotionFrame];
            
            //更新列、行
            colum ++;
            if (colum % 7 == 0) {
                row ++;
                colum = 0;
            }
            if (row % 4 == 0) {
                row = 0;
            }
        }
    }
}




-(void)touchEmotion:(CGPoint)point{
    int page = point.x/ScreenWidth;//页数
    float x  = point.x - (page*ScreenWidth)-10;
    float y  = point.y- 10;
    
    int colum = x/ item_width;
    int row   = (y-11)/item_height;
    
    if (colum > 6) {
        colum = 6;
    }
    if (colum < 0) {
        colum = 0;
    }
    if (row > 3) {
        row =3;
    }
    if (row <0 ) {
        row = 0;
    }
    
    int index = colum +(row*7); //公式：计算每个表情的索引
    NSLog(@"%d",index);
    if (!(page == 3 && index > 19)) {
        NSArray *items2D = [items objectAtIndex:page];
        NSDictionary *item = [items2D objectAtIndex:index];
        NSString *emotionName = [item objectForKey:@"chs"];
        NSLog(@"%@",emotionName);
        
        magnifierView.hidden = NO;
        
        
        if (![self.selectedEmotion isEqualToString:emotionName] || self.selectedEmotion == nil) {
            NSString *faceName = [item objectForKey:@"png"];
            UIImageView *bigFace = (UIImageView *)[magnifierView viewWithTag:11111];
            bigFace.image = [UIImage imageNamed:faceName];
            self.selectedEmotion = emotionName;

            magnifierView.left = (page *ScreenWidth) + colum*item_width;
            magnifierView.bottom = row*item_height +30;
        }
    }
    
    
    
}

#pragma mark  - touch method
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point  = [touch locationInView:self];
    [self touchEmotion:point];
    NSLog(@"%@",NSStringFromCGPoint(point));
    

    //禁用DDMenu的滑动
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        scrollView.scrollEnabled = NO;
    }
    NSLog(@"self.window.rootViewController:%@", self.window.rootViewController);
    DDMenuController *vc = (DDMenuController *)self.window.rootViewController;
    [vc setEnableGesture:NO];

}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint point  = [touch locationInView:self];
    [self touchEmotion:point];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    magnifierView.hidden = YES;
    
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        scrollView.scrollEnabled = YES;
    }
    DDMenuController *vc = (DDMenuController *)self.window.rootViewController;
    [vc setEnableGesture:YES];
    
    if (self.block != nil) {
        self.block(self.selectedEmotion);
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    magnifierView.hidden = YES;
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        scrollView.scrollEnabled = YES;
    }
    DDMenuController *vc = (DDMenuController *)self.window.rootViewController;
    [vc setEnableGesture:YES];

}


@end




