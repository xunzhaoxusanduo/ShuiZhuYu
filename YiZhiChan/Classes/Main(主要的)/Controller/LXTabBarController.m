//
//  LXTabBarController.m
//  YiZhiChan
//
//  Created by wuyaju on 16/4/26.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXTabBarController.h"
#import "LXHomeViewController.h"
#import "LXBaseNavigationController.h"
#import "LXWebViewController.h"
#import "RxWebViewNavigationViewController.h"
#import "RxWebViewController.h"
#import "LXFriendViewController.h"
#import "LXPlayViewController.h"
#import "LXMovieViewController.h"
#import "LXCarouselWebViewController.h"
#import "LXSettingViewController.h"
#import "LXMeSettingViewController.h"
#import "LXCookie.h"
#import "UMessage.h"
#import "UIViewController+Extension.h"
#import "LXWebViewController.h"
#import "LXUserInfo.h"
#import "Macros.h"
#import "LXPushTool.h"
#import "YMCitySelect.h"
#import <CoreLocation/CoreLocation.h>
#import "LXRedDotRegister.h"
#import "GJRedDot.h"

#ifdef Unity
#import "UnityAppController.h"
#else
#import "AppDelegate.h"
#endif

@interface LXTabBarController () <CLLocationManagerDelegate, UITabBarControllerDelegate>

@property (nonatomic, strong)CLLocationManager *locationManager;

@end

@implementation LXTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [self setupAllChildViewControllers];
    [self setupLocationManager];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Topbar-bg"] forBarMetrics:UIBarMetricsDefault];
    
    [LXCookie updateSession];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginClose:) name:LXCLoginCloseNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRemotePush:) name:LXRemotePushNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLoginSuccess:) name:LXWebViewLoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLogoutSuccess:) name:LXWebViewLogoutSuccessNotification object:nil];
    
    [GJRedDot registWithProfile:@[@{LXTabBarHome: LXHomeMessage}]];
    __weak __typeof(&*self) weakSelf = self;
    [self setRedDotKey:LXTabBarHome refreshBlock:^(BOOL show) {
        UITabBarItem *homeTabBarItem = weakSelf.tabBar.items[0];
        homeTabBarItem.showRedDot = show;
    } handler:self];
    
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo != nil) {
        [self resetRedDotState:YES forKey:LXHomeMessage];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - 私有方法
/**
 *  开启定位
 */
- (void)setupLocationManager {
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [locationManager requestAlwaysAuthorization];
    }
    locationManager.delegate = self;
    self.locationManager = locationManager;
    [self.locationManager startUpdatingLocation];
}

/**
 *  初始化所有的子控制器
 */
