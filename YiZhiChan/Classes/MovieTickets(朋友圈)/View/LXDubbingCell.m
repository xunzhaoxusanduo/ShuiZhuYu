//
//  LXDubbingCell.m
//  YiZhiChan
//
//  Created by wuyaju on 16/5/24.
//  Copyright © 2016年 吴亚举. All rights reserved.
//  配音秀cell

#import "LXDubbingCell.h"
#import "LXVideoView.h"

@interface LXDubbingCell ()

// 发表的文字
@property (nonatomic, strong)LXContentView *textView;

@end

@implementation LXDubbingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubViews];
        [self setupAutoLayout];
    }
    
    return  self;
}

- (void)setupSubViews {
    // 发表的文字
    LXContentView *textView = [[LXContentView alloc] init];
    [self.contentView addSubview:textView];
    self.textView = textView;
    
    // 视频View
    LXVideoView *videoView = [[LXVideoView alloc] init];
    [self.contentView addSubview:videoView];
    self.videoView = videoView;
}

- (void)setupAutoLayout {
    WS(weakSelf);
    
    // 发表的文字
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.personInfoView.mas_bottom);
        make.left.right.equalTo(weakSelf.contentView);
    }];
    
    // 视频View
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.textView.mas_bottom);
//        make.left.right.equalTo(weakSelf.contentView);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(10);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-10);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-30);
    }];
}

- (void)setPoster:(LXPoster *)poster {
    _poster = poster;
    self.personInfoView.friend = poster;
    self.textView.friend = poster;
    self.videoView.poster = poster;
}

@end
