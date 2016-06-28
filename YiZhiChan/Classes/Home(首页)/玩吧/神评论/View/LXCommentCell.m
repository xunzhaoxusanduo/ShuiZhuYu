//
//  LXCommentCell.m
//  YiZhiChan
//
//  Created by wuyaju on 16/4/30.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXCommentCell.h"
#import "Masonry.h"
#import "Macros.h"
#import "UIImage+FEBoxBlur.h"
#import "LXComment.h"
#import "LXPhoto.h"
#import "UIImageView+WebCache.h"

#define PhotoCounts 3
#define PhotoViewHeight 80

@interface LXCommentCell ()

@property (nonatomic, strong)UILabel *title;
@property (nonatomic, strong)UILabel *detail;
@property (nonatomic, strong)NSMutableArray *photoViewArray;
// 分割线
@property (nonatomic, strong)UIView *divView;

@end

@implementation LXCommentCell

- (NSMutableArray *)photoViewArray {
    if (_photoViewArray == nil) {
        _photoViewArray = [NSMutableArray array];
    }
    
    return _photoViewArray;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubViews];
        [self setupAutoLayout];
    }
    
    return  self;
}

- (void)setupSubViews {
    UILabel *title = [[UILabel alloc] init];
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:TitleFontSize];
    title.numberOfLines = 1;
    [self.contentView addSubview:title];
    self.title = title;
    
    CGFloat preferMaxWidth = [UIScreen mainScreen].bounds.size.width - 10*2;
    
    UILabel *detail = [[UILabel alloc] init];
    detail.textColor = [UIColor whiteColor];
    detail.font = [UIFont systemFontOfSize:DetailFontSize];
    detail.numberOfLines = 0;
    detail.preferredMaxLayoutWidth = preferMaxWidth;
    [self.contentView addSubview:detail];
    self.detail = detail;
    
    for (int i = 0; i < PhotoCounts; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self.contentView addSubview:imageView];
        [self.photoViewArray addObject:imageView];
    }
}

- (void)setupAutoLayout {
    WS(weakSelf);
    int padding = 10;
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(padding);
        make.top.equalTo(weakSelf.contentView.mas_top).offset(padding);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-padding);
    }];
    
    [self.detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(padding);
        make.top.equalTo(weakSelf.title.mas_bottom).offset(padding);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-padding);
    }];
    
    __block UIImageView *lastImageView = nil;
    for (int i = 0; i < PhotoCounts; i++) {
        UIImageView *imageView = self.photoViewArray[i];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            //当是左边一列的时候
            if (i == 0) {
                make.left.equalTo(weakSelf.contentView.mas_left).offset(padding);
            }else {
                make.width.equalTo(lastImageView.mas_width);
                make.left.equalTo(lastImageView.mas_right).offset(padding);
            }
            
            if (i == 2) {
                make.right.equalTo(weakSelf.contentView.mas_right).offset(-padding);
            }
            
            make.top.equalTo(weakSelf.detail.mas_bottom).offset(padding);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-padding);
//            make.height.equalTo(imageView.mas_width);
            make.height.mas_equalTo(100);
        }];
        lastImageView = imageView;
    }
}

- (void)setComment:(LXComment *)comment {
    _comment = comment;
    self.title.text = comment.movieName;
    self.detail.text = comment.comment;
    
    for (int i = 0; i < PhotoCounts; i++) {
        UIImageView *imageView = self.photoViewArray[i];
        if (i < comment.imagesList.count) {
            imageView.hidden = NO;
            LXPhoto *photo = comment.imagesList[i];
            [imageView sd_setImageWithURL:[NSURL URLWithString:photo.images] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        }else {
            imageView.hidden = YES;
        }
    }
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
