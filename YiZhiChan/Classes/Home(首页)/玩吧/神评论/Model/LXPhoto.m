//
//  LXPhoto.m
//  YiZhiChan
//
//  Created by wuyaju on 16/4/30.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXPhoto.h"

@implementation LXPhoto

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.images forKey:@"images"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.images = [aDecoder decodeObjectForKey:@"images"];
    }
    
    return self;
}

@end
