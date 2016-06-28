//
//  LXHomeViewController.m
//  YiZhiChan
//
//  Created by wuyaju on 16/4/26.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXHomeViewController.h"
#import "LXSuspendCollectionView.h"
#import "LXRecommendMovieView.h"
#import "LXRecommendMovie.h"
#import "LXRecommendMovieCell.h"
#import "LXNewMovie.h"
#import "LXNewMovieCell.h"
#import "LXAdvert.h"
#import "LXAdvertCell.h"
#import "LXShow.h"
#import "LXShowCell.h"
#import "LXHomePlate.h"
#import "LXCellHeader.h"
#import "LXCellHeaderView.h"
#import "LXMoviePoster.h"
#import "LXWebViewController.h"
#import "LXCommentCell.h"
#import "LXComment.h"
#import "LXRefreshTitleView.h"

#import "UINavigationBar+Extend.h"
#import "Macros.h"

#import "AFNetworking.h"
#import "MJExtension.h"
#import "SDCycleScrollView.h"
#import "Masonry.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "RxWebViewController.h"
#import "YMCitySelect.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "SDWebImagePrefetcher.h"
#import "SDWebImageManager.h"
#import "SDImageCache.h"

#import "LXAssistiveView.h"
#import "LXAssistiveViewBorder.h"
#import "LXNewMovieController.h"
#import "LXMovieViewController.h"
#import "LXPosterShow.h"
#import "LXSubTitleShow.h"
#import "LXBaseNavigationController.h"
#import "NSDictionary+NSNull.h"
#import "LXRedDotRegister.h"
#import "GJRedDot.h"
#import "LXMyMessageViewController.h"
#import "LXShuiZhuYuHttpTool.h"
#import "LXDownloadManager.h"

#define Bundle [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"shuizhuyu" ofType:@"bundle"]];
#define HomeCachePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"homeCache.plist"]

static NSString *recommendMovieCellID = @"recommendMovieCellID";
static NSString *latestMovieCellID = @"latestMovieCellID";
static NSString *showCellID = @"showCellID";
static NSString *commentCellID = @"commentCellID";
static NSString *advertCellID = @"advertCellID";

@interface LXHomeViewController () <SDCycleScrollViewDelegate, UIScrollViewDelegate, UITableViewDelegate,
                                    UITableViewDataSource, LXSuspendCollectionViewDelegate, LXCellHeaderViewDelegate,
                                    LXRecommendMovieCellDelegate, LXAssistiveViewDelegate, YMCitySelectDelegate,
                                    SDWebImagePrefetcherDelegate, LXAdvertCellDelegate, LXShowCellDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)SDCycleScrollView *bgScrollView;
@property (nonatomic, strong)LXSuspendCollectionView *suspendCollectionView;
@property (nonatomic, strong)LXAssistiveView *assistiveView;
@property (nonatomic, strong)UIVisualEffectView *visualEffectView;
@property (nonatomic, strong)UIButton *locationBtn;
@property (nonatomic, strong)UIButton *messageBtn;
@property (nonatomic, strong)LXRefreshTitleView *titleView;
@property (nonatomic, assign)BOOL refreshFlg;
@property (nonatomic, strong)UIImageView *blackImageView;

// 板块模型数组
@property (nonatomic, strong)NSMutableArray *homePlateArray;
// 电影海报数组
@property (nonatomic, strong)NSMutableArray *moviePosterArray;
// 推荐电影场次数组
@property (nonatomic, strong)NSMutableArray *recommendMovieArray;
// 新影讯数组
@property (nonatomic, strong)NSMutableArray *latestMovieArray;
// 玩吧数组
@property (nonatomic, strong)NSMutableArray *playArray;
// 神评论数组
@property (nonatomic, strong)NSMutableArray *commentArray;
// 广告数组
@property (nonatomic, strong)NSMutableArray *advertArray;

@property (nonatomic, strong)NSMutableArray *imagesURLStringsArray;
@end

@implementation LXHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self readHomeCache];

    [self setupNavBar];
    [self setupbgScrollView];
    [self setupBlackBackground];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = self.bgScrollView.frame;
    visualEffectView.alpha = 0.0;
    [self.bgScrollView addSubview:visualEffectView];
    self.visualEffectView = visualEffectView;
    
    [self setupTableView];
    [self setupTitleView];
    [self setupAssistiveView];
    [self setupGesture];
    
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    
    [self loadData];
    [[LXDownloadManager sharedInstance] downLoadArData];
}

