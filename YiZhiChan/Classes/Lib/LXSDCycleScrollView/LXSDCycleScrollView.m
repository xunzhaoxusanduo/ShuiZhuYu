//
//  SDCycleScrollView.m
//  SDCycleScrollView
//
//  Created by aier on 15-3-22.
//  Copyright (c) 2015年 GSD. All rights reserved.
//


#import "LXSDCycleScrollView.h"
#import "LXSDCollectionViewCell.h"
#import "UIView+SDExtension.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "CVCLCoverFlowLayout.h"

static NSString * const ID = @"LXcycleCell";

@interface LXSDCycleScrollView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) NSInteger totalItemsCount;

@property (nonatomic, weak) UIImageView *backgroundImageView; // 当imageURLs为空时的背景图
@property (nonatomic, assign) NSInteger networkFailedRetryCount;

@property (nonatomic, strong)UIImageView *backImageView;

@property (nonatomic, weak)CVCLCoverFlowLayout *layout;
@property (nonatomic, weak) UICollectionView *mainView; // 显示图片的collectionView
@property (nonatomic, strong)NSIndexPath *curMidIndexPath;

@end

@implementation LXSDCycleScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialization];
        [self setupMainView];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initialization];
    [self setupMainView];
}

- (void)initialization
{
    _autoScrollTimeInterval = 2.0;
    _autoScroll = YES;
    _infiniteLoop = YES;
    _bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    self.backgroundColor = [UIColor lightGrayColor];
}

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame imageNamesGroup:(NSArray *)imageNamesGroup
{
    LXSDCycleScrollView *cycleScrollView = [[self alloc] initWithFrame:frame];
    cycleScrollView.localizationImageNamesGroup = [NSMutableArray arrayWithArray:imageNamesGroup];
    return cycleScrollView;
}

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame shouldInfiniteLoop:(BOOL)infiniteLoop imageNamesGroup:(NSArray *)imageNamesGroup
{
    LXSDCycleScrollView *cycleScrollView = [[self alloc] initWithFrame:frame];
    cycleScrollView.infiniteLoop = infiniteLoop;
    cycleScrollView.localizationImageNamesGroup = [NSMutableArray arrayWithArray:imageNamesGroup];
    return cycleScrollView;
}

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame imageURLStringsGroup:(NSArray *)imageURLsGroup
{
    LXSDCycleScrollView *cycleScrollView = [[self alloc] initWithFrame:frame];
    cycleScrollView.imageURLStringsGroup = [NSMutableArray arrayWithArray:imageURLsGroup];
    return cycleScrollView;
}

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame delegate:(id<LXSDCycleScrollViewDelegate>)delegate placeholderImage:(UIImage *)placeholderImage
{
    LXSDCycleScrollView *cycleScrollView = [[self alloc] initWithFrame:frame];
    cycleScrollView.delegate = delegate;
    cycleScrollView.placeholderImage = placeholderImage;
    
    return cycleScrollView;
}

// 设置显示图片的collectionView
- (void)setupMainView
{
    CVCLCoverFlowLayout *layout = [[CVCLCoverFlowLayout alloc]init];
    layout.cellSize = CGSizeMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.65);
    layout.cellInterval = layout.cellSize.width / 3;
    layout.reflection = NO;
    self.layout = layout;
    
    UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    mainView.backgroundColor = [UIColor clearColor];
    mainView.showsHorizontalScrollIndicator = YES;
    mainView.showsVerticalScrollIndicator = YES;
    [mainView registerClass:[LXSDCollectionViewCell class] forCellWithReuseIdentifier:ID];
    mainView.dataSource = self;
    mainView.delegate = self;
    mainView.scrollsToTop = NO;
    mainView.decelerationRate = 0.8;
    [self addSubview:mainView];
    _mainView = mainView;
    
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.contentMode = UIViewContentModeScaleToFill;
    [self insertSubview:backImageView atIndex:0];
    backImageView.frame = self.bounds;
    self.backImageView = backImageView;
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = self.bounds;
    [self.backImageView addSubview:visualEffectView];
}


