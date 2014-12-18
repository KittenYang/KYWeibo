//
//  FriendTableView.m
//  KittenYang
//
//  Created by Kitten Yang on 14/11/2.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "FriendTableView.h"
#import "FriendTableViewCell.h"

@implementation FriendTableView
-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self != nil) {
        self.separatorStyle  = UITableViewCellSeparatorStyleNone;
    }
    
    return self;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"cell";
    FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[FriendTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSArray *array = [self.data objectAtIndex:indexPath.row];
    cell.data = array;
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
