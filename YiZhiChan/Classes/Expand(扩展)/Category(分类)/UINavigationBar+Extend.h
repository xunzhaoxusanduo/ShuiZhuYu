//
//  UINavigationBar+Extend.h
//  YiZhiChan
//
//  Created by wuyaju on 16/4/26.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (Extend)

//- (void)lx_setBackgroundImage:(UIImage *)backgroundImage;
//- (void)lx_reset;

- (void)lt_setBackgroundColor:(UIColor *)backgroundColor;
- (void)lt_setElementsAlpha:(CGFloat)alpha;
- (void)lt_setTranslationY:(CGFloat)translationY;
- (void)lt_reset;

@end
