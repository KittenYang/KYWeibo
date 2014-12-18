//
//  SendViewController.h
//  KittenYang
//
//  Created by Kitten Yang on 14/10/4.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "BaseViewController.h"
#import "EmotionScrollView.h"

@interface SendViewController : BaseViewController<WBHttpRequestDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate>{
    NSMutableArray *buttons;
    UIImageView *fullImageView;
    EmotionScrollView *emotionScrollView;
}


@property (nonatomic,copy)NSString * longitude;
@property (nonatomic,copy)NSString * latitude;
@property (nonatomic,retain)UIImage  *sendImage;

@property (nonatomic,retain)UIButton *sendImageButton;

@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIView *editBar;
@property (strong, nonatomic) IBOutlet UIView *placeView;
@property (strong, nonatomic) IBOutlet UIImageView *placeImageView;
@property (strong, nonatomic) IBOutlet UILabel *placeLabel;

- (IBAction)btActions:(id)sender;

@end
