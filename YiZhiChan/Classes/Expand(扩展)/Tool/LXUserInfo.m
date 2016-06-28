//
//  LXUserInfo.m
//  YiZhiChan
//
//  Created by wuyaju on 16/5/18.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXUserInfo.h"
#import "LXCookie.h"
#import "LXWebViewController.h"
#import "LXBaseNavigationController.h"
#import "Macros.h"

@implementation LXUserInfo

+ (LXUserInfo *)user {
    static LXUserInfo *user;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[LXUserInfo alloc]init];
    });
    return user;
}

- (id)updateByCookieWithURL:(NSString *) url{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *cookieProperties = [defaults objectForKey:LXCookieName];
    if (cookieProperties) {
        NSString *userInfoStr=[cookieProperties[@"Value"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData *userInfoJsonData = [userInfoStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *userInfoDict = [NSJSONSerialization JSONObjectWithData:userInfoJsonData options: NSJSONReadingMutableLeaves error:nil];
        self.userId = userInfoDict[@"userId"];
        return self;
    }else {
        return nil;
    }
}

/**
 *  判断当前是否登录
 *
 *
 *  @return YES：已登录     NO：未登录
 */
- (BOOL)isLogin {
    if ([self updateByCookieWithURL:nil]) {
        return YES;
    }else {
        return NO;
    }
}

/**
 *  判断当前是否登录
 *
 *  @param viewController 当前所在的控制器
 *
 *  @return YES：已登录     NO：未登录
 */
- (BOOL)isLogin:(UIViewController *)viewController {
    if ([self updateByCookieWithURL:nil]) {
        return YES;
    }else {
        // 调用登录页面
        LXWebViewController* webViewController = [[LXWebViewController alloc] initWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/fashhtml/form/phoneLogin.html?navbarstyle=0", LXBaseUrl]]];
        LXBaseNavigationController *nav = [[LXBaseNavigationController alloc] initWithRootViewController:webViewController];
        [viewController presentViewController:nav animated:YES completion:nil];
        
        return NO;
    }
}

@end
