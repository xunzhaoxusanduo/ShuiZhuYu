//
//  LXFriendViewController.m
//  YiZhiChan
//
//  Created by wuyaju on 16/4/30.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXFriendViewController.h"
#import "UINavigationBar+Extend.h"
#import "LXBaseFriend.h"
#import "MJExtension.h"
#import "LXPoster.h"
#import "LXFilmReview.h"
#import "LXPosterCell.h"
#import "LXFilmReviewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "Macros.h"
#import "LXFriendHeaderView.h"
#import "HFStretchableTableHeaderView.h"
#import "LXFriendInfo.h"
#import "AFNetworking.h"
#import "LXUserInfo.h"
#import "LXMyInfo.h"
#import "LXRefreshTitleView.h"
#import "MJRefresh.h"
#import "LXMovieView.h"
#import "LXFilmInfo.h"
#import "LXWebViewController.h"
#import "LXDubbingCell.h"
#import "XLVideoPlayer.h"
#import "LXFriendPhoto.h"
#import "LXVideoView.h"
#import "UIButton+Extension.h"
#import "LXAttitude.h"
#import "LXPlayBtn.h"
#import "NSDictionary+NSNull.h"
#import "MBProgressHUD+MJ.h"

#define ImageHeight self.view.frame.size.height*0.4

static NSString *posterCellID = @"advertCellID";
static NSString *filmReviewCellID = @"filmReviewCellID";
static NSString *dubbingCellID = @"dubbingCellID";

@interface LXFriendViewController () <UITableViewDelegate, UITableViewDataSource, LXPersonInfoViewDelegate, LXFriendHeaderViewDelegate,LXMovieViewDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)HFStretchableTableHeaderView* stretchableTableHeaderView;
@property (nonatomic, strong)LXFriendHeaderView *headerView;
@property (nonatomic, strong)LXRefreshTitleView *titleView;
@property (nonatomic, assign)BOOL refreshFlg;
@property (nonatomic, strong)UIView *notLoginView;
@property (nonatomic, strong)NSMutableArray *statusArray;

@property (nonatomic, strong)NSIndexPath *indexPath;
@property (nonatomic, strong)XLVideoPlayer *player;

@end

@implementation LXFriendViewController

/**
 *  初始化控制器
 *
 *  @param friendInfoUrlStr 个人信息获取地址
 *  @param statusUrlStr     动态数据获取地址
 *
 */
- (instancetype)initWithFriendInfoUrl:(NSString *)friendInfoUrlStr userId:(NSInteger)userId statusUrl:(NSString *)statusUrlStr {
    if (self = [super init]) {
        self.friendInfoUrl = [friendInfoUrlStr copy];
        self.statusUrl = [statusUrlStr copy];
        self.userId = userId;
    }
    
    return self;
}

- (void)viewDidLoad {
    NSLog(@"朋友圈viewDidLoad");
    [super viewDidLoad];
    [self setupTableView];
    [self setupHeadView];
    [self setupTitleView];
    [self setupRefreshView];
    [self setupNotLoginView];
    [LXUserInfo user].shouldLoadNewData = YES;
    
    // 添加登录成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:LXWebViewLoginSuccessNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self scrollViewDidScroll:self.tableView];

    [self checkLogin];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.player destroyPlayer];
    self.player = nil;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 懒加载
- (NSMutableArray *)statusArray {
    if (_statusArray == nil) {
        _statusArray = [NSMutableArray array];
    }
    
    return _statusArray;
}

#pragma mark - 私有方法
/**
 *  设置tableView
 */
- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = RGB(239, 239, 239);
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
//    tableView.sectionFooterHeight = 10;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [tableView registerClass:[LXPosterCell class] forCellReuseIdentifier:posterCellID];
    [tableView registerClass:[LXFilmReviewCell class] forCellReuseIdentifier:filmReviewCellID];
    [tableView registerClass:[LXDubbingCell class] forCellReuseIdentifier:dubbingCellID];
}

/**
 *  设置头部视图
 */
