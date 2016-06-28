//
//  LXBaseFriendTableViewCell.m
//  YiZhiChan
//
//  Created by wuyaju on 16/5/22.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXBaseFriendTableViewCell.h"

#define LXStatusTableBorder 20

@implementation LXBaseFriendTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupBaseSubViews];
        [self setupBaseAutoLayout];
    }
    
    return  self;
}

- (void)setupBaseSubViews {
    // 个人信息
    LXPersonInfoView *personInfoView = [[LXPersonInfoView alloc] init];
    [self.contentView addSubview:personInfoView];
    self.personInfoView = personInfoView;
}

- (void)setupBaseAutoLayout {
    WS(weakSelf);
    
    // 个人信息
    [self.personInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.contentView);
    }];
}

@end
