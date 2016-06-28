//
//  LXCellHeaderView.m
//  YiZhiChan
//
//  Created by wuyaju on 16/4/27.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXCellHeaderView.h"
#import "LXCellHeader.h"
#import "Masonry.h"
#import "Macros.h"

@interface LXCellHeaderView ()

// 标题图片
@property (nonatomic, strong)UIImageView *titleImage;
// 标题
@property (nonatomic, strong)UILabel *titleLbl;
// 右侧指示器
@property (nonatomic, strong)UIButton *indicatorBtn;

@end

@implementation LXCellHeaderView

- (instancetype)init {
    if (self = [super init]) {
        [self setupSubViews];
        [self setupAutoLayout];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
        [self setupAutoLayout];
    }
    
    return  self;
}

- (void)setupSubViews {
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clicked)];
    [self addGestureRecognizer:tapGestureRecognizer];
    
    // 标题图片
    UIImageView *titleImage = [[UIImageView alloc] init];
    titleImage.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:titleImage];
    self.titleImage = titleImage;
    
    // 标题
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.font = [UIFont boldSystemFontOfSize:18];
    [self addSubview:titleLbl];
    self.titleLbl = titleLbl;
    
    // 右侧指示器
    UIButton *indicatorBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [indicatorBtn setImage:[[UIImage imageNamed:@"more"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    indicatorBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [indicatorBtn addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:indicatorBtn];
    self.indicatorBtn = indicatorBtn;
}

- (void)setupAutoLayout {
    WS(weakSelf);
    int padding = 10;
    
    // 标题图片
    [self.titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(padding);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.height.mas_equalTo(23);
        make.width.mas_equalTo(23);
    }];
    
    // 标题
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleImage.mas_right).offset(padding);
        make.height.equalTo(weakSelf.mas_height);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    
    // 右侧指示器
    [self.indicatorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(15);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-15);
        make.right.equalTo(weakSelf.mas_right).offset(-10);
        make.width.mas_equalTo(20);
    }];
}

- (void)setCellHeader:(LXCellHeader *)cellHeader {
    _cellHeader = cellHeader;
    self.titleImage.image = [UIImage imageNamed:cellHeader.imageUrl];
    self.titleLbl.text = cellHeader.titleName;
}

- (void)clicked {
    if ([self.delegate respondsToSelector:@selector(headerView:diddidSelectSection:)]) {
        [self.delegate headerView:self diddidSelectSection:self.section];
    }
}

// 自绘分割线
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, RGBA(255, 255, 255, 0.15).CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height - 1, rect.size.width, 1));
}

@end
