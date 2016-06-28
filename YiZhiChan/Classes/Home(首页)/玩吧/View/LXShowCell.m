//
//  LXShowCell.m
//  YiZhiChan
//
//  Created by wuyaju on 16/4/27.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXShowCell.h"
#import "Masonry.h"
#import "Macros.h"
#import "LXShow.h"
#import "UIImage+FEBoxBlur.h"
#import "UIButton+Extension.h"
#import "UIImageView+WebCache.h"
#import "LXPosterShow.h"
#import "LXSubTitleShow.h"

#define StatusBgImageHeight 30
#define Height              17

@interface LXShowCell ()

// 标题的背景
@property (nonatomic, strong)UIView *titleBgView;
// 标题
@property (nonatomic, strong)UILabel *title;
// 海报图片
@property (nonatomic, strong)UIImageView *posterImage;
// 点赞和评论数的背景图片
@property (nonatomic, strong)UIImageView *statusBgImageView;
// 点赞
@property (nonatomic, strong)UIButton *attitudeBtn;
// 评论
@property (nonatomic, strong)UIButton *commentBtn;

// 字幕背景
@property (nonatomic, strong)UIImageView *subTitleBgImageView;
// 字幕
@property (nonatomic, strong)UILabel *subTitleLbl;

@property (nonatomic, strong)MASConstraint *posterImageTopConstraint;
@property (nonatomic, strong)MASConstraint *heightConstraint;


@end

@implementation LXShowCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubViews];
        [self setupAutoLayout];
    }
    
    return  self;
}

- (void)setupSubViews {
    // 标题的背景
    UIView *titleBgView = [[UIView alloc] init];
    titleBgView.backgroundColor = RGBA(0, 0, 0, 0.4);
    [self.contentView addSubview:titleBgView];
    self.titleBgView = titleBgView;
    
    // 标题
    UILabel *title = [[UILabel alloc] init];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:TitleFontSize];
    [self.titleBgView addSubview:title];
    self.title = title;
    
    // 海报图片
    UIImageView *posterImage = [[UIImageView alloc] init];
    posterImage.contentMode = UIViewContentModeScaleAspectFill;
    posterImage.clipsToBounds = YES;
    [self.contentView addSubview:posterImage];
    self.posterImage = posterImage;
    
//    // 点赞和评论数的背景图片
//    UIImage *image = [UIImage imageNamed:@"play_statusBg"];
//    if (image.size.height > StatusBgImageHeight) {
//        CGSize size = CGSizeMake(image.size.width * (StatusBgImageHeight / image.size.height), StatusBgImageHeight);
//        image = [image reSizeImage:image toSize:size];
//    }
    
    UIImageView *statusBgImageView = [[UIImageView alloc] init];
//    statusBgImageView.image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    statusBgImageView.image = [UIImage imageNamed:@"play_statusBg"];
    [self.posterImage addSubview:statusBgImageView];
    self.statusBgImageView = statusBgImageView;
    
    // 点赞
    UIButton *attitudeBtn = [[UIButton alloc] init];
    [attitudeBtn setImage:[UIImage imageNamed:@"play_attitude"] forState:UIControlStateNormal];
    attitudeBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    attitudeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
    attitudeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:attitudeBtn];
    self.attitudeBtn = attitudeBtn;
    
    // 评论
    UIButton *commentBtn = [[UIButton alloc] init];
    [commentBtn setImage:[UIImage imageNamed:@"play_comment"] forState:UIControlStateNormal];
    commentBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    commentBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
    commentBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:commentBtn];
    self.commentBtn = commentBtn;
    
    // 字幕背景
    UIImageView *subTitleBgImageView = [[UIImageView alloc] init];
    subTitleBgImageView.image = [UIImage imageNamed:@"Bottom-bg"];
    [self.contentView addSubview:subTitleBgImageView];
    self.subTitleBgImageView = subTitleBgImageView;
    
    // 字幕
    UILabel *subTitleLbl = [[UILabel alloc] init];
    subTitleLbl.textAlignment = NSTextAlignmentCenter;
    subTitleLbl.textColor = [UIColor whiteColor];
    subTitleLbl.font = [UIFont systemFontOfSize:15];
    [self.subTitleBgImageView addSubview:subTitleLbl];
    self.subTitleLbl = subTitleLbl;
}

