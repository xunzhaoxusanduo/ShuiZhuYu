//
//  LXMovieViewController.m
//  YiZhiChan
//
//  Created by wuyaju on 16/4/30.
//  Copyright © 2016年 吴亚举. All rights reserved.
//  电影票控制器

#import "LXMovieViewController.h"
#import "YMCitySelect.h"
#import "WebViewJavascriptBridge.h"
#import "LXSDCycleScrollView.h"
#import "LXReleaseMovie.h"
#import <CoreLocation/CoreLocation.h>
#import "LXTitleBtn.h"
#import "Masonry.h"
#import "Macros.h"
#import "LXRegionMenuViewController.h"
#import "SUPopupsView.h"
#import "HHDropDownMenu.h"
#import "UINavigationBar+Extend.h"

@interface LXMovieViewController () <CLLocationManagerDelegate, LXWebViewControllerDelegate, LXSDCycleScrollViewDelegate, HHDropDownMenuDelegate, UITableViewDelegate>

@property (nonatomic, strong)CLLocationManager *locationManager;
@property (nonatomic, strong)NSTimer *gpsTimer;
@property (nonatomic, strong)UIButton *locationBtn;
@property (nonatomic, strong)LXTitleBtn *titleBtn;
@property (nonatomic, strong)LXRegionMenuViewController *regionVc;
@property (nonatomic, strong)HHDropDownMenu *menu;

@end

@implementation LXMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"电影票";
    
    [self setupWebViewJavascriptBridge];
    [self setupLocationManager];
//    [self setupNavBar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectNewCity:) name:LXSelectNewCityNotification object:nil];
    [self setupTitleView];
    
    // 轮播海报地址
    self.carouselUrl = [NSString stringWithFormat:@"%@/fishapi/api/movie/ticketmovie", LXBaseUrl];
    
    self.carouselScrollView.autoScroll = NO;
    self.carouselScrollView.delegate = self;
    self.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *curCityName = [[NSUserDefaults standardUserDefaults] objectForKey:LXCurCityNameKey];
    if (curCityName == nil) {
        [self presentViewController:[[YMCitySelect alloc] initWithDelegate:nil] animated:YES completion:nil];
    }else {
        [self.locationBtn setTitle:curCityName forState:UIControlStateNormal];
    }
}

#pragma mark - 私有方法
/**
 *  设置导航栏的内容
 */
- (void)setupNavBar {
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
    
    if (self.navigationController.childViewControllers.count == 1) {
        self.navigationItem.leftBarButtonItem = locationBtnItem;
    }else {
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:navigationLeftSpacer, locationBtnItem,nil];
    }
    
    self.navigationItem.leftItemsSupplementBackButton = YES;
}

- (void)setupTitleView {
    WS(weakSelf);
    
    LXTitleBtn *titleBtn = [[LXTitleBtn alloc] init];
    NSString *regionName = [[NSUserDefaults standardUserDefaults] objectForKey:LXRegionKey];
    if (regionName == nil) {
        regionName = @"全部";
        [[NSUserDefaults standardUserDefaults] setObject:@"全部" forKey:LXRegionKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    titleBtn.titleLbl.text = [NSString stringWithFormat:@"您所在的地区：%@", regionName];
    titleBtn.titleLbl.shadowColor = RGBA(0, 0, 0, 0.5);
    titleBtn.titleLbl.shadowOffset = CGSizeMake(1.2, 1.2);
    [self.carouselScrollView addSubview:titleBtn];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [titleBtn addGestureRecognizer:tapGesture];
    self.titleBtn = titleBtn;
    
    [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.carouselScrollView.mas_centerX);
        make.bottom.equalTo(weakSelf.carouselScrollView.mas_bottom).offset(-5);
        make.size.mas_equalTo(CGSizeMake(200, 30));
    }];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    if (self.titleBtn.selected) {
        self.titleBtn.selected = NO;
    }else {
        self.titleBtn.selected = YES;
        [self setupRegionView];
    }
}

- (void)setupRegionView {
    LXRegionMenuViewController *regionVc = [[LXRegionMenuViewController alloc] init];
    regionVc.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 170);
    
    // 1.创建下拉菜单
    HHDropDownMenu *menu = [HHDropDownMenu menu];
    menu.delegate = self;
    self.menu = menu;
    
    // 2.设置内容(这里是创建了一个控制器)
    menu.contentViewController = regionVc;
    
    // 3.显示
    [menu showFrom:self.titleBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectRegion:) name:LXSelectRegionNotification object:nil];
}

- (void)citySelect {
    [self presentViewController:[[YMCitySelect alloc] initWithDelegate:nil] animated:YES completion:nil];
}

/**
 *  选择新的城区通知
 *
 */
- (void)selectRegion:(NSNotification *)aNotification {
    [UIView animateWithDuration:0.3 animations:^{
        self.menu.alpha = 0;
    } completion:^(BOOL finished) {
        self.menu = nil;
    }];
    
    self.titleBtn.selected = NO;
    
    NSString *regionName = [[NSUserDefaults standardUserDefaults] objectForKey:LXRegionKey];
    self.titleBtn.titleLbl.text = [NSString stringWithFormat:@"您所在的地区：%@", regionName];
    
    [self myWebViewDidFinishLoad:nil];
}

/**
 *  选择新的城市通知
 *
 */
