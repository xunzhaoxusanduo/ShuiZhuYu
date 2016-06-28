//
//  LXRecommendMovieView.h
//  YiZhiChan
//
//  Created by wuyaju on 16/4/27.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LXRecommendMovie;

@interface LXRecommendMovieView : UIView

@property (nonatomic, strong)LXRecommendMovie *recommendMovie;

// 电影名
@property (nonatomic, strong)UILabel *movenameLbl;

@end
