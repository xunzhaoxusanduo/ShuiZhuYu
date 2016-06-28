//
//  LXPushTool.m
//  YiZhiChan
//
//  Created by wuyaju on 16/6/1.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXPushTool.h"
#import "Macros.h"
#import "UMessage.h"
#import "LXUserInfo.h"
#import "MBProgressHUD+MJ.h"
#import "UMSocial.h"

@implementation LXPushTool

/**
 *  设置远程推送别名
 *
 *  @param aSwitch   UISwitch控件
 *  @param aliasName 别名名字
 *  @param type      别名类型
 *  @param key       保存当前推送状态的Key
 */
+ (void)setAlias:(UISwitch *)aSwitch type:(NSString * __nonnull)type key:(NSString * __nonnull)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // 只有登录了才能设置别名，因为别名绑定了自有的账号体系
    if ([[LXUserInfo user] isLogin]) {
        NSString *aliasName = [[LXUserInfo user].userId stringValue];
        
        [UMessage addAlias:aliasName type:type response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
            if(responseObject) {
                NSLog(@"绑定成功！");
                [defaults setBool:true forKey:key];
            }
            else {
                // UISwitch控件不为空时，才显示提示
                if (aSwitch != nil) {
                    aSwitch.on = false;
                    [MBProgressHUD showError:error.localizedDescription];
                }
                NSLog(@"绑定错误 %@", error.localizedDescription);
            }
        }];
    }
}

/**
 *  移除远程推送别名
 *
 *  @param aSwitch   UISwitch控件
 *  @param aliasName 别名名字
 *  @param type      别名类型
 *  @param key       保存当前推送状态的Key
 */
+ (void)removeAlias:(UISwitch *)aSwitch type:(NSString * __nonnull)type key:(NSString * __nonnull)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // 只有登录了才能设置别名，因为别名绑定了自有的账号体系
    if ([[LXUserInfo user] isLogin]) {
        NSString *aliasName = [[LXUserInfo user].userId stringValue];
        
        [UMessage removeAlias:aliasName type:type response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
            if(responseObject) {
                NSLog(@"解除绑定成功！");
                // 保存状态
                [defaults setBool:false forKey:key];
            }
            else {
                // UISwitch控件不为空时，才显示提示
                if (aSwitch != nil) {
                    aSwitch.on = true;
                    [MBProgressHUD showError:error.localizedDescription];
                }
                NSLog(@"解除绑定错误 %@", error.localizedDescription);
            }
        }];
    }
}

/**
 *  设置远程推送Tag
 *
 *  @param aSwitch UISwitch控件
 *  @param tagName Tag名字
 *  @param key     保存当前推送状态的Key
 */
+ (void)setTag:(UISwitch *)aSwitch tagName:(NSString *)tagName key:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [UMessage addTag:tagName response:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
        if(responseObject) {
            [defaults setBool:true forKey:key];
            NSLog(@"绑定成功！");
        }
        else {
            // UISwitch控件不为空时，才显示提示
            if (aSwitch != nil) {
                aSwitch.on = false;
                [MBProgressHUD showError:error.localizedDescription];
            }
            NSLog(@"绑定错误 %@", error.localizedDescription);
        }
    }];
}

/**
 *  移除远程推送Tag
 *
 *  @param aSwitch UISwitch控件
 *  @param tagName Tag名字
 *  @param key     保存当前推送状态的Key
 */
+ (void)removeTag:(UISwitch *)aSwitch tagName:(NSString *)tagName key:(NSString *)key {
    [UMessage removeTag:tagName response:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        if(responseObject) {
            NSLog(@"解除绑定成功！");
            // 保存状态
            [defaults setBool:false forKey:key];
        }
        else {
            // UISwitch控件不为空时，才显示提示
            if (aSwitch != nil) {
                aSwitch.on = true;
                [MBProgressHUD showError:error.localizedDescription];
            }
            NSLog(@"解除绑定错误 %@", error.localizedDescription);
        }
    }];
}

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
                                contentUrl:(NSString *)contentUrl{
    // 设置url资源类型和url地址
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:imageUrl];
    
    [UMSocialData defaultData].extConfig.title = title;
    
    // 微信好友分享内容
    [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = contentUrl;
    [UMSocialData defaultData].extConfig.wechatSessionData.shareText = content;
    
    // 微信朋友圈内容
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = contentUrl;
    [UMSocialData defaultData].extConfig.wechatTimelineData.shareText = content;
    
    // 新浪微博内容
    NSString *sinaStr = [content copy];
    if (sinaStr.length >= 140) {
        sinaStr = [[sinaStr substringToIndex:137] stringByAppendingString:@"…"];
    }
    [UMSocialData defaultData].extConfig.sinaData.shareText = sinaStr;
    
    // 分享到QQ内容
    [UMSocialData defaultData].extConfig.qqData.title = title;
    [UMSocialData defaultData].extConfig.qqData.url = contentUrl;
    [UMSocialData defaultData].extConfig.qqData.shareText = content;
    
    // 分享到Qzone内容
    [UMSocialData defaultData].extConfig.qzoneData.title = title;
    [UMSocialData defaultData].extConfig.qzoneData.url = contentUrl;
    [UMSocialData defaultData].extConfig.qzoneData.shareText = content;
    
    // 分享到邮箱内容
    [UMSocialData defaultData].extConfig.emailData.title = title;
    [UMSocialData defaultData].extConfig.emailData.shareText = content;
    
    // 分享到短信内容
    [UMSocialData defaultData].extConfig.smsData.shareText = content;
    
    [UMSocialSnsService presentSnsIconSheetView:controller
                                         appKey:UMessage_APPKEY
                                      shareText:nil
                                     shareImage:nil
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ,UMShareToQzone, UMShareToEmail, UMShareToSms]
                                       delegate:nil];
}

@end
