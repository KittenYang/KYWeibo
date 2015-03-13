//
//  WeiboView.m
//  KittenYang
//
//  Created by Kitten Yang on 14-7-22.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "WeiboView.h"
#import "UIFactory.h"
#import "WeiboModel.h"
#import "UIImageView+WebCache.h"
#import "NSString+URLEncoding.h"
#import "UIUtils.h"
#import "ZFModalTransitionAnimator.h"
#import "ProfileModalViewController.h"

#import "WeiboCell.h"

@interface WeiboView ()
@property (nonatomic, strong) ZFModalTransitionAnimator *animator;

@end


#define LIST_FONT  16.0f
#define LIST_REPOST_FONT 15.0f
#define DETAIL_FONT  16.0f
#define DETAIL_REPOST_FONT  15.0f


@implementation WeiboView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initView];
        _parseText = [NSMutableString string];
    }
    return self;
}


//初始化子视图,一共四个子视图: *_textLabel;*_image; *_repostBackgroundView;*repostView;

- (void)_initView{
    


    _textLabel = [[RTLabel alloc]initWithFrame:CGRectZero];
    _textLabel.delegate = self;
    _textLabel.font  = [UIFont systemFontOfSize:14.0f];

    //超链接颜色
    _textLabel.linkAttributes = [NSDictionary dictionaryWithObject:@"blue" forKey:@"color"];
    //用三色值设置，如用r:69  g:119  b:203，但是要转换成16进制
//    _textLabel.linkAttributes = [NSDictionary dictionaryWithObject:@"#3471BC" forKey:@"color"];
    
    //高亮颜色
    _textLabel.selectedLinkAttributes = [NSDictionary dictionaryWithObject:@"darkGray" forKey:@"color"];
    [self addSubview:_textLabel];
    
    
    //微博图片
    _image = [[UIImageView alloc] initWithFrame:CGRectZero];
    _image.image = [UIImage imageNamed:@"page_image_loading.png"];
    //设置图片的内容显示模式：等比例缩/放（不会被拉伸或压缩）
    _image.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_image];
    
    
    //转发微博背景
    _repostBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"timeline_retweet_background.png" ]];
    //第一个是左边不拉伸区域的宽度   第二个是上面不拉伸区域的宽度
    UIImage *image = [_repostBackgroundView.image stretchableImageWithLeftCapWidth:25 topCapHeight:10];
    _repostBackgroundView.image = image;
    _repostBackgroundView.backgroundColor = [UIColor clearColor];
    //把_repostBackgroundView插入到最下面
    [self insertSubview:_repostBackgroundView atIndex:0];
    
}


//重写weibomodel 的设置器 判断是否为转发
//如果在 weiboview 的init中创建转发视图将会死循环
- (void)setWeiboModel:(WeiboModel *)weiboModel{
    if (_weiboModel != weiboModel) {
        _weiboModel = weiboModel;
    }
    
    //创建转发源微博视图
    if (_repostView == nil) {
        _repostView = [[WeiboView alloc]initWithFrame:CGRectZero];
        _repostView.isRepost = YES;
        _repostView.isDetail = self.isDetail;
        [self addSubview:_repostView];
    }
    
    [self parseLink];
}

//正则表达式的解析
- (void)parseLink{
    
    [_parseText setString:@""];
    //判断当前是否为转发微博
    if (_isRepost){
        //将原微博作者拼接
        NSString *nickName =  _weiboModel.user.screen_name;
        NSString *encodeName = [nickName URLEncodedString];
        [_parseText appendFormat:@"<a href='user://%@'>@%@</a>:",encodeName,nickName];
    }
    NSString *text = _weiboModel.text;
    text = [UIUtils parseLink:text];
    
    
    [_parseText appendString:text];
    
}

