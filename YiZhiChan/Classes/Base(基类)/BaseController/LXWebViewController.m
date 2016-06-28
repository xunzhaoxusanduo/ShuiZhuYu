//
//  LXWebViewController.m
//  YiZhiChan
//
//  Created by wuyaju on 16/4/29.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXWebViewController.h"
#import "UINavigationBar+Extend.h"
#import "LXMovieViewController.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworking.h"
#import "Masonry.h"
#import "Macros.h"
#import "WebViewJavascriptBridge.h"
#import "LXCookie.h"
#import "LXUserInfo.h"
#import "LXBaseNavigationController.h"
#import "LXFriendViewController.h"
#import "LXPushTool.h"
#import "AFNetworking.h"
#import "NSDictionary+NSNull.h"

#ifdef Unity
#import "UnityAppController.h"
#endif

@interface LXWebViewController () <UIWebViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong)MBProgressHUD *hud;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, strong)UIView *reloadBgView;
@property (nonatomic, assign)CGFloat imageHeight;
@property (nonatomic, strong)UIButton *collectBtn;

@end

@implementation LXWebViewController

- (instancetype)initWithUrl:(NSURL *)url {
    if (self = [super init]) {
        self.url = url;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupWebView];
    [self setupNoNetwork];
    [self setupRefreshView];
    [self setupBaseNavBar];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            [MBProgressHUD showError:@"您的网络好像不太顺畅！"];
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cookiesChanged:) name:NSHTTPCookieManagerCookiesChangedNotification object:nil];
}

- (void)cookiesChanged:(NSNotification *)aNotification {
    NSLog(@"cookiesChanged");
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookiesArray = [cookieStorage cookies];
    if (cookiesArray) {
        [LXCookie saveLoginSession];
        [[LXUserInfo user] updateByCookieWithURL:nil];
    }
}

