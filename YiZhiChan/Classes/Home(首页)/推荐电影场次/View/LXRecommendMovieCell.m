//
//  LXRecommendMovieCell.m
//  YiZhiChan
//
//  Created by wuyaju on 16/4/27.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXRecommendMovieCell.h"
#import "LXRecommendMovieView.h"
#import "LXCellHeaderView.h"
#import "Masonry.h"
#import "Macros.h"
#import "LXCellHeader.h"

#define MovieCounts         6

@interface LXRecommendMovieCell ()

@property (nonatomic, strong)UIView *movieBgView;
@property (nonatomic, strong)NSMutableArray *movieArray;

@end

@implementation LXRecommendMovieCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubViews];
        [self setupAutoLayout];
    }
    
    return  self;
}

- (void)setupSubViews {
    self.backgroundColor = HomeCellBackgroundColour;
    
    UIView *movieBgView = [[UIView alloc] init];
    movieBgView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:movieBgView];
    self.movieBgView = movieBgView;
    
    for (int i = 0; i < MovieCounts; i++) {
        LXRecommendMovieView *movieView = [[LXRecommendMovieView alloc] init];
        movieView.clipsToBounds = YES;
        movieView.tag = i;
        [self.movieBgView addSubview:movieView];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [movieView addGestureRecognizer:tapGestureRecognizer];
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    if ([sender.view isKindOfClass:[LXRecommendMovieView class]]) {
        for (int i = 0; i < [self.movieBgView.subviews count]; i++) {
            LXRecommendMovieView *movieView = self.movieBgView.subviews[i];
            if (movieView.tag == sender.view.tag) {
                if ([self.delegate respondsToSelector:@selector(didSelectImage:)]) {
                    if ((self.recommendMovieArray != nil) && (i < self.recommendMovieArray.count)) {
                        [self.delegate didSelectImage:self.recommendMovieArray[i]];
                    }
                }
            }
        }
    }
}

- (void)setupAutoLayout {
    WS(weakSelf);
    int padding = 10;
    
    [self.movieBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView);
    }];
    
    __block LXRecommendMovieView *lastMovieView = nil;
    
    for (int i = 0; i < [self.movieBgView.subviews count]; i++) {
        LXRecommendMovieView *movieView = (LXRecommendMovieView *)self.movieBgView.subviews[i];
        
       [movieView mas_remakeConstraints:^(MASConstraintMaker *make) {
            //当是左边一列的时候
            if (i%3 == 0) {
                make.left.equalTo(weakSelf.movieBgView.mas_left).offset(padding);
            }else {
                make.width.equalTo(lastMovieView.mas_width);
                make.left.equalTo(lastMovieView.mas_right).offset(padding);
            }
            
            // 最右边一列
            if (i % 3 == 2) {
                make.right.equalTo(weakSelf.movieBgView.mas_right).offset(-padding);
            }
            
            // 第一行
            if (i / 3 == 0) {
                make.top.equalTo(weakSelf.movieBgView.mas_top).offset(padding);
            }else if (i / 3 == 1) { // 第二行
                make.top.equalTo(weakSelf.movieBgView.subviews[i % 3].mas_bottom).offset(padding);
                make.bottom.equalTo(weakSelf.movieBgView.mas_bottom).offset(-padding).priorityLow();
            }
            
            make.height.equalTo(movieView.mas_width).multipliedBy(1.9);
        }];
        
        lastMovieView = movieView;
    }
}

- (void)setRecommendMovieArray:(NSArray *)recommendMovieArray {
    _recommendMovieArray = recommendMovieArray;
    
    for (int i = 0; i < [self.recommendMovieArray count]; i++) {
        LXRecommendMovieView *movieView = (LXRecommendMovieView *)self.movieBgView.subviews[i];
        movieView.recommendMovie = recommendMovieArray[i];
    }
}

@end