- (void)testSignalException {
    NSLog(@"test signal exception");
    NSString * null = nil;
    NSLog(@"print the nil string %s", [null UTF8String]);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tableView.delegate = self;
    [self scrollViewDidScroll:self.tableView];
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    
    NSString *curCityName = [[NSUserDefaults standardUserDefaults] objectForKey:LXCurCityNameKey];
    if (curCityName == nil) {
        [self presentViewController:[[YMCitySelect alloc] initWithDelegate:nil] animated:YES completion:nil];
    }else {
        [self.locationBtn setTitle:curCityName forState:UIControlStateNormal];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 懒加载
- (NSMutableArray *)homePlateArray {
    if (_homePlateArray == nil) {
        _homePlateArray = [NSMutableArray array];
    }
    
    return _homePlateArray;
}

- (NSMutableArray *)moviePosterArray {
    if (_moviePosterArray == nil) {
        _moviePosterArray = [NSMutableArray array];
    }
    
    return _moviePosterArray;
}

- (NSMutableArray *)recommendMovieArray {
    if (_recommendMovieArray == nil) {
        _recommendMovieArray = [NSMutableArray array];
    }
    
    return _recommendMovieArray;
}

- (NSMutableArray *)latestMovieArray {
    if (_latestMovieArray == nil) {
        _latestMovieArray = [NSMutableArray array];
    }
    
    return _latestMovieArray;
}

- (NSMutableArray *)playArray {
    if (_playArray == nil) {
        _playArray = [NSMutableArray array];
    }
    
    return _playArray;
}

- (NSMutableArray *)commentArray {
    if (_commentArray == nil) {
        _commentArray = [NSMutableArray array];
    }
    
    return _commentArray;
}

- (NSMutableArray *)advertArray {
    if (_advertArray == nil) {
        _advertArray = [NSMutableArray array];
    }
    
    return _advertArray;
}

- (NSMutableArray *)imagesURLStringsArray {
    if (_imagesURLStringsArray == nil) {
        _imagesURLStringsArray = [NSMutableArray array];
    }
    
    return _imagesURLStringsArray;
}

#pragma mark - 私有方法
/**
 *  设置导航栏的内容
 */
- (void)setupNavBar {
    self.navigationItem.title = @"";
    
    UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    locationBtn.frame = CGRectMake(0, 0, 100, 23);
    [locationBtn setImage:[UIImage imageNamed:@"navBar_location"] forState:UIControlStateNormal];
    locationBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    locationBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    locationBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
    [locationBtn addTarget:self action:@selector(citySelect) forControlEvents:UIControlEventTouchUpInside];
    
    self.locationBtn = locationBtn;
    UIBarButtonItem *locationBtnItem = [[UIBarButtonItem alloc] initWithCustomView:locationBtn];

    UIBarButtonItem *navigationLeftSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    navigationLeftSpacer.width = -5;
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:navigationLeftSpacer, locationBtnItem,nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectNewCity:) name:LXSelectNewCityNotification object:nil];
    
    
    // 设置导航栏右侧内容
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    searchBtn.frame = CGRectMake(0, 0, 20, 20);
    [searchBtn setImage:[UIImage imageNamed:@"navBar_search"] forState:UIControlStateNormal];
    searchBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [searchBtn addTarget:self action:@selector(searchClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *searchBtnItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    
    UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    messageBtn.frame = CGRectMake(0, 0, 23, 23);
    [messageBtn setImage:[UIImage imageNamed:@"navBar_message"] forState:UIControlStateNormal];
    messageBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [messageBtn addTarget:self action:@selector(messageClicked) forControlEvents:UIControlEventTouchUpInside];
    self.messageBtn = messageBtn;
    UIBarButtonItem *messageBtnItem = [[UIBarButtonItem alloc] initWithCustomView:messageBtn];
    __weak __typeof(&*self) weakSelf = self;
    [self setRedDotKey:LXHomeMessage refreshBlock:^(BOOL show) {
        weakSelf.messageBtn.showRedDot = show;
    } handler:self];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:messageBtnItem, searchBtnItem, nil];
}

- (void)searchClicked {
    LXWebViewController *webVc = [[LXWebViewController alloc] initWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/fashhtml/search.html?navbarstyle=hidden", LXBaseUrl]]];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webVc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)messageClicked {
    LXMyMessageViewController *messageVc = [[LXMyMessageViewController alloc] init];
    [self.navigationController pushViewController:messageVc animated:YES];
}

- (void)citySelect {
    [self presentViewController:[[YMCitySelect alloc] initWithDelegate:nil] animated:YES completion:nil];
}

- (void)selectNewCity:(NSNotification *)aNotification {
    NSDictionary *userInfo = aNotification.userInfo;
    NSString *cityName = userInfo[LXNewCityNameKey];
    [self.locationBtn setTitle:cityName forState:UIControlStateNormal];
}

/**
 *  设置背景轮播图片
 */
- (void)setupbgScrollView{
    NSArray *imagesURLStrings = @[
                                  @"bg1",
                                  @"bg2",
                                  @"bg3"
                                  ];
    SDCycleScrollView *bgScrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.view.frame delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    bgScrollView.showPageControl = NO;
    bgScrollView.autoScroll = NO;
    bgScrollView.infiniteLoop = YES;
    bgScrollView.autoScrollTimeInterval = 4;
    bgScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    if ((self.imagesURLStringsArray != nil) && (self.imagesURLStringsArray.count > 0)) {
        
        NSMutableArray *imagesArray = [NSMutableArray array];
        for (NSString *urlStr in self.imagesURLStringsArray) {
            NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:urlStr]];
            NSString *imagePath = [[SDImageCache sharedImageCache] defaultCachePathForKey:key];
            [imagesArray addObject:imagePath];
        }
        bgScrollView.localizationImageNamesGroup = imagesArray;
    }else {
        bgScrollView.localizationImageNamesGroup = imagesURLStrings;
    }
    self.bgScrollView = bgScrollView;
    [self.view addSubview:bgScrollView];
}