//layoutSubviews 展示数据、设置子视图布局
//layoutSubviews 可能会被调用多次，所以不能在这里进行正则表达式的解析
- (void)layoutSubviews{
    [super layoutSubviews];
    
    //----------------------------微博内容----------------------------------
    //获取字体大小
    _textLabel.frame = CGRectMake(2, 0 , self.width-10, 20);
    float fontSize = [WeiboView getFontSize:self.isDetail isRepost:self.isRepost];
    _textLabel.font = [UIFont systemFontOfSize:fontSize];
    //判断当前视图是否为转发视图
    if (self.isRepost ) {
        _textLabel.frame = CGRectMake(10, 12, self.width - 20, 0);
    }
    
    _textLabel.text = _parseText;
    //文本内容的尺寸
    CGSize textSize = _textLabel.optimumSize;
    _textLabel.height = textSize.height;
    
    
    //--------------------------转发的微博视图--------------------------------
    //转发的微博model
    WeiboModel *repostWeibo = _weiboModel.relWeibo;
    if (repostWeibo) {
        _repostView.weiboModel = repostWeibo;

        //设置转发微博视图的frame
        float h = [WeiboView getWeiboViewHeight:repostWeibo isDetail:self.isDetail          isRepost:YES];
        //_textLabel.bottom是转发微博背景带着文字整体下移
        _repostView.frame = CGRectMake(0, _textLabel.bottom, self.width, h+2);
        _repostView.hidden = NO;
    }else{
        _repostView.hidden = YES;
    }
    
    
    //--------------------------微博图片视图--------------------------------
    if (self.isDetail) {
        NSString *bmiddleImage = _weiboModel.bmiddleImage;
        if (bmiddleImage != nil && ![@"" isEqualToString:bmiddleImage]){

            _image.hidden = NO;
            _image.frame  = CGRectMake(10, _textLabel.bottom+10, 280, 200);
            
            //加载网络图片
            [_image sd_setImageWithURL:[NSURL URLWithString:bmiddleImage]];

        }else{
            _image.hidden = YES;
        }
        
        
    }else{
        //图片浏览模式
        NSInteger mode = [[NSUserDefaults standardUserDefaults]integerForKey:kBrowseMode];
        if (mode == 0) {
            mode = SmallBrowseMode;
        }
        //小图浏览模式
        if (mode == SmallBrowseMode) {
            //缩略图
            NSString *thumbnailImage = _weiboModel.thumbnailImage;
            if (thumbnailImage != nil && ![@"" isEqualToString:thumbnailImage]){
                _image.hidden = NO;
                _image.frame  = CGRectMake(10, _textLabel.bottom+10, 70, 80);
                
                //加载网络图片
                [_image sd_setImageWithURL:[NSURL URLWithString:thumbnailImage]];
            }else{
                _image.hidden = YES;
            }
        }else if (mode == LargeBrowseMode){
        //大图浏览模式
            NSString *bmiddleImage = _weiboModel.bmiddleImage;
            if (bmiddleImage != nil && ![@"" isEqualToString:bmiddleImage]){
                _image.hidden = NO;
                _image.frame  = CGRectMake(10, _textLabel.bottom+10, self.width-20, 180);
                
                //加载网络图片
                [_image sd_setImageWithURL:[NSURL URLWithString:bmiddleImage]];
            }else{
                _image.hidden = YES;
            }
        }
    }
    
    

    //--------------------------转发视图背景--------------------------------
    if (self.isRepost ) {
        _repostBackgroundView.frame = self.bounds;
        _repostBackgroundView.hidden = NO;
    }else{
        _repostBackgroundView.hidden = YES;
    }
    
}


