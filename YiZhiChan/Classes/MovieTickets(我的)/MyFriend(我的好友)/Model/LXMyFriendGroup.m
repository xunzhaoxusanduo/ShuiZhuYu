//
//  LXMyFriendGroup.m
//  YiZhiChan
//
//  Created by wuyaju on 16/5/17.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXMyFriendGroup.h"
#import "MJExtension.h"
#import "LXMyFriend.h"

@implementation LXMyFriendGroup

- (NSDictionary *)objectClassInArray {
    return @{@"userList": [LXMyFriend class]};
}

@end
