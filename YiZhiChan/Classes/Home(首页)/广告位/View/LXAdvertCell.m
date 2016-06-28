//
//  LXAdvertCell.m
//  YiZhiChan
//
//  Created by wuyaju on 16/4/27.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXAdvertCell.h"
#import "Masonry.h"
#import "LXAdvert.h"
#import "UIImage+FEBoxBlur.h"
#import "Macros.h"
#import "UIImageView+WebCache.h"
#import "SDWebImagePrefetcher.h"

@interface LXAdvertCell ()

@property (nonatomic, strong)UIImageView *advertImageView;
@property (nonatomic, strong)MASConstraint *heightConstraint;

@end

@implementation LXAdvertCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubViews];
        [self setupAutoLayout];
    }
    
    return  self;
}

- (void)setupSubViews {
    self.contentView.clipsToBounds = YES;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [self.contentView addSubview:imageView];
    self.advertImageView = imageView;
}

- (void)setupAutoLayout {
    WS(weakSelf);
    
    [self.advertImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.equalTo(self.contentView);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        weakSelf.heightConstraint = make.height.mas_equalTo(200).with.priorityHigh();
    }];
}

- (void)setAdvert:(LXAdvert *)advert {
    WS(weakSelf);
    
    _advert = advert;
    if ((advert.imageWidth != nil) && (advert.imageHeight != nil)) {
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = advert.imageHeight.integerValue * screenWidth / advert.imageWidth.integerValue;
        self.heightConstraint.mas_equalTo(height);
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
    }
    
    [self.advertImageView sd_setImageWithURL:[NSURL URLWithString:self.advert.imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        weakSelf.advertImageView.image = [UIImage scaleAspectFitWidthImageWithImage:image imageWidth:screenWidth];
    }];
}

- (void)updateConstraints {
    [super updateConstraints];
}

@end
