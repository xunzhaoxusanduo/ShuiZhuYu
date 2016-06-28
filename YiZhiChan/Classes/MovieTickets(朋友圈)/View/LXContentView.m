//
//  LXContentView.m
//  YiZhiChan
//
//  Created by wuyaju on 16/5/22.
//  Copyright © 2016年 吴亚举. All rights reserved.
//  发表的文字内容View

#import "LXContentView.h"
#import "Masonry.h"
#import "Macros.h"
#import "LXBaseFriend.h"

@interface LXContentView ()

// 发表文字内容
@property (nonatomic, strong)UILabel *textLbl;

@end

@implementation LXContentView

- (instancetype)init {
    if (self = [super init]) {
        [self setupSubViews];
        [self setupAutoLayout];
    }
    
    return self;
}

- (void)setupSubViews {
    // 发表的文字内容
    CGFloat preferMaxWidth = [UIScreen mainScreen].bounds.size.width - 10*2;
    
    UILabel *textLbl = [[UILabel alloc] init];
    textLbl.preferredMaxLayoutWidth = preferMaxWidth;
    textLbl.numberOfLines = 0;
    textLbl.font = [UIFont systemFontOfSize:15];
    [self addSubview:textLbl];
    self.textLbl = textLbl;
}

- (void)setupAutoLayout {
    WS(weakSelf);
    int padding = 10;
    
    [self.textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf).insets(UIEdgeInsetsMake(0, padding, padding, padding));
//        make.height.mas_equalTo(20);
    }];
}

- (void)setFriend:(LXBaseFriend *)friend {
    _friend = friend;
    
    self.textLbl.text = friend.content;
}

@end
