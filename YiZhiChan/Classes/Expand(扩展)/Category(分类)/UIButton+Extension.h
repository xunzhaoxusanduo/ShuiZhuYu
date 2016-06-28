//
//  UIButton+Extension.h
//  YiZhiChan
//
//  Created by wuyaju on 16/5/22.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)

/**
 *  设置按钮的显示标题
 *
 *  @param originalTitle 按钮的原始标题(显示的数字为0的时候, 显示这个原始标题)
 *  @param count         显示的个数
 */
- (void)setupOriginalTitle:(NSString *)originalTitle count:(NSInteger)count;

@end
