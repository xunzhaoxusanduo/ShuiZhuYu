//
//  LXTitleBtn.m
//  YiZhiChan
//
//  Created by wuyaju on 16/5/25.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXTitleBtn.h"
#import "Macros.h"
#import "Masonry.h"

@interface LXTitleBtn ()

@property (nonatomic, strong)UIImageView *imageView;

@end

@implementation LXTitleBtn

- (instancetype)init {
    if (self = [super init]) {
        [self setupSubViews];
        [self setupAutoLayout];
    }
    
    return self;
}

- (void)setupSubViews {
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.font = [UIFont systemFontOfSize:16];
    [self addSubview:titleLbl];
    self.titleLbl = titleLbl;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:@"navigationbar_arrow_down"];
    [self addSubview:imageView];
    self.imageView = imageView;
}

- (void)setupAutoLayout {
    WS(weakSelf);
    int padding = 5;
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.titleLbl.mas_centerY);
        make.left.equalTo(weakSelf.titleLbl.mas_right).offset(padding);
    }];
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    
    if (selected) {
        self.imageView.image = [UIImage imageNamed:@"navigationbar_arrow_up"];
    }else {
        self.imageView.image = [UIImage imageNamed:@"navigationbar_arrow_down"];
    }
}

@end
