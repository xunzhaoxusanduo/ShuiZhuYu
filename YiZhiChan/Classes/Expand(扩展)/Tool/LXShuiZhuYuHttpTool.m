//
//  LXShuiZhuYuHttpTool.m
//  YiZhiChan
//
//  Created by wuyaju on 16/6/22.
//  Copyright © 2016年 吴亚举. All rights reserved.
//  封装整个项目对水煮娱服务器的GET\POST请求

#import "LXShuiZhuYuHttpTool.h"
#import "LXHttpTool.h"
#import "Macros.h"

@implementation LXShuiZhuYuHttpTool

/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *urlStr = [LXBaseUrl stringByAppendingPathComponent:url];
    [LXHttpTool postWithURL:urlStr params:params success:success failure:failure];
}

/**
 *  发送一个GET请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *urlStr = [LXBaseUrl stringByAppendingPathComponent:url];
    [LXHttpTool getWithURL:urlStr params:params success:success failure:failure];
}

/**
 *  同步发送一个GET请求，不要在主线程中调用
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)syncGetWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *urlStr = [LXBaseUrl stringByAppendingPathComponent:url];
    [LXHttpTool syncGetWithURL:urlStr params:params success:success failure:failure];
}

@end
