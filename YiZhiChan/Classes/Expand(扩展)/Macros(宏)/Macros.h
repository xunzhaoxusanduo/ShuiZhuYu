//
//  Macros.h
//  MobileProject  常见的配置项
//
//  Created by wujunyang on 16/1/5.
//  Copyright © 2016年 wujunyang. All rights reserved.
//


//中文字体
#define CHINESE_FONT_NAME  @"Heiti SC"
#define CHINESE_SYSTEM(x) [UIFont fontWithName:CHINESE_FONT_NAME size:x]

#define UNICODETOUTF16(x) (((((x - 0x10000) >>10) | 0xD800) << 16)  | (((x-0x10000)&3FF) | 0xDC00))
#define MULITTHREEBYTEUTF16TOUNICODE(x,y) (((((x ^ 0xD800) << 2) | ((y ^ 0xDC00) >> 8)) << 8) | ((y ^ 0xDC00) & 0xFF)) + 0x10000

// App Frame Height&Width
#define App_Frame_Height        [[UIScreen mainScreen] applicationFrame].size.height
#define App_Frame_Width         [[UIScreen mainScreen] applicationFrame].size.width

//获取View的属性
#define GetViewWidth(view)  view.frame.size.width
#define GetViewHeight(view) view.frame.size.height
#define GetViewX(view)      view.frame.origin.x
#define GetViewY(view)      view.frame.origin.y

// MainScreen Height&Width
#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width

// MainScreen bounds
#define Main_Screen_Bounds [[UIScreen mainScreen] bounds]

//导航栏高度
#define TopBarHeight 64.5
#define TabBarHeight 49

// 字体大小(常规/粗体)
#define BOLDSYSTEMFONT(FONTSIZE)[UIFont boldSystemFontOfSize:FONTSIZE]
#define SYSTEMFONT(FONTSIZE)    [UIFont systemFontOfSize:FONTSIZE]
#define FONT(NAME, FONTSIZE)    [UIFont fontWithName:(NAME) size:(FONTSIZE)]

// 当前版本
#define FSystemVersion          ([[[UIDevice currentDevice] systemVersion] floatValue])
#define DSystemVersion          ([[[UIDevice currentDevice] systemVersion] doubleValue])
#define SSystemVersion          ([[UIDevice currentDevice] systemVersion])

// 是否IOS7
#define isIOS7                  ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
// 是否IOS6
#define isIOS6                  ([[[UIDevice currentDevice]systemVersion]floatValue] < 7.0)
//
#define isIOS8                  ([[[UIDevice currentDevice]systemVersion]floatValue] >=8.0)
// 是否iPad
#define isPad                   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

// 是否空对象
#define IS_NULL_CLASS(OBJECT) [OBJECT isKindOfClass:[NSNull class]]

//色值
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

#define HEXCOLOR(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]

#define COLOR_RGB(rgbValue,a) [UIColor colorWithRed:((float)(((rgbValue) & 0xFF0000) >> 16))/255.0 green:((float)(((rgbValue) & 0xFF00)>>8))/255.0 blue: ((float)((rgbValue) & 0xFF))/255.0 alpha:(a)]


//App版本号
#define appMPVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

//AppDelegate对象
#define AppDelegateInstance [[UIApplication sharedApplication] delegate]

//获取图片资源
#define GetImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]

//在Main线程上运行
#define DISPATCH_ON_MAIN_THREAD(mainQueueBlock) dispatch_async(dispatch_get_main_queue(), mainQueueBlock);

//主线程上Demo
//DISPATCH_ON_MAIN_THREAD(^{
    //更新UI
//})

//在Global Queue上运行
#define DISPATCH_ON_GLOBAL_QUEUE_HIGH(globalQueueBlocl) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), globalQueueBlocl);
#define DISPATCH_ON_GLOBAL_QUEUE_DEFAULT(globalQueueBlocl) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), globalQueueBlocl);
#define DISPATCH_ON_GLOBAL_QUEUE_LOW(globalQueueBlocl) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), globalQueueBlocl);
#define DISPATCH_ON_GLOBAL_QUEUE_BACKGROUND(globalQueueBlocl) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), globalQueueBlocl);

//Global Queue
//DISPATCH_ON_GLOBAL_QUEUE_DEFAULT(^{
    //异步耗时任务
//})

//DDLog等级
//#ifdef DEBUG
//static const int ddLogLevel = LOG_LEVEL_VERBOSE;
//#else
//static const int ddLogLevel = LOG_LEVEL_ERROR;
//#endif

#define MinNavBarAlpha                          0.9
#define HomeCellBackgroundColour                RGBA(0, 0, 0, 0.3)
#define HomeCellSeclectBackgroundColour         RGBA(0, 0, 0, 0.4)
#define NavBarBackgroundColour                  RGBA(38, 38, 38, MinNavBarAlpha)

#define TitleFontSize 16
#define DetailFontSize 13
//#define LXYellowColor RGBA(255, 106, 0, 1)
#define LXYellowColor RGBA(255, 86, 8, 1)

//#define Unity

#define WS(weakSelf) __weak __typeof(&*self) weakSelf = self

#define LXBaseUrl   @"http://devftp.lansum.cn"
// 获取某人的动态的URL
#define LXOtherPersonDynamicUrl @"http://devftp.lansum.cn/fishapi/api/friendCircle/UserInfo"
// 获取关注人的动态
#define LXFollowDynamicUrl @"http://devftp.lansum.cn/fishapi/api/friendCircle/followInfo"
// 个人信息获取地址
#define LXPersonInfoUrl @"http://devftp.lansum.cn/fishapi/api/User/UserInfo"
// 关注列表获取地址
#define LXFollowListUrl @"http://devftp.lansum.cn/fashhtml/myData/fans.html?fansType="
// 粉丝列表获取地址
#define LXFanListUrl    @"http://devftp.lansum.cn/fashhtml/myData/fans.html?fansType="

// 被赞提醒别名类型
#define LXMessageAliasTypePraise @"LXMessageAliasTypePraise"
// 评论回复提醒别名类型
#define LXMessageAliasTypeComment @"LXMessageAliasTypeComment"
// 系统通知别名类型
#define LXMessageAliasTypeSystem @"LXMessageAliasTypeSystem"
// 影讯通知别名类型
#define LXMessageAliasTypeFilmNews @"LXMessageAliasTypeFilmNews"

// 系统通知Tag名字
#define LXMessageTagTypeSystem  @"LXMessageTagTypeSystem"
// 影讯通知Tag名字
#define LXMessageTagTypeFilmNews  @"LXMessageTagTypeFilmNews"

// 被赞提醒Key
#define LXAttitudeItemKey               @"LXAttitudeItemKey"
// 评论回复提醒Key
#define LXCommentItemKey                @"LXCommentItemKey"
// 系统通知Key
#define LXSystemNotificationItemKey     @"LXSystemNotificationItemKey"

// 影讯通知Key
#define LXMovieNotificationItemKey      @"LXMovieNotificationItemKey"

#define PGY_APPKEY  @"5de67883d7f75980031bd27da91b595b"
#define UMessage_APPKEY @"574804c9e0f55a759c002cd0"
#define BUGLY_APP_ID @"900035438"

#define LXRemotePushNotification @"LXRemotePushNotification"