/**
 *  设置黑色渐变背景
 */
- (void)setupBlackBackground {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Bottom-bg"]];
    CGFloat x = 0;
    CGFloat height = self.view.frame.size.height * 0.3;
    CGFloat y = self.view.frame.size.height - CGRectGetHeight(self.tabBarController.tabBar.frame) - height;
    CGFloat width = self.view.frame.size.width;
    imageView.frame = CGRectMake(x, y, width, height);
    [self.view addSubview:imageView];
    self.blackImageView = imageView;
}

/**
 *  添加移动按钮
 */
- (void)setupAssistiveView {
    LXAssistiveViewBorder *left = [[LXAssistiveViewBorder alloc] initWithType:LXAssistiveViewBorderTypeLeft];
    LXAssistiveViewBorder *right = [[LXAssistiveViewBorder alloc] initWithType:LXAssistiveViewBorderTypeRight];
    LXAssistiveViewBorder *bottom = [[LXAssistiveViewBorder alloc] initWithType:LXAssistiveViewBorderTypeBottom];
    
    LXAssistiveView *assistiveView = [[LXAssistiveView alloc] initWithFrame:CGRectMake(50, 400, 100, 100)];
    assistiveView.supportBorders = [NSMutableArray arrayWithObjects:left, right, bottom, nil];
    assistiveView.borderEdge = UIEdgeInsetsMake(64, 0, 49, 0);
    assistiveView.delegate = self;
    [self.view addSubview:assistiveView];
    LXAssistiveViewBorder *startLeft = [[LXAssistiveViewBorder alloc] initWithType:LXAssistiveViewBorderTypeLeft];
    [assistiveView startAttachmentAtBorder:startLeft];
}

/**
 *  添加tableView
 */
- (void)setupTableView {
    // headerView与tableView第一个cell之间的间距
    CGFloat headerBottomInset = 63;
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + headerBottomInset);
    CGRect moveFrame = CGRectMake(0, 200, CGRectGetWidth(frame), CGRectGetHeight(frame) - 200 - TabBarHeight);
    LXSuspendCollectionView *collectionView = [[LXSuspendCollectionView alloc] initWithVisibleFrame:frame
                                                withMoveFrame:moveFrame
                                                itemSize:CGSizeMake(50, 80)
                                                sectionInset:UIEdgeInsetsMake(0, 10, TabBarHeight + 20 + headerBottomInset, 10)
                                                minimumLineSpacing:5
                                                minimumInteritemSpacing:10];
    collectionView.delegate = self;
    self.suspendCollectionView = collectionView;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableHeaderView = self.suspendCollectionView;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    
    [tableView registerClass:[LXRecommendMovieCell class] forCellReuseIdentifier:recommendMovieCellID];
    [tableView registerClass:[LXNewMovieCell class] forCellReuseIdentifier:latestMovieCellID];
    [tableView registerClass:[LXShowCell class] forCellReuseIdentifier:showCellID];
    [tableView registerClass:[LXCommentCell class] forCellReuseIdentifier:commentCellID];
    [tableView registerClass:[LXAdvertCell class] forCellReuseIdentifier:advertCellID];
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

/**
 *  集成头部刷新控件
 */
- (void)setupTitleView {
    LXRefreshTitleView *titleView = [[LXRefreshTitleView alloc] init];
    self.navigationItem.titleView = titleView;
    self.titleView = titleView;
}

/**
 *  添加手势识别器
 */
- (void)setupGesture {
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.suspendCollectionView addGestureRecognizer:tapGestureRecognizer];
}

/**
 *  拖动手势识别
 *
 *  @param sender 拖动手势识别器对象
 *  因为滚动背景视图位于视图层次最下面，不能响应手势，故加一个拖动手势识别器
 */
- (void)handlePanGesture:(UIPanGestureRecognizer *)sender {
    static CGPoint startPoint;
    static CGPoint startContentOffset;
    // YES:右滑 NO：左滑
    static BOOL direction;
    
    // tableHeaderView不可见时，拖动手势不可用
    if (self.tableView.contentOffset.y > self.view.frame.size.height / 2) {
        return;
    }
    
    CGPoint point = [sender locationInView:self.view];
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:{
            startPoint = point;
            startContentOffset = self.bgScrollView.mainView.contentOffset;
            self.bgScrollView.startPanGestureIndex = [self.bgScrollView currentIndex];
            break;
        }
        case UIGestureRecognizerStateChanged:{
            CGFloat x = startContentOffset.x + startPoint.x - point.x;
            x = MIN(MAX(0, x), self.bgScrollView.mainView.contentSize.width - self.bgScrollView.frame.size.width);
            [self.bgScrollView.mainView setContentOffset:CGPointMake(x, 0)];
            
            // 左滑
            if ((point.x - startPoint.x) < 0) {
                direction = NO;
            }else {// 右滑
                direction = YES;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{
            if (direction) {
                [self.bgScrollView upImage];
            }else {
                [self.bgScrollView downImage];
            }
            break;
        }
        case UIGestureRecognizerStateCancelled:{
            if (direction) {
                [self.bgScrollView upImage];
            }else {
                [self.bgScrollView downImage];
            }
            break;
        }
        default:
            break;
    }
}

/**
 *  点击手势处理
 *  用于处理点击海报
 */
- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    NSLog(@"handleTapGesture");
    if ((self.bgScrollView.imagePathsGroup != nil) && (self.bgScrollView.imageURLStringsGroup.count > 0)) {
        int index = [self.bgScrollView currentIndex] % self.bgScrollView.imagePathsGroup.count;
        LXMoviePoster *moviePoster = self.moviePosterArray[index];
        NSString *urlStr = moviePoster.url;
        LXWebViewController *webViewVc = [[LXWebViewController alloc] initWithUrl:[NSURL URLWithString:urlStr]];
        [self.navigationController pushViewController:webViewVc animated:YES];
    }
}

