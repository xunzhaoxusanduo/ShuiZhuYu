//
//  LXSubTitleShow.h
//  YiZhiChan
//
//  Created by wuyaju on 16/5/30.
//  Copyright © 2016年 吴亚举. All rights reserved.
//  首页字幕秀模型

#import <Foundation/Foundation.h>

@interface LXSubTitleShow : NSObject <NSCoding>

// 海报图片
@property (nonatomic, copy)NSString *imageUrl;
// 点赞
@property (nonatomic, strong)NSNumber *praiseCount;
// 评论
@property (nonatomic, strong)NSNumber *commentCount;
// 跳转的链接
@property (nonatomic, copy)NSString *url;
// 字幕
@property (nonatomic, copy)NSString *subTitle;

@end