//--------------------------------计算高度--------------------------------------
+(CGFloat)getWeiboViewHeight:(WeiboModel *)weiboModel isDetail:(BOOL)isDetail  isRepost:(BOOL)isRepost{
    /**
     *  实现思路：分别计算每个子视图的高度，然后相加
     **/
    float height = 0;
    
    //-------------------------计算微博内容的高度--------------------------
    RTLabel *textLabel = [[RTLabel alloc]initWithFrame:CGRectZero];
    float fontSize = [WeiboView getFontSize:isDetail isRepost:isRepost];
    textLabel.font = [UIFont systemFontOfSize:fontSize];
    if (isDetail) { //是否是详情
        textLabel.width = kWeibo_width_Detail;
    }else{
        textLabel.width = kWeibo_width_List;
    }
    NSString *weiboText = nil;
    if (isRepost) {
        textLabel.width -= 20;
        //昵称
        NSString *nickName = weiboModel.user.screen_name;
        weiboText = [NSString stringWithFormat:@"%@:%@",nickName,weiboModel.text];
    }else{
        weiboText = weiboModel.text;
    }
    
    
    textLabel.text = weiboModel.text;
    height += textLabel.optimumSize.height;
    
    
    //-------------------------计算微博图片的高度--------------------------
    if (isDetail ) {
        NSString *bmiddleImage = weiboModel.bmiddleImage;
        if (bmiddleImage != nil && ![@"" isEqualToString:bmiddleImage]){
            height += (200+10);
        }
    }else{
        NSInteger mode = [[NSUserDefaults standardUserDefaults]integerForKey:kBrowseMode];
        if (mode == 0) {
            mode = SmallBrowseMode;
        }
        
        //小图浏览模式
        if (mode == SmallBrowseMode) {
            NSString *thumbnailImage = weiboModel.thumbnailImage;
            if (thumbnailImage != nil && ![@"" isEqualToString:thumbnailImage]){
                height += (80+10);
            }
        }else if(mode == LargeBrowseMode){
            NSString *bmiddleImage = weiboModel.bmiddleImage;
            if (bmiddleImage != nil && ![@"" isEqualToString:bmiddleImage]){
                height += (180+10);
            }
        }
        
    }
    

    //-------------------------转发微博的高度--------------------------
    WeiboModel *relWeibo = weiboModel.relWeibo;
    if (relWeibo != nil) {
        //微博视图的高度
        float repostHeight = [WeiboView getWeiboViewHeight:relWeibo isDetail:isDetail isRepost:YES];
        height += (repostHeight);
    }
    
    if (isRepost == YES){
        height += 32;
    }

    return height;
}



+(float)getFontSize:(BOOL)isDetail isRepost:(BOOL)isRepost{
    float fontSize = 14.0f;
    if (!isDetail && !isRepost) {
        return LIST_FONT;
    }else if(!isDetail && isRepost){
        return LIST_REPOST_FONT;
    }else if (isDetail && isRepost){
        return DETAIL_REPOST_FONT;
    }else if (isDetail && !isRepost){
        return DETAIL_FONT;
    }

    return fontSize;
    
}


#pragma mark  - RTLabel delegates
//点击高亮字体后的动作
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url{
    
    NSLog(@"%@",self.superview.superview);
    
    NSString *absoluteString = [url absoluteString];
    
    if ([absoluteString hasPrefix:@"user"]) {
        NSString *urlString = [url host];
        urlString = [urlString URLDecodedString];
        
        NSLog(@"%@",urlString);
        
        ProfileModalViewController *modalVC = [[ProfileModalViewController alloc]init];

        urlString = [urlString stringByReplacingOccurrencesOfString:@"@" withString:@""];
        
        modalVC.userName = urlString;

        
        if (self.superview.superview.tag == kModalView || self.superview.tag == kModalView) {

            //在详细页面点击
            modalVC.modalPresentationStyle = UIModalPresentationCustom;
            
            self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:modalVC];
            self.animator.dragable = YES;
            self.animator.direction = ZFModalTransitonDirectionRight;
            
            modalVC.transitioningDelegate = self.animator;
            
            [self.viewController presentViewController:modalVC animated:YES completion:nil];
            
        }else if(self.superview.superview.tag == kCellContentView || self.superview.tag == kCellContentView){
            
            //在首页点击
            [self.viewController.navigationController pushViewController:modalVC animated:YES];
        }
        
    }else if ([absoluteString hasPrefix:@"http"]){
        NSLog(@"%@",absoluteString);
        
        WebModalViewController *webView = [[WebModalViewController alloc]initWithURL:absoluteString];
        
        if (self.superview.superview.tag == kModalView || self.superview.tag == kModalView) {
            
            //在详细页面点击
            webView.modalPresentationStyle = UIModalPresentationCustom;
            
            self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:webView];
            self.animator.dragable = YES;
            self.animator.direction = ZFModalTransitonDirectionLeft;
            
            webView.transitioningDelegate = self.animator;
            
            [self.viewController presentViewController:webView animated:YES completion:nil];
            
        }else if(self.superview.superview.tag == kCellContentView || self.superview.tag == kCellContentView){
            
            //在首页点击
            [self.viewController.navigationController pushViewController:webView animated:YES];

        }
        
        
    }else if ([absoluteString hasPrefix:@"topic"]){
        NSString *urlString = [url host];
        urlString = [urlString URLDecodedString];
        NSLog(@"%@",urlString);
        
        

    }
}


@end