/**
 *  保存首页缓存数据
 */
- (void)saveHomeCache {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if ((self.moviePosterArray != nil) && (self.moviePosterArray.count > 0)) {
        [dic setObject:self.moviePosterArray forKey:@"moviePoster"];
    }
    
    if ((self.homePlateArray != nil) && self.homePlateArray.count > 0 ) {
        [dic setObject:self.homePlateArray forKey:@"homePlate"];
        for (LXHomePlate *homePlate in self.homePlateArray) {
            NSString *name = homePlate.moduleName;
            if ([name isEqualToString:@"推荐电影场次"]) {
                [dic setObject:self.recommendMovieArray forKey:name];
            }else if ([name isEqualToString:@"新影讯"]) {
                [dic setObject:self.latestMovieArray forKey:name];
            }else if ([name isEqualToString:@"玩吧"]) {
                [dic setObject:self.playArray forKey:name];
            }else if ([name isEqualToString:@"神评论"]) {
                [dic setObject:self.commentArray forKey:name];
            }
        }
    }
    
    // 保存缓存
    [NSKeyedArchiver archiveRootObject:dic toFile:HomeCachePath];
}

/**
 *  读取首页缓存数据
 */
- (void)readHomeCache {
    NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithFile:HomeCachePath];
    if (dic != nil) {
        // 读取背景海报缓存
        if (dic[@"moviePoster"] != nil) {
            self.moviePosterArray = dic[@"moviePoster"];
            if (self.imagesURLStringsArray) {
                [self.imagesURLStringsArray removeAllObjects];
            }
            for (LXMoviePoster *moviePoster in self.moviePosterArray) {
                [self.imagesURLStringsArray addObject:moviePoster.imageUrl];
            }
            
            self.bgScrollView.imageURLStringsGroup = self.imagesURLStringsArray;
        }
        
        // 读取版块数据
        if (dic[@"homePlate"]) {
            self.homePlateArray = dic[@"homePlate"];
            for (LXHomePlate *homePlate in self.homePlateArray) {
                NSString *name = homePlate.moduleName;
                if ([name isEqualToString:@"推荐电影场次"]) {
                    self.recommendMovieArray = dic[name];
                }else if ([name isEqualToString:@"新影讯"]) {
                    self.latestMovieArray = dic[name];
                }else if ([name isEqualToString:@"玩吧"]) {
                    self.playArray = dic[name];
                }else if ([name isEqualToString:@"神评论"]) {
                    self.commentArray = dic[name];
                }
            }
        }
    }
}

/**
 *  加载数据
 */
- (void)loadData {
    [self loadMoviePoster];
    [self loadHomePlate];
}

/**
 *  加载海报数据
 */
- (void)loadMoviePoster {
    [LXShuiZhuYuHttpTool getWithURL:@"fishapi/api/home/IndexBanner" params:nil success:^(id responseObject) {
        responseObject = [NSDictionary changeType:responseObject];
        if ([responseObject[@"state"] intValue] == 1) {
            self.moviePosterArray = (NSMutableArray *)[LXMoviePoster objectArrayWithKeyValuesArray:responseObject[@"data"]];
            
            if (self.imagesURLStringsArray) {
                [self.imagesURLStringsArray removeAllObjects];
            }
            
            for (LXMoviePoster *moviePoster in self.moviePosterArray) {
                [self.imagesURLStringsArray addObject:moviePoster.imageUrl];
            }
            
            // 预加载海报图片
            SDWebImagePrefetcher *manager = [SDWebImagePrefetcher sharedImagePrefetcher];
            [manager prefetchURLs:self.imagesURLStringsArray];
            manager.delegate = self;
        }
    } failure:nil];
}

/**
 *  加载板块数据
 */
- (void)loadHomePlate {
    [LXShuiZhuYuHttpTool getWithURL:@"fishapi/api/home/index" params:nil success:^(id responseObject) {
        responseObject = [NSDictionary changeType:responseObject];
        if ([responseObject[@"state"] intValue] == 1) {
            dispatch_group_t group = dispatch_group_create();
            self.homePlateArray = (NSMutableArray *)[LXHomePlate objectArrayWithKeyValuesArray:responseObject[@"data"]];
            
            for (LXHomePlate *homePlate in self.homePlateArray) {
                NSString *name = homePlate.moduleName;
                if ([name isEqualToString:@"推荐电影场次"]) {
                    [self loadRecommendMovie:group];
                }else if ([name isEqualToString:@"新影讯"]) {
                    [self loadLatestMovie:group];
                }else if ([name isEqualToString:@"玩吧"]) {
                    [self loadPlay:group];
                }else if ([name isEqualToString:@"神评论"]) {
                    [self loadComment:group];
                }
            }
            
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                NSLog(@"所有任务执行完成--%@", group);
                [self saveHomeCache];
                [self.tableView reloadData];
                [self.titleView.indicatorView stopAnimating];
            });
        }
    } failure:nil];
}

