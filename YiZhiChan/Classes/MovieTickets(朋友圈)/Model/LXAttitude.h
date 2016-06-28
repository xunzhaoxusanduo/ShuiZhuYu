//
//  LXAttitude.h
//  YiZhiChan
//
//  Created by wuyaju on 16/5/25.
//  Copyright © 2016年 吴亚举. All rights reserved.
//  点赞模型

#import <Foundation/Foundation.h>

@interface LXAttitude : NSObject

// 当前点赞状态
@property (nonatomic, strong)NSNumber *currUserLike;
// 当前点赞数量
@property (nonatomic, strong)NSNumber *praiseCount;

@end
