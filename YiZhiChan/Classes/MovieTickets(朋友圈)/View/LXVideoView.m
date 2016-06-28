//
//  LXVideoView.m
//  YiZhiChan
//
//  Created by wuyaju on 16/5/21.
//  Copyright © 2016年 吴亚举. All rights reserved.
//  视频View

#import "LXVideoView.h"
#import "Masonry.h"
#import "Macros.h"
#import "UIImageView+WebCache.h"
#import "LXPoster.h"
#import "LXPlayBtn.h"

#define PlayBtnWidthHeight  60

@interface LXVideoView ()

// 视频缩略图
@property (nonatomic, strong)UIImageView *coverImageView;
// 视频长度标签
@property (nonatomic, strong)UILabel *timeLbl;

@end

@implementation LXVideoView

- (instancetype)init {
    if (self = [super init]) {
        [self setupSubViews];
        [self setupAutoLayout];
    }
    
    return self;
}

- (void)setupSubViews {
    self.backgroundColor = [UIColor grayColor];
    
    // 视频缩略图
    UIImageView *coverImageView = [[UIImageView alloc] init];
    coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    coverImageView.clipsToBounds = YES;
    coverImageView.userInteractionEnabled = YES;
    [self addSubview:coverImageView];
    self.coverImageView = coverImageView;
    
    // 播放/暂停按钮
//    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    playBtn.contentMode = UIViewContentModeScaleAspectFit;
//    [playBtn setBackgroundImage:[UIImage imageNamed:@"ImageResources.bundle/play"] forState:UIControlStateNormal];
//    [self addSubview:playBtn];
//    self.playBtn = playBtn;
    
    LXPlayBtn *playBtn = [[LXPlayBtn alloc] init];
    playBtn.layer.cornerRadius = PlayBtnWidthHeight / 2;
    playBtn.clipsToBounds = YES;
    [self addSubview:playBtn];
    self.playBtn = playBtn;
    
    // 视频长度标签
    UILabel *timeLbl = [[UILabel alloc] init];
    timeLbl.backgroundColor = RGBA(0, 0, 0, 0.5);
    timeLbl.textColor = [UIColor whiteColor];
    [self addSubview:timeLbl];
    self.timeLbl = timeLbl;
}

- (void)setupAutoLayout {
    WS(weakSelf);
    int padding = 10;
    
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf.mas_top).priorityLow();
        make.bottom.equalTo(weakSelf.mas_bottom).priorityLow();
        make.height.mas_equalTo(200);
    }];
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(PlayBtnWidthHeight, PlayBtnWidthHeight));
    }];
    
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(padding);
        make.right.equalTo(weakSelf.mas_right).offset(-padding);
    }];
}

- (void)setPoster:(LXPoster *)poster {
    _poster = poster;

    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:poster.poster] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.timeLbl.text = poster.videoTime;
    
}

@end