#pragma mark - properties

- (void)setPlaceholderImage:(UIImage *)placeholderImage
{
    _placeholderImage = placeholderImage;
    
//    if (!self.backgroundImageView) {
//        UIImageView *bgImageView = [UIImageView new];
//        bgImageView.contentMode = UIViewContentModeScaleAspectFit;
//        [self insertSubview:bgImageView belowSubview:self.mainView];
//        self.backgroundImageView = bgImageView;
//    }
//    
//    self.backgroundImageView.image = placeholderImage;
}

- (void)setInfiniteLoop:(BOOL)infiniteLoop
{
    _infiniteLoop = infiniteLoop;
    
    if (self.imagePathsGroup.count) {
        self.imagePathsGroup = self.imagePathsGroup;
    }
}

-(void)setAutoScroll:(BOOL)autoScroll{
    _autoScroll = autoScroll;
    [_timer invalidate];
    _timer = nil;
    
    if (_autoScroll) {
        [self setupTimer];
    }
}

- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection
{
    _scrollDirection = scrollDirection;
    
    _flowLayout.scrollDirection = scrollDirection;
}

- (void)setAutoScrollTimeInterval:(CGFloat)autoScrollTimeInterval
{
    _autoScrollTimeInterval = autoScrollTimeInterval;
    
    [self setAutoScroll:self.autoScroll];
}

- (void)setImagePathsGroup:(NSArray *)imagePathsGroup
{
    if (imagePathsGroup.count < _imagePathsGroup.count) {
        [_mainView setContentOffset:CGPointZero animated:NO];
    }
    
    _imagePathsGroup = imagePathsGroup;
    
    _totalItemsCount = self.infiniteLoop ? self.imagePathsGroup.count * 10000 : self.imagePathsGroup.count;
    
    if (imagePathsGroup.count != 1) {
        self.mainView.scrollEnabled = YES;
        [self setAutoScroll:self.autoScroll];
    } else {
        self.mainView.scrollEnabled = NO;
    }

    [self.mainView reloadData];
    [self scrollViewDidScroll:self.mainView];
    
    if (_mainView.contentOffset.x == 0 &&  _totalItemsCount) {
        int targetIndex = 0;
        if (self.infiniteLoop) {
            targetIndex = _totalItemsCount * 0.5;
        }else{
            targetIndex = 0;
        }
        [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] animated:NO];
    }
    [self updayeBackImageView];
}

- (void)setImageURLStringsGroup:(NSArray *)imageURLStringsGroup
{
    _imageURLStringsGroup = imageURLStringsGroup;
    
    NSMutableArray *temp = [NSMutableArray new];
    [_imageURLStringsGroup enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * stop) {
        NSString *urlString;
        if ([obj isKindOfClass:[NSString class]]) {
            urlString = obj;
        } else if ([obj isKindOfClass:[NSURL class]]) {
            NSURL *url = (NSURL *)obj;
            urlString = [url absoluteString];
        }
        if (urlString) {
            [temp addObject:urlString];
        }
    }];
    self.imagePathsGroup = [temp copy];
}

- (void)setLocalizationImageNamesGroup:(NSArray *)localizationImageNamesGroup
{
    _localizationImageNamesGroup = localizationImageNamesGroup;
    self.imagePathsGroup = [localizationImageNamesGroup copy];
}

#pragma mark - actions

- (void)automaticScroll
{
    if (0 == _totalItemsCount) return;
    
    NSIndexPath *indexPath = [self currentIndex];
    if (indexPath) {
        NSInteger targetIndex = indexPath.item + 1;
        if (targetIndex >= _totalItemsCount) {
            if (self.infiniteLoop) {
                targetIndex = _totalItemsCount * 0.5;
                [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] animated:NO];
            }
            return;
        }
        [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] animated:YES];
    }
}

