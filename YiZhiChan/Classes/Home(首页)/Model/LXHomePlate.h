//
//  LXHomePlate.h
//  YiZhiChan
//
//  Created by wuyaju on 16/4/28.
//  Copyright © 2016年 吴亚举. All rights reserved.
//  首页板块模型

#import <Foundation/Foundation.h>

@interface LXHomePlate : NSObject <NSCoding>

// 板块类型
@property (nonatomic, copy)NSString *moduleType;
// 板块名字
@property (nonatomic, copy)NSString *moduleName;

@property (nonatomic, copy)NSString *imageUrl;

// 板块跳转的链接
@property (nonatomic, copy)NSString *url;

@property (nonatomic, copy)NSString *imageWidth;
@property (nonatomic, copy)NSString *imageHeight;

@end
