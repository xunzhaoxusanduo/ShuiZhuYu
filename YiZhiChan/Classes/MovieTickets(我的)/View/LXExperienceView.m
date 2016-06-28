//
//  LXExperienceView.m
//  YiZhiChan
//
//  Created by wuyaju on 16/6/2.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXExperienceView.h"
#import "Macros.h"
#import "Masonry.h"
#import "LXMyInfo.h"
#import "LXProgressView.h"

@interface LXExperienceView ()

// 背景视图
@property (nonatomic, strong)UIView *bgView;
// 标题背景视图
@property (nonatomic, strong)UIView *titleBgView;
@property (nonatomic, strong)UILabel *titleLbl;
@property (nonatomic, strong)UIImageView *experienceImageView;
@property (nonatomic, strong)UILabel *experienceTitleLbl;
@property (nonatomic, strong)LXProgressView *progressView;
@property (nonatomic, strong)UILabel *subtitleLbl;
@property (nonatomic, strong)UIButton *descriptionBtn;

@end

@implementation LXExperienceView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
        [self setupAutoLayout];
    }
    
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setupSubViews];
        [self setupAutoLayout];
    }
    
    return self;
}

- (void)setupSubViews {
    self.backgroundColor = RGBA(0, 0, 0, 0.5);
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tapGesture];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 10;
    bgView.clipsToBounds = YES;
    [self addSubview:bgView];
    self.bgView = bgView;
    
    UIView *titleBgView = [[UIView alloc] init];
    titleBgView.backgroundColor = RGB(237, 238, 240);
    [self.bgView addSubview:titleBgView];
    self.titleBgView = titleBgView;
    
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.text = @"我的等级";
    titleLbl.font = [UIFont systemFontOfSize:16];
    [self.titleBgView addSubview:titleLbl];
    self.titleLbl = titleLbl;
    
    UIImageView *experienceImageView = [[UIImageView alloc] init];
    experienceImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.titleBgView addSubview:experienceImageView];
    self.experienceImageView = experienceImageView;
    
    UILabel *experienceTitleLbl = [[UILabel alloc] init];
    experienceTitleLbl.text = @"经验值";
    experienceTitleLbl.font = [UIFont systemFontOfSize:16];
    [self.bgView addSubview:experienceTitleLbl];
    self.experienceTitleLbl = experienceTitleLbl;
    
    LXProgressView *progressView = [[LXProgressView alloc] init];
    progressView.progressTintColor = LXYellowColor;
    progressView.trackTintColor = [UIColor grayColor];
    progressView.titleLbl.font = [UIFont systemFontOfSize:13];
    progressView.titleLbl.textColor = [UIColor whiteColor];
    [self.bgView addSubview:progressView];
    self.progressView = progressView;
    
    UILabel *subtitleLbl = [[UILabel alloc] init];
    subtitleLbl.text = @"当经验值满足条件时才能升级";
    subtitleLbl.font = [UIFont systemFontOfSize:13];
    subtitleLbl.textColor = [UIColor grayColor];
    [self.bgView addSubview:subtitleLbl];
    self.subtitleLbl = subtitleLbl;
    
    UIButton *descriptionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [descriptionBtn setTitle:@"等级说明" forState:UIControlStateNormal];
    [descriptionBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [descriptionBtn setImage:[UIImage imageNamed:@"info"] forState:UIControlStateNormal];
    descriptionBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    descriptionBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    descriptionBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [self.bgView addSubview:descriptionBtn];
    self.descriptionBtn = descriptionBtn;
}

- (void)setupAutoLayout {
    WS(weakSelf);
    int paddding = 10;
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.mas_width).multipliedBy(0.8);
        make.height.equalTo(weakSelf.bgView.mas_width).multipliedBy(0.6);
        make.center.equalTo(weakSelf);
    }];
    
    [self.titleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.bgView);
        make.height.equalTo(weakSelf.bgView.mas_height).multipliedBy(0.3);
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(weakSelf.titleBgView);
        make.left.equalTo(weakSelf.titleBgView.mas_left).offset(paddding);
    }];
    
    [self.experienceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.titleLbl.mas_centerY);
        make.left.equalTo(weakSelf.titleLbl.mas_right).offset(paddding / 2);
        make.height.mas_equalTo(20);
    }];
    
    [self.experienceTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).offset(paddding);
        make.centerY.equalTo(weakSelf.bgView.mas_centerY);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.experienceTitleLbl.mas_centerY);
        make.left.equalTo(weakSelf.experienceTitleLbl.mas_right).offset(paddding);
        make.right.equalTo(weakSelf.bgView.mas_right).offset(-paddding);
        make.height.mas_equalTo(20);
    }];
    
    [self.subtitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).offset(paddding);
        make.centerY.equalTo(weakSelf.bgView.mas_centerY).multipliedBy(1.6);
    }];
    
    [self.descriptionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.subtitleLbl.mas_centerY);
        make.left.greaterThanOrEqualTo(weakSelf.subtitleLbl.mas_right).offset(5);
        make.right.equalTo(weakSelf.bgView.mas_right).offset(-paddding);
        make.width.mas_equalTo(85);
    }];
    
    [self.subtitleLbl setContentCompressionResistancePriority:UILayoutPriorityDefaultLow
                                                          forAxis:UILayoutConstraintAxisHorizontal];
    [self.subtitleLbl setContentHuggingPriority:UILayoutPriorityRequired
                                            forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.descriptionBtn setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                      forAxis:UILayoutConstraintAxisHorizontal];
    [self.descriptionBtn setContentHuggingPriority:UILayoutPriorityRequired
                                        forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)setMyInfo:(LXMyInfo *)myInfo {
    _myInfo = myInfo;
    
    NSString *levelImageName = [NSString stringWithFormat:@"me_%ldlevel", myInfo.level.integerValue];
    self.experienceImageView.image = [UIImage imageNamed:levelImageName];
    self.progressView.titleLbl.text = [NSString stringWithFormat:@"%ld/%ld", myInfo.experience.integerValue, myInfo.nextExperience.integerValue];
    self.progressView.progress = (CGFloat)( ((CGFloat)myInfo.experience.integerValue) / ((CGFloat)myInfo.nextExperience.integerValue));
}

- (void)handleTap:(UITapGestureRecognizer *)tapGesture {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