- (void)setupHeadView {
    LXFriendHeaderView *headerView = [[LXFriendHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, ImageHeight)];
    headerView.delegate = self;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBgImageView)];
    headerView.bgImageView.userInteractionEnabled = YES;
    [headerView addGestureRecognizer:tapGesture];
    self.headerView = headerView;
    _stretchableTableHeaderView = [[HFStretchableTableHeaderView alloc] init];
    [_stretchableTableHeaderView stretchHeaderForTableView:self.tableView withView:headerView];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
}

- (void)handleTapBgImageView {
    // 只有是自己的朋友圈才可以更换背景图片
    if (self.userId == [[[LXUserInfo user] userId] integerValue]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *photoLibraryAction = [UIAlertAction actionWithTitle:@"选择相册照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.sourceType = sourceType;
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
        }];
        
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.sourceType = sourceType;
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alertController addAction:photoLibraryAction];
        [alertController addAction:cameraAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}


/**
 *  设置titleView
 */
- (void)setupTitleView {
    LXRefreshTitleView *titleView = [[LXRefreshTitleView alloc] init];
    titleView.titleLbl.text = @"朋友圈";
    self.navigationItem.titleView = titleView;
    self.titleView = titleView;
}

/**
 *  集成刷新控件
 */
- (void)setupRefreshView {
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
}

/**
 *  设置没有登录时的视图
 */
- (void)setupNotLoginView {
    UIView *notLoginView = [[UIView alloc] initWithFrame:self.view.frame];
    notLoginView.backgroundColor = [UIColor whiteColor];
    notLoginView.hidden = YES;
    [self.view addSubview:notLoginView];
    [self.view bringSubviewToFront:notLoginView];
    self.notLoginView = notLoginView;
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [loginBtn setTitle:@"去登录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.layer.borderColor = LXYellowColor.CGColor;
    loginBtn.layer.borderWidth = 1.0f;
    loginBtn.layer.cornerRadius = 5.0f;
    [self.notLoginView addSubview:loginBtn];
    
    WS(weakSelf);
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
}

/**
 *  登录点击事件
 */
- (void)login {
    [[LXUserInfo user] isLogin:self];
}

/**
 *  检测是否登录
 */
- (void)checkLogin {
//    // 已经登录
//    if ([[LXUserInfo user] updateByCookieWithURL:nil]) {
//        self.notLoginView.hidden = YES;
//        
//        [self repairurl];
//        [self loadHeadData];
//        [self loadNewData];
//        
//    }else { // 未登录
//        self.notLoginView.hidden = NO;
//    }
    if ([LXUserInfo user].shouldLoadNewData == YES) {
        if ([[LXUserInfo user] isLogin:self]) {
            self.notLoginView.hidden = YES;
            
            [self repairurl];
            [self loadHeadData];
            [self loadNewData];
            [self.titleView.indicatorView startAnimating];
        }
    }else {
        [LXUserInfo user].shouldLoadNewData = YES;
    }
}

/**
 *  加载头部数据
 */
- (void)loadHeadData {
    if (self.friendInfoUrl != nil) {
        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
        NSString *urlStr = [NSString stringWithFormat:@"%@?userId=%ld", self.friendInfoUrl, self.userId];
        
        [mgr GET:urlStr parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             __block LXMyInfo *myInfo = nil;
             responseObject = [NSDictionary changeType:responseObject];
//             NSLog(@"myInfo-----%@", responseObject);
             if ([responseObject[@"state"] intValue] == 1) {
                 if (responseObject[@"data"] != nil) {
                     myInfo = (LXMyInfo *)[LXMyInfo objectWithKeyValues:responseObject[@"data"]];
                 }
             }
             
             self.headerView.myInfo = myInfo;
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
         }];
    }
}

/**
 *  加载朋友圈最新动态数据
 */
