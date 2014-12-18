//
//  CommentTableView.m
//  KittenYang
//
//  Created by Kitten Yang on 14-8-12.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//


#import "CommentTableView.h"
#import "CommentCell.h"

@implementation CommentTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {

    }
    return self;
}

#pragma mark - TableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    static NSString *identify = @"commentCell";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CommentCell" owner:self options:nil]lastObject];
    }
    
    CommentModel *commmentModel = [self.data objectAtIndex:indexPath.row];
    cell.commentModel = commmentModel;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentModel *commmentModel = [self.data objectAtIndex:indexPath.row];
    float h = [CommentCell getCommentHeight:commmentModel];
    return h + 42;
}

//tableView顶部不会滑下去的view
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, 40)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *commentCount = [[UILabel alloc]initWithFrame:CGRectMake(10,10, 100, 20)];
    commentCount.backgroundColor = [UIColor clearColor];
    commentCount.font = [UIFont boldSystemFontOfSize:16.0f];
    commentCount.textColor = [UIColor blueColor];
    
 

    commentCount.text = [NSString stringWithFormat:@"评论数:%@",_totalCommentNumber];
    [view addSubview:commentCount];
    
    return view;
    
}

//
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0f;
}


//选中评论cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
@end
