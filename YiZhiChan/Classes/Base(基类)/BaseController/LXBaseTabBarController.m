//
//  LXBaseTabBarController.m
//  YiZhiChan
//
//  Created by wuyaju on 16/4/26.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXBaseTabBarController.h"
#import "Macros.h"

//UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState: .Normal)
//UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: YZCYellowColor], forState: .Selected)

@interface LXBaseTabBarController ()

@end

@implementation LXBaseTabBarController

+ (void)initialize {
    UITabBar *tabBar = [UITabBar appearance];
    tabBar.tintColor = LXYellowColor;
    tabBar.barStyle = UIBarStyleBlack;
    
    UITabBarItem *tabBarItem = [UITabBarItem appearance];
    [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : LXYellowColor} forState:UIControlStateSelected];
}

@end
