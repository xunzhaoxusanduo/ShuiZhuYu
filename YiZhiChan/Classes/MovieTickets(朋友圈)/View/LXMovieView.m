//
//  LXMovieView.m
//  YiZhiChan
//
//  Created by wuyaju on 16/5/21.
//  Copyright © 2016年 吴亚举. All rights reserved.
//  电影简介View

#import "LXMovieView.h"
#import "Masonry.h"
#import "Macros.h"
#import "UIImage+FEBoxBlur.h"
#import "UIImageView+WebCache.h"
#import "LXFilmInfo.h"

#define PosterImageWidth    80
#define PosterImageHeight   110

@interface LXMovieView ()

// 海报图片
@property (nonatomic, strong)UIImageView *posterImageView;
// 电影名
@property (nonatomic, strong)UILabel *movieNameLbl;
// 电影评分
@property (nonatomic, strong)UIButton *gradeBtn;
// 电影类型
@property (nonatomic, strong)UIImageView *movieType;
// 导演名字
@property (nonatomic, strong)UILabel *directorNameLbl;
// 上映日期
@property (nonatomic, strong)UILabel *releaseDateLbl;
// 电影简介
@property (nonatomic, strong)UILabel *movieNotesLbl;

@property (nonatomic, strong)NSDictionary *movieTypeDic;

@end

@implementation LXMovieView

- (instancetype)init {
    if (self = [super init]) {
        [self setupSubViews];
        [self setupAutoLayout];
    }
    
    return self;
}

- (NSDictionary *)movieTypeDic {
    if (_movieTypeDic == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"movieType.plist" ofType:nil];
        _movieTypeDic = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    
    return _movieTypeDic;
}

- (void)setupSubViews {
    // 视图添加点击事件
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self addGestureRecognizer:tapGestureRecognizer];
    
    // 海报图片
    UIImageView *posterImageView = [[UIImageView alloc] init];
    posterImageView.contentMode = UIViewContentModeScaleAspectFill;
    posterImageView.clipsToBounds = YES;
    [self addSubview:posterImageView];
    self.posterImageView = posterImageView;
    
    // 电影名
    UILabel *movieNameLbl = [[UILabel alloc] init];
    movieNameLbl.font = [UIFont systemFontOfSize:TitleFontSize];
    [self addSubview:movieNameLbl];
    self.movieNameLbl = movieNameLbl;
    
    // 电影评分
    UIButton *gradeBtn = [[UIButton alloc] init];
    gradeBtn.userInteractionEnabled = NO;
    gradeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [gradeBtn setBackgroundImage:[UIImage resizedImageWithName:@"main_badge"] forState:UIControlStateNormal];
    [self addSubview:gradeBtn];
    self.gradeBtn = gradeBtn;
    
    // 电影类型
    UIImageView *movieType = [[UIImageView alloc] init];
    movieType.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:movieType];
    self.movieType = movieType;
    
    // 导演名字
    UILabel *directorNameLbl = [[UILabel alloc] init];
    directorNameLbl.textColor = [UIColor grayColor];
    directorNameLbl.font = [UIFont systemFontOfSize:DetailFontSize];
    [self addSubview:directorNameLbl];
    self.directorNameLbl = directorNameLbl;
    
    // 上映日期
    UILabel *releaseDateLbl = [[UILabel alloc] init];
    releaseDateLbl.textColor = [UIColor grayColor];
    releaseDateLbl.font = [UIFont systemFontOfSize:DetailFontSize];
    [self addSubview:releaseDateLbl];
    self.releaseDateLbl = releaseDateLbl;
    
    // 电影简介
    CGFloat preferMaxWidth = [UIScreen mainScreen].bounds.size.width*0.7;
    UILabel *movieNotesLbl = [[UILabel alloc] init];
    movieNotesLbl.textColor = [UIColor grayColor];
    movieNotesLbl.font = [UIFont systemFontOfSize:13];
    movieNotesLbl.numberOfLines = 2;
    movieNotesLbl.preferredMaxLayoutWidth = preferMaxWidth;
    [self addSubview:movieNotesLbl];
    self.movieNotesLbl = movieNotesLbl;
}

