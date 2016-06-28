//
//  LXSuspendCollectionView.m
//  自定义collectionview
//
//  Created by wuyaju on 16/4/21.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXSuspendCollectionView.h"
#import "LXSuspenditemManager.h"
#import "LXSuspenditem.h"
#import "LXSuspenditemView.h"

@interface LXSuspendCollectionView () <LXSuspenditemViewDelegate>

@property (nonatomic, assign)CGRect moveFrame;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)NSMutableArray *btnArray;

@end

@implementation LXSuspendCollectionView

- (NSMutableArray *)btnArray {
    if (_btnArray == nil) {
        _btnArray = [NSMutableArray array];
    }
    
    return _btnArray;
}

/**
 *  初始化自定义collectionview
 *
 *  @param visibleFrame            图标可移动的区域
 *  @param moveFrame               图标可停靠的区域
 *  @param itemSize                图标的尺寸
 *  @param sectionInset            自定义collectionview的内边距
 *  @param minimumLineSpacing      列与列之间的间距
 *  @param minimumInteritemSpacing 一行内图标之间的间距
 *
 *  @return 自定义collectionview对象
 */
- (instancetype)initWithVisibleFrame:(CGRect)visibleFrame withMoveFrame:(CGRect)moveFrame
                                itemSize:(CGSize)itemSize
                                sectionInset:(UIEdgeInsets)sectionInset
                                minimumLineSpacing:(CGFloat)minimumLineSpacing
                                minimumInteritemSpacing:(CGFloat)minimumInteritemSpacing{
    if (self = [super initWithFrame:visibleFrame]) {
        self.itemSize = itemSize;
        self.sectionInset = sectionInset;
        self.moveFrame = moveFrame;
        self.minimumLineSpacing = self.minimumLineSpacing<0 ? 0 : minimumLineSpacing;
        self.minimumInteritemSpacing = self.minimumInteritemSpacing<0 ? 0 : minimumInteritemSpacing;
        
//        self.backgroundColor = [UIColor grayColor];
        
        self.dataArray = [LXSuspenditemManager suspenditems];
        // 如果为空，则可能是第一次启动，根据当前设置的坐标计算可划分为几行几列，并写入默认的图标排列顺序
        if (self.dataArray.count == 0) {
            NSMutableArray *array = [NSMutableArray array];
            int hCount = 0;
            int vCount = 0;
            [self suspenditemCalculateWithFrame:self.moveFrame hCountAddr:&hCount vCountAddr:&vCount];
            for (int i = 0; i < hCount * vCount; i++) {
                LXSuspenditem *suspenditem = [[LXSuspenditem alloc] init];
                if (i == (hCount * vCount - 1)) {
                    suspenditem.imageName = @"home_suspend_play";
                    suspenditem.title = @"玩吧";
                    suspenditem.type = LXSuspenditemTypeEntity;
                }else if (i == (hCount * vCount - 2)) {
                    suspenditem.imageName = @"home_suspend_newMovie";
                    suspenditem.title = @"新影讯";
                    suspenditem.type = LXSuspenditemTypeEntity;
                }else if (i == (hCount * vCount - 3)) {
                    suspenditem.imageName = @"home_suspend_comment";
                    suspenditem.title = @"神评论";
                    suspenditem.type = LXSuspenditemTypeEntity;
                }else if (i == (hCount * vCount - 4)){
                    suspenditem.imageName = @"home_suspend_hot";
                    suspenditem.title = @"热度榜";
                    suspenditem.type = LXSuspenditemTypeEntity;
                }else {
                    suspenditem.imageName = nil;
                    suspenditem.title = nil;
                    suspenditem.type = LXSuspenditemTypePlaceholder;
                }
                [array addObject:suspenditem];
            }
            self.dataArray = array;
            [LXSuspenditemManager saveSuspenditems:self.dataArray];
        }
        
        for (int i = 0; i < self.dataArray.count; i++) {
            LXSuspenditem *suspenditem = self.dataArray[i];
            if (suspenditem.type == LXSuspenditemTypeEntity) {
                LXSuspenditemView *btn = [[LXSuspenditemView alloc] initWithFrame:CGRectZero andImage:[UIImage imageNamed:suspenditem.imageName] inView:self];
                [btn setTitle:suspenditem.title forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
                btn.tag = i;
                btn.delegate = self;
                [self addSubview:btn];
                [self.btnArray addObject:btn];
            }else {
                LXSuspenditemView *btn = [[LXSuspenditemView alloc] init];
                btn.enabled = NO;
                btn.tag = i;
                [self addSubview:btn];
                [self.btnArray addObject:btn];
            }
        }
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setButtonsFrameWithAnimate:NO withoutShakingButton:nil];
}

#pragma mark - 私有方法
- (void)clicked:(LXSuspenditemView *)suspenditemView {
    LXSuspenditemAction actionType = LXSuspenditemActionNone;
    if ([suspenditemView.titleLabel.text isEqualToString:@"玩吧"]) {
        actionType = LXSuspenditemActionPlay;
    }else if ([suspenditemView.titleLabel.text isEqualToString:@"新影讯"]) {
        actionType = LXSuspenditemActionNewMovie;
    }else if ([suspenditemView.titleLabel.text isEqualToString:@"神评论"]) {
        actionType = LXSuspenditemActionComment;
    }else if ([suspenditemView.titleLabel.text isEqualToString:@"热度榜"]) {
        actionType = LXSuspenditemActionHot;
    }
    
    if ([self.delegate respondsToSelector:@selector(suspendCollectionView:suspendType:)]) {
        [self.delegate suspendCollectionView:self suspendType:actionType];
    }
}

/**
 *  计算在指定的区域内可存放多少图标
 *
 *  @param frame      指定的区域
 *  @param hCountAddr 一行存放的数量的指针
 *  @param vCountAddr 可存放的行数的指针
 */
- (void)suspenditemCalculateWithFrame:(CGRect)frame hCountAddr:(int *)hCountAddr vCountAddr:(int *)vCountAddr {
    int hRender = ((int)(frame.size.width - self.sectionInset.left - self.sectionInset.right)) % ((int)(self.itemSize.width + self.minimumInteritemSpacing));
    int hCount = ((int)(frame.size.width - self.sectionInset.left - self.sectionInset.right)) / ((int)(self.itemSize.width + self.minimumInteritemSpacing));
    // 一行剩余的宽度还可以再放下一个item
    if ((hRender + self.minimumInteritemSpacing) >= self.itemSize.width) {
        hCount++;
    }
    // 因为item要平均分布一行，同时两边的item要贴近两边，而传入的minimumInteritemSpacing不一定能保证达到这个效果，需要重新计算
    self.minimumInteritemSpacing = ((int)(frame.size.width - self.sectionInset.left - self.sectionInset.right - hCount * self.itemSize.width)) / (hCount - 1);
    
    int vRender = ((int)(frame.size.height - self.sectionInset.top - self.sectionInset.bottom)) % ((int)(self.itemSize.height + self.minimumLineSpacing));
    int vCount = ((int)(frame.size.height - self.sectionInset.top - self.sectionInset.bottom)) / ((int)(self.itemSize.height + self.minimumLineSpacing));
    // 一列剩余的高度还可以再放下一个item
    if ((vRender + self.minimumLineSpacing) >= self.itemSize.height) {
        vCount++;
    }
    // 因为item要平均分布一列，同时上下的item要贴近顶部和底部，而传入的minimumLineSpacing不一定能保证达到这个效果，需要重新计算
//    self.minimumLineSpacing = ((int)(frame.size.height - self.sectionInset.top - self.sectionInset.bottom - vCount * self.itemSize.height)) / (vCount - 1);
    
    *hCountAddr = hCount;
    *vCountAddr = vCount;
}

/**
 *  重新计算所有图标的坐标
 *
 *  @param shakingButton 正在移动的图标，不为空不计算正在移动的图标
 */
//- (void)layoutSuspenditemsWithoutShakingButton:(LXSuspenditemView *)shakingButton {
//    int hCount = 0;
//    int vCount = 0;
//    [self suspenditemCalculateWithFrame:self.moveFrame hCountAddr:&hCount vCountAddr:&vCount];
//    
//    CGFloat x = 0;
//    CGFloat y = 0;
//    CGRect frame;
//    if (shakingButton != nil) {
//        for (int i = 0; i < vCount; i++) {
//            for (int j = 0; j < hCount; j++) {
//                LXSuspenditemView *btn = (LXSuspenditemView *)self.btnArray[i*hCount + j];
//                if (btn.tag != shakingButton.tag) {
//                    x = self.sectionInset.left + j * (self.itemSize.width + self.minimumInteritemSpacing) + self.moveFrame.origin.x;
//                    y = self.sectionInset.top + i * (self.itemSize.height + self.minimumLineSpacing) + self.moveFrame.origin.y;
//                    frame = CGRectMake(x, y, self.itemSize.width, self.itemSize.height);
//                    btn.frame = frame;
//                }
//            }
//        }
//    }else {
//        for (int i = 0; i < vCount; i++) {
//            for (int j = 0; j < hCount; j++) {
//                x = self.sectionInset.left + j * (self.itemSize.width + self.minimumInteritemSpacing) + self.moveFrame.origin.x;
//                y = self.sectionInset.top + i * (self.itemSize.height + self.minimumLineSpacing) + self.moveFrame.origin.y;
//                frame = CGRectMake(x, y, self.itemSize.width, self.itemSize.height);
//                LXSuspenditemView *btn = (LXSuspenditemView *)self.btnArray[i*hCount + j];
//                btn.frame = frame;
//            }
//        }
//    }
//}

- (void)layoutSuspenditemsWithoutShakingButton:(LXSuspenditemView *)shakingButton {
    int hCount = 0;
    int vCount = 0;
    [self suspenditemCalculateWithFrame:self.moveFrame hCountAddr:&hCount vCountAddr:&vCount];
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGRect frame;
    if (shakingButton != nil) {
        for (int i = vCount - 1; i >= 0; i--) {
            for (int j = 0; j < hCount; j++) {
                LXSuspenditemView *btn = (LXSuspenditemView *)self.btnArray[i*hCount + j];
                if (btn.tag != shakingButton.tag) {
                    x = self.sectionInset.left + j * (self.itemSize.width + self.minimumInteritemSpacing) + self.moveFrame.origin.x;
                    // 如果是最后一行
                    if (i == (vCount - 1)) {
                        y = self.frame.size.height - self.sectionInset.bottom - self.itemSize.height;
                    }else {
                        y = self.frame.size.height - self.sectionInset.bottom - self.itemSize.height - (vCount - i - 1)*(self.itemSize.height + self.minimumLineSpacing);
                    }
                    frame = CGRectMake(x, y, self.itemSize.width, self.itemSize.height);
                    btn.frame = frame;
                }
            }
        }
    }else {
        for (int i = vCount - 1; i >= 0; i--) {
            for (int j = 0; j < hCount; j++) {
                x = self.sectionInset.left + j * (self.itemSize.width + self.minimumInteritemSpacing) + self.moveFrame.origin.x;
                // 如果是最后一行
                if (i == (vCount - 1)) {
                    y = self.frame.size.height - self.sectionInset.bottom - self.itemSize.height;
                }else {
                    y = self.frame.size.height - self.sectionInset.bottom - self.itemSize.height - (vCount - i - 1)*(self.itemSize.height + self.minimumLineSpacing);
                }
                frame = CGRectMake(x, y, self.itemSize.width, self.itemSize.height);
                LXSuspenditemView *btn = (LXSuspenditemView *)self.btnArray[i*hCount + j];
                btn.frame = frame;
            }
        }
    }
}

/**
 *  重新计算所有图标的坐标
 *
 *  @param animate       是否带动画效果
 *  @param shakingButton 正在移动的图标，不为空不计算正在移动的图标
 */
- (void)setButtonsFrameWithAnimate:(BOOL)animate withoutShakingButton:(LXSuspenditemView *)shakingButton
{
    if (animate) {
        [UIView animateWithDuration:0.3 animations:^{
            [self layoutSuspenditemsWithoutShakingButton:shakingButton];
        }];
    }else{
        [self layoutSuspenditemsWithoutShakingButton:shakingButton];
    }
}

#pragma mark - LXSuspenditemViewDelegate代理方法

/**
 *  检查正在移动的图标和其他图标是否交叉
 *
 *  @param shakingButton 正在移动的图标
 */
- (void)checkLocationOfOthersWithButton:(LXSuspenditemView *)shakingButton
{
    int indexOfShakingButton = 0;
    for ( int i = 0; i < self.btnArray.count; i++) {
        if (((LXSuspenditemView *)[self.btnArray objectAtIndex:i]).tag == shakingButton.tag) {
            indexOfShakingButton = i;
            break;
        }
    }
    for (int i = 0; i < self.btnArray.count; i++) {
        LXSuspenditemView *button = (LXSuspenditemView *)[self.btnArray objectAtIndex:i];
        if (button.tag != shakingButton.tag){
            if (CGRectContainsPoint(button.frame, shakingButton.center)) {
                [self.btnArray exchangeObjectAtIndex:i withObjectAtIndex:indexOfShakingButton];
                [self.dataArray exchangeObjectAtIndex:i withObjectAtIndex:indexOfShakingButton];
                [LXSuspenditemManager saveSuspenditems:self.dataArray];
                [self setButtonsFrameWithAnimate:YES withoutShakingButton:shakingButton];
                break;
            }
        }
    }
}

/**
 *  长按手势停止
 */
- (void)longPressGestureEnd {
    [self setButtonsFrameWithAnimate:YES withoutShakingButton:nil];
}

@end
