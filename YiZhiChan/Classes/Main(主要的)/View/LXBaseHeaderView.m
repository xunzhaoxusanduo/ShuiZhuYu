//
//  LXBaseHeaderView.m
//  YiZhiChan
//
//  Created by wuyaju on 16/5/23.
//  Copyright © 2016年 吴亚举. All rights reserved.
//  头部视图基类

#import "LXBaseHeaderView.h"

#define IconWidthHeight 70
#define BgViewHeight    30

@implementation LXBaseHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupBaseSubViews];
        [self setupBaseAutoLayout];
    }
    
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setupBaseSubViews];
        [self setupBaseAutoLayout];
    }
    
    return self;
}

- (void)setupBaseSubViews {
    // 封面图片
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.image = [UIImage imageNamed:@"image"];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    bgImageView.userInteractionEnabled = YES;
    self.clipsToBounds = YES;
    [self addSubview:bgImageView];
    self.bgImageView = bgImageView;
    
    // 头像
    UIImageView *iconImage = [[UIImageView alloc] init];
    iconImage.layer.cornerRadius = IconWidthHeight / 2;
    iconImage.clipsToBounds = YES;
    iconImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.bgImageView addSubview:iconImage];
    self.iconImage = iconImage;
    
    // 昵称，性别，等级的背景视图
    UIView *bgView = [[UIView alloc] init];
    bgView.clipsToBounds = YES;
    [self.bgImageView addSubview:bgView];
    self.bgView = bgView;
    
    // 昵称
    UILabel *nickNameLbl = [[UILabel alloc] init];
    nickNameLbl.textColor = [UIColor whiteColor];
    nickNameLbl.font = [UIFont systemFontOfSize:17];
    nickNameLbl.shadowColor = RGBA(0, 0, 0, 0.5);
    nickNameLbl.shadowOffset = CGSizeMake(1.2, 1.2);
    [self.bgView addSubview:nickNameLbl];
    self.nickNameLbl = nickNameLbl;
    
    // 性别
    UIImageView *sexImageView = [[UIImageView alloc] init];
    sexImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.bgView addSubview:sexImageView];
    self.sexImageView = sexImageView;
    
    // 等级的背景视图
    UIView *levelView = [[UIView alloc] init];
    levelView.clipsToBounds = YES;
    [self.bgView addSubview:levelView];
    self.levelView = levelView;
    
    // 等级
    UIImageView *levelImageView = [[UIImageView alloc] init];
    levelImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.levelView addSubview:levelImageView];
    self.levelImageView = levelImageView;
    
    // 底部渐变背景视图
    UIView *bottomView = [[UIView alloc] init];
    
    // 设置渐变效果
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 70);
    gradientLayer.borderWidth = 0;
    gradientLayer.frame = gradientLayer.bounds;
    gradientLayer.colors = [NSArray arrayWithObjects:
                            (id)[[UIColor clearColor] CGColor],
                            (id)[[UIColor blackColor] CGColor], nil];
    [bottomView.layer insertSublayer:gradientLayer atIndex:0];
    
    [self.bgImageView addSubview:bottomView];
    self.bottomView = bottomView;
}

- (void)setupBaseAutoLayout {
    WS(weakSelf);
    int padding = 10;
    
    // 封面图片
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    // 头像
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.bgImageView.mas_centerX);
        make.centerY.equalTo(weakSelf.bgImageView.mas_centerY).offset(-15);
        make.size.mas_equalTo(CGSizeMake(IconWidthHeight, IconWidthHeight));
    }];
    
    // 昵称，性别，等级的背景视图
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.bgImageView.mas_centerX);
        make.top.equalTo(weakSelf.iconImage.mas_bottom).offset(padding/2);
        make.height.mas_equalTo(BgViewHeight);
    }];
    
    // 昵称
    [self.nickNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(weakSelf.bgView);
    }];
    
    // 性别
    [self.sexImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.nickNameLbl.mas_centerY);
        make.left.equalTo(weakSelf.nickNameLbl.mas_right).offset(padding);
        make.size.mas_equalTo(CGSizeMake(20, 18));
    }];
    
    // 等级的背景视图
    [self.levelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.nickNameLbl.mas_centerY);
        make.right.equalTo(weakSelf.bgView.mas_right);
        make.left.equalTo(weakSelf.sexImageView.mas_right).offset(padding);
        make.size.mas_equalTo(CGSizeMake(50, 18));
    }];
    
    // 等级
    [self.levelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.levelView);
    }];
    
    // 底部渐变背景视图
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(weakSelf.bgImageView);
        make.height.mas_equalTo(60);
    }];
}

@end
