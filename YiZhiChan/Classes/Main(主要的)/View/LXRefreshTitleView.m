//
//  LXRefreshTitleView.m
//  YiZhiChan
//
//  Created by wuyaju on 16/5/23.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXRefreshTitleView.h"
#import "Macros.h"
#import "Masonry.h"

@interface LXRefreshTitleView ()

@end

@implementation LXRefreshTitleView

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
    self.backgroundColor = [UIColor redColor];
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] init];
    [self addSubview:indicatorView];
    self.indicatorView = indicatorView;
    
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.textColor = [UIColor whiteColor];
    [self addSubview:titleLbl];
    self.titleLbl = titleLbl;
}

- (void)setupAutoLayout {
    WS(weakSelf);
    int padding = 5;
    
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.right.equalTo(weakSelf.titleLbl.mas_left).offset(-padding);
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf);
    }];
}

@end
