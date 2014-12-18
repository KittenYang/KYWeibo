//
//  WebModalViewController.m
//  KittenYang
//
//  Created by Kitten Yang on 14/9/28.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "WebModalViewController.h"

@interface WebModalViewController ()

@end

@implementation WebModalViewController


-(id)initWithURL:(NSString *)url{
    self = [super init];
    if (self != nil) {
        _url = [url copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    _webView.scalesPageToFit = YES;
    NSURL *url = [NSURL URLWithString:_url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];

    
    self.title  =@"载入中...";
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;//显示状态栏的loading图标
    
}
- (IBAction)goBack:(id)sender {
    if ([_webView canGoBack]) {
        [_webView goBack];
    }
}

- (IBAction)refresh:(id)sender {
    [_webView reload];
}

- (IBAction)goForward:(id)sender {
    if ([_webView canGoForward]) {
        [_webView goForward];
    }
}



#pragma mark -  delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;//显示状态栏的loading图标
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];    //如何在nav上显示网站的title（执行js代码）
    self.title = title;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"网页加载失败");
}



@end





