//
//  LXDownloadManager.h
//  YiZhiChan
//
//  Created by wuyaju on 16/6/14.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import <Foundation/Foundation.h>

#define arDataPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"arData.json"]

@interface LXDownloadManager : NSObject

+ (instancetype)sharedInstance;
- (void)downLoadArData;
- (void)createArData;

@end
