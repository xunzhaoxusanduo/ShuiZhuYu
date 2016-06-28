//
//  LXMyFriendGroup.h
//  YiZhiChan
//
//  Created by wuyaju on 16/5/17.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXMyFriendGroup : NSObject

@property (nonatomic, copy)NSString *firstPY;
// 里面存放的是LXMyFriend模型
@property (nonatomic, strong)NSArray *userList;

@end
