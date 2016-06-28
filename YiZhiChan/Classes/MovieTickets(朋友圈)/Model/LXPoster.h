//
//  LXPoster.h
//  YiZhiChan
//
//  Created by wuyaju on 16/5/21.
//  Copyright © 2016年 吴亚举. All rights reserved.
//  海报秀/海报秀模型

#import <Foundation/Foundation.h>
#import "LXBaseFriend.h"

@interface LXPoster : LXBaseFriend

// 里面存放的是LXFriendPhoto模型，配图集合
@property (nonatomic, strong)NSArray *files;

@end