- (void)selectNewCity:(NSNotification *)aNotification {
    NSDictionary *userInfo = aNotification.userInfo;
    NSString *cityName = userInfo[LXNewCityNameKey];
    [self.locationBtn setTitle:cityName forState:UIControlStateNormal];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"全部" forKey:LXRegionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.titleBtn.titleLbl.text = [NSString stringWithFormat:@"您所在的地区：全部"];
    
    [self myWebViewDidFinishLoad:nil];
}

- (void)setupWebViewJavascriptBridge {
    // web端调用iOS获取当前经纬度
    [self.bridge registerHandler:@"mobileGetLocation" handler:^(id data, WVJBResponseCallback responseCallback) {
        self.gpsTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(getGpsTimer) userInfo:nil repeats:NO];
        [self.locationManager startUpdatingLocation];
    }];
    // web端调用iOS获取当前城市
    [self.bridge registerHandler:@"mobileGetCity" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *cityName = [[NSUserDefaults standardUserDefaults] objectForKey:LXCurCityNameKey];
        NSString *region = [[NSUserDefaults standardUserDefaults] objectForKey:LXRegionKey];
        if (region == nil) {
            region = @"全部";
        }
        NSString *respondJson = [NSString stringWithFormat:@"{\"cityName\": \"%@\", \"regionName\": \"%@\"}", cityName, region];
//        NSLog(@"%@", respondJson);
        responseCallback(respondJson);
    }];
}

/**
 *  设置定位
 */
- (void)setupLocationManager {
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [locationManager requestAlwaysAuthorization];
    }
    self.locationManager = locationManager;
}

/**
 *  获取经纬度超时
 *
 */
- (void)getGpsTimer {
    if ([self.gpsTimer isValid]) {
        [self.gpsTimer invalidate];
        self.gpsTimer = nil;
        CLLocationDegrees longitude = [[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"] doubleValue];
        CLLocationDegrees latitude = [[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"] doubleValue];
        NSString *locationJson=[NSString stringWithFormat:@"{\"longitude\": %f, \"latitude\": %f}", longitude, latitude];
        [self.bridge callHandler:@"setLocationIphone" data:locationJson responseCallback:^(id response) {
        }];
//        NSLog(@"%@", locationJson);
    }
}

/**
 *  根据index更新网页电影票信息
 *
 */
- (void)updateWebMovieInfo:(NSInteger)index {
    
//    NSLog(@"%ld", (long)index);
//    NSLog(@"%lu", (unsigned long)self.releaseMovieArray.count);
    
    if (index < self.releaseMovieArray.count) {
        LXReleaseMovie *releaseMovie = self.releaseMovieArray[index];
        NSString *cityName = [[NSUserDefaults standardUserDefaults] objectForKey:LXCurCityNameKey];
        NSString *region = [[NSUserDefaults standardUserDefaults] objectForKey:LXRegionKey];
        if (region == nil) {
            region = @"全部";
        }
        NSString *respondJson = [NSString stringWithFormat:@"{\"movieInfoId\": %ld,\"cityName\": \"%@\", \"regionName\": \"%@\"}", releaseMovie.movieInfoId.integerValue, cityName, region];
//        NSLog(@"%@", respondJson);
        [self.bridge callHandler:@"getMovieInfoId" data:respondJson responseCallback:nil];
    }
}

#pragma mark - CLLocationManagerDelegate代理方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    // 取消超时定时器
    if ([self.gpsTimer isValid]) {
        [self.gpsTimer invalidate];
        self.gpsTimer = nil;
    }
    
    [self.locationManager stopUpdatingLocation];
    CLLocation *location = [locations firstObject];
    NSString *locationJson=[NSString stringWithFormat:@"{\"longitude\": %f, \"latitude\": %f}",location.coordinate.longitude, location.coordinate.latitude];
    [self.bridge callHandler:@"setLocationIphone" data:locationJson responseCallback:^(id response) {
    }];
    
    // 保存经纬度
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:location.coordinate.longitude] forKey:@"longitude"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:location.coordinate.latitude] forKey:@"latitude"];
    NSLog(@"%@", locationJson);
}

#pragma mark - LXWebViewControllerDelegate代理方法
- (void)myWebViewDidFinishLoad:(UIWebView *)webView {
//    NSLog(@"myWebViewDidFinishLoad");
    NSIndexPath *indexPath = [self.carouselScrollView currentIndex];
    if (indexPath) {
        NSInteger itemIndex = indexPath.item % self.carouselScrollView.imagePathsGroup.count;
        [self updateWebMovieInfo:itemIndex];
    }
}

#pragma mark - LXSDCycleScrollViewDelegate代理方法
- (void)cycleScrollView:(LXSDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    [self updateWebMovieInfo:index];
}

- (void)cycleScrollView:(LXSDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    NSIndexPath *indexPath = [self.carouselScrollView currentIndex];
    if (indexPath) {
        NSInteger itemIndex = indexPath.item % self.carouselScrollView.imagePathsGroup.count;
        [self updateWebMovieInfo:itemIndex];
    }
}

#pragma mark - HHDropDownMenuDelegate
- (void)HHDropDownMenuDidShow:(HHDropDownMenu *)menu {
    // 让箭头向下
    self.titleBtn.selected = YES;
}

- (void)HHDropDownMenuDidDismiss:(HHDropDownMenu *)menu {
    // 让箭头向上
    self.titleBtn.selected = NO;
    self.menu = nil;
}

@end
