//
//  LXCookie.m
//  YiZhiChan
//
//  Created by wuyaju on 16/5/18.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXCookie.h"

@implementation LXCookie

+ (void)saveLoginSession {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSHTTPCookieStorage *shareCookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *allCookies = [shareCookies cookies];
    
    for (NSHTTPCookie *cookie in allCookies) {
        if ([cookie.name isEqualToString:LXCookieName]) {
            [defaults setObject:cookie.properties forKey:LXCookieName];
            [defaults synchronize];
            NSLog(@"saveLoginSession %@", [defaults objectForKey:LXCookieName]);
            break;
        }
    }
}

+ (void)updateSession {
    NSLog(@"-------------------------------updateSession");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSHTTPCookieStorage *shareCookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSDictionary *cookieProperties = [defaults objectForKey:LXCookieName];
    
    if ([shareCookies cookieAcceptPolicy] != NSHTTPCookieAcceptPolicyAlways) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    }
    
    if (cookieProperties != nil) {
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
        [shareCookies setCookie:cookie];
        NSLog(@"updateSession %@", cookie.properties);
    }
}

+ (void)removeLoginSession {
    [self deleteAllCookies];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:LXCookieName];
    [defaults synchronize];
}

+ (void)deleteAllCookies {
    NSHTTPCookieStorage *sharedHTTPCookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    NSArray *cookies = [sharedHTTPCookieStorage cookies];
    
    for (NSHTTPCookie *cookie in cookies) {
        [sharedHTTPCookieStorage deleteCookie:cookie];
        NSLog(@"deletedCookieName %@",[cookie name]);
    }
}

@end
