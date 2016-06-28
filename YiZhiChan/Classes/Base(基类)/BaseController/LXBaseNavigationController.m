//
//  LXBaseNavigationController.m
//  YiZhiChan
//
//  Created by wuyaju on 16/4/26.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXBaseNavigationController.h"
#import "UINavigationBar+Extend.h"
#import "Macros.h"

@interface LXBaseNavigationController ()

@end

@implementation LXBaseNavigationController

+ (void)initialize {
    [self setupBarButtonItemTheme];
    [self setupNavBarTheme];
}

/**
 *  设置导航栏按钮主题
 */
+ (void)setupBarButtonItemTheme
{
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    // 设置文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
//    textAttrs[NSShadowAttributeName] = [NSValue valueWithUIOffset:UIOffsetZero];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateHighlighted];
    
//    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
//    disableTextAttrs[UITextAttributeTextColor] =  [UIColor lightGrayColor];
//    [item setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
}

/**
 *  设置导航栏主题
 */
+ (void)setupNavBarTheme {
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    
    // 设置标题属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [navigationBar setTitleTextAttributes:textAttrs];
    
    // 设置返回箭头颜色
    navigationBar.tintColor = [UIColor whiteColor];
    
    [navigationBar lt_setBackgroundColor:NavBarBackgroundColour];
    [navigationBar setBarStyle:UIBarStyleBlack];
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end
