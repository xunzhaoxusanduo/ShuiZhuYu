//
//  LXBaseFriend.h
//  YiZhiChan
//
//  Created by wuyaju on 16/5/21.
//  Copyright © 2016年 吴亚举. All rights reserved.
//  朋友圈动态模型基类

#import <Foundation/Foundation.h>

@class LXFriendInfo;

@interface LXBaseFriend : NSObject

// 动态类型
@property (nonatomic, copy)NSString *typeEn;
// 评论数
@property (nonatomic, strong)NSNumber *replyCount;
// 点赞数
@property (nonatomic, strong)NSNumber *praiseCount;
// 发表时间
@property (nonatomic, copy)NSString *addTime;
// 发表时间
@property (nonatomic, copy)NSString *formatAddTime;
// 发表的内容
@property (nonatomic, copy)NSString *content;
// 登录用户对于这条数据是否点赞
@property (nonatomic, strong)NSNumber *currUserLike;
// 
@property (nonatomic, strong)NSNumber *infoId;
//
@property (nonatomic, strong)NSNumber *commentId;
// 该条动态对应的评论链接
@property (nonatomic, copy)NSString *detailsUrl;
// 发表该动态的用户信息
@property (nonatomic, strong)LXFriendInfo *userInfo;

// 视频缩略图
@property (nonatomic, copy)NSString *poster;
// 视频长度
@property (nonatomic, copy)NSString *videoTime;

@end