/**
 *  加载推荐电影场次
 */
- (void)loadRecommendMovie:(dispatch_group_t) group {
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:2];
        [LXShuiZhuYuHttpTool syncGetWithURL:@"fishapi/api/Home/IndexMovie" params:nil success:^(id responseObject) {
            responseObject = [NSDictionary changeType:responseObject];
            if ([responseObject[@"state"] intValue] == 1) {
                self.recommendMovieArray = (NSMutableArray *)[LXRecommendMovie objectArrayWithKeyValuesArray:responseObject[@"data"]];
            }
        } failure:nil];
    });
}

/**
 *  加载新影讯
 */
- (void)loadLatestMovie:(dispatch_group_t) group {
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [LXShuiZhuYuHttpTool syncGetWithURL:@"fishapi/api/home/newmovie" params:nil success:^(id responseObject) {
            responseObject = [NSDictionary changeType:responseObject];
            if ([responseObject[@"state"] intValue] == 1) {
                self.latestMovieArray = (NSMutableArray *)[LXNewMovie objectArrayWithKeyValuesArray:responseObject[@"data"]];
            }
        } failure:nil];
    });
}

/**
 *  加载玩吧
 */
- (void)loadPlay:(dispatch_group_t) group {
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [LXShuiZhuYuHttpTool syncGetWithURL:@"fishapi/api/home/Show" params:nil success:^(id responseObject) {
            responseObject = [NSDictionary changeType:responseObject];
            if ([responseObject[@"state"] intValue] == 1) {
                if (self.playArray != nil) {
                    [self.playArray removeAllObjects];
                }
                NSDictionary *dataDic = responseObject[@"data"];
                LXPosterShow *posterShow = [[LXPosterShow objectArrayWithKeyValuesArray:dataDic[@"posterShow"]] firstObject];
                LXSubTitleShow *subTitleShow = [[LXSubTitleShow objectArrayWithKeyValuesArray:dataDic[@"subTitleShow"]] firstObject];
                [self.playArray addObject:posterShow];
                [self.playArray addObject:subTitleShow];
            }
        } failure:nil];
    });
}

/**
 *  加载神评论数据
 */
- (void)loadComment:(dispatch_group_t) group {
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [LXShuiZhuYuHttpTool syncGetWithURL:@"fishapi/api/home/DeityComment" params:nil success:^(id responseObject) {
            responseObject = [NSDictionary changeType:responseObject];
            if ([responseObject[@"state"] intValue] == 1) {
                self.commentArray = (NSMutableArray *)[LXComment objectArrayWithKeyValuesArray:responseObject[@"data"]];
            }
        } failure:nil];
    });
}

- (void)openUrl:(NSString *)urlStr {
    NSLog(@"%@", urlStr);
    LXWebViewController* webViewController = [[LXWebViewController alloc] initWithUrl:[NSURL URLWithString:urlStr]];
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UIScrollViewDelegate代理方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.refreshFlg = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y + scrollView.contentInset.top;
    CGFloat scale = offsetY / scrollView.frame.size.height;
    scale = MIN(scale, 1);
    self.bgScrollView.transform = CGAffineTransformMakeScale(MAX(scale/2 + 1, 1), MAX(scale/2 + 1, 1));
    self.visualEffectView.alpha = scale;
    self.blackImageView.alpha = 1 - scale;
    if (offsetY <= (scrollView.frame.size.height + 10)) {
        scrollView.pagingEnabled = YES;
    }else {
        scrollView.pagingEnabled = NO;
    }
    
    UIColor * color = NavBarBackgroundColour;
    if (offsetY > scrollView.frame.size.height - 20) {
        [UIView animateWithDuration:0.1 animations:^{
            [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:MinNavBarAlpha]];
        }];
    } else {
        [UIView animateWithDuration:0.1 animations:^{
            [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
        }];
    }
    
    if(scrollView.contentOffset.y < 0) {
        CGFloat offsetY = (scrollView.contentOffset.y + scrollView.contentInset.top) * -1;
        // 下拉到一定距离刷新用户信息
        if (offsetY > 50) {
            if (![self.titleView.indicatorView isAnimating]) {
                if (self.refreshFlg) {
                    [self.titleView.indicatorView startAnimating];
                }
            }
        }
    }
}

