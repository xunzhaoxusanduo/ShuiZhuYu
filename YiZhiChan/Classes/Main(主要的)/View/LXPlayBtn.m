//
//  LXPlayBtn.m
//  YiZhiChan
//
//  Created by wuyaju on 16/6/2.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXPlayBtn.h"
#import "Macros.h"
#import "Masonry.h"

@interface LXPlayBtn ()

@property (nonatomic, strong)UIView *bgView;
@property (nonatomic, strong)UIVisualEffectView *visualEffectView;

@end

@implementation LXPlayBtn

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
        [self setupAutoLayout];
    }
    
    return self;
}

- (void)setupSubViews {
//    UIView *bgView = [[UIView alloc] init];
//    bgView.backgroundColor = RGBA(22, 22, 22, 0.9);
//    [self addSubview:bgView];
//    self.bgView = bgView;
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [self addSubview:visualEffectView];
    self.visualEffectView = visualEffectView;
    
    UIButton *playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [playOrPauseBtn setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [playOrPauseBtn setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
    playOrPauseBtn.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:playOrPauseBtn];
    self.playOrPauseBtn = playOrPauseBtn;
}

- (void)setupAutoLayout {
    WS(weakSelf);
    
//    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(weakSelf);
//    }];
    
    [self.visualEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [self.playOrPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.width.equalTo(weakSelf.mas_width).multipliedBy(0.5);
        make.height.equalTo(weakSelf.mas_width).multipliedBy(0.5);
    }];
}

@end
