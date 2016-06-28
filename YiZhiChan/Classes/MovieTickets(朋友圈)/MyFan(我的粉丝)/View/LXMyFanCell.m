//
//  LXMyFriendCell.m
//  YiZhiChan
//
//  Created by wuyaju on 16/5/17.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXMyFanCell.h"
#import "LXMyFan.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"
#import "Macros.h"

#define IconImageWidthHeight    35

@interface LXMyFanCell ()

@property (nonatomic, strong)UIImageView *iconImageView;
@property (nonatomic, strong)UILabel *nickNameLbl;

@end

@implementation LXMyFanCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"FanCellID";
    LXMyFanCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[LXMyFanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubViews];
        [self setupAutolayout];
    }
    
    return self;
}

- (void)setupSubViews {
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    iconImageView.layer.cornerRadius = IconImageWidthHeight / 2;
    iconImageView.clipsToBounds = YES;
    [self.contentView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    UILabel *nickNameLbl = [[UILabel alloc] init];
    [self.contentView addSubview:nickNameLbl];
    self.nickNameLbl = nickNameLbl;
}

- (void)setupAutolayout {
    WS(weakSelf);
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(IconImageWidthHeight, IconImageWidthHeight));
    }];
    
    [self.nickNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(10);
        make.top.bottom.equalTo(weakSelf.contentView);
    }];
}

- (void)setFan:(LXMyFan *)fan {
    _fan = fan;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:fan.userImg] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.nickNameLbl.text = fan.userName;
}

@end