- (void)scrollToItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated{
    UICollectionViewLayoutAttributes *attr = [self.mainView layoutAttributesForItemAtIndexPath:indexPath];
    CGFloat offsetMidX = self.mainView.contentOffset.x + self.mainView.frame.size.width / 2;
    CGFloat offsetX = attr.center.x - offsetMidX;
    CGFloat distOffsetX = self.mainView.contentOffset.x + offsetX;
    [self.mainView setContentOffset:CGPointMake(distOffsetX, 0) animated:animated];
}

/**
 *  返回当前位于屏幕中央的cell的indexPath
 *
 */
- (NSIndexPath *)currentIndex
{
    CGFloat offsetMidX = self.mainView.contentOffset.x + self.mainView.frame.size.width / 2;
    NSIndexPath *indexPath = [self.mainView indexPathForItemAtPoint:CGPointMake(offsetMidX, self.mainView.bounds.size.height/ 2.0)];
    return indexPath;
}

- (void)setupTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)clearCache
{
    [[self class] clearImagesCache];
}

+ (void)clearImagesCache
{
    [[[SDWebImageManager sharedManager] imageCache] clearDisk];
}

#pragma mark - life circles
//解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
        [_timer invalidate];
        _timer = nil;
    }
}

//解决当timer释放后 回调scrollViewDidScroll时访问野指针导致崩溃
- (void)dealloc {
    _mainView.delegate = nil;
    _mainView.dataSource = nil;
}

#pragma mark - public actions


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _totalItemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    __block LXSDCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    long itemIndex = indexPath.item % self.imagePathsGroup.count;
    
    NSString *imagePath = self.imagePathsGroup[itemIndex];
    
    if ([imagePath isKindOfClass:[NSString class]]) {
        if ([imagePath hasPrefix:@"http"]) {
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:self.placeholderImage];
        } else {
            UIImage *image = [UIImage imageNamed:imagePath];
            if (!image) {
                [UIImage imageWithContentsOfFile:imagePath];
            }
            cell.imageView.image = image;
        }
    } else if ([imagePath isKindOfClass:[UIImage class]]) {
        cell.imageView.image = (UIImage *)imagePath;
    }
    
    cell.imageView.contentMode = self.bannerImageViewContentMode;
    cell.imageView.clipsToBounds = YES;
    
    // 下拉刷新及首次加载，更新cell阴影
    if (indexPath.item == self.curMidIndexPath.item) {
        cell.layer.shadowColor = [UIColor blackColor].CGColor;
        cell.layer.shadowRadius = 20;
        cell.layer.shadowOpacity = 1;
        cell.clipsToBounds = NO;
    }else {
        cell.layer.shadowColor = nil;
        cell.layer.shadowRadius = 0;
        cell.layer.shadowOpacity = 0;
        cell.clipsToBounds = YES;
    }
 
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didSelectItemAtIndex:)]) {
        [self.delegate cycleScrollView:self didSelectItemAtIndex:indexPath.item % self.imagePathsGroup.count];
    }
//    if (self.clickItemOperationBlock) {
//        self.clickItemOperationBlock(indexPath.item % self.imagePathsGroup.count);
//    }
}