/**
 *  停止滚动开始刷新
 *
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.titleView.indicatorView isAnimating]) {
        [self loadData];
    }
}

#pragma mark - UITableViewDataSource数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.homePlateArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    LXHomePlate *homePlate = self.homePlateArray[section];
    // 普通板块
    if (homePlate.moduleType.intValue == 1) {
        NSString *name = homePlate.moduleName;
        if ([name isEqualToString:@"推荐电影场次"]) {
            return 1;
        }else if ([name isEqualToString:@"新影讯"]) {
            return self.latestMovieArray.count;
        }else if ([name isEqualToString:@"玩吧"]) {
            return self.playArray.count;
        }else if ([name isEqualToString:@"神评论"]) {
            return self.commentArray.count;
        }else {
            return 0;
        }
    }else if (homePlate.moduleType.intValue == 2){ // 广告板块
        return 1;
    }else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LXHomePlate *homePlate = self.homePlateArray[indexPath.section];
    // 普通板块
    if (homePlate.moduleType.intValue == 1) {
        NSString *name = homePlate.moduleName;
        if ([name isEqualToString:@"推荐电影场次"]) {
            LXRecommendMovieCell *cell = [tableView dequeueReusableCellWithIdentifier:recommendMovieCellID];
            cell.recommendMovieArray = self.recommendMovieArray;
            cell.backgroundColor = HomeCellBackgroundColour;
            // 推荐电影场次cell禁止选中
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
        }else if ([name isEqualToString:@"新影讯"]) {
            LXNewMovieCell *cell = [tableView dequeueReusableCellWithIdentifier:latestMovieCellID];
            cell.movieInfo = self.latestMovieArray[indexPath.row];
            cell.backgroundColor = HomeCellBackgroundColour;
            UIView *selectView = [[UIView alloc] init];
            selectView.backgroundColor = HomeCellSeclectBackgroundColour;
            cell.selectedBackgroundView = selectView;
            cell.lastRowInSection = (self.latestMovieArray.count - 1 == indexPath.row);
            return cell;
        }else if ([name isEqualToString:@"玩吧"]) {
            LXShowCell *cell = [tableView dequeueReusableCellWithIdentifier:showCellID];
            // 海报秀
            if ([self.playArray[indexPath.row] isKindOfClass:[LXPosterShow class]]) {
                cell.posterShow = self.playArray[indexPath.row];
            }else if ([self.playArray[indexPath.row] isKindOfClass:[LXSubTitleShow class]]) { // 字幕秀
                cell.subTitleShow = self.playArray[indexPath.row];
            }

            cell.backgroundColor = HomeCellBackgroundColour;
            UIView *selectView = [[UIView alloc] init];
            selectView.backgroundColor = HomeCellSeclectBackgroundColour;
            cell.selectedBackgroundView = selectView;
            return cell;
        }else if ([name isEqualToString:@"神评论"]) {
            LXCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellID];
            cell.comment = self.commentArray[indexPath.row];
            cell.backgroundColor = HomeCellBackgroundColour;
            UIView *selectView = [[UIView alloc] init];
            selectView.backgroundColor = HomeCellSeclectBackgroundColour;
            cell.selectedBackgroundView = selectView;
            cell.lastRowInSection = (self.commentArray.count - 1 == indexPath.row);
            cell.backgroundColor = [UIColor clearColor];
            return cell;
        }else {
            return nil;
        }
    }else if (homePlate.moduleType.intValue == 2){ // 广告板块
        LXAdvertCell *cell = [tableView dequeueReusableCellWithIdentifier:advertCellID];
        LXAdvert *advert = [[LXAdvert alloc] init];
        cell.backgroundColor = [UIColor clearColor];
        advert.imageUrl = homePlate.imageUrl;
        advert.url = homePlate.url;
        advert.imageWidth = homePlate.imageWidth;
        advert.imageHeight = homePlate.imageHeight;
        cell.advert = advert;
        cell.delegate = self;
        return cell;
    }else {
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LXHomePlate *homePlate = self.homePlateArray[indexPath.section];
    // 普通板块
    if (homePlate.moduleType.intValue == 1) {
        NSString *name = homePlate.moduleName;
        if ([name isEqualToString:@"推荐电影场次"]) {
            return [self.tableView fd_heightForCellWithIdentifier:recommendMovieCellID cacheByIndexPath:indexPath configuration:^(LXRecommendMovieCell *cell) {
                cell.recommendMovieArray = self.recommendMovieArray;
            }];
        }else if ([name isEqualToString:@"新影讯"]) {
            return [self.tableView fd_heightForCellWithIdentifier:latestMovieCellID cacheByIndexPath:indexPath configuration:^(LXNewMovieCell *cell) {
                cell.movieInfo = self.latestMovieArray[indexPath.row];
            }];
        }else if ([name isEqualToString:@"玩吧"]) {
            return [self.tableView fd_heightForCellWithIdentifier:showCellID cacheByIndexPath:indexPath configuration:^(LXShowCell *cell) {
                cell.show = self.playArray[indexPath.row];
                cell.firstRowInSection = (indexPath.row == 0);
            }];
        }else if ([name isEqualToString:@"神评论"]) {
            return [self.tableView fd_heightForCellWithIdentifier:commentCellID cacheByIndexPath:indexPath configuration:^(LXCommentCell *cell) {
                cell.comment = self.commentArray[indexPath.row];
            }];
        }else {
            return 0;
        }
        
    }else if (homePlate.moduleType.intValue == 2){ // 广告板块
        return [self.tableView fd_heightForCellWithIdentifier:advertCellID cacheByIndexPath:indexPath configuration:^(LXAdvertCell *cell) {
            LXAdvert *advert = [[LXAdvert alloc] init];
            advert.imageUrl = homePlate.imageUrl;
            advert.url = homePlate.url;
            advert.imageWidth = homePlate.imageWidth;
            advert.imageHeight = homePlate.imageHeight;
            cell.advert = advert;
        }];
    }else {
        return 0;
    }
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    LXHomePlate *homePlate = self.homePlateArray[indexPath.section];
//    // 普通板块
//    if (homePlate.moduleType.intValue == 1) {
//        NSString *name = homePlate.moduleName;
//        if ([name isEqualToString:@"推荐电影场次"]) {
//            LXRecommendMovieCell *cell = [tableView dequeueReusableCellWithIdentifier:recommendMovieCellID];
//            cell.recommendMovieArray = self.recommendMovieArray;
//            return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
//        }else if ([name isEqualToString:@"新影讯"]) {
//            LXNewMovieCell *cell = [tableView dequeueReusableCellWithIdentifier:latestMovieCellID];
//            cell.movieInfo = self.latestMovieArray[indexPath.row];
//            return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
//        }else if ([name isEqualToString:@"玩吧"]) {
//            LXShowCell *cell = [tableView dequeueReusableCellWithIdentifier:showCellID];
//            // 海报秀
//            if ([self.playArray[indexPath.row] isKindOfClass:[LXPosterShow class]]) {
//                cell.posterShow = self.playArray[indexPath.row];
//            }else if ([self.playArray[indexPath.row] isKindOfClass:[LXSubTitleShow class]]) { // 字幕秀
//                cell.subTitleShow = self.playArray[indexPath.row];
//            }
//            return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
//        }else if ([name isEqualToString:@"神评论"]) {
//            LXCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellID];
//            cell.comment = self.commentArray[indexPath.row];
//            return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
//        }else {
//            return 0;
//        }
//        
//    }else if (homePlate.moduleType.intValue == 2){ // 广告板块
//        LXAdvertCell *cell = [tableView dequeueReusableCellWithIdentifier:advertCellID];
//        LXAdvert *advert = [[LXAdvert alloc] init];
//        advert.imageUrl = homePlate.imageUrl;
//        advert.url = homePlate.url;
//        cell.advert = advert;
//        return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
//        
//    }else {
//        return 0;
//    }
//}

/**
 *  返回headerView
 *
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section  {
    LXHomePlate *homePlate = self.homePlateArray[section];
    // 普通板块
    if (homePlate.moduleType.intValue == 1) {
        return [self headerViewWithName:homePlate.moduleName section:section];
    }else if (homePlate.moduleType.intValue == 2){ // 广告板块
        UIView *view = [[UIView alloc] init];
        return view;
    }else {
        UIView *view = [[UIView alloc] init];
        return view;
    }
    
    return nil;
}

/**
 *  根据板块名字返回对应的headerView
 *
 */
