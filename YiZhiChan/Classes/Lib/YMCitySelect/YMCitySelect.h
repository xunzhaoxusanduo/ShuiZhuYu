//代码地址：https://github.com/iosdeveloperSVIP/YMCitySelect
//原创：iosdeveloper赵依民
//邮箱：iosdeveloper@vip.163.com
//
//  YMCitySelect.h
//  YMCitySelect
//
//  Created by mac on 16/4/23.
//  Copyright © 2016年 YiMin. All rights reserved.
//
#import <UIKit/UIKit.h>

//NSString *const LXSelectNewCityNotification = @"df";
//
//NSString *const LXNewCityNameKey = @"asfdv";

#define LXSelectNewCityNotification @"LXSelectNewCityNotification"
#define LXNewCityNameKey            @"LXNewCityNameKey"
#define LXCurCityNameKey            @"LXCurCityNameKey"

@protocol YMCitySelectDelegate <NSObject>

@optional
- (void)ym_ymCitySelectCityName:(NSString *)cityName;

@end

@interface YMCitySelect : UIViewController

-(instancetype)initWithDelegate:(id)targe;

@property (nonatomic,weak) id<YMCitySelectDelegate> ymDelegate;

@end