- (void)setupAutoLayout {
    int padding = 5;
    WS(weakSelf);
    
    // 标题的背景
    [self.titleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(40);
    }];
    
    //标题
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.titleBgView);
    }];
    
    // 海报图片
    [self.posterImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleBgView.mas_bottom).priorityLow();
        make.left.and.right.equalTo(weakSelf.contentView);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).priorityLow();
        make.height.mas_equalTo(150);
    }];
    
    // 点赞和评论数的背景图片
    [self.statusBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(130, StatusBgImageHeight));
        make.right.equalTo(weakSelf.contentView.mas_right);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-20);
    }];
    
    // 点赞
    [self.attitudeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.statusBgImageView.mas_left).offset(padding);
        make.centerY.equalTo(weakSelf.statusBgImageView.mas_centerY);
        make.right.equalTo(weakSelf.commentBtn.mas_left).offset(-padding);
        make.width.equalTo(weakSelf.commentBtn.mas_width);
        make.height.mas_equalTo(Height);
    }];
    
    // 评论
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.statusBgImageView.mas_right).offset(-padding);
        make.centerY.equalTo(weakSelf.statusBgImageView.mas_centerY);
        make.right.equalTo(weakSelf.statusBgImageView.mas_right).offset(-padding);
        make.width.equalTo(weakSelf.attitudeBtn.mas_width);
        make.height.mas_equalTo(Height);
    }];
    
    // 字幕背景
    [self.subTitleBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(30);
    }];
    
    // 字幕
    [self.subTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.subTitleBgImageView);
    }];

}

