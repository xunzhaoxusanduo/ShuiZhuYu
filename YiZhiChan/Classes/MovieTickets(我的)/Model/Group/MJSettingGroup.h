//
//  MJSettingGroup.h
//  00-ItcastLottery
//
//  Created by apple on 14-4-17.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJSettingGroup : NSObject
/**
 *  头部标题
 */
@property (nonatomic, copy) NSString *header;
/**
 *  尾部标题
 */
@property (nonatomic, copy) NSString *footer;
/**
 *  存放着这组所有行的模型数据(这个数组中都是MJSettingItem对象)
 */
@property (nonatomic, strong) NSArray *items;
@end
