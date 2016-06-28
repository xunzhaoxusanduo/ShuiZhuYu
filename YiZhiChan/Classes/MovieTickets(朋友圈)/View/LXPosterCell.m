//
//  LXPosterCell.m
//  YiZhiChan
//
//  Created by wuyaju on 16/5/21.
//  Copyright © 2016年 吴亚举. All rights reserved.
//  海报秀cell

#import "LXPosterCell.h"
#import "LXPhotosView.h"
#import "LXPoster.h"

@interface LXPosterCell ()

// 发表的文字
@property (nonatomic, strong)LXContentView *textView;
// 发表的图片
@property (nonatomic, strong)LXPhotosView *photosView;
// 图片顶部与个人信息底部的约束
@property (nonatomic, strong)MASConstraint *photosViewTopConstraint;

@end

@implementation LXPosterCell

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
    
    // 发表的图片
    LXPhotosView *photosView = [[LXPhotosView alloc] init];
    [self.contentView addSubview:photosView];
    self.photosView = photosView;
}

- (void)setupAutoLayout {
    WS(weakSelf);

    // 发表的文字
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.personInfoView.mas_bottom);
        make.left.right.equalTo(weakSelf.contentView);
    }];

    // 发表的图片
    [self.photosView mas_makeConstraints:^(MASConstraintMaker *make) {
        self.photosViewTopConstraint = make.top.equalTo(weakSelf.textView.mas_bottom);
        make.top.equalTo(weakSelf.personInfoView.mas_bottom).offset(10).priorityLow();
        make.left.right.equalTo(weakSelf.contentView);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-20);
    }];
}

- (void)setPoster:(LXPoster *)poster {
    _poster = poster;

    // tell constraints they need updating
    [self setNeedsUpdateConstraints];
    // update constraints now so we can animate the change
    [self updateConstraintsIfNeeded];
}

- (void)updateConstraints {
    // 有文字
    if ((self.poster.content != nil) && (self.poster.content.length > 0)) {
        self.textView.hidden = NO;
        [self.photosViewTopConstraint activate];
        self.textView.friend = self.poster;
    }else { // 没有文字
        self.textView.hidden = YES;
        [self.photosViewTopConstraint deactivate];
    }
    
    self.personInfoView.friend = self.poster;
    self.textView.friend = self.poster;
    self.photosView.photosArray = self.poster.files;
    
    //according to apple super should be called at end of method
    [super updateConstraints];
}

@end

////
////  LXPosterCell.m
////  YiZhiChan
////
////  Created by wuyaju on 16/5/21.
////  Copyright © 2016年 吴亚举. All rights reserved.
////  海报秀cell
//
//#import "LXPosterCell.h"
//#import "LXPhotosView.h"
//#import "LXPoster.h"
//
//@interface LXPosterCell ()
//
//@property (nonatomic, strong)UIView *view;
//// 发表的文字
//@property (nonatomic, strong)LXContentView *textView;
//// 发表的图片
//@property (nonatomic, strong)LXPhotosView *photosView;
//
//@property (nonatomic, strong)MASConstraint *photosViewTopConstraint;
//@property (nonatomic, strong)MASConstraint *viewConstraint;
//@end
//
//@implementation LXPosterCell
//
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        [self setupSubViews];
//        [self setupAutoLayout];
//    }
//    
//    return  self;
//}
//
//- (void)setupSubViews {
//    UIView *view = [[UIView alloc] init];
//    [self.contentView addSubview:view];
//    self.view = view;
//    
//    // 发表的文字
//    LXContentView *textView = [[LXContentView alloc] init];
//    [self.view addSubview:textView];
//    self.textView = textView;
//    
//    // 发表的图片
//    LXPhotosView *photosView = [[LXPhotosView alloc] init];
//    photosView.backgroundColor = [UIColor redColor];
//    [self.contentView addSubview:photosView];
//    self.photosView = photosView;
//}
//
//- (void)setupAutoLayout {
//    WS(weakSelf);
//    
//    [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.personInfoView.mas_bottom);
//        make.left.right.equalTo(weakSelf.contentView);
//        self.viewConstraint = make.height.mas_equalTo(0).priority(UILayoutPriorityRequired);
//        [self.viewConstraint deactivate];
//    }];
//    
//    // 发表的文字
//    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.top.equalTo(weakSelf.personInfoView.mas_bottom);
////        make.left.right.equalTo(weakSelf.contentView);
//        make.edges.equalTo(weakSelf.view).with.priorityLow();
//    }];
//    
//    // 发表的图片
//    [self.photosView mas_makeConstraints:^(MASConstraintMaker *make) {
//        self.photosViewTopConstraint = make.top.equalTo(weakSelf.view.mas_bottom);
////        make.top.equalTo(weakSelf.personInfoView.mas_bottom).with.priorityLow();
//        make.left.right.bottom.equalTo(weakSelf.contentView);
//    }];
//}
//
//- (void)setPoster:(LXPoster *)poster {
//    _poster = poster;
//    self.personInfoView.friend = poster;
//    self.textView.friend = poster;
//    self.photosView.photosArray = poster.files;
//}
//
//- (void)updateConstraints {
//    
//    // 有文字
//    if ((self.poster.content != nil) && (self.poster.content.length > 0)) {
//        self.textView.hidden = NO;
//        [self.viewConstraint deactivate];
//        self.textView.friend = self.poster;
//    }else { // 没有文字
//        self.textView.hidden = YES;
//        [self.viewConstraint activate];
//    }
//    
//    [super updateConstraints];
//}
//
//- (void)setPosterAutoLayout:(LXPoster *)posterAutoLayout {
//    _posterAutoLayout = posterAutoLayout;
//    
//    self.personInfoView.friend = posterAutoLayout;
//    self.textView.friend = posterAutoLayout;
//    self.photosView.photosArray = posterAutoLayout.files;
//    
//    // tell constraints they need updating
//    [self setNeedsUpdateConstraints];
//    // update constraints now so we can animate the change
//    [self updateConstraintsIfNeeded];
//}
//
//@end

