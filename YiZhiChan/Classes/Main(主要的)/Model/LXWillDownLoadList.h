//
//  LXWillDownLoadList.h
//  AR下载任务
//
//  Created by wuyaju on 16/6/14.
//  Copyright © 2016年 lansum. All rights reserved.
//  将要下载的任务模型

#import <Foundation/Foundation.h>

@interface LXWillDownLoadList : NSObject

@property (nonatomic, copy)NSString *imageUrl;
@property (nonatomic, copy)NSString *actionUrl;
@property (nonatomic, strong)NSNumber *actionType;
@property (nonatomic, assign)NSNumber *x;
@property (nonatomic, assign)NSNumber *y;
@property (nonatomic, assign)NSNumber *z;

@end
