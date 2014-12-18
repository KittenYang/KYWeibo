//
//  SendViewController.m
//  KittenYang
//
//  Created by Kitten Yang on 14/10/4.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "SendViewController.h"
#import "NearbyViewController.h"
#import "BaseNavigationController.h"

@interface SendViewController ()

@end

@implementation SendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    //显示键盘
    [_textView becomeFirstResponder];
//    [self showKeyboardView];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"发微博";
    buttons = [[NSMutableArray alloc]initWithCapacity:6];
    
    UIButton *cancel = [UIFactory createNavigationButton:CGRectMake(0, 0, 45, 30) title:@"取消" target:self action:@selector(cancelAction)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithCustomView:cancel];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIButton *send = [UIFactory createNavigationButton:CGRectMake(0, 0, 45, 30) title:@"发布" target:self action:@selector(sendAction)];
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc]initWithCustomView:send];
    self.navigationItem.rightBarButtonItem = sendButton;

    
    [self _initViews];
}

- (void)_initViews{
    

    self.textView.delegate = self;
    UIImage *image = [self.placeImageView.image stretchableImageWithLeftCapWidth:30 topCapHeight:0];
    [self.placeImageView setImage:image];
    
    self.placeLabel.left = 35;
    self.placeLabel.width = 120;
    
/*
//    NSArray *imgArray = [NSArray arrayWithObjects:
//                         @"compose_locatebutton_background.png",
//                         @"compose_camerabutton_background.png",
//                         @"compose_trendbutton_background.png",
//                         @"compose_mentionbutton_background.png",
//                         @"compose_emoticonbutton_background.png",
//                         @"compose_keyboardbutton_background.png",
//                         nil];
//    NSArray *imgArrayHigh = [NSArray arrayWithObjects:
//                         @"compose_locatebutton_background_highlighted.png",
//                         @"compose_camerabutton_background_highlighted.png",
//                         @"compose_trendbutton_background_highlighted.png",
//                         @"compose_mentionbutton_background_highlighted.png",
//                         @"compose_emoticonbutton_background_highlighted.png",
//                         @"compose_keyboardbutton_background_highlighted.png",
//                         nil];
 
//    for (int i = 0; i < 6; i++) {
//        int xx = 20.5+(41+23)*i;
//        UIButton *bt = [[UIButton alloc]initWithFrame:CGRectMake(xx, 10, 23, 19)];
//        [bt setImage:[UIImage imageNamed:[imgArray objectAtIndex:i]] forState:UIControlStateNormal];
//        [bt setImage:[UIImage imageNamed:[imgArrayHigh objectAtIndex:i]] forState:UIControlStateHighlighted];
//        bt.tag = (10+i);
//        [bt addTarget:self action:@selector(btAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self.editBar addSubview:bt];
//        [buttons addObject:bt];
//        
//        if (i == 5) {
//            bt.hidden = YES;
//            bt.left -= 64;
//        }
//    }
   */
}

#pragma mark - 使用地理位置
-(void)location{
    NearbyViewController *nearCtrl = [[NearbyViewController alloc]init];
    BaseNavigationController *nearNav = [[BaseNavigationController alloc]initWithRootViewController:nearCtrl];
    [self presentViewController:nearNav animated:YES completion:nil];

    nearCtrl.selectBlock = ^(NSDictionary *result){
        NSLog(@"%@",result);
        self.longitude = [result objectForKey:@"lon"];
        self.latitude  = [result objectForKey:@"lat"];
        
        NSString *address = [result objectForKey:@"address"];
        if ([address isKindOfClass:[NSNull class]] || address.length == 0) {
            address = [result objectForKey:@"title"];
        }
        self.placeLabel.text = address;
        self.placeLabel.textAlignment = NSTextAlignmentCenter;
        self.placeView.hidden = NO;
        
        UIButton *locationButton = (UIButton *)[self.editBar viewWithTag:10];
        locationButton.selected = YES;
        
    };

}

#pragma mark - 使用相册
-(void)selectImage{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"用户相册",nil];
    [actionSheet showInView:self.view];
}


