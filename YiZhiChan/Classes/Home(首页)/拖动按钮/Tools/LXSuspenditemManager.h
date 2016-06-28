//
//  LXSuspenditemManager.h
//  YiZhiChan
//
//  Created by wuyaju on 16/4/21.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXSuspenditemManager : NSObject

/**
 *  读取存贮的可移动图标的排列顺序
 *
 *  @return 返回保存的可移动图标的排列顺序
 */
+ (NSArray *)suspenditems;

/**
 *  保存可移动图标的排列顺序
 *
 *  @param suspenditemsArray 要保存的可移动图标的排列顺序
 *
 *  @return true：保存成功 false：保存失败
 */
+ (BOOL)saveSuspenditems:(NSArray *)suspenditemsArray;

@end
