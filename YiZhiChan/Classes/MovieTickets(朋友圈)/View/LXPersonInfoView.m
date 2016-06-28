//
//  LXPersonInfoView.m
//  YiZhiChan
//
//  Created by wuyaju on 16/5/21.
//  Copyright © 2016年 吴亚举. All rights reserved.
//  个人信息View

#import "LXPersonInfoView.h"
#import "Masonry.h"
#import "Macros.h"
#import "UIImageView+WebCache.h"
#import "UIImage+FEBoxBlur.h"
#import "UIButton+WebCache.h"
#import "UIButton+Extension.h"
#import "LXBaseFriend.h"
#import "LXFriendInfo.h"

#define IconWidthHeight     42
#define BtnWidth            50
#define BtnHeight           17

@interface LXPersonInfoView ()

// 头像
@property (nonatomic, strong)UIButton *iconBtn;
// 昵称
@property (nonatomic, strong)UILabel *nickLbl;
// 等级
@property (nonatomic, strong)UIImageView *levelImageView;
// 动态发布时间
@property (nonatomic, strong)UILabel *createLbl;
// 点赞数
@property (nonatomic, strong)UIButton *commentsBtn;
// 评论数
@property (nonatomic, strong)UIButton *attitudesBtn;
@property (nonatomic, strong)UIView *divView;

@end

@implementation LXPersonInfoView

- (instancetype)init {
    if (self = [super init]) {
        [self setupSubViews];
        [self setupAutoLayout];
    }
    
    return self;
}

- (void)setupSubViews {
    // 头像
    UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    iconBtn.layer.cornerRadius = IconWidthHeight / 2;
    iconBtn.layer.masksToBounds = YES;
    [iconBtn addTarget:self action:@selector(iconClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:iconBtn];
    self.iconBtn = iconBtn;
    
    // 昵称
    UILabel *nickLbl = [[UILabel alloc] init];
    nickLbl.textColor = RGB(14, 111, 223);
//    nickLbl.font = [UIFont fontWithName:@"微软雅黑" size:5];
    nickLbl.font = [UIFont systemFontOfSize:15];
    [self addSubview:nickLbl];
    self.nickLbl = nickLbl;
    
    // 等级
    UIImageView *levelImageView = [[UIImageView alloc] init];
    levelImageView.contentMode = UIViewContentModeScaleAspectFit;
    levelImageView.clipsToBounds = YES;
    [self addSubview:levelImageView];
    self.levelImageView = levelImageView;
    
    // 动态发布时间
    UILabel *createLbl = [[UILabel alloc] init];
    createLbl.font = [UIFont systemFontOfSize:12];
    createLbl.textColor = [UIColor lightGrayColor];
    [self addSubview:createLbl];
    self.createLbl = createLbl;
    
    // 点赞数
    UIButton *attitudesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [attitudesBtn setImage:[UIImage imageNamed:@"play_attitude_gray"] forState:UIControlStateNormal];
    [attitudesBtn setImage:[UIImage imageNamed:@"play_attitude_select"] forState:UIControlStateSelected];
    attitudesBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    attitudesBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    attitudesBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    attitudesBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [attitudesBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [attitudesBtn addTarget:self action:@selector(attitudeClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:attitudesBtn];
    self.attitudesBtn = attitudesBtn;
    
    // 评论数
    UIButton *commentsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentsBtn setImage:[UIImage imageNamed:@"play_comment_gray"] forState:UIControlStateNormal];
    commentsBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    commentsBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    commentsBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    commentsBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [commentsBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [commentsBtn addTarget:self action:@selector(commentClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:commentsBtn];
    self.commentsBtn = commentsBtn;
}

- (void)setupAutoLayout {
    WS(weakSelf);
    int padding = 10;
    
    // 头像
    [self.iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(3 * padding).priorityLow();
        make.left.equalTo(weakSelf.mas_left).offset(padding);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-padding).priorityLow();
        make.size.mas_equalTo(CGSizeMake(IconWidthHeight, IconWidthHeight));
    }];
    
    // 昵称
    [self.nickLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.iconBtn.mas_centerY);
        make.left.equalTo(weakSelf.iconBtn.mas_right).offset(padding);
    }];
    
    
    // 等级
    [self.levelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nickLbl.mas_right).offset(padding);
        make.centerY.equalTo(weakSelf.nickLbl.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(35, 15));
    }];
    
    // 动态发布时间
    [self.createLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nickLbl.mas_bottom).offset(padding / 4);
        make.left.equalTo(weakSelf.iconBtn.mas_right).offset(padding);
    }];
    
    // 点赞数
    [self.attitudesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.iconBtn.mas_centerY);
        make.right.equalTo(weakSelf.commentsBtn.mas_left);
        make.size.equalTo(weakSelf.commentsBtn);
    }];
    
    // 评论数
    [self.commentsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.iconBtn.mas_centerY);
        make.right.equalTo(weakSelf.mas_right).offset(-padding);
        make.size.mas_equalTo(CGSizeMake(BtnWidth, BtnHeight));
    }];
}

- (void)setFriend:(LXBaseFriend *)friend {
    _friend = friend;
    
    LXFriendInfo *friendInfo = friend.userInfo;
    
    // 头像
    [self.iconBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:friendInfo.userImg] forState:UIControlStateNormal];
    
    // 昵称
    if (friendInfo.userName.length > 6) {
        NSString *str = [[friendInfo.userName substringToIndex:6] stringByAppendingString:@"…"];
        self.nickLbl.text = str;
    }else {
        self.nickLbl.text = friendInfo.userName;
    }
    
    // 发表时间
    self.createLbl.text = friend.formatAddTime;
    
    // 等级
    NSString *levelImageName = [NSString stringWithFormat:@"me_%ldlevel", [friendInfo.level integerValue]];
    self.levelImageView.image = [UIImage imageNamed:levelImageName];
    
    // 点赞数
    [self.attitudesBtn setupOriginalTitle:@"赞" count:[friend.praiseCount integerValue]];
    self.attitudesBtn.selected = friend.currUserLike.boolValue;
    
    // 评论数
    [self.commentsBtn setupOriginalTitle:@"评论" count:[friend.replyCount integerValue]];
}

//// 自绘分割线
//- (void)drawRect:(CGRect)rect
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetStrokeColorWithColor(context, RGBA(199, 199, 199, 1).CGColor);
//    CGContextStrokeRect(context, CGRectMake(0, rect.size.height - 1, rect.size.width, 0.5));
//}

/**
 *  头像点击事件
 */
- (void)iconClicked {
    if ([self.delegate respondsToSelector:@selector(iconDidSelectWithInfo:)]) {
        [self.delegate iconDidSelectWithInfo:self.friend];
    }
}

/**
 *  点赞点击事件
 */
- (void)attitudeClicked:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(attitudeDidSelectWithInfo:withBtn:withCell:)]) {
        [self.delegate attitudeDidSelectWithInfo:self.friend withBtn:btn withCell:btn.superview.superview.superview];
    }
}

/**
 *  评论点击事件
 */
- (void)commentClicked {
    if ([self.delegate respondsToSelector:@selector(commentDidSelectWithInfo:)]) {
        [self.delegate commentDidSelectWithInfo:self.friend];
    }
}

@end
