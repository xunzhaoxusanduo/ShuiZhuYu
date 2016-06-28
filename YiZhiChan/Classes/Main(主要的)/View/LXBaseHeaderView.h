//
//  LXBaseHeaderView.h
//  YiZhiChan
//
//  Created by wuyaju on 16/5/23.
//  Copyright © 2016年 吴亚举. All rights reserved.
//  头部视图基类

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "Macros.h"

@interface LXBaseHeaderView : UIView

// 封面图片
@property (nonatomic, strong)UIImageView *bgImageView;
// 头像
@property (nonatomic,strong)UIImageView *iconImage;
// 昵称，性别，等级的背景视图
@property (nonatomic, strong)UIView *bgView;
// 昵称
@property (nonatomic, strong)UILabel *nickNameLbl;
// 性别
@property (nonatomic, strong)UIImageView *sexImageView;
// 等级的背景视图
@property (nonatomic, strong)UIView *levelView;
// 等级
@property (nonatomic, strong)UIImageView *levelImageView;
// 底部渐变背景视图
@property (nonatomic, strong)UIView *bottomView;

@end
