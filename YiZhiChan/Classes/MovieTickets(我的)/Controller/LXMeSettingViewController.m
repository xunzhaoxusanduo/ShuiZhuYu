//
//  LXMeSettingViewController.m
//  YiZhiChan
//
//  Created by wuyaju on 16/5/14.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXMeSettingViewController.h"
#import "MJSettingArrowItem.h"
#import "MJSettingGroup.h"
#import "MBProgressHUD+MJ.h"
#import "UINavigationBar+Extend.h"
#import "Macros.h"
#import "LXSettingViewController.h"
#import "YMCitySelect.h"
#import "HFStretchableTableHeaderView.h"
#import "LXMeHeaderView.h"
#import "LXMyInfoViewController.h"
#import "LXMyInfo.h"
#import "MJExtension.h"
#import "LXMyFriendsController.h"
#import "LXWebViewController.h"
#import "LXBaseNavigationController.h"
#import "LXUserInfo.h"
#import "LXRefreshTitleView.h"
#import "MJRefresh.h"
#import "LXExperienceView.h"
#import "LXBadgedItem.h"
#import "LXMyMessageViewController.h"
#import "NSDictionary+NSNull.h"
#import "AFNetworking.h"

@interface LXMeSettingViewController () <YMCitySelectDelegate, LXMeHeaderViewDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong)MJSettingItem *switchCityItem;
@property (nonatomic, strong)MJSettingItem *myMessageItem;
@property (nonatomic, strong)HFStretchableTableHeaderView* stretchableTableHeaderView;
@property (nonatomic, strong)LXMeHeaderView *headerView;
@property (nonatomic, strong)LXRefreshTitleView *titleView;
@property (nonatomic, assign)BOOL refreshFlg;

@end

@implementation LXMeSettingViewController

