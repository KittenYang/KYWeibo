//
//  ModalViewController.h
//  KittenYang
//
//  Created by Kitten Yang on 14-8-10.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentTableView.h"
#import "WeiboModel.h"
#import "WeiboView.h"
#import "CommentModel.h"
#import "ProfileModalViewController.h"
#import "ZFModalTransitionAnimator.h"


@interface ModalViewController : UIViewController<WBHttpRequestDelegate,UITableViewEventDelegate>{
    WeiboView *_weiboView;

}
@property(nonatomic,copy)NSString *lastWeiboID;
@property (nonatomic,retain)NSMutableArray *comments;

@property(nonatomic,retain)WeiboModel *weiboModel;

@property (strong, nonatomic) IBOutlet CommentTableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *userBarView;

@property (strong, nonatomic) IBOutlet UIImageView *userImageView;

@property (strong, nonatomic) IBOutlet UILabel *nickLabel;

@property (nonatomic, strong) ZFModalTransitionAnimator *animator;

-(void)loadData;

@end
