//
//  LXPosterCell.h
//  YiZhiChan
//
//  Created by wuyaju on 16/5/21.
//  Copyright © 2016年 吴亚举. All rights reserved.
//  海报秀cell

#import "LXBaseFriendTableViewCell.h"

@class LXPoster;

@interface LXPosterCell : LXBaseFriendTableViewCell

@property (nonatomic, strong)LXPoster *poster;

// 计算高度使用
@property (nonatomic, strong)LXPoster *posterAutoLayout;

@end
