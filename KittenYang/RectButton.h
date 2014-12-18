//
//  RectButton.h
//  KittenYang
//
//  Created by Kitten Yang on 14-8-29.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RectButton : UIButton{
    UILabel *_rectTitleLabel;
    UILabel *_subTitleLabel;
}

@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *subtitle;


@end
