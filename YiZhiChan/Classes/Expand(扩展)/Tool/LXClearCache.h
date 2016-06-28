//
//  LXClearCache.h
//  YiZhiChan
//
//  Created by wuyaju on 16/5/12.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXClearCache : NSObject

/**
 *  根据路径返回文件或者目录的文件大小
 *
 *  @param path 文件路径或者目录
 *
 *  @return 文件或者目录的文件大小
 */
+ (double)sizeWithFilePath:(NSString *)path;

/**
 *  删除指定目录或文件
 *
 */
+ (void)clearCachesWithFilePath:(NSString *)path;

/**
 *  清空指定目录下文件
 *
 */
+ (void)clearCachesFromDirectoryPath:(NSString *)path;

@end
