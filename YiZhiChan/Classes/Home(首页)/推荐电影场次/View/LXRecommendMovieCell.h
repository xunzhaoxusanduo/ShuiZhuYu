//
//  LXRecommendMovieCell.h
//  YiZhiChan
//
//  Created by wuyaju on 16/4/27.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LXRecommendMovie;

@protocol LXRecommendMovieCellDelegate <NSObject>

@optional
- (void)didSelectImage:(LXRecommendMovie *)recommendMovie;

@end

@interface LXRecommendMovieCell : UITableViewCell

// 里面存放的是LXRecommendMovie模型
@property (nonatomic, strong)NSArray *recommendMovieArray;
@property (nonatomic, weak)id<LXRecommendMovieCellDelegate>delegate;

@end
