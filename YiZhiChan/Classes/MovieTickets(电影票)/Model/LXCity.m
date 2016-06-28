//
//  LXCity.m
//  YiZhiChan
//
//  Created by wuyaju on 16/5/25.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXCity.h"
#import "MJExtension.h"
#import "LXRegion.h"

@implementation LXCity

- (NSDictionary *)objectClassInArray
{
    return @{@"districts" : [LXRegion class]};
}

@end
