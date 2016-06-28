//
//  AppDelegate.m
//  YiZhiChan
//
//  Created by Michael on 16/4/1.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "AppDelegate.h"
#import <PgySDK/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>

#import "LCNewFeatureVC.h"
#import "Macros.h"
#import "LXPushTool.h"
#import "LXTabBarController.h"

#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMessage.h"
#import "UMMobClick/MobClick.h"
#import <Bugly/Bugly.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    // 集成蒲公英SDK
    //    [[PgyManager sharedPgyManager] setEnableFeedback:false];
    [[PgyManager sharedPgyManager] startManagerWithAppId:PGY_APPKEY];
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:PGY_APPKEY];
    
    // 集成友盟推送
    [UMessage startWithAppkey:UMessage_APPKEY launchOptions:launchOptions];
    [UMessage registerForRemoteNotifications];
    [UMessage setLogEnabled:YES];
    [UMessage setAutoAlert:NO];
    
    // 集成友盟分享
    [self registerUMSocial];
    
    // 集成友盟统计
    UMConfigInstance.appKey = UMessage_APPKEY;
    UMConfigInstance.ePolicy = BATCH;
    [MobClick startWithConfigure:UMConfigInstance];
    [MobClick setCrashReportEnabled:NO];
    
    // 集成腾讯崩溃日志收集框架
    [self setupBugly];
    
    BOOL showNewFeature = [LCNewFeatureVC shouldShowNewFeature];
    if (showNewFeature) {   // 如果需要显示新特性界面
        __weak typeof(self) weakSelf = self;
        
        LCNewFeatureVC *newFeatureVC = [LCNewFeatureVC newFeatureWithImageName:@"NewFeature"
                                                                    imageCount:4
                                                               showPageControl:YES
                                                                   finishBlock:^{
                                                                       [weakSelf enterRootViewController];
                                                                   }];
        newFeatureVC.pointOtherColor = [UIColor whiteColor];
        self.window.rootViewController = newFeatureVC;
    }else {
        [self enterRootViewController];
    }
    
    [self.window makeKeyAndVisible];
    
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo != nil) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LXRemotePushNotification object:nil userInfo:userInfo];
        [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    }
    
    return YES;
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *decToken = [NSString stringWithFormat:@"%@", deviceToken];
    //获取到之后要去掉尖括号和中间的空格
    NSMutableString *st = [NSMutableString stringWithString:decToken];
    [st deleteCharactersInRange:NSMakeRange(0, 1)];
    [st deleteCharactersInRange:NSMakeRange(st.length-1, 1)];
    NSString *string1 = [st stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"decToken-----------------------%@", string1);
    
    [UMessage registerDeviceToken:deviceToken];
    [self firstInstallInit];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UMessage didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [UMessage didReceiveRemoteNotification:userInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:LXRemotePushNotification object:nil userInfo:userInfo];
//    [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    notification.alertBody = [NSString stringWithFormat:@"%@", userInfo];
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

/**
 这里处理新浪微博SSO授权进入新浪微博客户端后进入后台，再返回原来应用
 */
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[PgyUpdateManager sharedPgyManager] checkUpdate];
    [UMSocialSnsService  applicationDidBecomeActive];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)registerUMSocial {
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:UMessage_APPKEY];
    
    //打开调试log的开关
    [UMSocialData openLog:YES];
    
    //如果你要支持不同的屏幕方向，需要这样设置，否则在iPhone只支持一个竖屏方向
    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskAll];
    
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:@"wx3a4096976acb32fd" appSecret:@"341cc398b669157ce7200a16b60932f2" url:@"http://www.lansum.com/gb/default.htm"];
    
    // 打开新浪微博的SSO开关
    // 将在新浪微博注册的应用appkey、redirectURL替换下面参数，并在info.plist的URL Scheme中相应添加wb+appkey，如"wb3921700954"，详情请参考官方文档。
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"3315624365"
                                              secret:@"d60066463e6767d5511e554214aefca3"
                                         RedirectURL:@"http://www.lansum.com/gb/default.htm"];
    
    //    //设置分享到QQ空间的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:@"1105379489" appKey:@"HPeiyhveAP0EKyF8" url:@"http://www.lansum.com/gb/default.htm"];
    //    //设置支持没有客户端情况下使用SSO授权
    [UMSocialQQHandler setSupportWebView:YES];

//    ////    下面打开Instagram的开关
//    [UMSocialInstagramHandler openInstagramWithScale:NO paddingColor:[UIColor blackColor]];
//    
//    //打开line
//    [UMSocialLineHandler openLineShare:UMSocialLineMessageTypeImage];
}

/**
 *  集成腾讯崩溃日志收集框架
 */
- (void)setupBugly {
    // Get the default config
    BuglyConfig * config = [[BuglyConfig alloc] init];
    
    // Open the debug mode to print the sdk log message.
    // Default value is NO, please DISABLE it in your RELEASE version.
#if DEBUG
    config.debugMode = YES;
#endif
    
    // Open the customized log record and report, BuglyLogLevelWarn will report Warn, Error log message.
    // Default value is BuglyLogLevelSilent that means DISABLE it.
    // You could change the value according to you need.
    config.reportLogLevel = BuglyLogLevelWarn;
    
    // Open the STUCK scene data in MAIN thread record and report.
    // Default value is NO
    config.blockMonitorEnable = YES;
    
    // Set the STUCK THRESHOLD time, when STUCK time > THRESHOLD it will record an event and report data when the app launched next time.
    // Default value is 3.5 second.
    config.blockMonitorTimeout = 1.5;
    
    // Set the app channel to deployment
    config.channel = @"Bugly";
    
    // NOTE:Required
    // Start the Bugly sdk with APP_ID and your config
    [Bugly startWithAppId:BUGLY_APP_ID
#if DEBUG
        developmentDevice:YES
#endif
                   config:config];
    
    // Set the customizd tag thats config in your APP registerd on the  bugly.qq.com
    //    [Bugly setTag:1799];
    
    [Bugly setUserIdentifier:[NSString stringWithFormat:@"User: %@", [UIDevice currentDevice].name]];
    
    [Bugly setUserValue:[NSProcessInfo processInfo].processName forKey:@"App"];
}

/**
 这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

- (void)enterRootViewController {
    [UIView transitionWithView:self.window duration:0.7f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        self.window.rootViewController = [[LXTabBarController alloc] init];
        [UIView setAnimationsEnabled:oldState];
        
    } completion:nil];
}

- (void)firstInstallInit {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // 设置界面中系统通知默认状态，默认允许推送
    if ([defaults objectForKey:LXSystemNotificationItemKey] == nil) {
        [LXPushTool setTag:nil tagName:LXMessageTagTypeSystem key:LXSystemNotificationItemKey];
    }
    
    // 设置界面中影讯通知默认状态，默认允许推送
    if ([defaults objectForKey:LXMovieNotificationItemKey] == nil) {
        [LXPushTool setTag:nil tagName:LXMessageTagTypeFilmNews key:LXMovieNotificationItemKey];
    }
}

@end
