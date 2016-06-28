//
//  LXCarouselWebViewController.h
//  YiZhiChan
//
//  Created by wuyaju on 16/5/9.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXWebViewController.h"

@class LXSDCycleScrollView;

@interface LXCarouselWebViewController : LXWebViewController

@property (nonatomic, strong)LXSDCycleScrollView *carouselScrollView;
@property (nonatomic, strong)NSMutableArray *releaseMovieArray;
// 轮播图片请求地址
@property (nonatomic, copy)NSString *carouselUrl;

@end
