//
//  LXDidDownLoadList.h
//  AR下载任务
//
//  Created by wuyaju on 16/6/14.
//  Copyright © 2016年 lansum. All rights reserved.
//  本地已经下载的任务模型

#import <Foundation/Foundation.h>

@class LXWillDownLoadList;

@interface LXDidDownLoadList : NSObject

@property (nonatomic, copy)NSString *mpDownLoadPath;
@property (nonatomic, copy)NSString *mpDownloadUrlString;
@property (nonatomic, strong)NSNumber *mpDownloadState;
@property (nonatomic, strong)LXWillDownLoadList *mpDownloadExtra;

@end
