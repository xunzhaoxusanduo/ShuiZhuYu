//
//  LXCarouselWebViewController.m
//  YiZhiChan
//
//  Created by wuyaju on 16/5/9.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXCarouselWebViewController.h"
#import "LXSDCycleScrollView.h"
#import "UINavigationBar+Extend.h"
#import "LXMovieViewController.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworking.h"
#import "Masonry.h"
#import "Macros.h"
#import "LXWebViewController.h"
#import "LXReleaseMovie.h"
#import "WebViewJavascriptBridge.h"
#import "YMCitySelect.h"
#import <CoreLocation/CoreLocation.h>
#import "NSDictionary+NSNull.h"

#define ImageHeight self.view.frame.size.height * 0.6

@interface LXCarouselWebViewController () <LXSDCycleScrollViewDelegate, UIWebViewDelegate, UIScrollViewDelegate,
                                            CLLocationManagerDelegate>

@end

@implementation LXCarouselWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCarouselView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadReleaseMovie];
    NSLog(@"-------%@", NSStringFromCGSize(self.webView.scrollView.contentSize));
}

/**
 *  添加轮播视图
 */
- (void)setupCarouselView {
    NSArray *imagesURLStrings = @[
                                  @"http://123",
                                  @"https://3543",
                                  @"https://343",
                                  @"https://ghrgh"
                                  ];
    LXSDCycleScrollView *carouselScrollView = [LXSDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, -ImageHeight, self.view.frame.size.width, ImageHeight)
                                                                             delegate:nil placeholderImage:[UIImage imageNamed:@"placeholder"]];
    carouselScrollView.autoScroll = YES;
    carouselScrollView.autoScrollTimeInterval = 3.0;
    carouselScrollView.infiniteLoop = YES;
    carouselScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    carouselScrollView.imageURLStringsGroup = imagesURLStrings;
    self.carouselScrollView = carouselScrollView;
    
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.scrollView.delegate = self;
    [self.webView.scrollView addSubview:carouselScrollView];
    
    // 没有tabBar
    if (self.tabBarController == nil) {
        self.webView.scrollView.contentInset = UIEdgeInsetsMake(ImageHeight, 0, 0, 0);
    }else {
        if (self.navigationController.viewControllers.count <= 1) {
            self.webView.scrollView.contentInset = UIEdgeInsetsMake(ImageHeight, 0, 49, 0);
        }else {
            self.webView.scrollView.contentInset = UIEdgeInsetsMake(ImageHeight, 0, 0, 0);
        }
    }
    
    // 由于网页中嵌套了原生控件, 初始化的时候scrollView的偏移量不对，特殊情况处理
    [self.webView.scrollView setContentOffset:CGPointMake(0, -ImageHeight)];
    // 由于网页中嵌套了原生控件，初始化的时候scrollView的ContentSize不对，而网页加载需要一定的时间，会出现短暂的黑屏
    [self.webView.scrollView setContentSize:[UIScreen mainScreen].bounds.size];
    
    self.webView.hidden = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.webView.hidden = NO;
    });
}

#pragma mark - UIScrollViewDelegate代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (ImageHeight > 0) {
        UIColor *color = NavBarBackgroundColour;
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY > -ImageHeight) {
            CGFloat alpha = MIN(MinNavBarAlpha, 1- ((ImageHeight - 64 - (ImageHeight + offsetY)) / 64));
            [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        } else {
            [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
        }
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)releaseMovieArray {
    if (_releaseMovieArray == nil) {
        _releaseMovieArray = [NSMutableArray array];
    }
    
    return _releaseMovieArray;
}

#pragma mark - 私有方法
/**
 *  重新加载网页
 */
- (void)reloadWebView {
    [super reloadWebView];
    [self loadReleaseMovie];
}

- (void)setCarouselUrl:(NSString *)carouselUrl {
    _carouselUrl = [carouselUrl copy];
    [self loadReleaseMovie];
}

/**
 *  加载海报数据
 */
- (void)loadReleaseMovie {
    if (self.carouselUrl) {
        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
        
        [mgr GET:self.carouselUrl parameters:nil
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
            responseObject = [NSDictionary changeType:responseObject];
            if ([responseObject[@"state"] intValue] == 1) {
             self.releaseMovieArray = (NSMutableArray *)[LXReleaseMovie objectArrayWithKeyValuesArray:responseObject[@"data"]];
                if (self.releaseMovieArray.count > 0) {
                    __block NSMutableArray *imagesURLStringsArray = [NSMutableArray array];
                    for (LXReleaseMovie *releaseMovie in self.releaseMovieArray) {
                        [imagesURLStringsArray addObject:releaseMovie.cover];
                    }

                    self.carouselScrollView.imageURLStringsGroup = imagesURLStringsArray;
                }
            }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
         }];
    }
}

@end
