//
//  LXRecommendMovieView.m
//  YiZhiChan
//
//  Created by wuyaju on 16/4/27.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXRecommendMovieView.h"
#import "LXRecommendMovie.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "Macros.h"
#import "UIImage+FEBoxBlur.h"

#define ImageRadio              0.77
#define GradeViewWidthAndHeigth 40
#define ARC4RANDOM_MAX          0x100000000
#define ImageWidth              100
#define ImageHeight             200

@interface LXRecommendMovieView ()

// 海报视图
@property (nonatomic, strong)UIImageView *imageView;

// 评分
@property (nonatomic, strong)UIButton *gradeBtn;

@end

@implementation LXRecommendMovieView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
        [self setupAutoLayout];
    }
    
    return self;
}

- (instancetype)init{
    if (self = [super init]) {
        [self setupSubViews];
        [self setupAutoLayout];
    }
    
    return self;
}

- (void)setupSubViews {
    self.clipsToBounds = YES;
    
    // 海报视图
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.image = [UIImage imageNamed:@"placeholder"];
    imageView.userInteractionEnabled = YES;
    [self addSubview:imageView];
    self.imageView = imageView;
    
    // 评分
    UIButton *gradeBtn = [[UIButton alloc] init];
    gradeBtn.layer.cornerRadius = GradeViewWidthAndHeigth/2;
    gradeBtn.layer.masksToBounds = YES;
    gradeBtn.backgroundColor = RGB(251, 84, 9);
    gradeBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    gradeBtn.titleLabel.numberOfLines = 0;
    [self addSubview:gradeBtn];
    self.gradeBtn = gradeBtn;
    
    // 电影名
    UILabel *movenameLbl = [[UILabel alloc] init];
    movenameLbl.textAlignment = NSTextAlignmentCenter;
    movenameLbl.textColor = [UIColor whiteColor];
    movenameLbl.font = [UIFont systemFontOfSize:15];
    [self addSubview:movenameLbl];
    self.movenameLbl = movenameLbl;
}

- (void)setupAutoLayout {
    WS(weakSelf);
    
    // 海报视图
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.equalTo(weakSelf);
        make.height.equalTo(weakSelf.imageView.mas_width).multipliedBy(1.38);
    }];
    
    // 评分
    [self.gradeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(GradeViewWidthAndHeigth, GradeViewWidthAndHeigth));
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.imageView.mas_bottom);
    }];
    
    // 电影名
    [self.movenameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.gradeBtn.mas_bottom).offset(10);
        make.left.right.equalTo(weakSelf);
    }];
}

- (void)setRecommendMovie:(LXRecommendMovie *)recommendMovie {
    _recommendMovie = recommendMovie;

    [self.imageView sd_setImageWithURL:[NSURL URLWithString:recommendMovie.cover] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    NSString *str = [NSString stringWithFormat:@"%0.1f\n分", [recommendMovie.rating floatValue]];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, 3)];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, str.length)];
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, str.length)];
    [self.gradeBtn setAttributedTitle:attributedStr forState:UIControlStateNormal];
    
    self.movenameLbl.text = recommendMovie.movieName;
}

@end
