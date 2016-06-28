//
//  LXPersonInfoView.h
//  YiZhiChan
//
//  Created by wuyaju on 16/5/21.
//  Copyright © 2016年 吴亚举. All rights reserved.
//  个人信息View

#import <UIKit/UIKit.h>

@class LXBaseFriend;

@protocol LXPersonInfoViewDelegate <NSObject>

@optional
- (void)iconDidSelectWithInfo:(LXBaseFriend *)friend;
- (void)attitudeDidSelectWithInfo:(LXBaseFriend *)friend withBtn:(UIButton *)btn withCell:(UIView *)cell;
- (void)commentDidSelectWithInfo:(LXBaseFriend *)friend;

@end

@interface LXPersonInfoView : UIView

@property (nonatomic, strong)LXBaseFriend *friend;
@property (nonatomic, weak)id<LXPersonInfoViewDelegate>delegate;

@end
