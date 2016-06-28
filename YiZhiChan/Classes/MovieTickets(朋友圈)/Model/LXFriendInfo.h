//
//  LXFriendInfo.h
//  YiZhiChan
//
//  Created by wuyaju on 16/5/21.
//  Copyright © 2016年 吴亚举. All rights reserved.
//  每条动态对应的用户信息

#import <Foundation/Foundation.h>

@interface LXFriendInfo : NSObject

// 用户头像
@property (nonatomic, copy)NSString *userImg;
// 用户ID
@property (nonatomic, strong)NSNumber *userId;
// 用户昵称
@property (nonatomic, copy)NSString *userName;
// 等级
@property (nonatomic, strong)NSNumber *level;
// 动态数
@property (nonatomic, strong)NSNumber *dtCount;
// 关注数
@property (nonatomic, strong)NSNumber *gzCount;
// 粉丝数
@property (nonatomic, strong)NSNumber *fsCount;

@end