- (LXCellHeaderView *)headerViewWithName:(NSString *)name section:(NSInteger)section{
    LXCellHeader *header = [[LXCellHeader alloc] init];
    
    if ([name isEqualToString:@"推荐电影场次"]) {
        header.imageUrl = @"home_section_recommend";
        header.titleName = name;
    }else if ([name isEqualToString:@"新影讯"]) {
        header.imageUrl = @"home_section_newMovie";
        header.titleName = name;
    }else if ([name isEqualToString:@"玩吧"]) {
        header.imageUrl = @"home_section_play";
        header.titleName = name;
    }else if ([name isEqualToString:@"神评论"]) {
        header.imageUrl = @"home_section_comment";
        header.titleName = name;
    }else {
        return nil;
    }
    
    LXCellHeaderView *headerView = [[LXCellHeaderView alloc] init];
    headerView.backgroundColor = HomeCellBackgroundColour;
    headerView.cellHeader = header;
    headerView.section = section;
    headerView.delegate = self;
    
    return headerView;
}

/**
 *  返回headerView高度
 *
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    LXHomePlate *homePlate = self.homePlateArray[section];
    // 普通板块
    if (homePlate.moduleType.intValue == 1) {
        return 50;
    }else if (homePlate.moduleType.intValue == 2){ // 广告板块
        return 0;
    }else {
        return 0;
    }
}

/**
 *  返回footerView的高度
 *
 */
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    LXHomePlate *homePlate = self.homePlateArray[section];
    // 普通板块
    if (homePlate.moduleType.intValue == 1) {
        return 5;
    }else if (homePlate.moduleType.intValue == 2){ // 广告板块
        return 22;
    }else {
        return 0;
    }
}

