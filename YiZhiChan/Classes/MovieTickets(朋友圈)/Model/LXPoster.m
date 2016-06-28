//
//  LXPoster.m
//  YiZhiChan
//
//  Created by wuyaju on 16/5/21.
//  Copyright © 2016年 吴亚举. All rights reserved.
//  海报秀/海报秀模型

#import "LXPoster.h"
#import "MJExtension.h"
#import "LXFriendPhoto.h"

@implementation LXPoster

- (NSDictionary *)objectClassInArray
{
    return @{@"files" : [LXFriendPhoto class]};
}

@end
