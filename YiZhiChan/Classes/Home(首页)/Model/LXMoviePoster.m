//
//  LXMoviePoster.m
//  YiZhiChan
//
//  Created by wuyaju on 16/4/29.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXMoviePoster.h"

@implementation LXMoviePoster

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.imageUrl forKey:@"imageUrl"];
    [aCoder encodeObject:self.url forKey:@"url"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.imageUrl = [aDecoder decodeObjectForKey:@"imageUrl"];
        self.url = [aDecoder decodeObjectForKey:@"url"];
    }
    
    return self;
}

@end