- (void)updayeBackImageView {
    if (!self.imagePathsGroup.count) return; // 解决清除timer时偶尔会出现的问题
    
    // 获取当前屏幕中心所对应的indexPath
    NSIndexPath *indexPath = [self currentIndex];
    
    // 更新背景图片
    if (indexPath) {
        self.curMidIndexPath = indexPath;
        __block long itemIndex = indexPath.item % self.imagePathsGroup.count;
    
        NSString *imagePath = self.imagePathsGroup[itemIndex];
        
        if ([imagePath isKindOfClass:[NSString class]]) {
            if ([imagePath hasPrefix:@"http"]) {
                [self.backImageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            } else {
                UIImage *image = [UIImage imageNamed:imagePath];
                if (!image) {
                    [UIImage imageWithContentsOfFile:imagePath];
                }
                self.backImageView.image = image;
            }
        } else if ([imagePath isKindOfClass:[UIImage class]]) {
            self.backImageView.image = (UIImage *)imagePath;
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static long lastIndex = 0;
    
    if (!self.imagePathsGroup.count) return; // 解决清除timer时偶尔会出现的问题

    // 获取当前屏幕中心所对应的indexPath
    NSIndexPath *indexPath = [self currentIndex];
    
    // 更新cell阴影
    NSArray *visibleCells = [self.mainView visibleCells];
    for (LXSDCollectionViewCell *cell in visibleCells) {
        if (indexPath) {
            LXSDCollectionViewCell *midCell = (LXSDCollectionViewCell *)[self.mainView cellForItemAtIndexPath:indexPath];
            if (midCell == cell) {
                cell.layer.shadowColor = [UIColor blackColor].CGColor;
                cell.layer.shadowRadius = 20;
                cell.layer.shadowOpacity = 1;
                cell.clipsToBounds = NO;
            }else {
                cell.layer.shadowColor = nil;
                cell.layer.shadowRadius = 0;
                cell.layer.shadowOpacity = 0;
                cell.clipsToBounds = YES;
            }
        }else {
            cell.layer.shadowColor = nil;
            cell.layer.shadowRadius = 0;
            cell.layer.shadowOpacity = 0;
            cell.clipsToBounds = YES;
        }
    }
    
    // 更新背景图片
    if (indexPath) {
        self.curMidIndexPath = indexPath;
        __block long itemIndex = indexPath.item % self.imagePathsGroup.count;
        
        if (lastIndex != itemIndex) {
            lastIndex = itemIndex;
            // 背景图片切换时，实现淡出淡入效果
            [UIView animateWithDuration:0.1 animations:^{
                self.backImageView.alpha = 0;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.3 animations:^{
                    NSString *imagePath = self.imagePathsGroup[itemIndex];
                    
                    if ([imagePath isKindOfClass:[NSString class]]) {
                        if ([imagePath hasPrefix:@"http"]) {
                            [self.backImageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"placeholder"]];
                        } else {
                            UIImage *image = [UIImage imageNamed:imagePath];
                            if (!image) {
                                [UIImage imageWithContentsOfFile:imagePath];
                            }
                            self.backImageView.image = image;
                        }
                    } else if ([imagePath isKindOfClass:[UIImage class]]) {
                        self.backImageView.image = (UIImage *)imagePath;
                    }
                    
                    self.backImageView.alpha = 1;
                }];
            }];
        }
    }
}

/**
 *  将要停止拖拽
 *
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.autoScroll) {
        [_timer invalidate];
        _timer = nil;
    }
}

/**
 *  停止拖拽
 *
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"scrollViewDidEndDragging");
    if (self.autoScroll) {
        [self setupTimer];
    }
    // 停止拖拽时，没有减速
    if (decelerate == NO) {
        NSIndexPath *indexPath = [self currentIndex];
        if (indexPath) {
            NSInteger targetIndex = indexPath.item;
            if (targetIndex >= _totalItemsCount) {
                if (self.infiniteLoop) {
                    targetIndex = _totalItemsCount * 0.5;
                    [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] animated:NO];
                }
                return;
            }
            [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] animated:YES];
        }
        [self scrollViewDidEndScrollingAnimation:self.mainView];
    }
}

/**
 *  停止减速
 *
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidEndDecelerating");
    [self scrollViewDidEndScrollingAnimation:self.mainView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self updayeBackImageView];
    if (!self.imagePathsGroup.count) return; // 解决清除timer时偶尔会出现的问题
    NSIndexPath *indexPath = [self currentIndex];
    if (indexPath) {
        NSInteger indexOnPageControl = indexPath.item % self.imagePathsGroup.count;
        
        if ([self.delegate respondsToSelector:@selector(cycleScrollView:didScrollToIndex:)]) {
            [self.delegate cycleScrollView:self didScrollToIndex:indexOnPageControl];
        }
    }
}

@end
