//
//  LXShow.h
//  YiZhiChan
//
//  Created by wuyaju on 16/4/28.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXShow : NSObject <NSCoding>

// 标题
@property (nonatomic, copy)NSString *title;
// 海报图片
@property (nonatomic, copy)NSString *posterImageUrl;
// 点赞
@property (nonatomic, strong)NSNumber *attitude;
// 评论
@property (nonatomic, strong)NSNumber *comment;
// 跳转的链接
@property (nonatomic, copy)NSString *url;

@end
