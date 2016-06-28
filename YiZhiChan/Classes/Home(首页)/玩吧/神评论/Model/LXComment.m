//
//  LXComment.m
//  YiZhiChan
//
//  Created by wuyaju on 16/4/30.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXComment.h"
#import "MJExtension.h"
#import "LXPhoto.h"

@implementation LXComment

- (NSDictionary *)objectClassInArray {
    return @{@"imagesList": [LXPhoto class]};
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.movieName forKey:@"movieName"];
    [aCoder encodeObject:self.comment forKey:@"comment"];
    [aCoder encodeObject:self.movieInfoId forKey:@"movieInfoId"];
    [aCoder encodeObject:self.imagesList forKey:@"imagesList"];
    [aCoder encodeObject:self.cover forKey:@"cover"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.movieName = [aDecoder decodeObjectForKey:@"movieName"];
        self.comment = [aDecoder decodeObjectForKey:@"comment"];
        self.movieInfoId = [aDecoder decodeObjectForKey:@"movieInfoId"];
        self.imagesList = [aDecoder decodeObjectForKey:@"imagesList"];
        self.cover = [aDecoder decodeObjectForKey:@"cover"];
    }
    
    return self;
}

@end