- (void)setupWebView {
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = self.view.frame;
    webView.delegate = self;
    webView.scrollView.delegate = self;
    [self.view addSubview:webView];

    // 没有tabBar
    if (self.tabBarController == nil) {
        webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }else {
        if (self.navigationController.viewControllers.count <= 1) {
            webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
        }else {
            webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }
    }
    self.webView = webView;
    
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    [self.bridge setWebViewDelegate:self];
    [self.bridge registerHandler:@"handleArPosterFromJS" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"handleArPosterFromJS called: %@", data);
        #ifdef Unity
        LXBaseNavigationController *nav = [[LXBaseNavigationController alloc] initWithRootViewController:[GetAppController() rootViewController]];
        [self presentViewController:nav animated:YES completion:nil];
        [GetAppController() restartUnity];
        #endif
    }];
    
    // web端调用iOS弹出登录界面
    [self.bridge registerHandler:@"presentLoginFromJS" handler:^(id data, WVJBResponseCallback responseCallback) {
        // 调用登录页面
        LXWebViewController* webViewController = [[LXWebViewController alloc] initWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/fashhtml/form/phoneLogin.html?navbarstyle=0", LXBaseUrl]]];
        LXBaseNavigationController *nav = [[LXBaseNavigationController alloc]initWithRootViewController:webViewController];
        [self presentViewController:nav animated:YES completion:nil];
    }];
    
    // web端调用iOS登录成功
    [self.bridge registerHandler:@"loginSuccessFromJS" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self dismissViewControllerAnimated:YES completion:nil];
        // 发出通知
        [[NSNotificationCenter defaultCenter] postNotificationName:LXWebViewLoginSuccessNotification object:nil userInfo:nil];
    }];
    
    // web端调用iOS关闭登录页面
    [self.bridge registerHandler:@"loginCloseFromJS" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:LXCLoginCloseNotification object:nil userInfo:nil];
    }];
    
    // web端调用iOS打开朋友空间
    [self.bridge registerHandler:@"getDynamic" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSInteger userID = [data[@"userId"] integerValue];
        LXFriendViewController *vc = [[LXFriendViewController alloc] initWithFriendInfoUrl:LXPersonInfoUrl userId:userID statusUrl:LXOtherPersonDynamicUrl];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    // web端调用iOS关闭个人信息修改页面
    [self.bridge registerHandler:@"popPersonInfoFromJS" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    // web端调用iOS关闭搜索页面
    [self.bridge registerHandler:@"closeSearchFromJS" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    // web端调用iOS设置当前页面标题
    [self.bridge registerHandler:@"setTitleFromJS" handler:^(id data, WVJBResponseCallback responseCallback) {
        self.title = data;
    }];
    
    // web端调用iOS设置收藏按钮状态
    [self.bridge registerHandler:@"setCollectBtnState" handler:^(id data, WVJBResponseCallback responseCallback) {
        if ([LXUserInfo user].isLogin) {
            self.collectBtn.selected = [data boolValue];
        }
    }];
    
    if (self.url) {
        NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
        [self.webView loadRequest:request];
    }
}

/**
 *  添加网络不可用时的提示控件
 */
- (void)setupNoNetwork {
    WS(weakself);
    
    UIView *reloadBgView = [[UIView alloc] init];
    reloadBgView.backgroundColor = [UIColor whiteColor];
    reloadBgView.hidden = YES;
    [self.webView addSubview:reloadBgView];
    self.reloadBgView = reloadBgView;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"global_no_network"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [reloadBgView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"亲，您的手机网络不太顺畅喔~";
    [reloadBgView addSubview:label];
    
    UIButton *reloadBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [reloadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
    [reloadBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [reloadBtn addTarget:self action:@selector(reloadWebView) forControlEvents:UIControlEventTouchUpInside];
    reloadBtn.layer.borderColor = [UIColor grayColor].CGColor;
    reloadBtn.layer.borderWidth = 1.0f;
    reloadBtn.layer.cornerRadius = 5.0f;
    [reloadBgView addSubview:reloadBtn];
    
    [reloadBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakself.webView);
    }];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.reloadBgView.mas_centerX);
        make.centerY.equalTo(weakself.reloadBgView.mas_centerY).offset(-20);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.reloadBgView.mas_centerX);
        make.top.mas_equalTo(imageView.mas_bottom);
        make.height.mas_equalTo(20);
    }];
    
    [reloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.reloadBgView.mas_centerX);
        make.top.mas_equalTo(label.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
}

/**
 *  集成刷新控件
 */
- (void)setupRefreshView
{
    __unsafe_unretained UIWebView *webView = self.webView;
    __unsafe_unretained UIScrollView *scrollView = self.webView.scrollView;
    
    // 添加下拉刷新控件
    scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadWebView)];
    scrollView.mj_header.automaticallyChangeAlpha = YES;
}

