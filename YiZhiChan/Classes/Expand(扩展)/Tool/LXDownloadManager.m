//
//  LXDownloadManager.m
//  YiZhiChan
//
//  Created by wuyaju on 16/6/14.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXDownloadManager.h"
#import "MusicPartnerDownloadManager.h"
#import "LXWillDownLoadList.h"
#import "LXDidDownLoadList.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "Macros.h"

#define willDownListPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"willDownList.json"]

@implementation LXDownloadManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static LXDownloadManager *downloadManager;
    dispatch_once(&onceToken, ^{
        downloadManager = [[self alloc] init];
    });
    return downloadManager;
}

- (void)downLoadArData {
    
    // 初始化上次未完成的任务
    [[MusicPartnerDownloadManager sharedInstance] updateTaskState];
    [[MusicPartnerDownloadManager sharedInstance] initUnFinishedTask];
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    NSString *urlStr = nil;
    
    urlStr = [NSString stringWithFormat:@"%@/fishapi/api/Home/ARConfig", LXBaseUrl];
    
    [mgr GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if ([responseObject[@"state"] intValue] == 1) {
             
             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                 NSLog(@"从服务器获取下载列表-%@", responseObject[@"data"]);
                 // 将从服务器获取的下载列表保存在本地
                 NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
                 [data writeToFile:willDownListPath atomically:YES];
                 
                 // 已经下载的任务列表
                 NSArray *didLoadDownLoadArray = [LXDidDownLoadList objectArrayWithKeyValuesArray:[MusicPartnerDownloadManager sharedInstance].loadDownLoadTask];
                 // 将要下载的任务列表
                 NSArray *willLoadDownLoadArray = [LXWillDownLoadList objectArrayWithKeyValuesArray:responseObject[@"data"]];
                 
                 // 删除过期的资源
                 for (LXDidDownLoadList *didDownLoad in didLoadDownLoadArray) {
                     NSString *didDownLoadUrl =didDownLoad.mpDownloadUrlString;
                     NSLog(@"已经下载资源-%@", didDownLoadUrl);
                     
                     // 删除没有下载完成的资源
                     if (![didDownLoad.mpDownloadState isEqualToNumber:@(3)]) {
                         NSLog(@"删除未下载完成的资源-%@", didDownLoadUrl);
                         [[MusicPartnerDownloadManager sharedInstance] deleteFile:didDownLoadUrl];
                     }
                     
                     BOOL existFlg = NO;
                     for (LXWillDownLoadList *willDownLoad in willLoadDownLoadArray) {
                         // 已经下载的资源没有过期
                         if ([didDownLoadUrl isEqualToString:willDownLoad.actionUrl] || [didDownLoadUrl isEqualToString:willDownLoad.imageUrl]) {
                             existFlg = YES;
                             break;
                         }
                     }
                     
                     // 如果已经下载的资源不在将要下载的列表当中，则说明已经下载的资源过期，需要删除
                     if (existFlg == NO) {
                         [[MusicPartnerDownloadManager sharedInstance] deleteFile:didDownLoadUrl];
                         NSLog(@"删除过期资源-%@", didDownLoadUrl);
                     }
                 }
                 
                 // 添加下载任务
                 for (LXWillDownLoadList *willDownLoad in willLoadDownLoadArray) {
                     MPTaskState imageTaskState = [[MusicPartnerDownloadManager sharedInstance ] getTaskState:willDownLoad.imageUrl];
                     if (imageTaskState != MPTaskCompleted) {
                         MusicPartnerDownloadEntity *downLoadEntity = [[MusicPartnerDownloadEntity alloc] init];
                         downLoadEntity.downLoadUrlString = willDownLoad.imageUrl;
                         downLoadEntity.extra = [willDownLoad keyValues];
                         [[MusicPartnerDownloadManager sharedInstance] addTaskWithDownLoadMusic:downLoadEntity];
                         [NSThread sleepForTimeInterval:4];
                         NSLog(@"添加识别图下载任务-%@", willDownLoad.imageUrl);
                     }
                     
                     // 识别动作资源体积比较大，只有通过wifi网络才能下载
                     if ([AFNetworkReachabilityManager sharedManager].isReachableViaWiFi) {
                         if ((willDownLoad.actionType.integerValue == 2) || (willDownLoad.actionType.integerValue == 3)) {
                             MPTaskState actionTaskState = [[MusicPartnerDownloadManager sharedInstance ] getTaskState:willDownLoad.actionUrl];
                             if (actionTaskState != MPTaskCompleted) {
                                 MusicPartnerDownloadEntity *downLoadEntity = [[MusicPartnerDownloadEntity alloc] init];
                                 downLoadEntity.downLoadUrlString = willDownLoad.actionUrl;
                                 downLoadEntity.extra = [willDownLoad keyValues];
                                 [[MusicPartnerDownloadManager sharedInstance] addTaskWithDownLoadMusic:downLoadEntity];
                                 [NSThread sleepForTimeInterval:4];
                                 NSLog(@"WIFI网络添加识别动作下载任务-%@", willDownLoad.actionUrl);
                             }
                         }
                     }
                 }
             });
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     }];
}

