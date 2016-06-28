//
//  LXHomePlate.m
//  YiZhiChan
//
//  Created by wuyaju on 16/4/28.
//  Copyright © 2016年 吴亚举. All rights reserved.
//  首页板块模型

#import "LXHomePlate.h"

@implementation LXHomePlate

+ (instancetype)homePlateWithDictionary:(NSDictionary *)dic {
    return [[self alloc] initWithDictionary:dic];
}

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        self.moduleType = dic[@"moduleType"];
        self.moduleName = dic[@"moduleName"];
        self.imageUrl = dic[@"imageUrl"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.moduleType forKey:@"moduleType"];
    [aCoder encodeObject:self.moduleName forKey:@"moduleName"];
    [aCoder encodeObject:self.imageUrl forKey:@"imageUrl"];
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeObject:self.imageWidth forKey:@"imageWidth"];
    [aCoder encodeObject:self.imageHeight forKey:@"imageHeight"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.moduleType = [aDecoder decodeObjectForKey:@"moduleType"];
        self.moduleName = [aDecoder decodeObjectForKey:@"moduleName"];
        self.imageUrl = [aDecoder decodeObjectForKey:@"imageUrl"];
        self.url = [aDecoder decodeObjectForKey:@"url"];
        self.imageWidth = [aDecoder decodeObjectForKey:@"imageWidth"];
        self.imageHeight = [aDecoder decodeObjectForKey:@"imageHeight"];
    }
    
    return self;
}

@end
