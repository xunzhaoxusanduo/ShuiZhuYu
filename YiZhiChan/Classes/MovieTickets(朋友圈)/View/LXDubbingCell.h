//
//  LXDubbingCell.h
//  YiZhiChan
//
//  Created by wuyaju on 16/5/24.
//  Copyright © 2016年 吴亚举. All rights reserved.
//  配音秀cell

#import "LXBaseFriendTableViewCell.h"

@class LXPoster;
@class LXVideoView;

@interface LXDubbingCell : LXBaseFriendTableViewCell

// 视频View
@property (nonatomic, strong)LXVideoView *videoView;
@property (nonatomic, strong)LXPoster *poster;

@end