/**
 *  生成已经下载好的AR资源列表
 */
- (void)createArData {
    NSData *data = [NSData dataWithContentsOfFile:willDownListPath];
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    NSMutableArray *arDataArray = [NSMutableArray array];
    
    if ([responseObject[@"state"] intValue] == 1) {
        NSArray *willDownLoadArray = [LXWillDownLoadList objectArrayWithKeyValuesArray:responseObject[@"data"]];
        NSArray *didDownLoadArray = [LXDidDownLoadList objectArrayWithKeyValuesArray:[MusicPartnerDownloadManager sharedInstance].loadFinishedTask];
        
        for (LXWillDownLoadList *willDownLoad in willDownLoadArray) {
            LXWillDownLoadList *arDidDownLoad = [[LXWillDownLoadList alloc] init];
            arDidDownLoad.actionType = willDownLoad.actionType;
            arDidDownLoad.x = willDownLoad.x;
            arDidDownLoad.y = willDownLoad.y;
            arDidDownLoad.z = willDownLoad.z;
            
            // 在已下载任务列表中匹配资源
            for (LXDidDownLoadList *didDownLoad in didDownLoadArray) {
                // 识别图已经下载
                if ([didDownLoad.mpDownloadUrlString isEqualToString:willDownLoad.imageUrl]) {
                    // 获取下载在本地的识别图路径
                    arDidDownLoad.imageUrl = MPFileFullpath(didDownLoad.mpDownLoadPath);
                    NSLog(@"识别图路径----%@", arDidDownLoad.imageUrl);
                }
                
                // 识别动作资源已经下载
                if ((willDownLoad.actionType.integerValue == 2) || (willDownLoad.actionType.integerValue == 3)) {
                    if ([didDownLoad.mpDownloadUrlString isEqualToString:willDownLoad.actionUrl]) {
                        // 获取下载在本地的识别动作资源路径
                        arDidDownLoad.actionUrl = MPFileFullpath(didDownLoad.mpDownLoadPath);
                        NSLog(@"识别动作资源路径----%@", arDidDownLoad.actionUrl);
                    }
                }else {
                    arDidDownLoad.actionUrl = willDownLoad.actionUrl;
                }
            }
            // 一个识别图对应的所有资源都已经下载完毕
            if ((arDidDownLoad.imageUrl != nil) && (arDidDownLoad.actionUrl != nil)) {
                [arDataArray addObject:[arDidDownLoad keyValues]];
            }
        }
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             @(1), @"state",
                             @"获取成功", @"msg",
                             arDataArray, @"data", nil];
        NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        [data writeToFile:arDataPath atomically:YES];
        
        NSLog(@"已经可以使用的AR资源-%@", dic);
    }
}


@end
