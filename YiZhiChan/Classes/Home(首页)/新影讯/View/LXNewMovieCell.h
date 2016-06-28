//
//  LXNewMovieCell.h
//  YiZhiChan
//
//  Created by wuyaju on 16/4/27.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LXNewMovie;

@interface LXNewMovieCell : UITableViewCell

@property (nonatomic, strong)LXNewMovie *movieInfo;
// 是否为最后一个cell
@property (nonatomic, assign, getter = isLastRowInSection) BOOL lastRowInSection;

@end
