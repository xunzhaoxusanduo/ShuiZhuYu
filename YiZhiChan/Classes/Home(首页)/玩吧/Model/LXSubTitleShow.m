//
//  LXSubTitleShow.m
//  YiZhiChan
//
//  Created by wuyaju on 16/5/30.
//  Copyright © 2016年 吴亚举. All rights reserved.
//  首页字幕秀模型

#import "LXSubTitleShow.h"

@implementation LXSubTitleShow

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.imageUrl forKey:@"imageUrl"];
    [aCoder encodeObject:self.praiseCount forKey:@"praiseCount"];
    [aCoder encodeObject:self.commentCount forKey:@"commentCount"];
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeObject:self.subTitle forKey:@"subTitle"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.imageUrl = [aDecoder decodeObjectForKey:@"imageUrl"];
        self.praiseCount = [aDecoder decodeObjectForKey:@"praiseCount"];
        self.commentCount = [aDecoder decodeObjectForKey:@"commentCount"];
        self.url = [aDecoder decodeObjectForKey:@"url"];
        self.subTitle = [aDecoder decodeObjectForKey:@"subTitle"];
    }
    
    return self;
}

@end
