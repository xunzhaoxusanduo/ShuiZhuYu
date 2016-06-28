//
//  LXShowCell.h
//  YiZhiChan
//
//  Created by wuyaju on 16/4/27.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LXShow;
@class LXPosterShow;
@class LXSubTitleShow;

@protocol LXShowCellDelegate <NSObject>

@optional
- (void)showCellHeightDidChanged:(UITableViewCell *)cell;

@end

@interface LXShowCell : UITableViewCell

@property (nonatomic, strong)LXShow *show;
@property (nonatomic, strong)LXPosterShow *posterShow;
@property (nonatomic, strong)LXSubTitleShow *subTitleShow;

// 是否为第一个cell
@property (nonatomic, assign, getter = isFirstRowInSection) BOOL firstRowInSection;
@property (nonatomic, weak)id<LXShowCellDelegate>delegate;

@end
