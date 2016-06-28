//
//  LXSuspenditemManager.m
//  YiZhiChan
//
//  Created by wuyaju on 16/4/21.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXSuspenditemManager.h"
#import "LXSuspenditem.h"

@implementation LXSuspenditemManager

// 文件路径
#define LXSuspenditemManagerFilepath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"suspenditem.plist"]

/**
 *  读取存贮的可移动图标的排列顺序
 *
 *  @return 返回保存的可移动图标的排列顺序
 */
+ (NSArray *)suspenditems{
    // 读取存贮的可移动图标的排列顺序
    NSLog(@"%@", LXSuspenditemManagerFilepath);
    NSArray *suspenditemsArray = [NSKeyedUnarchiver unarchiveObjectWithFile:LXSuspenditemManagerFilepath];
    return suspenditemsArray;
}

/**
 *  保存可移动图标的排列顺序
 *
 *  @param suspenditemsArray 要保存的可移动图标的排列顺序
 *
 *  @return true：保存成功 false：保存失败
 */
+ (BOOL)saveSuspenditems:(NSArray *)suspenditemsArray{
    return [NSKeyedArchiver archiveRootObject:suspenditemsArray toFile:LXSuspenditemManagerFilepath];
}

@end
