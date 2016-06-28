//
//  NSString+Utils.m
//  WeChatContacts-demo
//
//  Created by shen_gh on 16/3/12.
//  Copyright © 2016年 com.joinup(Beijing). All rights reserved.
//

#import "NSString+Utils.h"

@implementation NSString (Utils)

//汉字的拼音
- (NSString *)pinyin{
    NSMutableString *str = [self mutableCopy];
    CFStringTransform(( CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    
    return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
}

/**
 *  将整数转换为一定格式的字符串
 *
 */
+ (NSString *)count:(NSInteger)count {
    /**
     0 -> @"转发"
     <10000  -> 完整的数量, 比如个数为6545,  显示出来就是6545
     >= 10000
     * 整万(10100, 20326, 30000 ....) : 1万, 2万
     * 其他(14364) : 1.4万
     */
    NSString *title = nil;
    if (count < 10000) { // 小于1W
        title = [NSString stringWithFormat:@"%ld", (long)count];
    } else { // >= 1W
        // 42342 / 1000 * 0.1 = 42 * 0.1 = 4.2
        // 10742 / 1000 * 0.1 = 10 * 0.1 = 1.0
        // double countDouble = count / 1000 * 0.1;
        
        // 42342 / 10000.0 = 4.2342
        // 10742 / 10000.0 = 1.0742
        double countDouble = count / 10000.0;
        title = [NSString stringWithFormat:@"%.1f万", countDouble];
        
        // title == 4.2万 4.0万 1.0万 1.1万
        title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
    }
    
    return title;
}

@end