//- (void)loadNewData {
//    if (self.statusUrl != nil) {
//        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
//        
//        NSInteger cueUserId = [LXUserInfo user].userId.integerValue;
//        NSString *urlStr = nil;
//        // 不是第一次请求数据
//        if (self.statusArray.count) {
//            urlStr = [NSString stringWithFormat:@"%@?userId=%ld&time=&currentUserId=%ld&first=false", self.statusUrl, self.userId, cueUserId];
//        }else { // 第一次请求数据
//            urlStr = [NSString stringWithFormat:@"%@?userId=%ld&time=null&currentUserId=%ld&first=true", self.statusUrl, self.userId, cueUserId];
//        }
//        
//        [mgr GET:urlStr parameters:nil
//         success:^(AFHTTPRequestOperation *operation, id responseObject) {
//             
//             NSArray *newArray = [self analysisJsonData:responseObject];
//             if (newArray != nil) {
//                 // 将最新的数据追加到旧数据的最前面
//                 // 旧数据: self.statusArray
//                 // 新数据: newArray
//                 NSMutableArray *tempArray = [NSMutableArray array];
//                 [tempArray addObjectsFromArray:newArray];
//                 [tempArray addObjectsFromArray:self.statusArray];
//                 self.statusArray = tempArray;
//                 
//                 //             dispatch_sync(dispatch_get_main_queue(), ^{
//                 [self.tableView reloadData];
//                 
//                 //             });
//             }
//             [self.titleView.indicatorView stopAnimating];
//             
//         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                [self.titleView.indicatorView stopAnimating];
//         }];
//    }
//}

- (void)loadNewData {
    if (self.statusUrl != nil) {
        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
        
        NSInteger cueUserId = [LXUserInfo user].userId.integerValue;
        NSString *urlStr = nil;

        urlStr = [NSString stringWithFormat:@"%@?userId=%ld&time=null&currentUserId=%ld&first=true", self.statusUrl, self.userId, cueUserId];
        
        [mgr GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSArray *newArray = [self analysisJsonData:responseObject];
             if (newArray != nil) {
                 [self.statusArray removeAllObjects];
                 [self.statusArray addObjectsFromArray:newArray];
                 [self.tableView reloadData];
             }
             [self.titleView.indicatorView stopAnimating];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [self.titleView.indicatorView stopAnimating];
         }];
    }
}


/**
 *  加载朋友圈更多动态
 */
- (void)loadMoreData {
    if (self.statusUrl != nil) {
        if (self.statusArray.count) {
            LXBaseFriend *friend = [self.statusArray lastObject];
            NSString *lastTime = friend.addTime;
            NSInteger cueUserId = [LXUserInfo user].userId.integerValue;
            NSLog(@"%@", lastTime);
            NSString *urlStr = [NSString stringWithFormat:@"%@?userId=%ld&time=%@&currentUserId=%ld&first=false", self.statusUrl, self.userId, lastTime, cueUserId];
            NSString *utl = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"-----------------------------------------%@", utl);
            
            AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
            
            [mgr GET:utl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSArray *newArray = [self analysisJsonData:responseObject];
                 if (newArray != nil) {
                     [self.statusArray addObjectsFromArray:newArray];
                     [self.tableView reloadData];
                 }
                 [self.tableView.mj_footer endRefreshing];
                 
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 [self.tableView.mj_footer endRefreshing];
             }];
        }
    }
}

/**
 *  解析json数据
 *
 *  @param responseObject json数据
 *
 *  @return 返回转换后的数据模型
 */
