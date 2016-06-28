//
//  LXUserInfo.h
//  YiZhiChan
//
//  Created by wuyaju on 16/5/18.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LXUserInfo : NSObject

@property (nonatomic, strong)NSNumber *userId;

+ (LXUserInfo *)user;
- (id)updateByCookieWithURL:(NSString *) url;

// 朋友圈是否加载新的数据的标志
@property (nonatomic, assign)BOOL shouldLoadNewData;

/**
 *  判断当前是否登录
 *
 *
 *  @return YES：已登录     NO：未登录
 */
- (BOOL)isLogin;

/**
 *  判断当前是否登录
 *
 *  @param viewController 当前所在的控制器
 *
 *  @return YES：已登录     NO：未登录
 */
- (BOOL)isLogin:(UIViewController *)viewController;

@end
