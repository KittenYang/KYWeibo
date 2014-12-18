//
//  UIView+Extra.m
//  KittenYang
//
//  Created by Kitten Yang on 14-8-26.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "UIView+Extra.h"

@implementation UIView (Extra)

- (UIViewController *)viewController{

    //下一个响应者
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return  (UIViewController *)next;
        }else{
            next = [next nextResponder];
        }
    } while (next != nil);
    
    
    return nil;
}

@end
