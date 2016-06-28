//
//  LXPosterShow.m
//  YiZhiChan
//
//  Created by wuyaju on 16/5/30.
//  Copyright © 2016年 吴亚举. All rights reserved.
//  首页海报秀模型

#import "LXPosterShow.h"

@implementation LXPosterShow

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.posterUrl forKey:@"posterUrl"];
    [aCoder encodeObject:self.praiseCount forKey:@"praiseCount"];
    [aCoder encodeObject:self.commentCount forKey:@"commentCount"];
    [aCoder encodeObject:self.url forKey:@"url"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.posterUrl = [aDecoder decodeObjectForKey:@"posterUrl"];
        self.praiseCount = [aDecoder decodeObjectForKey:@"praiseCount"];
        self.commentCount = [aDecoder decodeObjectForKey:@"commentCount"];
        self.url = [aDecoder decodeObjectForKey:@"url"];
    }
    
    return self;
}

@end
