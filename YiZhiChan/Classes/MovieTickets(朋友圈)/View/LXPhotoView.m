//
//  LXPhotoView.m
//  YiZhiChan
//
//  Created by wuyaju on 16/5/22.
//  Copyright © 2016年 吴亚举. All rights reserved.
//  显示单张图片的View

#import "LXPhotoView.h"
#import "Masonry.h"
#import "Macros.h"
#import "LXFriendPhoto.h"
#import "UIImageView+WebCache.h"

@interface LXPhotoView ()

//// 配图
//@property (nonatomic, strong)UIImageView *imageView;
// 字幕秀背景
@property (nonatomic, strong)UIImageView *subtitleBgImageView;
// 字幕
@property (nonatomic, strong)UILabel *subtitleLbl;

@end

@implementation LXPhotoView

- (instancetype)init {
    if (self = [super init]) {
        [self setupSubViews];
        [self setupAutoLayout];
    }
    
    return self;
}

- (void)setupSubViews {
//    // 配图
//    UIImageView *imageView = [[UIImageView alloc] init];
//    imageView.contentMode = UIViewContentModeScaleAspectFill;
//    [self addSubview:imageView];
//    self.imageView = imageView;
    // 字幕秀背景
    UIImageView *subtitleBgImageView = [[UIImageView alloc] init];
    subtitleBgImageView.image = [UIImage imageNamed:@"Bottom-bg"];
    [self addSubview:subtitleBgImageView];
    self.subtitleBgImageView = subtitleBgImageView;
    
    // 字幕
    UILabel *subtitleLbl = [[UILabel alloc] init];
    subtitleLbl.textAlignment = NSTextAlignmentCenter;
    subtitleLbl.textColor = [UIColor whiteColor];
    subtitleLbl.font = [UIFont systemFontOfSize:13];
    [self.subtitleBgImageView addSubview:subtitleLbl];
    self.subtitleLbl = subtitleLbl;
}

- (void)setupAutoLayout {
    WS(weakSelf);
    int padding = 15;
    
//    // 配图
//    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(weakSelf);
//    }];
    // 字幕秀背景
    [self.subtitleBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(weakSelf);
        make.height.mas_equalTo(40);
    }];
    
    // 字幕
    [self.subtitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.subtitleBgImageView);
        make.bottom.equalTo(weakSelf.subtitleBgImageView.mas_bottom).offset(-padding);
    }];
}

- (void)setPhoto:(LXFriendPhoto *)photo {
    _photo = photo;
    [self sd_setImageWithURL:[NSURL URLWithString:photo.imgUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    if ((photo.text != nil) && (photo.text.length > 0)) {
        self.subtitleBgImageView.hidden = NO;
        self.subtitleLbl.text = photo.text;
    }else {
        self.subtitleBgImageView.hidden = YES;
    }
}

@end
