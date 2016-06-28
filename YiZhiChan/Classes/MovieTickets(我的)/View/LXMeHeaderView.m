//
//  LXMeHeaderView.m
//  YiZhiChan
//
//  Created by wuyaju on 16/5/14.
//  Copyright © 2016年 吴亚举. All rights reserved.
//  我的界面头部视图

#import "LXMeHeaderView.h"
#import "LXMyInfo.h"
#import "UIImageView+WebCache.h"
#import "UIImage+FEBoxBlur.h"
#import "UIButton+WebCache.h"

@interface LXMeHeaderView ()

// 经验值和积分值的背景视图
@property (nonatomic, strong)UIView *experienceBgView;
// 经验值
@property (nonatomic, strong)UIButton *experienceBtn;
// 积分值
@property (nonatomic, strong)UIButton *pointsBtn;
// 登录按钮
@property (nonatomic, strong)UIButton *loginBtn;

@end

@implementation LXMeHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
        [self setupAutoLayout];
    }
    
    return self;
}

- (void)setupSubViews {
    self.iconImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.iconImage addGestureRecognizer:tapGestureRecognizer];
    
    UITapGestureRecognizer *taptapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.bgView addGestureRecognizer:taptapGesture];
    
    // 经验值和积分值的背景视图
    UIView *experienceBgView = [[UIView alloc] init];
    [self.bgImageView addSubview:experienceBgView];
    self.experienceBgView = experienceBgView;

    
    // 经验值
    UIButton *experienceBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [experienceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    experienceBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    experienceBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [experienceBtn addTarget:self action:@selector(experienceClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.experienceBgView addSubview:experienceBtn];
    self.experienceBtn = experienceBtn;
    
    // 积分值
    UIButton *pointsBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [pointsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    pointsBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    pointsBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [pointsBtn addTarget:self action:@selector(pointsClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.experienceBgView addSubview:pointsBtn];
    self.pointsBtn = pointsBtn;
    
    // 登录按钮
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [loginBtn setTitle:@"点击登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.bgImageView addSubview:loginBtn];
    self.loginBtn = loginBtn;
}

/**
 *  点击登录
 */
- (void)loginClicked {
    if ([self.delegate respondsToSelector:@selector(loginBtnClicked)]) {
        [self.delegate loginBtnClicked];
    }
}

/**
 *  头像点击事件
 *
 */
- (void)handleTapGesture:(UITapGestureRecognizer *)gestureRecognizer {
    if ([self.delegate respondsToSelector:@selector(iconClicked)]) {
        [self.delegate iconClicked];
    }
}

- (void)setupAutoLayout {
    WS(weakSelf);
    int padding = 10;
    
    // 登录按钮
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.bgImageView.mas_centerX);
        make.top.equalTo(weakSelf.iconImage.mas_bottom).offset(padding);
        make.size.mas_equalTo(CGSizeMake(80, 40));
    }];
    
    // 经验值和积分值的背景视图
    [self.experienceBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.bottomView);
    }];
    
    // 经验值
    [self.experienceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.experienceBgView.mas_left);
        make.bottom.equalTo(weakSelf.experienceBgView.mas_bottom).offset(-padding);
        make.width.equalTo(weakSelf.pointsBtn.mas_width);
        make.height.mas_equalTo(30);
    }];
    
    // 积分值
    [self.pointsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.experienceBtn.mas_right);
        make.right.equalTo(weakSelf.experienceBgView.mas_right);
        make.bottom.equalTo(weakSelf.experienceBtn.mas_bottom);
        make.width.equalTo(weakSelf.experienceBtn.mas_width);
        make.height.equalTo(weakSelf.experienceBtn.mas_height);
    }];
}

- (void)setMyInfo:(LXMyInfo *)myInfo {
    _myInfo = myInfo;
    
    if (myInfo) {
        // 隐藏登录按钮
        self.loginBtn.hidden = YES;
        self.bgView.hidden = NO;
        self.experienceBtn.hidden = NO;
        self.pointsBtn.hidden = NO;
        
        // 封面图片
        [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:myInfo.bgImage]];
        
        // 头像
        if (myInfo.iconUrl.length) {
            [self.iconImage sd_setImageWithURL:[NSURL URLWithString:myInfo.iconUrl]];
        }else {
            self.iconImage.image = [UIImage imageNamed:@"me_icon_notLogin"];
        }
        
        // 昵称
        self.nickNameLbl.text = myInfo.nickName;
        
        // 性别
        NSString *sexImageName = myInfo.sex.integerValue ? @"me_male" : @"me_female";
        self.sexImageView.image = [UIImage imageNamed:sexImageName];
        
        // 等级
        NSString *levelImageName = [NSString stringWithFormat:@"me_%ldlevel", myInfo.level.integerValue];
        self.levelImageView.image = [UIImage imageNamed:levelImageName];
        
        // 经验值
        NSString *experienceStr = [NSString stringWithFormat:@"经验值 %ld", myInfo.experience.integerValue];
        NSMutableAttributedString *experienceAttStr = [[NSMutableAttributedString alloc] initWithString:experienceStr];
        [experienceAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 3)];
        [experienceAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, experienceStr.length)];
        [experienceAttStr addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithFloat:1.5] range:NSMakeRange(0, 3)];
        [self.experienceBtn setAttributedTitle:experienceAttStr forState:UIControlStateNormal];
        
        // 积分值
        NSString *pointsStr = [NSString stringWithFormat:@"积分值 %ld", myInfo.experience.integerValue];
        NSMutableAttributedString *pointsAttStr = [[NSMutableAttributedString alloc] initWithString:pointsStr];
        [pointsAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 3)];
        [pointsAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, pointsStr.length)];
        [pointsAttStr addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithFloat:1.5] range:NSMakeRange(0, 3)];
        [self.pointsBtn setAttributedTitle:pointsAttStr forState:UIControlStateNormal];
    }else {
        self.iconImage.image = [UIImage imageNamed:@"me_icon_notLogin"];
        self.loginBtn.hidden = NO;
        self.bgView.hidden = YES;
        self.experienceBtn.hidden = YES;
        self.pointsBtn.hidden = YES;
    }
}

- (void)experienceClicked {
    if ([self.delegate respondsToSelector:@selector(experienceDidSelectWithInfo:)]) {
        [self.delegate experienceDidSelectWithInfo:self.myInfo];
    }
}

- (void)pointsClicked {
    if ([self.delegate respondsToSelector:@selector(pointsDidSelectWithInfo:)]) {
        [self.delegate pointsDidSelectWithInfo:self.myInfo];
    }
}

@end
