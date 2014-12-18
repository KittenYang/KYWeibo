//
//  UIFactory.h
//  KittenYang
//
//  Created by Kitten Yang on 14-5-23.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThemeButton.h"
#import "ThemeImageView.h"

@interface UIFactory : NSObject

+(ThemeButton *)createButton:(NSString *)imageName highlighted:(NSString *)highlightedName selected:(NSString *)selectedName;
+(ThemeButton *)createBkgButton:(NSString *)bkgImageName highlighted:(NSString *)bkgHighlightedName;
+(UIButton *)createNavigationButton:(CGRect)frame
                              title:(NSString *)title
                              target:(id)target
                              action:(SEL)selector;

+(ThemeImageView *)createImageView:(NSString *)imageName;

@end
