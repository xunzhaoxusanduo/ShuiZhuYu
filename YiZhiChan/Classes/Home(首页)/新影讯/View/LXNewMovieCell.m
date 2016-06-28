//
//  LXNewMovieCell.m
//  YiZhiChan
//
//  Created by wuyaju on 16/4/27.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXNewMovieCell.h"
#import "Masonry.h"
#import "Macros.h"
#import "LXNewMovie.h"
#import "UIImage+FEBoxBlur.h"
#import "UIImageView+WebCache.h"
#import "UIButton+Extension.h"

#define PosterImageWidth    80
#define PosterImageHeight   110

@interface LXNewMovieCell ()

// 海报图片
@property (nonatomic, strong)UIImageView *posterImageView;
// 标题
@property (nonatomic, strong)UILabel *titleLbl;
// 时间
@property (nonatomic, strong)UILabel *timeLbl;
// 点赞数
@property (nonatomic, strong)UIButton *commentsBtn;
// 评论数
@property (nonatomic, strong)UIButton *attitudesBtn;
// 分割线
@property (nonatomic, strong)UIView *divView;

@property (nonatomic, strong)MASConstraint *widthConstraint;

@end

@implementation LXNewMovieCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubViews];
        [self setupAutoLayout];
    }
    
    return  self;
}

- (void)setupSubViews {
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // 海报图片
    UIImageView *posterImageView = [[UIImageView alloc] init];
    posterImageView.contentMode = UIViewContentModeScaleAspectFill;
    posterImageView.clipsToBounds = YES;
    [self.contentView addSubview:posterImageView];
    self.posterImageView = posterImageView;
    
    // 标题
    CGFloat preferMaxWidth = [UIScreen mainScreen].bounds.size.width - 10 - PosterImageWidth - 10 - 10;
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.font = [UIFont systemFontOfSize:TitleFontSize];
    titleLbl.numberOfLines = 4;
    titleLbl.preferredMaxLayoutWidth = preferMaxWidth;
    [self.contentView addSubview:titleLbl];
    self.titleLbl = titleLbl;
    
    // 时间
    UILabel *timeLbl = [[UILabel alloc] init];
    timeLbl.textColor = [UIColor whiteColor];
    timeLbl.font = [UIFont systemFontOfSize:DetailFontSize];
    [self.contentView addSubview:timeLbl];
    self.timeLbl = timeLbl;
    
    // 点赞数
    UIButton *attitudesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [attitudesBtn setImage:[UIImage imageNamed:@"play_attitude"] forState:UIControlStateNormal];
    attitudesBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    attitudesBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    attitudesBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    attitudesBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self addSubview:attitudesBtn];
    self.attitudesBtn = attitudesBtn;
    
    // 评论数
    UIButton *commentsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentsBtn setImage:[UIImage imageNamed:@"play_comment"] forState:UIControlStateNormal];
    commentsBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    commentsBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    commentsBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    commentsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [commentsBtn sizeToFit];
    [commentsBtn.titleLabel sizeToFit];
    [self addSubview:commentsBtn];
    self.commentsBtn = commentsBtn;
}

- (void)setupAutoLayout {
    WS(weakSelf);
    int padding = 10;
    
    // 海报图片
    [self.posterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(padding).priorityLow();
        make.left.equalTo(weakSelf.contentView.mas_left).offset(padding);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-padding).priorityLow();
        make.right.equalTo(weakSelf.titleLbl.mas_left).offset(-padding);
        make.size.mas_equalTo(CGSizeMake(PosterImageWidth, PosterImageHeight));
    }];
    
    // 标题
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.posterImageView.mas_top);
        make.right.equalTo(weakSelf.mas_right).offset(-2*padding);
        make.left.equalTo(weakSelf.posterImageView.mas_right).offset(padding);
    }];
    
    // 时间
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.posterImageView.mas_right).offset(padding);
        make.bottom.equalTo(weakSelf.posterImageView.mas_bottom);
    }];
    
    // 点赞数
    [self.attitudesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.commentsBtn.mas_left);
        make.bottom.equalTo(weakSelf.posterImageView.mas_bottom);
        make.height.equalTo(weakSelf.commentsBtn.mas_height);
        make.width.mas_greaterThanOrEqualTo(50);
    }];
    
    // 评论数
    [self.commentsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right).offset(-padding);
        make.bottom.equalTo(weakSelf.posterImageView.mas_bottom);
        make.height.mas_equalTo(17);
        weakSelf.widthConstraint = make.width.mas_greaterThanOrEqualTo(50);
    }];
}

