//
//  LXVideoView.h
//  YiZhiChan
//
//  Created by wuyaju on 16/5/21.
//  Copyright © 2016年 吴亚举. All rights reserved.
//  视频View

#import <UIKit/UIKit.h>

@class LXPoster;
@class LXPlayBtn;

@interface LXVideoView : UIView

@property (nonatomic, strong)LXPoster *poster;

// 播放/暂停按钮
@property (nonatomic, strong)LXPlayBtn *playBtn;

@end