- (void)setupAutoLayout {
    WS(weakSelf);
    int padding = 10;
    
    // 海报图片
    [self.posterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(padding).priorityLow();
        make.left.equalTo(weakSelf.mas_left).offset(padding);
        make.right.equalTo(weakSelf.movieNameLbl.mas_left).offset(-padding);
        make.size.mas_equalTo(CGSizeMake(PosterImageWidth, PosterImageHeight));
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-padding).priorityLow();
    }];
    
    // 电影名
    [self.movieNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.posterImageView.mas_top).offset(padding);
        make.left.equalTo(weakSelf.posterImageView.mas_right).offset(padding);
        make.height.mas_equalTo(20);
    }];
    
    // 电影评分
    [self.gradeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.movieNameLbl.mas_centerY);
        make.left.equalTo(weakSelf.movieNameLbl.mas_right).offset(padding/2);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(50);
    }];
    
    // 电影类型
    [self.movieType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.movieNameLbl.mas_centerY);
        make.left.equalTo(weakSelf.gradeBtn.mas_right).offset(padding);
        make.height.mas_equalTo(18);
//        make.width.mas_equalTo(60);
        make.right.lessThanOrEqualTo(weakSelf.mas_right).offset(-padding);
    }];
    
    // 导演名字
    [self.directorNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.movieNameLbl.mas_bottom).offset(padding);
        make.left.equalTo(weakSelf.posterImageView.mas_right).offset(padding);
        make.right.lessThanOrEqualTo(weakSelf.mas_right).offset(-padding);
    }];
    
    // 上映日期
    [self.releaseDateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.movieNameLbl.mas_bottom).offset(padding);
        make.left.equalTo(weakSelf.directorNameLbl.mas_right).offset(padding);
    }];
    
    // 电影简介
    [self.movieNotesLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.posterImageView.mas_right).offset(padding);
        make.right.equalTo(weakSelf.mas_right).offset(-padding);
        make.bottom.equalTo(weakSelf.posterImageView.mas_bottom);
    }];
    
    [self.movieNameLbl setContentCompressionResistancePriority:UILayoutPriorityDefaultLow
                                             forAxis:UILayoutConstraintAxisHorizontal];
    [self.movieNameLbl setContentHuggingPriority:UILayoutPriorityRequired
                               forAxis:UILayoutConstraintAxisHorizontal];
    [self.gradeBtn setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                       forAxis:UILayoutConstraintAxisHorizontal];
    [self.gradeBtn setContentHuggingPriority:UILayoutPriorityRequired
                                         forAxis:UILayoutConstraintAxisHorizontal];
    [self.movieType setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                       forAxis:UILayoutConstraintAxisHorizontal];
    [self.movieType setContentHuggingPriority:UILayoutPriorityRequired
                                         forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)setFilmInfo:(LXFilmInfo *)filmInfo {
    _filmInfo = filmInfo;
    
    [self.posterImageView sd_setImageWithURL:[NSURL URLWithString:filmInfo.cover] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.movieNameLbl.text = filmInfo.movieName;
    
    NSString  *gradeStr = [NSString stringWithFormat:@"%@分", filmInfo.rating];
    [self.gradeBtn setTitle:gradeStr forState:UIControlStateNormal];
    
    NSString *movieTypeName = self.movieTypeDic[filmInfo.displayType];
    self.movieType.image = [UIImage imageNamed:movieTypeName];
    
    self.directorNameLbl.text = [NSString stringWithFormat:@"导演：%@", filmInfo.director];
    self.movieNotesLbl.text = filmInfo.remarks;
}

/**
 *  视图点击事件
 *
 */
- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture {
    if ([self.delegate respondsToSelector:@selector(movieViewDidSelectWithFilmInfo:)]) {
        [self.delegate movieViewDidSelectWithFilmInfo:self.filmInfo];
    }
}

@end
