//
//  LXWebViewController.h
//  YiZhiChan
//
//  Created by wuyaju on 16/4/29.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXBaseViewController.h"

#define LXCLoginCloseNotification @"LXCLoginCloseNotification"
#define LXWebViewLoginSuccessNotification @"LXWebViewLoginSuccessNotification"
#define LXWebViewLogoutSuccessNotification @"LXWebViewLogoutSuccessNotification"

@class WebViewJavascriptBridge;

@protocol LXWebViewControllerDelegate <NSObject>

@optional
- (void)myWebViewDidFinishLoad:(UIWebView *)webView;

@end

@interface LXWebViewController : LXBaseViewController

@property (nonatomic, strong)UIWebView *webView;
@property (nonatomic, strong)WebViewJavascriptBridge* bridge;
@property (nonatomic, copy)NSURL *url;
@property (nonatomic, weak)id<LXWebViewControllerDelegate> delegate;

- (instancetype)initWithUrl:(NSURL *)url;
/**
 *  重新加载网页
 */
- (void)reloadWebView;

@end