- (void)setPosterShow:(LXPosterShow *)posterShow {
    _posterShow = posterShow;
    self.title.text = @"海报秀";
    [self.posterImage sd_setImageWithURL:[NSURL URLWithString:posterShow.posterUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [self.attitudeBtn setupOriginalTitle:@"赞" count:[posterShow.praiseCount integerValue]];
    [self.commentBtn setupOriginalTitle:@"评论" count:[posterShow.commentCount integerValue]];
    self.subTitleBgImageView.hidden = YES;
}

- (void)setSubTitleShow:(LXSubTitleShow *)subTitleShow {
    _subTitleShow = subTitleShow;
    self.title.text = @"字幕秀";
    [self.posterImage sd_setImageWithURL:[NSURL URLWithString:subTitleShow.imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [self.attitudeBtn setupOriginalTitle:@"赞" count:[subTitleShow.praiseCount integerValue]];
    [self.commentBtn setupOriginalTitle:@"评论" count:[subTitleShow.commentCount integerValue]];
    self.subTitleBgImageView.hidden = NO;
    self.subTitleLbl.text = subTitleShow.subTitle;
}

//- (void)setShow:(LXShow *)show {
//    _show = show;
//    
//    // tell constraints they need updating
//    [self setNeedsUpdateConstraints];
//    // update constraints now so we can animate the change
//    [self updateConstraintsIfNeeded];
//}
//
//- (void)updateConstraints {
////    // 如果是第一个cell，则显示标题
////    if (self.firstRowInSection) {
////        self.titleBgView.hidden = NO;
////        [self.posterImageTopConstraint activate];
////        self.title.text = self.show.title;
////    }else { // 如果不是第一个cell，则不显示标题
////        self.titleBgView.hidden = YES;
////        [self.posterImageTopConstraint deactivate];
////    }
//    
//    [self.posterImageTopConstraint activate];
//    self.title.text = self.show.title;
//    
//    NSLog(@"----------------------------------------------- %d", self.firstRowInSection);
//    
//    self.posterImage.image = [UIImage imageNamed:self.show.posterImageUrl];
//    
////    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
////    self.posterImage.image = [UIImage scaleAspectFitWidthImageWithName:self.show.posterImageUrl imageWidth:screenWidth];
////    self.heightConstraint.mas_equalTo(self.posterImage.image.size.height);
////    if ([self.delegate respondsToSelector:@selector(showCellHeightDidChanged:)]) {
////        [self.delegate showCellHeightDidChanged:self];
////    }
//    
//    [self.attitudeBtn setupOriginalTitle:@"赞" count:[self.show.attitude integerValue]];
//    [self.commentBtn setupOriginalTitle:@"评论" count:[self.show.comment integerValue]];
//    
//    //according to apple super should be called at end of method
//    [super updateConstraints];
//}

@end


////
////  LXShowCell.m
////  YiZhiChan
////
////  Created by wuyaju on 16/4/27.
////  Copyright © 2016年 吴亚举. All rights reserved.
////
//
//#import "LXShowCell.h"
//#import "Masonry.h"
//#import "Macros.h"
//#import "LXShow.h"
//#import "UIImage+FEBoxBlur.h"
//#import "UIButton+Extension.h"
//#import "UIImageView+WebCache.h"
//
//#define StatusBgImageHeight 30
//#define Height              16
//
//@interface LXShowCell ()
//
//// 标题的背景
//@property (nonatomic, strong)UIView *titleBgView;
//// 标题
//@property (nonatomic, strong)UILabel *title;
//// 海报图片
//@property (nonatomic, strong)UIImageView *posterImage;
//// 点赞和评论数的背景图片
//@property (nonatomic, strong)UIImageView *statusBgImageView;
//// 点赞
//@property (nonatomic, strong)UIButton *attitudeBtn;
//// 评论
//@property (nonatomic, strong)UIButton *commentBtn;
//
//@property (nonatomic, strong)MASConstraint *heightConstraint;
//
//
//@end
//
//@implementation LXShowCell
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
//- (void)setupSubViews {
//    // 标题的背景
//    UIView *titleBgView = [[UIView alloc] init];
//    titleBgView.backgroundColor = RGBA(0, 0, 0, 0.4);
//    [self.contentView addSubview:titleBgView];
//    self.titleBgView = titleBgView;
//    
//    // 标题
//    UILabel *title = [[UILabel alloc] init];
//    title.textAlignment = NSTextAlignmentCenter;
//    title.textColor = [UIColor whiteColor];
//    title.font = [UIFont systemFontOfSize:TitleFontSize];
//    [self.titleBgView addSubview:title];
//    self.title = title;
//    
//    // 海报图片
//    UIImageView *posterImage = [[UIImageView alloc] init];
//    posterImage.contentMode = UIViewContentModeScaleAspectFill;
//    posterImage.clipsToBounds = YES;
//    [self.contentView addSubview:posterImage];
//    self.posterImage = posterImage;
//    
//    // 点赞和评论数的背景图片
//    UIImage *image = [UIImage imageNamed:@"play_statusBg"];
//    if (image.size.height > StatusBgImageHeight) {
//        CGSize size = CGSizeMake(image.size.width * (StatusBgImageHeight / image.size.height), StatusBgImageHeight);
//        image = [image reSizeImage:image toSize:size];
//    }
//    
//    UIImageView *statusBgImageView = [[UIImageView alloc] init];
//    statusBgImageView.image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
//    [self.posterImage addSubview:statusBgImageView];
//    self.statusBgImageView = statusBgImageView;
//    
//    // 点赞
//    UIButton *attitudeBtn = [[UIButton alloc] init];
//    [attitudeBtn setImage:[UIImage scaleAspectFitHeightImageWithName:@"play_attitude" imageHeight:Height] forState:UIControlStateNormal];
//    attitudeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
//    attitudeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//    [self.statusBgImageView addSubview:attitudeBtn];
//    self.attitudeBtn = attitudeBtn;
//    
//    // 评论
//    UIButton *commentBtn = [[UIButton alloc] init];
//    [commentBtn setImage:[UIImage scaleAspectFitHeightImageWithName:@"play_comment" imageHeight:Height] forState:UIControlStateNormal];
//    commentBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
//    commentBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//    [self.statusBgImageView addSubview:commentBtn];
//    self.commentBtn = commentBtn;
//}
//
//- (void)setupAutoLayout {
//    int padding = 5;
//    WS(weakSelf);
//    
//    // 标题的背景
//    [self.titleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.and.left.and.right.equalTo(weakSelf.contentView);
//        make.height.mas_equalTo(40);
//    }];
//    
//    //标题
//    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(weakSelf.titleBgView);
//    }];
//    
//    // 海报图片
//    [self.posterImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.titleBgView.mas_bottom);
//        make.left.and.right.equalTo(weakSelf.contentView);
//        make.width.equalTo(weakSelf.contentView.mas_width);
//        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
//        weakSelf.heightConstraint = make.height.mas_equalTo(200).with.priorityHigh();
//    }];
//    
//    //    // 点赞和评论数的背景图片
//    //    [self.statusBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//    //        make.size.mas_equalTo(CGSizeMake(150, StatusBgImageHeight));
//    //        make.right.equalTo(weakSelf.posterImage.mas_right);
//    //        make.bottom.equalTo(weakSelf.posterImage.mas_bottom).offset(-40);
//    //    }];
//    //
//    //    // 点赞
//    //    [self.attitudeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//    //        make.left.equalTo(weakSelf.statusBgImageView.mas_left).offset(padding);
//    //        make.centerY.equalTo(weakSelf.statusBgImageView.mas_centerY);
//    //        make.right.equalTo(weakSelf.commentBtn.mas_left).offset(-padding);
//    //        make.width.equalTo(weakSelf.commentBtn.mas_width);
//    //        make.height.mas_equalTo(Height);
//    //    }];
//    //
//    //    // 评论
//    //    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//    //        make.right.equalTo(weakSelf.statusBgImageView.mas_right).offset(-padding);
//    //        make.centerY.equalTo(weakSelf.statusBgImageView.mas_centerY);
//    //        make.right.equalTo(weakSelf.statusBgImageView.mas_right).offset(-padding);
//    //        make.width.equalTo(weakSelf.attitudeBtn.mas_width);
//    //        make.height.mas_equalTo(Height);
//    //    }];
//}
//
//- (void)setShow:(LXShow *)show {
//    _show = show;
//    
//    // tell constraints they need updating
//    [self setNeedsUpdateConstraints];
//    // update constraints now so we can animate the change
//    [self updateConstraintsIfNeeded];
//}
//
//- (void)updateConstraints {
//    self.title.text = self.show.title;
//    [self.posterImage sd_setImageWithURL:[NSURL URLWithString:self.show.posterUrl] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
//        self.posterImage.image = [UIImage scaleAspectFitWidthImageWithImage:image imageWidth:screenWidth];
//        self.heightConstraint.mas_equalTo(self.posterImage.image.size.height);
//        
//        if ([self.delegate respondsToSelector:@selector(showCellHeightDidChanged:)]) {
//            [self.delegate showCellHeightDidChanged:self];
//        }
//    }];
//    
//    //    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
//    //    self.posterImage.image = [UIImage scaleAspectFitWidthImageWithName:self.show.posterImageUrl imageWidth:screenWidth];
//    //    self.heightConstraint.mas_equalTo(self.posterImage.image.size.height);
//    //    if ([self.delegate respondsToSelector:@selector(showCellHeightDidChanged:)]) {
//    //        [self.delegate showCellHeightDidChanged:self];
//    //    }
//    
//    [self.attitudeBtn setupOriginalTitle:@"赞" count:[self.show.praiseCount integerValue]];
//    [self.commentBtn setupOriginalTitle:@"评论" count:[self.show.commentCount integerValue]];
//    
//    //according to apple super should be called at end of method
//    [super updateConstraints];
//}
//
//@end