#pragma mark - 使用表情
- (void)showEmotionView{
    [_textView resignFirstResponder];
    if (emotionScrollView == nil) {
        __block SendViewController *this = self;
        emotionScrollView = [[EmotionScrollView alloc]initWithSelectBlock:^(NSString *emotionName) {
            NSString *text = this.textView.text;
            text = [text stringByAppendingString:emotionName];
            this.textView.text = text;
            
        }];
        emotionScrollView.bottom = ScreenHeight;
        emotionScrollView.transform = CGAffineTransformTranslate(emotionScrollView.transform, 0, ScreenHeight-self.editBar.bottom);
        [self.view addSubview:emotionScrollView];
    }
    
    UIButton *emotionButton  = (UIButton *)[self.editBar viewWithTag:14];
    UIButton *keyboardButton = (UIButton *)[self.editBar viewWithTag:15];
    emotionButton.alpha  = 1;
    keyboardButton.alpha = 0;
    keyboardButton.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.editBar.transform = CGAffineTransformTranslate(self.editBar.transform, 0, (ScreenHeight-self.editBar.bottom)-emotionScrollView.height);
        emotionScrollView.transform = CGAffineTransformIdentity;
        emotionButton.alpha = 0;
        emotionButton.selected = NO;
        keyboardButton.alpha = 1;
        emotionButton.hidden  = YES;
    }];
}


#pragma mark -  使用键盘
- (void)showKeyboardView{
    [_textView becomeFirstResponder];
    UIButton *emoitonButton  = (UIButton *)[self.editBar viewWithTag:14];
    UIButton *keyboardButton = (UIButton *)[self.editBar viewWithTag:15];
    [UIView animateWithDuration:0.2 animations:^{
        emotionScrollView.transform = CGAffineTransformTranslate(emotionScrollView.transform, 0, ScreenHeight- self.editBar.bottom);
        self.editBar.transform = CGAffineTransformIdentity;
        emoitonButton.hidden     = NO;
        emoitonButton.alpha      = 1;
        keyboardButton.hidden    = YES;
    }];
}

#pragma mark -  action
-(void)cancelAction{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


-(void)sendAction{
    [self doSendData];
    [self performSelector:@selector(cancelAction) withObject:nil afterDelay:1.0];
}

- (IBAction)btActions:(UIButton *)sender {
    if (sender.tag == 10) {
        //地理位置
        [self location];
        
    }else if(sender.tag == 11){
        //图片
        [self selectImage];
        
    }else if(sender.tag == 12){
        
    }else if(sender.tag == 13){
        
    }else if(sender.tag == 14){
        //表情
        [self showEmotionView];
    }else if(sender.tag == 15){
        //键盘
        [self showKeyboardView];
    }
}

- (void)imageAction:(UIButton *)button{
    if (fullImageView == nil) {
        fullImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        fullImageView.backgroundColor = [UIColor blackColor];
        fullImageView.userInteractionEnabled = YES;
        fullImageView.contentMode = UIViewContentModeScaleAspectFit;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scaleImageAction:)];
        [fullImageView addGestureRecognizer:tap];
        
        //创建删除按钮
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteButton setImage:[UIImage imageNamed:@"trash.png"] forState:UIControlStateNormal];
        deleteButton.frame = CGRectMake(ScreenWidth - 50, 10, 50,50);
        deleteButton.tag = 100;
        [deleteButton setShowsTouchWhenHighlighted:YES];
        deleteButton.hidden = YES;
        [deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        [fullImageView addSubview:deleteButton];
    }
    
    [self.textView resignFirstResponder];
    if (![fullImageView superview]) {
        fullImageView.image = self.sendImage;
        [self.view.window addSubview:fullImageView];
        
        fullImageView.frame = CGRectMake(self.sendImageButton.left, self.editBar.top+self.editBar.height/2-self.sendImageButton.height/2, 25, 25);
        [UIView animateWithDuration:0.4 animations:^{
            fullImageView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        }completion:^(BOOL finished){
            [UIApplication sharedApplication].statusBarHidden = YES;
            UIButton *deleteButton = (UIButton *)[fullImageView viewWithTag:100];
            deleteButton.hidden = NO;
            
        }];
    }
}