- (void)setupBaseNavBar {
    // 设置导航栏右侧内容
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    searchBtn.frame = CGRectMake(0, 0, 20, 20);
    [searchBtn setImage:[UIImage imageNamed:@"navBar_search"] forState:UIControlStateNormal];
    searchBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [searchBtn addTarget:self action:@selector(searchClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *searchBtnItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    shareBtn.frame = CGRectMake(0, 0, 20, 20);
    [shareBtn setImage:[UIImage imageNamed:@"navBar_share"] forState:UIControlStateNormal];
    shareBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [shareBtn addTarget:self action:@selector(shareClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareBtnItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    
    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collectBtn.frame = CGRectMake(0, 0, 20, 20);
    [collectBtn setImage:[UIImage imageNamed:@"navBar_collect"] forState:UIControlStateNormal];
    [collectBtn setImage:[UIImage imageNamed:@"navBar_collect_select"] forState:UIControlStateSelected];
    collectBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [collectBtn addTarget:self action:@selector(collectClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.collectBtn = collectBtn;
    UIBarButtonItem *collectBtnItem = [[UIBarButtonItem alloc] initWithCustomView:collectBtn];
    
    NSMutableArray *rightArray = [NSMutableArray array];
    
    // 需要显示分享按钮
    if ([self.url.absoluteString containsString:@"share=1"]) {
        [rightArray addObject:shareBtnItem];
    }
    
    // 需要显示收藏按钮
    if ([self.url.absoluteString containsString:@"collect=1"]) {
        [rightArray addObject:collectBtnItem];
    }
    
    // 需要显示搜索按钮
    if ([self.url.absoluteString containsString:@"search=1"]) {
        [rightArray addObject:searchBtnItem];
    }
    
    self.navigationItem.rightBarButtonItems = rightArray;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 页面顶部是图片，navBar颜色需要渐变
    if ([self.url.absoluteString containsString:@"navbarstyle=0"]) {
        self.navigationController.navigationBar.hidden = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
        // 保证每次进入的时候，navBar渐变的状态和上次一样
        [self scrollViewDidScroll:self.webView.scrollView];
    }else if ([self.url.absoluteString containsString:@"navbarstyle=hidden"]) {// navBar需要隐藏
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.navigationController.navigationBar.hidden = YES;
    }else { // 页面顶部不是图片，navBar颜色不需要渐变
        self.navigationController.navigationBar.hidden = NO;
        self.automaticallyAdjustsScrollViewInsets = YES;
        [self.navigationController.navigationBar lt_setBackgroundColor:NavBarBackgroundColour];
    }
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self hideProgressHUD];
}

#pragma mark - UIWebViewDelegate代理方法
/**
 *  搜索点击事件
 */
- (void)searchClicked {
    LXWebViewController *webVc = [[LXWebViewController alloc] initWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/fashhtml/search.html?navbarstyle=hidden", LXBaseUrl]]];
    LXBaseNavigationController *nav = [[LXBaseNavigationController alloc] initWithRootViewController:webVc];
    [self presentViewController:nav animated:YES completion:nil];
}

/**
 *  收藏点击事件
 */
- (void)collectClicked:(UIButton *)btn {
    // 已经登录
    if ([[LXUserInfo user] isLogin:self]) {
        // 当前已经收藏
        if (btn.selected) {
            [self.bridge callHandler:@"getMovieInfoId" data:nil responseCallback:^(id response) {
                NSInteger userId = [LXUserInfo user].userId.integerValue;
                NSInteger movieInfoId = [response[@"MovieInfoId"] integerValue];
                
                AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
                NSString *urlStr = [NSString stringWithFormat:@"%@/fishapi/api/Movie/UnCollectionMovie?UserId=%ld&MovieInfoId=%ld", LXBaseUrl, userId, movieInfoId];
                [mgr GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    responseObject = [NSDictionary changeType:responseObject];
                    if ([responseObject[@"state"] intValue] == 1) {
                        if ([responseObject[@"data"] boolValue] == true) {
                            btn.selected = NO;
                        }
                    }
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     
                 }];
            }];
            
        }else {// 当前没有收藏
            [self.bridge callHandler:@"getMovieInfoId" data:nil responseCallback:^(id response) {
                NSInteger userId = [LXUserInfo user].userId.integerValue;
                NSInteger movieInfoId = [response[@"MovieInfoId"] integerValue];
                
                AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
                NSString *urlStr = [NSString stringWithFormat:@"%@/fishapi/api/Movie/CollectionMovie?UserId=%ld&MovieInfoId=%ld", LXBaseUrl, userId, movieInfoId];
                [mgr GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    responseObject = [NSDictionary changeType:responseObject];
                    if ([responseObject[@"state"] intValue] == 1) {
                        if ([responseObject[@"data"] boolValue] == true) {
                            btn.selected = YES;
                        }
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
            }];
        }
    }
}

/**
 *  分享点击事件
 */
- (void)shareClicked {
    [self.bridge callHandler:@"getShareInfo" data:nil responseCallback:^(id response) {
        NSLog(@"getShareInfo responded: %@", response);
        if (response) {
            [LXPushTool shareWithViewController:self title:response[@"title"] imageUrl:response[@"imageUrl"] content:response[@"content"] contentUrl:response[@"url"]];
        }
    }];
}

/**
 *  是否加载
 *
 */
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"\r\n");
    NSLog(@"shouldStartLoadWithRequest");
    
    // 网络可用
    if ([[AFNetworkReachabilityManager sharedManager] isReachable]) {
        self.reloadBgView.hidden = YES;
        
        if (self.hud == nil) {
            self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            if (self.timer == nil) {
                self.timer = [NSTimer scheduledTimerWithTimeInterval:8.0 target:self selector:@selector(progressHUDTimer) userInfo:nil repeats:YES];
            }
        }
    }else {// 网络不可用
        self.reloadBgView.hidden = NO;
    }

    if (request.URL == nil) {
        return YES;
    }
    
    if ([request.URL.absoluteString isEqualToString:@"about:blank"]) {
        return YES;
    }
    
    if ([request.URL.absoluteString isEqualToString:self.url.absoluteString]) {
        return YES;
    }
    
    NSLog(@"navigationType = %ld", navigationType);
    
    switch (navigationType) {
        case UIWebViewNavigationTypeLinkClicked: {
            [self hideProgressHUD];
            NSLog(@"%@", request.URL.absoluteString);
            LXWebViewController* webViewController = [[LXWebViewController alloc] initWithUrl:request.URL];
            [self.navigationController pushViewController:webViewController animated:YES];
            return NO;
            break;
        }
        case UIWebViewNavigationTypeFormSubmitted: {
            [self hideProgressHUD];
            LXWebViewController* webViewController = [[LXWebViewController alloc] initWithUrl:request.URL];
            [self.navigationController pushViewController:webViewController animated:YES];
            return NO;
            break;
        }
        case UIWebViewNavigationTypeBackForward: {
            break;
        }
        case UIWebViewNavigationTypeReload: {
            break;
        }
        case UIWebViewNavigationTypeFormResubmitted: {
            break;
        }
        case UIWebViewNavigationTypeOther: {
            break;
        }
        default: {
            break;
        }
    }

    return YES;
}

/**
 *  开始加载
 *
 */
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

/**
 *  加载完成
 *
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webViewDidFinishLoad");
    [self hideProgressHUD];
    
    // 防止当前控制器为navigationController的根控制器，如果title从网页获取，造成tabBar的标题改变
    if ([self.navigationController.viewControllers count] > 1) {
        if ([webView.request.URL.absoluteString containsString:@"movieDetail.html"]) {
            
        }else if ([webView.request.URL.absoluteString containsString:@"fans.html"]) {
            
        }else {
            NSString *theTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
            if (theTitle.length > 10) {
                theTitle = [[theTitle substringToIndex:9] stringByAppendingString:@"…"];
            }
            self.title = theTitle;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(myWebViewDidFinishLoad:)]) {
        [self.delegate myWebViewDidFinishLoad:webView];
    }
    
    self.imageHeight = [[webView stringByEvaluatingJavaScriptFromString:@"getImageHeight()"] floatValue];
    NSLog(@"%f", self.imageHeight);
}

/**
 *  加载失败
 *
 */
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self hideProgressHUD];
}

#pragma mark - UIScrollViewDelegate代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.imageHeight > 0) {
        UIColor *color = NavBarBackgroundColour;
        CGFloat offsetY = scrollView.contentOffset.y;
        NSLog(@"%f", offsetY);
        if (offsetY > 0) {
            CGFloat alpha = MIN(MinNavBarAlpha, 1 - ((self.imageHeight - 64 - offsetY) / 64));
            [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        } else {
            [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
        }
    }
}

#pragma mark - 私有方法
/**
 *  隐藏下拉刷新和加载提示
 */
- (void)hideProgressHUD {
    if (self.hud) {
        NSLog(@"hideProgressHUD");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.hud = nil;
    }
    
    [self.webView.scrollView.mj_header endRefreshing];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

/**
 *  下拉刷新和加载提示超时处理
 */
- (void)progressHUDTimer {
    if (self.timer) {
        if ([self.timer isValid]) {
            [self.timer invalidate];
            self.timer = nil;
            [self hideProgressHUD];
        }
    }
}

/**
 *  重新加载网页
 */
- (void)reloadWebView {
    [self.webView reload];
}

- (void)setUrl:(NSURL *)url {
    _url = url;
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
