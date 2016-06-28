//
//  LXMyFriend.m
//  YiZhiChan
//
//  Created by wuyaju on 16/5/16.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXMyFriend.h"
#import "NSString+Utils.h"

@implementation LXMyFriend

- (NSString *)nickNamePinYin {
    return [self.nickName pinyin];
}

@end
