//
//  FriendTableViewCell.m
//  KittenYang
//
//  Created by Kitten Yang on 14/11/2.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "FriendTableViewCell.h"
#import "UserGridView.h"
#import "UserModel.h"

@implementation FriendTableViewCell

- (void)awakeFromNib {
    
}

- (void)setData:(NSArray *)data{
    if (_data != data) {
        _data  = data;
    }
    
    
    for (int i =  0; i < 3; i++) {
        int tag = 2010+i;
        UserGridView *userGridView = (UserGridView *)[self.contentView viewWithTag:tag];
        userGridView.hidden = YES;
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    for (int i = 0; i<self.data.count; i++) {
        UserModel *userModel = [self.data objectAtIndex:i];
        int tag = 2010+i;
        UserGridView *gridView = (UserGridView *)[self.contentView viewWithTag:tag];
        
        gridView.userModel = userModel;
        gridView.hidden = NO;
        
        //让GridView 异步调用layoutSubViews
        [gridView setNeedsLayout];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
