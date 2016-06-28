//
//  NSString+Utils.h
//  WeChatContacts-demo
//
//  Created by shen_gh on 16/3/12.
//  Copyright © 2016年 com.joinup(Beijing). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utils)

/**
 *  汉字的拼音
 *
 *  @return 拼音
 */
- (NSString *)pinyin;

/**
 *  将整数转换为一定格式的字符串
 *
 */
+ (NSString *)count:(NSInteger)count;

@end
