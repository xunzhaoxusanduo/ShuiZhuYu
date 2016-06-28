//
//  LXFilmReview.h
//  YiZhiChan
//
//  Created by wuyaju on 16/5/22.
//  Copyright © 2016年 吴亚举. All rights reserved.
//  影评cell模型

#import "LXBaseFriend.h"

@class LXFilmInfo;

@interface LXFilmReview : LXBaseFriend

// 电影信息模型
@property (nonatomic, strong)LXFilmInfo *movieInfo;

@end