- (void)setMovieInfo:(LXNewMovie *)movieInfo {
    _movieInfo = movieInfo;
    
    [self.posterImageView sd_setImageWithURL:[NSURL URLWithString:movieInfo.thumbUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.titleLbl.text = movieInfo.title;
    self.timeLbl.text = movieInfo.addTime;
    [self.attitudesBtn setupOriginalTitle:@"赞" count:[movieInfo.praiseCount integerValue]];
    [self.commentsBtn setupOriginalTitle:@"评论" count:[movieInfo.commentCount integerValue]];
    
//    CGSize titleSize = [self.commentsBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}];
//    
//    self.widthConstraint.mas_equalTo(titleSize.width + self.commentsBtn.imageView.frame.size.width + self.commentsBtn.imageEdgeInsets.left + self.commentsBtn.imageEdgeInsets.right + self.commentsBtn.titleEdgeInsets.left + self.commentsBtn.titleEdgeInsets.right);
}

// 自绘分割线
- (void)drawRect:(CGRect)rect
{
    if (!self.lastRowInSection) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, RGBA(255, 255, 255, 0.15).CGColor);
        CGContextStrokeRect(context, CGRectMake(0, rect.size.height - 1, rect.size.width, 1));
    }
}

@end


////
////  LXNewMovieCell.m
////  YiZhiChan
////
////  Created by wuyaju on 16/4/27.
////  Copyright © 2016年 吴亚举. All rights reserved.
////
//
//#import "LXNewMovieCell.h"
//#import "Masonry.h"
//#import "Macros.h"
//#import "LXNewMovie.h"
//#import "UIImage+FEBoxBlur.h"
//#import "UIImageView+WebCache.h"
//
//#define PosterImageWidth    80
//#define PosterImageHeight   110
//
//@interface LXNewMovieCell ()
//
//// 海报图片
//@property (nonatomic, strong)UIImageView *posterImageView;
//// 电影名
//@property (nonatomic, strong)UILabel *movieNameLbl;
//// 电影评分
//@property (nonatomic, strong)UIButton *gradeBtn;
//// 电影类型
//@property (nonatomic, strong)UIImageView *movieType;
//// 导演名字
//@property (nonatomic, strong)UILabel *directorNameLbl;
//// 上映日期
//@property (nonatomic, strong)UILabel *releaseDateLbl;
//// 电影简介
//@property (nonatomic, strong)UILabel *movieNotesLbl;
//// 分割线
//@property (nonatomic, strong)UIView *divView;
//
//@property (nonatomic, strong)NSDictionary *movieTypeDic;
//
//@end
//
//@implementation LXNewMovieCell
//
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        [self setupSubViews];
//        [self setupAutoLayout];
//    }
//    
//    return  self;
//}
//
//- (NSDictionary *)movieTypeDic {
//    if (_movieTypeDic == nil) {
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"movieType.plist" ofType:nil];
//        _movieTypeDic = [NSDictionary dictionaryWithContentsOfFile:path];
//    }
//    
//    return _movieTypeDic;
//}
//
//- (void)setupSubViews {
//    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    
//    // 海报图片
//    UIImageView *posterImageView = [[UIImageView alloc] init];
//    posterImageView.contentMode = UIViewContentModeScaleAspectFill;
//    posterImageView.clipsToBounds = YES;
//    [self.contentView addSubview:posterImageView];
//    self.posterImageView = posterImageView;
//    
//    // 电影名
//    UILabel *movieNameLbl = [[UILabel alloc] init];
//    movieNameLbl.textColor = [UIColor whiteColor];
//    movieNameLbl.font = [UIFont boldSystemFontOfSize:TitleFontSize];
//    [self.contentView addSubview:movieNameLbl];
//    self.movieNameLbl = movieNameLbl;
//    
//    // 电影评分
//    UIButton *gradeBtn = [[UIButton alloc] init];
//    gradeBtn.userInteractionEnabled = NO;
//    gradeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    [gradeBtn setBackgroundImage:[UIImage resizedImageWithName:@"main_badge"] forState:UIControlStateNormal];
//    [self.contentView addSubview:gradeBtn];
//    self.gradeBtn = gradeBtn;
//    
//    // 电影类型
//    UIImageView *movieType = [[UIImageView alloc] init];
//    movieType.contentMode = UIViewContentModeScaleAspectFit;
//    [self.contentView addSubview:movieType];
//    self.movieType = movieType;
//    
//    // 导演名字
//    UILabel *directorNameLbl = [[UILabel alloc] init];
//    directorNameLbl.textColor = [UIColor whiteColor];
//    directorNameLbl.font = [UIFont systemFontOfSize:DetailFontSize];
//    [self.contentView addSubview:directorNameLbl];
//    self.directorNameLbl = directorNameLbl;
//    
//    // 上映日期
//    UILabel *releaseDateLbl = [[UILabel alloc] init];
//    releaseDateLbl.textColor = [UIColor whiteColor];
//    releaseDateLbl.font = [UIFont systemFontOfSize:DetailFontSize];
//    [self.contentView addSubview:releaseDateLbl];
//    self.releaseDateLbl = releaseDateLbl;
//    
//    // 电影简介
//    CGFloat preferMaxWidth = [UIScreen mainScreen].bounds.size.width*0.7;
//    UILabel *movieNotesLbl = [[UILabel alloc] init];
//    movieNotesLbl.textColor = [UIColor whiteColor];
//    movieNotesLbl.font = [UIFont systemFontOfSize:13];
//    movieNotesLbl.numberOfLines = 2;
//    movieNotesLbl.preferredMaxLayoutWidth = preferMaxWidth;
//    [self.contentView addSubview:movieNotesLbl];
//    self.movieNotesLbl = movieNotesLbl;
//}
//
//- (void)setupAutoLayout {
//    WS(weakSelf);
//    int padding = 10;
//    
//    // 海报图片
//    [self.posterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.contentView.mas_top).offset(padding).priorityLow();
//        make.left.equalTo(weakSelf.contentView.mas_left).offset(padding);
//        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-padding).priorityLow();
//        make.right.equalTo(weakSelf.movieNameLbl.mas_left).offset(-padding);
//        make.size.mas_equalTo(CGSizeMake(PosterImageWidth, PosterImageHeight));
//        
//    }];
//    
//    // 电影名
//    [self.movieNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.posterImageView.mas_top).offset(padding);
//        make.left.equalTo(weakSelf.posterImageView.mas_right).offset(padding);
//        make.height.mas_equalTo(10);
//    }];
//    
//    // 电影评分
//    [self.gradeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(weakSelf.movieNameLbl.mas_centerY);
//        make.left.equalTo(weakSelf.movieNameLbl.mas_right).offset(padding/2);
//        make.height.mas_equalTo(20);
//        make.width.mas_equalTo(50);
//    }];
//    
//    // 电影类型
//    [self.movieType mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(weakSelf.movieNameLbl.mas_centerY);
//        make.left.equalTo(weakSelf.gradeBtn.mas_right).offset(padding);
//        make.height.mas_equalTo(18);
////        make.width.mas_equalTo(60);
//        make.right.lessThanOrEqualTo(weakSelf.mas_right).offset(-padding);
//    }];
//    
//    // 导演名字
//    [self.directorNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.movieNameLbl.mas_bottom).offset(padding);
//        make.left.equalTo(weakSelf.posterImageView.mas_right).offset(padding);
//    }];
//    
//    // 上映日期
//    [self.releaseDateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.movieNameLbl.mas_bottom).offset(padding);
//        make.left.equalTo(weakSelf.directorNameLbl.mas_right).offset(padding);
//        make.right.lessThanOrEqualTo(weakSelf.mas_right).offset(-2);
//    }];
//    
//    // 电影简介
//    [self.movieNotesLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.posterImageView.mas_right).offset(padding);
//        make.right.equalTo(weakSelf.contentView.mas_right).offset(-padding);
//        make.bottom.equalTo(weakSelf.posterImageView.mas_bottom);
//    }];
//    
//    [self.movieNameLbl setContentCompressionResistancePriority:UILayoutPriorityDefaultLow
//                                                       forAxis:UILayoutConstraintAxisHorizontal];
//    [self.movieNameLbl setContentHuggingPriority:UILayoutPriorityRequired
//                                         forAxis:UILayoutConstraintAxisHorizontal];
//    [self.gradeBtn setContentCompressionResistancePriority:UILayoutPriorityRequired
//                                                   forAxis:UILayoutConstraintAxisHorizontal];
//    [self.gradeBtn setContentHuggingPriority:UILayoutPriorityRequired
//                                     forAxis:UILayoutConstraintAxisHorizontal];
//    [self.movieType setContentCompressionResistancePriority:UILayoutPriorityRequired
//                                                    forAxis:UILayoutConstraintAxisHorizontal];
//    [self.movieType setContentHuggingPriority:UILayoutPriorityRequired
//                                      forAxis:UILayoutConstraintAxisHorizontal];
//    
//    [self.directorNameLbl setContentCompressionResistancePriority:UILayoutPriorityDefaultLow
//                                                       forAxis:UILayoutConstraintAxisHorizontal];
//    [self.directorNameLbl setContentHuggingPriority:UILayoutPriorityRequired
//                                         forAxis:UILayoutConstraintAxisHorizontal];
//    [self.releaseDateLbl setContentCompressionResistancePriority:UILayoutPriorityRequired
//                                                    forAxis:UILayoutConstraintAxisHorizontal];
//    [self.releaseDateLbl setContentHuggingPriority:UILayoutPriorityRequired
//                                      forAxis:UILayoutConstraintAxisHorizontal];
//}
//
//- (void)setMovieInfo:(LXNewMovie *)movieInfo {
//    _movieInfo = movieInfo;
//    
//    [self.posterImageView sd_setImageWithURL:[NSURL URLWithString:movieInfo.cover] placeholderImage:[UIImage imageNamed:@"placeholder"]];
//    self.movieNameLbl.text = movieInfo.movieName;
//    
//    NSString  *gradeStr = [NSString stringWithFormat:@"%.1f分", movieInfo.rating.floatValue];
//    [self.gradeBtn setTitle:gradeStr forState:UIControlStateNormal];
//    
//    NSString *movieTypeName = self.movieTypeDic[movieInfo.displayType];
//    self.movieType.image = [UIImage imageNamed:movieTypeName];
//    
//    self.directorNameLbl.text = [NSString stringWithFormat:@"导演：%@", movieInfo.director];
//    
//    NSString *date = [movieInfo.releaseDate substringToIndex:9];
//    self.releaseDateLbl.text = [NSString stringWithFormat:@"%@上映", date];
//    
//    self.movieNotesLbl.text = movieInfo.remarks;
//}
//
//// 自绘分割线
//- (void)drawRect:(CGRect)rect
//{
//    if (!self.lastRowInSection) {
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGContextSetStrokeColorWithColor(context, RGBA(255, 255, 255, 0.15).CGColor);
//        CGContextStrokeRect(context, CGRectMake(0, rect.size.height - 1, rect.size.width, 1));
//    }
//}
//
////- (void)layoutSubviews {
////    [super layoutSubviews];
////    self.posterImageView.frame = CGRectMake(0, 0, PosterImageWidth, PosterImageHeight);
////    NSLog(@"%@", NSStringFromCGRect(self.bgView.frame));
////}
//
//@end
