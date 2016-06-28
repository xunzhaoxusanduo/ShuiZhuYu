//
//  LXCookie.h
//  YiZhiChan
//
//  Created by wuyaju on 16/5/18.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LXCookieName    @"UserInfo"

@interface LXCookie : NSObject

+ (void)saveLoginSession;
+ (void)updateSession;
+ (void)removeLoginSession;

@end
