
//
//  LXNewMovie.m
//  YiZhiChan
//
//  Created by wuyaju on 16/4/27.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXNewMovie.h"
#import "NSDate+MJ.h"

@implementation LXNewMovie

- (NSString *)addTime {
    // _addTime == 2016-05-18 10:12:22
    // 1.获得发送时间
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDate *createdDate = [fmt dateFromString:_addTime];
    
    // 2..判断发送时间 和 现在时间 的差距
    if (createdDate.isToday) { // 今天
        if (createdDate.deltaWithNow.hour >= 1) {
            return [NSString stringWithFormat:@"%ld小时前", (long)createdDate.deltaWithNow.hour];
        } else if (createdDate.deltaWithNow.minute >= 1) {
            return [NSString stringWithFormat:@"%ld分钟前", (long)createdDate.deltaWithNow.minute];
        } else {
            return @"刚刚";
        }
    } else if (createdDate.isYesterday) { // 昨天
        fmt.dateFormat = @"昨天 HH:mm";
        return [fmt stringFromDate:createdDate];
    } else if (createdDate.isThisYear) { // 今年(至少是前天)
        fmt.dateFormat = @"MM-dd HH:mm";
        return [fmt stringFromDate:createdDate];
    } else { // 非今年
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        return [fmt stringFromDate:createdDate];
    }
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.thumbUrl forKey:@"thumbUrl"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.addTime forKey:@"addTime"];
    [aCoder encodeObject:self.praiseCount forKey:@"praiseCount"];
    [aCoder encodeObject:self.commentCount forKey:@"commentCount"];
    [aCoder encodeObject:self.movieMsgId forKey:@"movieMsgId"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.thumbUrl = [aDecoder decodeObjectForKey:@"thumbUrl"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.addTime = [aDecoder decodeObjectForKey:@"addTime"];
        self.praiseCount = [aDecoder decodeObjectForKey:@"praiseCount"];
        self.commentCount = [aDecoder decodeObjectForKey:@"commentCount"];
        self.movieMsgId = [aDecoder decodeObjectForKey:@"movieMsgId"];
    }
    
    return self;
}

@end
