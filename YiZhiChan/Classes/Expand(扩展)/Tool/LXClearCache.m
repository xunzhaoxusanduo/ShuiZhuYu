//
//  LXClearCache.m
//  YiZhiChan
//
//  Created by wuyaju on 16/5/12.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXClearCache.h"
#import "UIImageView+WebCache.h"

@implementation LXClearCache

/**
 *  根据路径返回文件或者目录的文件大小
 *
 *  @param path 文件路径或者目录
 *
 *  @return 文件或者目录的文件大小
 */
+ (double)sizeWithFilePath:(NSString *)path {
    // 文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    // 是否为文件夹
    BOOL isDirectory = NO;
    // 这个路径是否存在
    BOOL exists = [mgr fileExistsAtPath:path isDirectory:&isDirectory];
    // 路径不存在
    if (exists == NO) return 0;
    
    if (isDirectory) { // 文件夹
        // 总大小
        NSInteger size = 0;
        // 获得文件夹中的所有内容
        NSDirectoryEnumerator *enumerator = [mgr enumeratorAtPath:path];
        for (NSString *subpath in enumerator) {
            // 获得全路径
            NSString *fullSubpath = [path stringByAppendingPathComponent:subpath];
            // 获得文件属性
            size += [mgr attributesOfItemAtPath:fullSubpath error:nil].fileSize;
        }
        return size + [[SDImageCache sharedImageCache] getSize];
    } else { // 文件
        return [mgr attributesOfItemAtPath:path error:nil].fileSize + [[SDImageCache sharedImageCache] getSize];
    }
}

/**
 *  删除指定目录或文件
 *
 */
+ (void)clearCachesWithFilePath:(NSString *)path{
    NSFileManager *mgr = [NSFileManager defaultManager];
    [mgr removeItemAtPath:path error:nil];
}

/**
 *  清空指定目录下文件
 *
 */
+ (void)clearCachesFromDirectoryPath:(NSString *)path{
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    
    [[[SDWebImageManager sharedManager] imageCache] clearDisk];
}

@end
