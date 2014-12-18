//
//  CommentCell.h
//  KittenYang
//
//  Created by Kitten Yang on 14-8-12.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
#import "CommentModel.h"

@interface CommentCell : UITableViewCell<RTLabelDelegate>{
    UIImageView *_userImageView;
    UILabel     *_nickLabel;
    UILabel     *_timeLabel;
    RTLabel     *_contentLabel;
    
}


@property(nonatomic,retain)CommentModel *commentModel;

//计算评论单元格的高度
+(float)getCommentHeight:(CommentModel *)commentModel;

@end
