//
//  CommentCell.m
//  KittenYang
//
//  Created by Kitten Yang on 14-8-12.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "CommentCell.h"
#import "UIImageView+WebCache.h"
#import "UIUtils.h"
#import "NSString+URLEncoding.h"
#import "ProfileModalViewController.h"
#import "ZFModalTransitionAnimator.h"

@interface CommentCell ()
@property (nonatomic, strong) ZFModalTransitionAnimator *animator;

@end
@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib{
    _userImageView = (UIImageView *)[self viewWithTag:100];
    _userImageView.backgroundColor = [UIColor clearColor];
    _userImageView.layer.cornerRadius = 15;     //圆弧半径
//    _userImageView.layer.borderWidth  = .5;   //加上这一句变成圆角矩形
    _userImageView.layer.borderColor  =[UIColor grayColor].CGColor;
    _userImageView.layer.masksToBounds = YES;  //超出部分裁剪掉

    
    //
    _nickLabel     = (UILabel *)[self viewWithTag:101];
    _timeLabel     = (UILabel *)[self viewWithTag:102];
    
    _contentLabel  = [[RTLabel alloc]initWithFrame:CGRectZero];
    _contentLabel.font = [UIFont systemFontOfSize:15.0f];
    _contentLabel.delegate = self;
    
    //超链接颜色
    _contentLabel.linkAttributes = [NSDictionary dictionaryWithObject:@"blue" forKey:@"color"];
    //高亮颜色
    _contentLabel.selectedLinkAttributes = [NSDictionary dictionaryWithObject:@"darkGray" forKey:@"color"];
    [self.contentView addSubview:_contentLabel];
}

- (void)layoutSubviews{
    [super layoutSubviews];

    //----------------
    _userImageView.frame = CGRectMake(10, 10, 30, 30);
    NSString *urlString = self.commentModel.user.profile_image_url;
    if (urlString != nil) {
        [_userImageView sd_setImageWithURL:[NSURL URLWithString:urlString]];
    }


    //---------------
    _nickLabel.text = self.commentModel.user.screen_name;
    
    //-------------
    NSString *createDate = self.commentModel.created_at;
    if (createDate != nil ) {
        _timeLabel.hidden = NO;
        NSString *dateString = [UIUtils fomateString:createDate];
        _timeLabel.text = dateString;
    }else{
        _timeLabel.hidden = YES;
    }
    
    //---------------
    _contentLabel.frame = CGRectMake(_userImageView.right + 10, _nickLabel.bottom + 5, 240, 21);
    NSString *commentText = self.commentModel.text;

    //正则表达式解析评论内容
    commentText = [UIUtils parseLink:commentText];
    _contentLabel.text = commentText;
    _contentLabel.height = _contentLabel.optimumSize.height + 1;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

#pragma mark - RTLabel delegate
//点击高亮字体后的动作
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url{
    
}


+(float)getCommentHeight:(CommentModel *)commentModel{
    RTLabel *rt = [[RTLabel alloc]initWithFrame:CGRectMake(0, 0, 240, 0)];
    rt.font = [UIFont systemFontOfSize:14.0f];
    rt.text = commentModel.text;
    
    return  rt.optimumSize.height + 3;
}



@end