- (void)setupAllChildViewControllers
{
    // 1、首页
    LXHomeViewController *homeVc = [[LXHomeViewController alloc] init];
    [self setupChildViewController:homeVc title:@"首页" imageName:@"home_tab_home" selectedImageName:@"home_tab_home"];
    
    // 2.电影票
    LXMovieViewController* movieVc = [[LXMovieViewController alloc] initWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/fashhtml/priceDetail.html?navbarstyle=0&search=1", LXBaseUrl]]];
    //    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"shuizhuyu1" ofType:@"bundle"];
    //    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    //    NSString *path = [bundle pathForResource:@"priceDetail" ofType:@"html" inDirectory:nil];
    //    LXMovieViewController* movieVc = [[LXMovieViewController alloc] initWithUrl:[NSURL fileURLWithPath:path]];
    [self setupChildViewController:movieVc title:@"电影票" imageName:@"home_tab_movie" selectedImageName:@"home_tab_movie"];
    
    // 3.玩吧
    LXPlayViewController* playVc = [[LXPlayViewController alloc] initWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/fashhtml/recreation/recreationShow.html?navbarstyle=0&search=1", LXBaseUrl]]];
    [self setupChildViewController:playVc title:@"玩吧" imageName:@"home_tab_play" selectedImageName:@"home_tab_play"];
    
    // 4.朋友圈
    LXFriendViewController* friendVc = [[LXFriendViewController alloc] init];
    [self setupChildViewController:friendVc title:@"朋友圈" imageName:@"home_tab_friend" selectedImageName:@"home_tab_friend"];
    
    // 5.我的
    LXMeSettingViewController *meVc = [[LXMeSettingViewController alloc] init];
    [self setupChildViewController:meVc title:@"我的" imageName:@"home_tab_me" selectedImageName:@"home_tab_me"];
    
    // 预加载所有控制器
    for (LXBaseNavigationController *navController in self.childViewControllers) {
        UIViewController *controller = navController.viewControllers[0];
        UIView *view = controller.view;
    }
}

/**
 *  初始化一个子控制器
 *
 *  @param childVc           需要初始化的子控制器
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    // 1.设置控制器的属性
    childVc.title = title;
    // 设置图标
    childVc.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    // 2.包装一个导航控制器
    LXBaseNavigationController *nav = [[LXBaseNavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
}

/**
 *  关闭登录页面通知
 *  如果当前在朋友圈界面，则直接跳转到主页
 */
- (void)loginClose:(NSNotification *)aNotification {
    if (self.selectedIndex == 3) {
        self.selectedIndex = 0;
    }
}

/**
 *  远程推送通知
 *
 */
- (void)handleRemotePush:(NSNotification *)aNotification {
    NSDictionary *userinfo = aNotification.userInfo[@"userInfo"];
    [self resetRedDotState:YES forKey:LXHomeMessage];
    if (userinfo) {
        
        // 程序处于前台
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
            //            self.childViewControllers[4].tabBarItem.badgeValue = @"12";
        }else {
            NSString *pushType = userinfo[@"pushType"];
            if ([pushType isEqualToString:@"home"]) {
                LXWebViewController* movieVc = [[LXWebViewController alloc]
                                                initWithUrl:[NSURL URLWithString:userinfo[@"url"]]];
                [[self topViewController].navigationController pushViewController:movieVc animated:YES];
            }else if ([pushType isEqualToString:@"me"]) {
                self.selectedIndex = 4;
                LXWebViewController* movieVc = [[LXWebViewController alloc]
                                                initWithUrl:[NSURL URLWithString:userinfo[@"url"]]];
                LXBaseNavigationController *nav = self.childViewControllers[4];
                [nav popToRootViewControllerAnimated:NO];
                [nav pushViewController:movieVc animated:YES];
                
                NSLog(@"%@", self.childViewControllers[4]);
            }
        }
    }
}

/**
 *  登录成功通知
 *
 */
- (void)handleLoginSuccess:(NSNotification *)aNotification {
    [LXPushTool setAlias:nil type:LXMessageAliasTypePraise key:LXAttitudeItemKey];
    [LXPushTool setAlias:nil type:LXMessageAliasTypeComment key:LXCommentItemKey];
}

/**
 *  退出登录通知
 *
 */
- (void)handleLogoutSuccess:(NSNotification *)aNotification {
    [LXPushTool removeAlias:nil type:LXMessageAliasTypePraise key:LXAttitudeItemKey];
    [LXPushTool removeAlias:nil type:LXMessageAliasTypeComment key:LXCommentItemKey];
}

#pragma mark 城市定位
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *ym_location =[locations firstObject];
    [self.locationManager stopUpdatingLocation];
    CLGeocoder *geocoder = [CLGeocoder new];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:ym_location.coordinate.latitude longitude:ym_location.coordinate.longitude];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count == 0 || error) {
            return;
        }
        else{
            CLPlacemark *placemark = placemarks.lastObject;
            if (placemark.locality) {
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSString * curCityName = [placemark.locality substringWithRange:NSMakeRange(0, [placemark.locality length] - 1)];
                NSLog(@"%@", curCityName);
                NSString *oldCityName = [defaults objectForKey:LXCurCityNameKey];
                // 当前定位城市和用户选择的不同
                if (![curCityName isEqualToString:oldCityName]) {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"您当前的城市是%@\n是否要切换？", curCityName] message:nil preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"切换" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [defaults setObject:curCityName forKey:LXCurCityNameKey];
                        [defaults synchronize];
                        [[NSNotificationCenter defaultCenter] postNotificationName:LXSelectNewCityNotification object:nil userInfo:@{LXNewCityNameKey: curCityName}];
                    }];
                    
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }];
                    
                    [alertController addAction:cancelAction];
                    [alertController addAction:okAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
            }
        }
    }];
}

@end