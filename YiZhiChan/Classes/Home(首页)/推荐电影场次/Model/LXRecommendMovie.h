//
//  LXRecommendMovie.h
//  YiZhiChan
//
//  Created by wuyaju on 16/4/27.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXRecommendMovie : NSObject <NSCoding>
// 电影详情ID
@property (nonatomic, strong)NSNumber *movieInfoId;
// 电影名
@property (nonatomic, copy)NSString *movieName;
// 电影封面
@property (nonatomic, copy)NSString *cover;
// 评分
@property (nonatomic, copy)NSNumber *rating;
// 跳转的链接
@property (nonatomic, copy)NSString *url;

@end
