//
//  MJSettingArrowItem.h
//  00-ItcastLottery
//
//  Created by apple on 14-4-17.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MJSettingItem.h"

//typedef enum {
//    MJSettingArrowItemVcShowTypePush,
//    MJSettingArrowItemVcShowTypeModal
//} MJSettingArrowItemVcShowType;

@interface MJSettingArrowItem : MJSettingItem
/**
 *  点击这行cell需要跳转的控制器
 */
@property (nonatomic, assign) Class destVcClass;

/**
 *  要跳转的控制器是否需要登录
 */
@property (nonatomic, assign)BOOL isNeedLogin;

/**
 *  要跳转控制器对应的链接
 */
@property (nonatomic, copy)NSString *urlStr;

//@property (nonatomic, assign)  MJSettingArrowItemVcShowType  vcShowType;

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destVcClass:(Class)destVcClass isNeedLogin:(BOOL)isNeedLogin;
+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destVcClass:(Class)destVcClass isNeedLogin:(BOOL)isNeedLogin urlStr:(NSString *)urlStr;
+ (instancetype)itemWithTitle:(NSString *)title destVcClass:(Class)destVcClass isNeedLogin:(BOOL)isNeedLogin;
@end
