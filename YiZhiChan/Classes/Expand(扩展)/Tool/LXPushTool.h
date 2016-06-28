//
//  LXPushTool.h
//  YiZhiChan
//
//  Created by wuyaju on 16/6/1.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LXPushTool : NSObject

/**
 *  设置远程推送别名
 *
 *  @param aSwitch   UISwitch控件
 *  @param aliasName 别名名字
 *  @param type      别名类型
 *  @param key       保存当前推送状态的Key
 */
+ (void)setAlias:(UISwitch *)aSwitch type:(NSString * __nonnull)type key:(NSString * __nonnull)key;

/**
 *  移除远程推送别名
 *
 *  @param aSwitch   UISwitch控件
 *  @param aliasName 别名名字
 *  @param type      别名类型
 *  @param key       保存当前推送状态的Key
 */
+ (void)removeAlias:(UISwitch *)aSwitch type:(NSString * __nonnull)type key:(NSString * __nonnull)key;

/**
 *  设置远程推送Tag
 *
 *  @param aSwitch UISwitch控件
 *  @param tagName Tag名字
 *  @param key     保存当前推送状态的Key
 */
+ (void)setTag:(UISwitch *)aSwitch tagName:(NSString *)tagName key:(NSString *)key;

/**
 *  移除远程推送Tag
 *
 *  @param aSwitch UISwitch控件
 *  @param tagName Tag名字
 *  @param key     保存当前推送状态的Key
 */
+ (void)removeTag:(UISwitch *)aSwitch tagName:(NSString *)tagName key:(NSString *)key;

/**
 *  分享内容
 *
 *  @param controller 在该controller弹出分享列表的UIActionSheet
 *  @param title      分享的标题
 *  @param imageUrl   分享的图片地址
 *  @param content    分享的内容
 *  @param contentUrl 点击分享的内容跳转的链接
 */
+ (void)shareWithViewController:(UIViewController *)controller
                          title:(NSString *)title
                       imageUrl:(NSString *)imageUrl
                        content:(NSString *)content
                     contentUrl:(NSString *)contentUrl;

@end