- (void)scaleImageAction:(UITapGestureRecognizer *)tap{
    [fullImageView viewWithTag:100].hidden = YES;
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIView animateWithDuration:0.4 animations:^{
        fullImageView.frame = CGRectMake(self.sendImageButton.left, self.editBar.top+self.editBar.height/2-self.sendImageButton.height/2, 25, 25);
    }completion:^(BOOL finished){
        [fullImageView removeFromSuperview];
    }];
    
    [self.textView becomeFirstResponder];
    
}
//取消图片选择
- (void)deleteAction:(UIButton *)button{
    [self scaleImageAction:nil];
    button.hidden = YES;
    [self.sendImageButton removeFromSuperview];
    self.sendImage = nil;
    UIButton *button1 = (UIButton *)[self.editBar viewWithTag:10];
    UIButton *button2 = (UIButton *)[self.editBar viewWithTag:11];
    [UIView animateWithDuration:0.5 animations:^{
        //为什么用transform？因为可以快速恢复回去，非常方便
        button1.transform = CGAffineTransformIdentity;
        button2.transform = CGAffineTransformIdentity;
    }];
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerControllerSourceType soureType;
    
    if (buttonIndex == 0) {
        BOOL isCameraDeviceAvailable = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!isCameraDeviceAvailable) {
            UIAlertView  *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"没有摄像头哦" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            [alertView show];
            return;
        }
        //拍照
        soureType = UIImagePickerControllerSourceTypeCamera;
    }else if(buttonIndex == 1){
        //用户相册
        soureType = UIImagePickerControllerSourceTypePhotoLibrary;
        
    }else if(buttonIndex == 2){
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.sourceType = soureType;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIImagePickerControllerDelegate
//这个方法是选择了一张相片之后调用或拍了一张照片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.sendImage = image;
    
    if (self.sendImageButton == nil) {
        UIButton *button  = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.cornerRadius  = 5;
        button.layer.masksToBounds = YES;
        button.frame = CGRectMake(8, (self.editBar.size.height-25)/2, 25, 25);
        [button addTarget:self action:@selector(imageAction:) forControlEvents:UIControlEventTouchUpInside];
        self.sendImageButton = button;
    }
    
    [self.sendImageButton setImage:image forState:UIControlStateNormal];
    [self.editBar addSubview:self.sendImageButton];
    UIButton *button1 = (UIButton *)[self.editBar viewWithTag:10];
    UIButton *button2 = (UIButton *)[self.editBar viewWithTag:11];
    [UIView animateWithDuration:0.5 animations:^{
        //为什么用transform？因为可以快速恢复回去，非常方便
        button1.transform = CGAffineTransformTranslate(button1.transform, 20, 0);
        button2.transform = CGAffineTransformTranslate(button2.transform, 5, 0);
    }];
    

    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - notification
-(void)keyboardShow:(NSNotification *)notification{
    NSValue *keyboardValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect frame = [keyboardValue CGRectValue];
    float keyBoardHeight = frame.size.height;
    
    self.editBar.bottom  = ScreenHeight-keyBoardHeight; //减去状态栏和导航栏的高度
    self.textView.height = self.editBar.top;
}

- (void)doSendData{
    
    [super showStatusTip:YES title:@"发送中..."];
    
    NSString *weiboText = self.textView.text;
    if (weiboText.length == 0) {
        NSLog(@"微博内容为空");
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:weiboText forKey:@"status"];
    if (self.longitude.length > 0) {
        [params setObject:self.longitude forKey:@"long"];
    }
    
    if (self.latitude.length > 0) {
        [params setObject:self.latitude forKey:@"lat"];
    }
    
    if (self.sendImage == nil) {
        //不带图的微博
        [WBHttpRequest requestWithAccessToken:[self getToken] url:WB_postWeibo httpMethod:@"POST" params:params delegate:self withTag:@"postWeibo"];
    }else{
        //带图的微博
        NSData *data = UIImageJPEGRepresentation(self.sendImage, 1  );
        [params setObject:data forKey:@"pic"];

        [WBHttpRequest requestWithAccessToken:[self getToken] url:WB_postWeiboWithPic httpMethod:@"POST" params:params delegate:self withTag:@"postWeiboWithPic"];
    }
    
    [super performSelector:@selector(multipleValue:) withObject:[NSArray arrayWithObjects:@"NO",@"发送成功",nil] afterDelay:1.5];

}


- (NSString *)getToken
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"WeiboAuthData"] objectForKey:@"accessToken"];
}

#pragma mark -  UITextViewDelegte 
//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
//    [self showKeyboardView];
//    return YES;
//}




@end