- (void)viewDidLoad
{
    NSLog(@"我的viewDidLoad");
    [super viewDidLoad];
    
    // 1.标题
    [self setupTitleView];
    
    // 2.添加头部视图
    [self setupHeadView];
    
    // 3.添加数据
    [self setupGroup];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectNewCity:) name:LXSelectNewCityNotification object:nil];
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.backgroundColor = RGB(239, 239, 239);
    
    [self loadMyInfo];
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"我的界面viewWillAppear");
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.myMessageItem.subtitle = self.tabBarItem.badgeValue;
    NSLog(@"%@", self.myMessageItem.subtitle);
    NSLog(@"%@", self.tabBarItem.badgeValue);
    [self loadMyInfo];
    [self.tableView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark -  私有方法
- (void)setupHeadView {
    LXMeHeaderView *headerView = [[LXMeHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*0.4)];
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
    if ([[LXUserInfo user] isLogin]) {
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

- (void)setupTitleView {
    LXRefreshTitleView *titleView = [[LXRefreshTitleView alloc] init];
    titleView.titleLbl.text = @"我的";
    self.navigationItem.titleView = titleView;
    self.titleView = titleView;
}

- (void)setupGroup
{
    MJSettingItem *myMovieRecommendItem = [MJSettingArrowItem itemWithIcon:@"me_recommend" title:@"我的影评" destVcClass:[LXWebViewController class] isNeedLogin:YES
                                                                    urlStr:[NSString stringWithFormat:@"%@/fashhtml/myData/filmReview.html?navbarstyle=0", LXBaseUrl]];
    MJSettingItem *myMessageItem = [LXBadgedItem itemWithIcon:@"me_news" title:@"我的消息" destVcClass:[LXMyMessageViewController class] isNeedLogin:YES];
    self.myMessageItem = myMessageItem;
    MJSettingItem *myfavoriteItem = [MJSettingArrowItem itemWithIcon:@"me_collection" title:@"我的收藏" destVcClass:[LXWebViewController class] isNeedLogin:YES
                                                              urlStr:[NSString stringWithFormat:@"%@/fashhtml/myData/filmReviewCollect.html?navbarstyle=0", LXBaseUrl]];
//    MJSettingItem *myAccountItem = [MJSettingArrowItem itemWithIcon:@"me_account" title:@"我的账户" destVcClass:[LXWebViewController class] isNeedLogin:YES
//                                                             urlStr:[NSString stringWithFormat:@"%@/fashhtml/myData/account.html?navbarstyle=0", LXBaseUrl]];
    MJSettingGroup *group0 = [[MJSettingGroup alloc] init];
    group0.items = @[myMovieRecommendItem, myfavoriteItem, myMessageItem];
    [self.data addObject:group0];
    
    MJSettingItem *myInfoItem = [MJSettingArrowItem itemWithIcon:@"me_info" title:@"我的信息" destVcClass:[LXMyInfoViewController class] isNeedLogin:YES
                                                          urlStr:[NSString stringWithFormat:@"%@/fashhtml/myData/baseMessage.html?navbarstyle=1", LXBaseUrl]];
    MJSettingItem *myFriendItem = [MJSettingArrowItem itemWithIcon:@"me_friend" title:@"我的好友" destVcClass:[LXMyFriendsController class] isNeedLogin:YES];
    MJSettingItem *switchCityItem = [MJSettingArrowItem itemWithIcon:@"me_switchCity" title:@"切换城市" destVcClass:nil isNeedLogin:NO];
    switchCityItem.option = ^{
        [self presentViewController:[[YMCitySelect alloc] initWithDelegate:nil] animated:YES completion:nil];
    };
    NSString *curCityName = [[NSUserDefaults standardUserDefaults] objectForKey:LXCurCityNameKey];
    if (curCityName == nil) {
        [self presentViewController:[[YMCitySelect alloc] initWithDelegate:nil] animated:YES completion:nil];
    }else {
        switchCityItem.subtitle = curCityName;
    }
    self.switchCityItem = switchCityItem;
    MJSettingGroup *group1 = [[MJSettingGroup alloc] init];
    group1.items = @[myInfoItem, myFriendItem, switchCityItem];
    [self.data addObject:group1];
    
    MJSettingItem *settingItem = [MJSettingArrowItem itemWithIcon:@"me_setting" title:@"设置" destVcClass:[LXSettingViewController class] isNeedLogin:NO];
    MJSettingGroup *group2 = [[MJSettingGroup alloc] init];
    group2.items = @[settingItem];
    [self.data addObject:group2];
}

/**
 *  加载个人信息
 */
- (void)loadMyInfo {
    // 已经登录过
    if ([[LXUserInfo user] updateByCookieWithURL:nil]) {
        NSString *urlStr = [NSString stringWithFormat:@"%@/fishapi/api/User/UserInfo?UserId=%ld", LXBaseUrl, [[LXUserInfo user].userId integerValue]];
        
        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
        
        [mgr GET:urlStr parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             __block LXMyInfo *myInfo = nil;
             responseObject = [NSDictionary changeType:responseObject];
             if ([responseObject[@"state"] intValue] == 1) {
                 myInfo = (LXMyInfo *)[LXMyInfo objectWithKeyValues:responseObject[@"data"]];
             }
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 NSLog(@"dispatch_async");
                 self.headerView.myInfo = myInfo;
                 [self.titleView.indicatorView stopAnimating];
             });
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [self.titleView.indicatorView stopAnimating];
         }];
        
    }else {// 没有登录过
        self.headerView.myInfo = nil;
    }
}

- (void)selectNewCity:(NSNotification *)aNotification {
    NSDictionary *userInfo = aNotification.userInfo;
    NSString *cityName = userInfo[LXNewCityNameKey];
    self.switchCityItem.subtitle = cityName;
}

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
}

/**
 *  停止滚动开始刷新
 *
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.titleView.indicatorView isAnimating]) {
        [self loadMyInfo];
    }
}

- (void)viewDidLayoutSubviews {
    [_stretchableTableHeaderView resizeView];
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
            [self loadMyInfo];
        }else {
            [MBProgressHUD showError:@"上传失败！"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - LXMeHeaderViewDelegate代理方法
- (void)loginBtnClicked {
    [[LXUserInfo user] isLogin:self];
}

- (void)iconClicked {
    if ([[LXUserInfo user] isLogin:self]) {
        LXWebViewController *vc = [[LXWebViewController alloc] initWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/fashhtml/myData/baseMessage.html?navbarstyle=1", LXBaseUrl]]];
        [self.navigationController pushViewController:vc  animated:YES];
    }
}

- (void)experienceDidSelectWithInfo:(LXMyInfo *)myInfo {
    LXExperienceView *experienceView = [[LXExperienceView alloc] initWithFrame:self.view.frame];
    experienceView.myInfo = myInfo;
    [self.view addSubview:experienceView];
    
    experienceView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        experienceView.alpha = 1;
    }];
}

- (void)pointsDidSelectWithInfo:(LXMyInfo *)myInfo {
    LXWebViewController *webVc = [[LXWebViewController alloc] initWithUrl:[NSURL URLWithString:myInfo.pointUrl]];
    [self.navigationController pushViewController:webVc animated:YES];
}

@end
