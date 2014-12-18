//
//  WebModalViewController.h
//  KittenYang
//
//  Created by Kitten Yang on 14/9/28.
//  Copyright (c) 2014年 Kitten Yang. All rights reserved.
//

#import "BaseViewController.h"

@interface WebModalViewController : BaseViewController<UIWebViewDelegate>{
    NSString *_url;
}

@property (strong, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)goBack:(id)sender;
- (IBAction)refresh:(id)sender;
- (IBAction)goForward:(id)sender;


- (id)initWithURL:(NSString *)url;

@end
