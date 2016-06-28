//
//  LXMeHeaderView.h
//  YiZhiChan
//
//  Created by wuyaju on 16/5/14.
//  Copyright © 2016年 吴亚举. All rights reserved.
//  我的界面头部视图

#import "LXBaseHeaderView.h"

@class LXMyInfo;

@protocol LXMeHeaderViewDelegate <NSObject>

@optional
- (void)loginBtnClicked;
- (void)iconClicked;
- (void)experienceDidSelectWithInfo:(LXMyInfo *)myInfo;
- (void)pointsDidSelectWithInfo:(LXMyInfo *)myInfo;

@end

@interface LXMeHeaderView : LXBaseHeaderView

@property (nonatomic, strong)LXMyInfo *myInfo;

@property (nonatomic, weak)id<LXMeHeaderViewDelegate> delegate;

@end
