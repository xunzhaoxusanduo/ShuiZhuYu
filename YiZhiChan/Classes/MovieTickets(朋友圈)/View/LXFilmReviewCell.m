//
//  LXFilmReviewCell.m
//  YiZhiChan
//
//  Created by wuyaju on 16/5/22.
//  Copyright © 2016年 吴亚举. All rights reserved.
//  影评cell

#import "LXFilmReviewCell.h"
#import "LXMovieView.h"
#import "LXFilmReview.h"

@interface LXFilmReviewCell ()

// 发表的文字
@property (nonatomic, strong)LXContentView *textView;

@property (nonatomic, strong)NSMutableArray *constraintsArray;

// 影评顶部与个人信息底部的约束
@property (nonatomic, strong)MASConstraint *movieViewTopConstraint;

@end

@implementation LXFilmReviewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubViews];
        [self setupAutoLayout];
    }
    
    return  self;
}

- (NSMutableArray *)constraintsArray {
    if (_constraintsArray == nil) {
        _constraintsArray = [NSMutableArray array];
    }
    
    return _constraintsArray;
}

- (void)setupSubViews {

    // 发表的文字
    LXContentView *textView = [[LXContentView alloc] init];
    [self.contentView addSubview:textView];
    self.textView = textView;
    
    // 电影简介
    LXMovieView *movieView = [[LXMovieView alloc] init];
    movieView.backgroundColor = RGB(239, 239, 239);
    [self.contentView addSubview:movieView];
    self.movieView = movieView;
}

- (void)setupAutoLayout {
    WS(weakSelf);
    int padding = 10;
    
    // 发表的文字
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.personInfoView.mas_bottom);
        make.left.right.equalTo(weakSelf.contentView);
    }];
    
    [self.movieView mas_makeConstraints:^(MASConstraintMaker *make) {
        self.movieViewTopConstraint = make.top.equalTo(weakSelf.textView.mas_bottom);
        make.top.equalTo(weakSelf.personInfoView.mas_bottom).offset(10).priorityLow();
        make.left.right.equalTo(weakSelf.contentView);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-3 * padding);
    }];
}

- (void)setFilmReview:(LXFilmReview *)filmReview {
    _filmReview = filmReview;
    
    // tell constraints they need updating
    [self setNeedsUpdateConstraints];
    
    // update constraints now so we can animate the change
    [self updateConstraintsIfNeeded];
}


- (void)updateConstraints {
    // 有文字
    if ((self.filmReview.content != nil) && (self.filmReview.content.length > 0)) {
        self.textView.hidden = NO;
        [self.movieViewTopConstraint activate];
        self.textView.friend = self.filmReview;
    }else { // 没有文字
        self.textView.hidden = YES;
        [self.movieViewTopConstraint deactivate];
    }

    // 朋友信息
    self.personInfoView.friend = self.filmReview;
    // 影评信息
    self.movieView.filmInfo = self.filmReview.movieInfo;
    
    //according to apple super should be called at end of method
    [super updateConstraints];
}

@end
