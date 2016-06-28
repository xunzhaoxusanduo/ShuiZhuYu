//
//  LXProgressView.m
//  YiZhiChan
//
//  Created by wuyaju on 16/6/2.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXProgressView.h"

@interface LXProgressView ()

@property (nonatomic, strong)UIView *trackView;
@property (nonatomic, strong)UIView *progressView;

@end

@implementation LXProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    UIView *trackView = [[UIView alloc] init];
    trackView.clipsToBounds = YES;
    [self addSubview:trackView];
    self.trackView = trackView;
    
    UIView *progressView = [[UIView alloc] init];
    progressView.clipsToBounds = YES;
    [self addSubview:progressView];
    self.progressView = progressView;
    
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.textAlignment = NSTextAlignmentRight;
    [self addSubview:titleLbl];
    self.titleLbl = titleLbl;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSLog(@"layoutSubviews");
    NSLog(@"%f", self.progress);
    
    self.trackView.frame = self.bounds;
    self.trackView.layer.cornerRadius = CGRectGetHeight(self.frame) / 2;
    
    self.progressView.frame = CGRectMake(0, 0, self.frame.size.width * self.progress, self.frame.size.height);
    self.progressView.layer.cornerRadius = CGRectGetHeight(self.frame) / 2;
    
    self.titleLbl.frame = CGRectMake(0, 0, self.frame.size.width - 10, self.frame.size.height);
}

- (void)setTrackTintColor:(UIColor *)trackTintColor {
    _trackTintColor = trackTintColor;
    self.trackView.backgroundColor = trackTintColor;
}

- (void)setProgressTintColor:(UIColor *)progressTintColor {
    _progressTintColor = progressTintColor;
    self.progressView.backgroundColor = progressTintColor;
}

@end
