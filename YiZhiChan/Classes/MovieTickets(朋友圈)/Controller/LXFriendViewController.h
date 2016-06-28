//
//  LXFriendViewController.h
//  YiZhiChan
//
//  Created by wuyaju on 16/4/30.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "RxWebViewController.h"
#import "LXBaseViewController.h"

@interface LXFriendViewController : LXBaseViewController

// 个人信息获取地址
@property (nonatomic, copy)NSString *friendInfoUrl;
// 动态数据获取地址
@property (nonatomic, copy)NSString *statusUrl;

@property (nonatomic, assign)NSInteger userId;

/**
 *  初始化控制器
 *
 *  @param friendInfoUrlStr 个人信息获取地址
 *  @param statusUrlStr     动态数据获取地址
 *
 */
- (instancetype)initWithFriendInfoUrl:(NSString *)friendInfoUrlStr userId:(NSInteger)userId statusUrl:(NSString *)statusUrlStr;

@end
