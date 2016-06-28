//
//  LXCity.h
//  YiZhiChan
//
//  Created by wuyaju on 16/5/25.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXCity : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *pinYin;

@property (nonatomic, copy) NSString *pinYinHead;

// 里面存放的是LXRegion模型
@property (nonatomic, strong) NSArray *districts;

@end
