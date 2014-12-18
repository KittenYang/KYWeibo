//
//  RectButton.m
//  KittenYang
//
//  Created by Kitten Yang on 14-8-29.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "RectButton.h"

@implementation RectButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    if (_title != title) {
        _title = [title copy];
    }
    
    [self setTitle:nil forState:UIControlStateNormal];
    
    if (_rectTitleLabel == nil) {
        _rectTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, self.size.width, self.size.height/2)];
        _rectTitleLabel. backgroundColor = [UIColor clearColor];
        _rectTitleLabel.font = [UIFont systemFontOfSize:18.0f];
        _rectTitleLabel.textColor = [UIColor blackColor];
        _rectTitleLabel.textAlignment = NSTextAlignmentCenter;
        _rectTitleLabel.text = _title;
        [self addSubview:_rectTitleLabel];
    }
    
}


-(void) setSubtitle:(NSString *)subtitle{
    if (_subtitle != subtitle) {
        _subtitle = [subtitle copy];
    }
    if (_subTitleLabel == nil ) {
        _subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, self.size.width, self.size.height/2)];
        _subTitleLabel.backgroundColor = [UIColor clearColor];
        _subTitleLabel.font =[UIFont systemFontOfSize:14.0f];
        _subTitleLabel.textColor = [UIColor blackColor];
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel.text = _subtitle;
        [self addSubview:_subTitleLabel];
    }
}






@end
