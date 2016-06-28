//
//  LXBaseFriend.m
//  YiZhiChan
//
//  Created by wuyaju on 16/5/21.
//  Copyright © 2016年 吴亚举. All rights reserved.
//  朋友圈动态模型基类

#import "LXBaseFriend.h"
#import "NSDate+MJ.h"

@implementation LXBaseFriend

//- (NSString *)addTime {
//    // _addTime == 2016-05-18 10:12:22
//    // 1.获得发送时间
//    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
//    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//#warning 真机调试下, 必须加上这段
//    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
//    NSDate *createdDate = [fmt dateFromString:_addTime];
//    
//    // 2..判断发送时间 和 现在时间 的差距
//    if (createdDate.isToday) { // 今天
//        if (createdDate.deltaWithNow.hour >= 1) {
//            return [NSString stringWithFormat:@"%ld小时前", (long)createdDate.deltaWithNow.hour];
//        } else if (createdDate.deltaWithNow.minute >= 1) {
//            return [NSString stringWithFormat:@"%ld分钟前", (long)createdDate.deltaWithNow.minute];
//        } else {
//            return @"刚刚";
//        }
//    } else if (createdDate.isYesterday) { // 昨天
//        fmt.dateFormat = @"昨天 HH:mm";
//        return [fmt stringFromDate:createdDate];
//    } else if (createdDate.isThisYear) { // 今年(至少是前天)
//        fmt.dateFormat = @"MM-dd HH:mm";
//        return [fmt stringFromDate:createdDate];
//    } else { // 非今年
//        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
//        return [fmt stringFromDate:createdDate];
//    }
//}

- (NSString *)formatAddTime {
    // _addTime == 2016-05-18 10:12:22
    // 1.获得发送时间
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
#warning 真机调试下, 必须加上这段
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDate *createdDate = [fmt dateFromString:self.addTime];
    
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

@end
