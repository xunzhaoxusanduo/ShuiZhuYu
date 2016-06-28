//
//  LXFriendHeaderView.m
//  YiZhiChan
//
//  Created by wuyaju on 16/5/23.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXFriendHeaderView.h"
#import "UIImageView+WebCache.h"
#import "LXMyInfo.h"
#import "NSString+Utils.h"

#define BtnHeight       40

@interface LXFriendHeaderView ()

// 动态、粉丝、关注的背景视图
@property (nonatomic, strong)UIView *followerBgView;
// 动态数
@property (nonatomic, strong)UIButton *dynamicBtn;
// 粉丝数
@property (nonatomic, strong)UIButton *followerBtn;
// 关注数
@property (nonatomic, strong)UIButton *followBtn;

@end

@implementation LXFriendHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
        [self setupAutoLayout];
    }
    
    return self;
}

- (void)setupSubViews {
    // 动态、粉丝、关注的背景视图
    UIView *followerBgView = [[UIView alloc] init];
    [self.bgImageView addSubview:followerBgView];
    self.followerBgView = followerBgView;
    
    // 动态数
    UIButton *dynamicBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    dynamicBtn.titleLabel.numberOfLines = 0;
    dynamicBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [dynamicBtn addTarget:self action:@selector(dynamicClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.followerBgView addSubview:dynamicBtn];
    self.dynamicBtn = dynamicBtn;
    
    // 粉丝数
    UIButton *followerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    followerBtn.titleLabel.numberOfLines = 0;
    followerBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [followerBtn addTarget:self action:@selector(fanClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.followerBgView addSubview:followerBtn];
    self.followerBtn = followerBtn;
    
    // 关注数
    UIButton *followBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    followBtn.titleLabel.numberOfLines = 0;
    followBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [followBtn addTarget:self action:@selector(followClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.followerBgView addSubview:followBtn];
    self.followBtn = followBtn;
}

- (void)setupAutoLayout {
    WS(weakSelf);
    int padding = 10;
    
    // 动态、粉丝、关注的背景视图
    [self.followerBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.bottomView);
    }];
    
    // 动态数
    [self.dynamicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.followerBgView.mas_left);
        make.bottom.equalTo(weakSelf.followerBgView.mas_bottom).offset(-padding);
        make.width.equalTo(weakSelf.followerBtn);
        make.height.mas_equalTo(BtnHeight);
    }];
    
    // 粉丝数
    [self.followerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.dynamicBtn.mas_right);
        make.bottom.equalTo(weakSelf.followerBgView.mas_bottom).offset(-padding);
        make.width.equalTo(weakSelf.followBtn);
        make.height.mas_equalTo(BtnHeight);
    }];
    
    // 关注数
    [self.followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.followerBtn.mas_right);
        make.bottom.equalTo(weakSelf.followerBgView.mas_bottom).offset(-padding);
        make.width.equalTo(weakSelf.dynamicBtn);
        make.right.equalTo(weakSelf.followerBgView.mas_right);
        make.height.mas_equalTo(BtnHeight);
    }];
}

- (void)setMyInfo:(LXMyInfo *)myInfo {
    _myInfo = myInfo;
    
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
    
    // 动态数
    [self.dynamicBtn setAttributedTitle:[self count:myInfo.dynamics.integerValue text:@"动态"] forState:UIControlStateNormal];
    
    // 粉丝数
    [self.followerBtn setAttributedTitle:[self count:myInfo.fans.integerValue text:@"粉丝"] forState:UIControlStateNormal];
    
    // 关注数
    [self.followBtn setAttributedTitle:[self count:myInfo.follows.integerValue text:@"关注"] forState:UIControlStateNormal];
}

- (NSMutableAttributedString *)count:(NSInteger)count text:(NSString *)text {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSString *tmpStr = [NSString count:count];
    NSString *str = [NSString stringWithFormat:@"%@\n%@", tmpStr, text];
    NSMutableAttributedString *AttStr = [[NSMutableAttributedString alloc] initWithString:str];
    [AttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, tmpStr.length)];
    [AttStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, str.length)];
    [AttStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, str.length)];
    
    return AttStr;
}

/**
 *  动态按钮点击事件
 */
- (void)dynamicClicked {
    if ([self.delegate respondsToSelector:@selector(dynamicDidSelectWithInfo:)]) {
        [self.delegate dynamicDidSelectWithInfo:self.myInfo];
    }
}

/**
 *  粉丝按钮点击事件
 */
- (void)fanClicked {
    if ([self.delegate respondsToSelector:@selector(fanDidSelectWithInfo:)]) {
        [self.delegate fanDidSelectWithInfo:self.myInfo];
    }
}

/**
 *  关注按钮点击事件
 */
- (void)followClicked {
    if ([self.delegate respondsToSelector:@selector(followDidSelectWithInfo:)]) {
        [self.delegate followDidSelectWithInfo:self.myInfo];
    }
}

@end
