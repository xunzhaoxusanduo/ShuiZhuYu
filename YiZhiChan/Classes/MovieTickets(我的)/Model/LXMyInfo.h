//
//  LXMyInfo.h
//  YiZhiChan
//
//  Created by wuyaju on 16/5/16.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXMyInfo : NSObject

// 封面的URL
@property (nonatomic, copy)NSString *cover;
// 头像的URL
@property (nonatomic, copy)NSString *iconUrl;
//  昵称
@property (nonatomic, copy)NSString *nickName;
// 性别   1：男性    0：女性
@property (nonatomic, assign)NSNumber *sex;
// 等级
@property (nonatomic, assign)NSNumber *level;
// 经验值
@property (nonatomic, assign)NSNumber *experience;
// 要达到下一级的经验值
@property (nonatomic, assign)NSNumber *nextExperience;
// 积分值
@property (nonatomic, assign)NSNumber *points;
// 积分值查看对应的链接
@property (nonatomic, copy)NSString *pointUrl;
// 动态数
@property (nonatomic, assign)NSNumber *dynamics;
// 粉丝数
@property (nonatomic, assign)NSNumber *fans;
// 关注数
@property (nonatomic, assign)NSNumber *follows;
// 背景图片链接
@property (nonatomic, copy)NSString *bgImage;

@end
