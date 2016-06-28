//
//  LXFilmReviewCell.h
//  YiZhiChan
//
//  Created by wuyaju on 16/5/22.
//  Copyright © 2016年 吴亚举. All rights reserved.
//  影评cell

#import "LXBaseFriendTableViewCell.h"

@class LXFilmReview;
@class LXMovieView;

@interface LXFilmReviewCell : LXBaseFriendTableViewCell

@property (nonatomic, strong)LXFilmReview *filmReview;

// 电影简介
@property (nonatomic, strong)LXMovieView *movieView;

@end
