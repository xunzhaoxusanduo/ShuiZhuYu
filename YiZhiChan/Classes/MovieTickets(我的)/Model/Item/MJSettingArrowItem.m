//
//  MJSettingArrowItem.m
//  00-ItcastLottery
//
//  Created by apple on 14-4-17.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MJSettingArrowItem.h"

@implementation MJSettingArrowItem

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destVcClass:(Class)destVcClass isNeedLogin:(BOOL)isNeedLogin urlStr:(NSString *)urlStr
{
    MJSettingArrowItem *item = [self itemWithIcon:icon title:title];
    item.destVcClass = destVcClass;
    item.urlStr = [urlStr copy];
    item.isNeedLogin = isNeedLogin;
    return item;
}

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destVcClass:(Class)destVcClass isNeedLogin:(BOOL)isNeedLogin;
{
    MJSettingArrowItem *item = [self itemWithIcon:icon title:title];
    item.destVcClass = destVcClass;
    item.isNeedLogin = isNeedLogin;
    return item;
}

+ (instancetype)itemWithTitle:(NSString *)title destVcClass:(Class)destVcClass isNeedLogin:(BOOL)isNeedLogin;
{
    return [self itemWithIcon:nil title:title destVcClass:destVcClass isNeedLogin:isNeedLogin];
}
@end
