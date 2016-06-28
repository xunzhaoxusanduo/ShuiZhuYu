//
//  LXSuspendCollectionView.h
//  自定义collectionview
//
//  Created by wuyaju on 16/4/21.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LXSuspendCollectionView;

typedef NS_ENUM(NSInteger, LXSuspenditemAction) {
    LXSuspenditemActionHot = 0,
    LXSuspenditemActionComment,
    LXSuspenditemActionNewMovie,
    LXSuspenditemActionPlay,
    LXSuspenditemActionNone
};

@protocol LXSuspendCollectionViewDelegate <NSObject>

@optional
- (void)suspendCollectionView:(LXSuspendCollectionView *)collectionView suspendType:(LXSuspenditemAction)actionType;

@end

@interface LXSuspendCollectionView : UIView

@property (nonatomic, assign) CGFloat minimumLineSpacing;
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) UIEdgeInsets sectionInset;
@property (nonatomic, weak)id<LXSuspendCollectionViewDelegate> delegate;

- (instancetype)initWithVisibleFrame:(CGRect)visibleFrame withMoveFrame:(CGRect)moveFrame
                            itemSize:(CGSize)itemSize
                        sectionInset:(UIEdgeInsets)sectionInset
                  minimumLineSpacing:(CGFloat)minimumLineSpacing
             minimumInteritemSpacing:(CGFloat)minimumInteritemSpacing;

//@property (nonatomic, strong) NSMutableArray *upButtons;
//
//- (void)addItems;
//- (void)setUpButtonsFrameWithAnimate:(BOOL)_bool withoutShakingButton:(UIDragButton *)shakingButton;
//- (void)setDownButtonsFrameWithAnimate:(BOOL)_bool withoutShakingButton:(UIDragButton *)shakingButton;

@end
