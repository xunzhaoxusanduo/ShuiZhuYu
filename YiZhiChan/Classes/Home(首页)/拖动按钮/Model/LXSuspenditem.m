//
//  LXSuspenditem.m
//  YiZhiChan
//
//  Created by Michael on 16/4/20.
//  Copyright © 2016年 吴亚举. All rights reserved.
//  可移动图标的模型文件

#import "LXSuspenditem.h"

@implementation LXSuspenditem

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.imageName forKey:@"imageName"];
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeInteger:self.type forKey:@"type"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.imageName = [decoder decodeObjectForKey:@"imageName"];
        self.title = [decoder decodeObjectForKey:@"title"];
        self.type = [decoder decodeIntegerForKey:@"type"];
    }
    return self;
}

@end
