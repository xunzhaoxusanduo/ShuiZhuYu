//
//  LXMoviePoster.h
//  YiZhiChan
//
//  Created by wuyaju on 16/4/29.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXMoviePoster : NSObject <NSCoding>

// 电影海报的url
@property (nonatomic, copy)NSString *imageUrl;
// 点击海报跳转的url
@property (nonatomic,copy)NSString *url;

@end