#pragma mark - UITableViewDelegate代理方法
/**
 *  点击cell
 *
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中

    LXHomePlate *homePlate = self.homePlateArray[indexPath.section];
    // 普通板块
    if (homePlate.moduleType.intValue == 1) {
        NSString *name = homePlate.moduleName;
        if ([name isEqualToString:@"推荐电影场次"]) {
        }else if ([name isEqualToString:@"新影讯"]) {
            LXNewMovie *movie = self.latestMovieArray[indexPath.row];
            NSString *urlStr = [NSString stringWithFormat:@"%@/fashhtml/movie/telecineDetail.html?MsgId=%ld&navbarstyle=1&search=0&share=1&collect=0", LXBaseUrl, movie.movieMsgId.integerValue];
            [self openUrl:urlStr];
        }else if ([name isEqualToString:@"玩吧"]) {
            LXShow *show = self.playArray[indexPath.row];
            [self openUrl:show.url];
        }else if ([name isEqualToString:@"神评论"]) {
            LXComment *comment = self.commentArray[indexPath.row];
            NSString *urlStr = [NSString stringWithFormat:@"%@/fashhtml/deityComment/deityCommentDetail.html?movieId=%ld&cover=%@", LXBaseUrl, comment.movieInfoId.integerValue, comment.cover];
            [self openUrl:urlStr];
        }
    }else if (homePlate.moduleType.intValue == 2){ // 广告板块
        [self openUrl:homePlate.url];
    }
}

#pragma mark - LXSuspendCollectionViewDelegate的代理方法
/**
 *  点击移动图标按钮
 *
 */
- (void)suspendCollectionView:(LXSuspendCollectionView *)collectionView suspendType:(LXSuspenditemAction)actionType{
    switch (actionType) {
        case LXSuspenditemActionHot:{
            NSString *urlStr = [NSString stringWithFormat:@"%@/fashhtml/heatNotice.html?navbarstyle=1&search=1", LXBaseUrl];
            [self openUrl:urlStr];
            break;
        }
        case LXSuspenditemActionPlay:{
            NSString *urlStr = [NSString stringWithFormat:@"%@/fashhtml/recreation/recreationShow.html?navbarstyle=0&search=1", LXBaseUrl];
            [self openUrl:urlStr];
            break;
        }
        case LXSuspenditemActionComment:{
            NSString *urlStr = [NSString stringWithFormat:@"%@/fashhtml/deityComment/deityComment.html?navbarstyle=0&search=1", LXBaseUrl];
            [self openUrl:urlStr];
            break;
        }
        case LXSuspenditemActionNewMovie:{
            NSString *urlStr = [NSString stringWithFormat:@"%@/fashhtml/movie/moviemsg.html?navbarstyle=0&search=0", LXBaseUrl];
            [self openUrl:urlStr];
            break;
        }
        default:
            break;
    }
}

#pragma mark - LXAssistiveViewDelegate代理方法
/**
 *  点击买票按钮
 */
- (void)didSelectedAssistiveView {
    NSString *urlStr = [NSString stringWithFormat:@"%@/fashhtml/priceDetail.html?navbarstyle=0&search=1", LXBaseUrl];
    LXMovieViewController* movieVc = [[LXMovieViewController alloc]
                                        initWithUrl:[NSURL URLWithString:urlStr]];
    [self.navigationController pushViewController:movieVc animated:YES];
}

#pragma mark - LXCellHeaderViewDelegate代理方法
/**
 *  点击headerView对应的事件
 *
 */
- (void)headerView:(LXCellHeaderView *)headerView diddidSelectSection:(NSInteger)section {
    LXHomePlate *homePlate = self.homePlateArray[section];
    
    // 普通板块
    if (homePlate.moduleType.intValue == 1) {
        NSString *name = homePlate.moduleName;
        if ([name isEqualToString:@"推荐电影场次"]) {
            LXNewMovieController *newMovieVc = [[LXNewMovieController alloc] init];
            newMovieVc.curIndex = 0;
            [self.navigationController pushViewController:newMovieVc animated:YES];
        }else if ([name isEqualToString:@"新影讯"]) {
            [self openUrl:homePlate.url];
        }else if ([name isEqualToString:@"玩吧"]) {
            [self openUrl:homePlate.url];
        }else if ([name isEqualToString:@"神评论"]) {
            [self openUrl:homePlate.url];
        }
    }else if (homePlate.moduleType.intValue == 2){ // 广告板块
        [self openUrl:homePlate.url];
    }
}

#pragma mark - LXRecommendMovieCellDelegate代理方法
/**
 *  点击推荐电影场次
 *
 */
- (void)didSelectImage:(LXRecommendMovie *)recommendMovie{
    if (recommendMovie.movieInfoId) {
        NSString *movieHtmlName = [NSString stringWithFormat:@"%@/fashhtml/Movie/movieDetail.html?MovieInfoId=%d&navbarstyle=0&share=1&collect=1", LXBaseUrl, [recommendMovie.movieInfoId intValue]];
        [self openUrl:movieHtmlName];
    }
}

#pragma mark - SDWebImagePrefetcherDelegate代理方法
- (void)imagePrefetcher:(SDWebImagePrefetcher *)imagePrefetcher didFinishWithTotalCount:(NSUInteger)totalCount skippedCount:(NSUInteger)skippedCount  {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.bgScrollView.imageURLStringsGroup = self.imagesURLStringsArray;
    });
}

- (void)advertCellHeightDidChanged:(LXAdvertCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath) {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSLog(@"重新刷新");
    }
//    [self.tableView reloadData];
}

- (void)showCellHeightDidChanged:(UITableViewCell *)cell {
//    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//    if (indexPath) {
//        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }
}

@end
