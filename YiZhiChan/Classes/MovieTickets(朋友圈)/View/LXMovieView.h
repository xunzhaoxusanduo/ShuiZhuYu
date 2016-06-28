//
//  LXMovieView.h
//  YiZhiChan
//
//  Created by wuyaju on 16/5/21.
//  Copyright © 2016年 吴亚举. All rights reserved.
//  电影简介View

#import <UIKit/UIKit.h>

@class LXFilmInfo;

@protocol LXMovieViewDelegate <NSObject>

@optional
- (void)movieViewDidSelectWithFilmInfo:(LXFilmInfo *)filmInfo;

@end

@interface LXMovieView : UIView

// 电影信息模型
@property (nonatomic, strong)LXFilmInfo *filmInfo;
@property (nonatomic, weak)id<LXMovieViewDelegate>delegate;

@end