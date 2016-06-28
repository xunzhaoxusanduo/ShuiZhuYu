//
//  LXReleaseMovie.h
//  YiZhiChan
//
//  Created by wuyaju on 16/5/13.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXReleaseMovie : NSObject

// 当前上映电影海报URL
@property (nonatomic, copy)NSString *cover;
// 当前上映电影海报ID
@property (nonatomic, copy)NSNumber *movieInfoId;

@end