- (NSArray *)analysisJsonData:(id)responseObject {
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *tempArray = [NSMutableArray array];
    responseObject = [NSDictionary changeType:responseObject];
    
    if ([responseObject[@"state"] intValue] == 1) {
        tempArray = (NSMutableArray *)[LXBaseFriend objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        for (int i = 0; i < tempArray.count; i++) {
            LXBaseFriend *status = tempArray[i];
            // 海报秀/字幕秀模型
            if ([status.typeEn isEqualToString:@"PosterShow"] || [status.typeEn isEqualToString:@"SubTitleShow"]) {
                if (responseObject[@"data"][i] != nil) {
                    LXPoster *poster = [LXPoster objectWithKeyValues:responseObject[@"data"][i]];
                    [array addObject:poster];
                }
            }else if ([status.typeEn isEqualToString:@"MovieDetail"]) { // 影评模型
                if (responseObject[@"data"][i] != nil) {
                    LXFilmReview *filmReview = [LXFilmReview objectWithKeyValues:responseObject[@"data"][i]];
                    [array addObject:filmReview];
                }
            }else if ([status.typeEn isEqualToString:@"DubbingShow"]) { // 配音秀
                if (responseObject[@"data"][i] != nil) {
                    LXPoster *poster = [LXPoster objectWithKeyValues:responseObject[@"data"][i]];
                    [array addObject:poster];
                }
            }
        }
        
        return array;
    }else {
        return nil;
    }
}

- (void)repairurl {
    if ((self.friendInfoUrl == nil) || (self.friendInfoUrl.length == 0) ||
        (self.statusUrl == nil) || (self.statusUrl.length == 0)) {
        if ([[LXUserInfo user] updateByCookieWithURL:nil]) {
            self.userId = [[[LXUserInfo user] userId] integerValue];
            self.friendInfoUrl = LXPersonInfoUrl;
            self.statusUrl = LXFollowDynamicUrl;
            // 说明登陆了新的账号，清除以前的数据
            [self.statusArray removeAllObjects];
        }
    }
}

- (void)loginSuccess:(NSNotification *)notification {
    NSLog(@"loginSuccess");
    self.userId = [[[LXUserInfo user] userId] integerValue];
    self.friendInfoUrl = LXPersonInfoUrl;
    self.statusUrl = LXFollowDynamicUrl;
    // 说明登陆了新的账号，清除以前的数据
    [self.statusArray removeAllObjects];
}

//- (void)showVideoPlayer:(UITapGestureRecognizer *)tapGesture {
//    WS(weakSelf);
//    
////    [self.player destroyPlayer];
////    self.player = nil;
////    
////    UIView *view = tapGesture.view;
////    LXPoster *dubbing = self.statusArray[view.tag - 100];
////    
////    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:view.tag - 100];
////    LXDubbingCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
////    LXFriendPhoto *item = dubbing.files[0];
////    
////    self.player = [[XLVideoPlayer alloc] init];
////    self.player.videoUrl = item.imgUrl;
////    NSLog(@"视频播放地址--------%@", item.imgUrl);
////    [self.player playerBindTableView:self.tableView currentIndexPath:self.indexPath];
////    self.player.frame = view.superview.bounds;
////    
////    [cell.videoView addSubview:self.player];
////    
////    self.player.completedPlayingBlock = ^(XLVideoPlayer *player) {
////        [weakSelf.player destroyPlayer];
////        weakSelf.player = nil;
////    };
//    
//    [self.player destroyPlayer];
//    self.player = nil;
//    
//    UIView *view = tapGesture.view;
//    LXPoster *dubbing = self.statusArray[self.indexPath.section];
//    
//    LXDubbingCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
//    LXFriendPhoto *item = dubbing.files[0];
//    
//    self.player = [[XLVideoPlayer alloc] init];
//    self.player.videoUrl = item.imgUrl;
//    NSLog(@"视频播放地址--------%@", item.imgUrl);
//    [self.player playerBindTableView:self.tableView currentIndexPath:self.indexPath];
//    self.player.frame = view.superview.bounds;
//    
//    [cell.videoView addSubview:self.player];
//    
//    self.player.completedPlayingBlock = ^(XLVideoPlayer *player) {
//        [weakSelf.player destroyPlayer];
//        weakSelf.player = nil;
//    };
//}

- (void)showVideoPlayer:(UIButton *)btn {
    WS(weakSelf);
    
    [self.player destroyPlayer];
    self.player = nil;
    
    LXPoster *dubbing = self.statusArray[self.indexPath.section];
    
    LXDubbingCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
    LXFriendPhoto *item = dubbing.files[0];
    
    self.player = [[XLVideoPlayer alloc] init];
    self.player.videoUrl = item.imgUrl;
    NSLog(@"视频播放地址--------%@", item.imgUrl);
    [self.player playerBindTableView:self.tableView currentIndexPath:self.indexPath];
    self.player.frame = btn.superview.superview.bounds;
    
    [cell.videoView addSubview:self.player];
    
    self.player.completedPlayingBlock = ^(XLVideoPlayer *player) {
        [weakSelf.player destroyPlayer];
        weakSelf.player = nil;
    };
}

#pragma mark - UIImagePickerControllerDelegate代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    NSString *imageBase64 = [imageData base64EncodedStringWithOptions:0];
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    NSString *urlStr = [NSString stringWithFormat:@"%@/fishapi/api/User/BgImage", LXBaseUrl];
    NSString *value = [NSString stringWithFormat:@"{\"UserId\": \"%ld\", \"ImageUrl\": \"%@\"}", [LXUserInfo user].userId.integerValue, imageBase64];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:value forKey:@""];
    
    [MBProgressHUD showMessage:@"正在上传..."];
    [mgr POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUD];
        if ([responseObject[@"state"] integerValue] == 1) {
            [MBProgressHUD showSuccess:@"上传成功！"];
            // 更新背景图片
            [self loadHeadData];
        }else {
            [MBProgressHUD showError:@"上传失败！"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIScrollViewDelegate代理方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.refreshFlg = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(scrollView.contentOffset.y < 0) {
        CGFloat offsetY = (scrollView.contentOffset.y + scrollView.contentInset.top) * -1;
        // 下拉到一定距离刷新用户信息
        if (offsetY > 50) {
            if ([[LXUserInfo user] updateByCookieWithURL:nil]) {
                if (![self.titleView.indicatorView isAnimating]) {
                    if (self.refreshFlg) {
                        [self.titleView.indicatorView startAnimating];
                    }
                }
            }
        }
    }
    
    [_stretchableTableHeaderView scrollViewDidScroll:scrollView];
    
    UIColor *color = NavBarBackgroundColour;
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 0) {
        CGFloat alpha = MIN(MinNavBarAlpha, 1 - ((ImageHeight - 64 - offsetY) / 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
    }
    
    //uitableview处理section的不悬浮，禁止section停留的方法
    CGFloat sectionHeaderHeight = 50;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

/**
 *  停止滚动开始刷新
 *
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.titleView.indicatorView isAnimating]) {
        [self loadHeadData];
        [self loadNewData];
    }
}

- (void)viewDidLayoutSubviews {
    [_stretchableTableHeaderView resizeView];
}

#pragma mark - UITableViewDataSource数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.statusArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LXBaseFriend *status = self.statusArray[indexPath.section];
    
    // 海报秀/字幕秀模型
    if ([status.typeEn isEqualToString:@"PosterShow"] || [status.typeEn isEqualToString:@"SubTitleShow"]) {
        LXPosterCell *cell = [tableView dequeueReusableCellWithIdentifier:posterCellID];
        cell.poster = self.statusArray[indexPath.section];
        cell.personInfoView.delegate = self;
        return cell;
    }else if ([status.typeEn isEqualToString:@"MovieDetail"]) { // 影评模型
        LXFilmReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:filmReviewCellID];
        cell.filmReview = self.statusArray[indexPath.section];
        cell.personInfoView.delegate = self;
        cell.movieView.delegate = self;
        return cell;
    }else if ([status.typeEn isEqualToString:@"DubbingShow"]) { // 配音秀
        LXDubbingCell *cell = [tableView dequeueReusableCellWithIdentifier:dubbingCellID];
        cell.poster = self.statusArray[indexPath.section];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showVideoPlayer:)];
//        [cell.videoView.playBtn addGestureRecognizer:tap];
//        cell.videoView.playBtn.tag = indexPath.section + 100;
        [cell.videoView.playBtn.playOrPauseBtn addTarget:self action:@selector(showVideoPlayer:) forControlEvents:UIControlEventTouchUpInside];
        self.indexPath = indexPath;
        cell.personInfoView.delegate = self;
        
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate代理方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LXBaseFriend *status = self.statusArray[indexPath.section];
    
    // 海报秀/字幕秀模型
    if ([status.typeEn isEqualToString:@"PosterShow"] || [status.typeEn isEqualToString:@"SubTitleShow"]) {
        return [self.tableView fd_heightForCellWithIdentifier:posterCellID cacheByIndexPath:indexPath configuration:^(LXPosterCell *cell) {
//                        cell.poster = self.statusArray[indexPath.section];
                        cell.poster = self.statusArray[indexPath.section];
                }];
    }else if ([status.typeEn isEqualToString:@"MovieDetail"]) { // 影评
        return [self.tableView fd_heightForCellWithIdentifier:filmReviewCellID cacheByIndexPath:indexPath configuration:^(LXFilmReviewCell *cell) {
            cell.filmReview = self.statusArray[indexPath.section];
        }];
    }else if ([status.typeEn isEqualToString:@"DubbingShow"]) { // 配音秀
        return [self.tableView fd_heightForCellWithIdentifier:dubbingCellID cacheByIndexPath:indexPath configuration:^(LXDubbingCell *cell) {
            cell.poster = self.statusArray[indexPath.section];
        }];
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    LXBaseFriend *friend = self.statusArray[indexPath.section];
    LXWebViewController* webViewController = [[LXWebViewController alloc] initWithUrl:[NSURL URLWithString:friend.detailsUrl]];
    [self.navigationController pushViewController:webViewController animated:YES];
    [LXUserInfo user].shouldLoadNewData = NO;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 0;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

#pragma mark - LXPersonInfoViewDelegate代理方法
/**
 *  头像点击事件
 */
- (void)iconDidSelectWithInfo:(LXBaseFriend *)friend {
    NSLog(@"头像点击事件  %@", friend.userInfo.userName);
    NSInteger userId = [friend.userInfo.userId integerValue];
    if (self.userId != userId) {
        LXFriendViewController *vc = [[LXFriendViewController alloc] initWithFriendInfoUrl:LXPersonInfoUrl userId:userId statusUrl:LXOtherPersonDynamicUrl];
        [self.navigationController pushViewController:vc animated:YES];
        [LXUserInfo user].shouldLoadNewData = NO;
    }
}

/**
 *  点赞点击事件
 */
- (void)attitudeDidSelectWithInfo:(LXBaseFriend *)friend withBtn:(UIButton *)btn withCell:(UIView *)cell {
    NSInteger curUserId = [LXUserInfo user].userId.integerValue;
    NSInteger userId = friend.userInfo.userId.integerValue;
    NSInteger infoId = friend.infoId.integerValue;
    NSInteger commentId = friend.commentId.integerValue;
    NSString *urlStr = nil;
    
    if ([friend.typeEn isEqualToString:@"MovieDetail"]) { //  影评
        urlStr = [NSString stringWithFormat:@"%@/fishapi/api/FriendInfo/CommentLike?cuId=%ld|%ld|%ld&currentUserId=%ld&type=%@",
                  LXBaseUrl, infoId, commentId, userId, curUserId, friend.typeEn];
    }else { // 非影评
        urlStr = [NSString stringWithFormat:@"%@/fishapi/api/FriendInfo/Like?type=%@&currentUserId=%ld&titleId=%ld", LXBaseUrl, friend.typeEn, curUserId, infoId];
    }
    
    NSString *utl = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr GET:utl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        responseObject = [NSDictionary changeType:responseObject];
         if ([responseObject[@"state"] intValue] == 1) {
             LXAttitude *curAttitude = [LXAttitude objectWithKeyValues:responseObject[@"data"]];
             
             // 更新按钮状态
             btn.selected = curAttitude.currUserLike.boolValue;
             [btn setupOriginalTitle:@"赞" count:curAttitude.praiseCount.integerValue];
             
             // 更新数据模型
             friend.currUserLike = curAttitude.currUserLike;
             friend.praiseCount = curAttitude.praiseCount;
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     }];
}

/**
 *  评论点击事件
 */
- (void)commentDidSelectWithInfo:(LXBaseFriend *)friend {
    NSLog(@"评论点击事件  %@", friend.userInfo.userName);
    LXWebViewController* webViewController = [[LXWebViewController alloc] initWithUrl:[NSURL URLWithString:friend.detailsUrl]];
    [self.navigationController pushViewController:webViewController animated:YES];
    [LXUserInfo user].shouldLoadNewData = NO;
}

#pragma mark - LXFriendHeaderViewDelegate代理方法
/**
 *  动态按钮点击事件
 */
- (void)dynamicDidSelectWithInfo:(LXMyInfo *)myInfo {
    NSLog(@"动态按钮点击事件  %@", myInfo.nickName);
    if ((self.userId == [[[LXUserInfo user] userId] integerValue]) &&
                         ([self.statusUrl isEqualToString:LXFollowDynamicUrl])) {
        LXFriendViewController *vc = [[LXFriendViewController alloc] initWithFriendInfoUrl:LXPersonInfoUrl userId:self.userId statusUrl:LXOtherPersonDynamicUrl];
        [self.navigationController pushViewController:vc animated:YES];
        [LXUserInfo user].shouldLoadNewData = NO;
    }
}

/**
 *  粉丝按钮点击事件
 */
- (void)fanDidSelectWithInfo:(LXMyInfo *)myInfo {
    NSLog(@"粉丝按钮点击事件  %@", myInfo.nickName);
    NSString *url = nil;
    // 查看自己的粉丝列表
    if (self.userId == [[[LXUserInfo user] userId] integerValue]) {
        // http://devftp.lansum.cn/fashhtml/myData/fans.html?fansType=1
        url = [NSString stringWithFormat:@"%@2", LXFanListUrl];
    }else { // 查看他人的粉丝列表
        // http://devftp.lansum.cn/fashhtml/myData/fans.html?fansType=4&UserId=第三人的ID
        url = [NSString stringWithFormat:@"%@4&UserId=%ld", LXFanListUrl, self.userId];
    }
    NSLog(@"粉丝列表----%@", url);
    LXWebViewController *webVc = [[LXWebViewController alloc] initWithUrl:[NSURL URLWithString:url]];
    [self.navigationController pushViewController:webVc animated:YES];
    [LXUserInfo user].shouldLoadNewData = NO;
}


/**
 *  关注按钮点击事件
 */
- (void)followDidSelectWithInfo:(LXMyInfo *)myInfo {
    NSLog(@"关注按钮点击事件  %@", myInfo.nickName);
    NSString *url = nil;
    // 查看自己的粉丝列表
    if (self.userId == [[[LXUserInfo user] userId] integerValue]) {
        // http://devftp.lansum.cn/fashhtml/myData/fans.html?fansType=2
        url = [NSString stringWithFormat:@"%@1", LXFollowListUrl];
    }else { // 查看他人的粉丝列表
        // http://devftp.lansum.cn/fashhtml/myData/fans.html?fansType=3&UserId=第三人的ID
        url = [NSString stringWithFormat:@"%@3&UserId=%ld", LXFollowListUrl, self.userId];
    }
    NSLog(@"关注列表----%@", url);
    LXWebViewController *webVc = [[LXWebViewController alloc] initWithUrl:[NSURL URLWithString:url]];
    [self.navigationController pushViewController:webVc animated:YES];
    [LXUserInfo user].shouldLoadNewData = NO;
}

#pragma mark - LXMovieViewDelegate代理方法
- (void)movieViewDidSelectWithFilmInfo:(LXFilmInfo *)filmInfo {
    LXWebViewController* webViewController = [[LXWebViewController alloc] initWithUrl:[NSURL URLWithString:filmInfo.movieDetailUrl]];
    [self.navigationController pushViewController:webViewController animated:YES];
    [LXUserInfo user].shouldLoadNewData = NO;
}

@end
