//
//  LXFilmInfo.h
//  YiZhiChan
//
//  Created by wuyaju on 16/5/22.
//  Copyright © 2016年 吴亚举. All rights reserved.
//  影评cell对应的电影信息模型

#import <Foundation/Foundation.h>

@interface LXFilmInfo : NSObject

// 海报封面
@property (nonatomic, copy)NSString *cover;
// 电影名字
@property (nonatomic, copy)NSString *movieName;
// 导演名字
@property (nonatomic, copy)NSString *director;
// 评分
@property (nonatomic, strong)NSNumber *rating;
// 电影ID
@property (nonatomic, strong)NSNumber *movieInfoId;
// 电影简介
@property (nonatomic, copy)NSString *remarks;
// 电影详情对应的链接
@property (nonatomic, copy)NSString *movieDetailUrl;
// 电影类型
@property (nonatomic, copy)NSString *displayType;

@end
