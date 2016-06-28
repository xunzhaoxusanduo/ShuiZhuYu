//
//  LXRecommendMovie.m
//  YiZhiChan
//
//  Created by wuyaju on 16/4/27.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXRecommendMovie.h"

@implementation LXRecommendMovie

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.movieInfoId forKey:@"movieInfoId"];
    [aCoder encodeObject:self.movieName forKey:@"movieName"];
    [aCoder encodeObject:self.cover forKey:@"cover"];
    [aCoder encodeObject:self.rating forKey:@"rating"];
    [aCoder encodeObject:self.url forKey:@"url"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.movieInfoId = [aDecoder decodeObjectForKey:@"movieInfoId"];
        self.movieName = [aDecoder decodeObjectForKey:@"movieName"];
        self.cover = [aDecoder decodeObjectForKey:@"cover"];
        self.rating = [aDecoder decodeObjectForKey:@"rating"];
        self.url = [aDecoder decodeObjectForKey:@"url"];
    }
    
    return self;
}


@end
