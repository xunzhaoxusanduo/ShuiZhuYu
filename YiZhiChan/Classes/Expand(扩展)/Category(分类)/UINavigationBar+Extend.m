//
//  UINavigationBar+Extend.m
//  YiZhiChan
//
//  Created by wuyaju on 16/4/26.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "UINavigationBar+Extend.h"
#import "Macros.h"
#import <objc/runtime.h>

@implementation UINavigationBar (Extend)

//static char overlayImageKey;
//
//- (UIImageView *)overlayImage
//{
//    return objc_getAssociatedObject(self, &overlayImageKey);
//}
//
//- (void)setOverlayImage:(UIImageView *)overlay
//{
//    objc_setAssociatedObject(self, &overlayImageKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//- (void)lx_setBackgroundImage:(UIImage *)backgroundImage
//{
//    if (!self.overla) {
//        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//        self.overlay = [[UIImageView alloc] initWithFrame:CGRectMake(0, -20, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + 20)];
//        self.shadowImage = [[UIImage alloc] init];
//        self.overlay.userInteractionEnabled = NO;
//        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//        [self insertSubview:self.overlay atIndex:0];
//    }
//    self.overlay.image = backgroundImage;
//}
//
//- (void)lx_reset
//{
//    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [self.overlay removeFromSuperview];
//    self.overlay = nil;
//}

static char overlayKey;

- (UIView *)overlay
{
    return objc_getAssociatedObject(self, &overlayKey);
}

- (void)setOverlay:(UIView *)overlay
{
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)lt_setBackgroundColor:(UIColor *)backgroundColor
{
//    NSLog(@"lt_setBackgroundColor %@", backgroundColor);
    
    if (!self.overlay) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, -20, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + 20)];
        self.overlay.userInteractionEnabled = NO;
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];  // 设置渐变效果
        gradientLayer.bounds = self.overlay.bounds;
        gradientLayer.borderWidth = 0;
        
        gradientLayer.frame = gradientLayer.bounds;
        gradientLayer.colors = [NSArray arrayWithObjects:
                                (id)[NavBarBackgroundColour CGColor],
                                (id)[[UIColor clearColor] CGColor], nil];
        [self.overlay.layer insertSublayer:gradientLayer atIndex:0];
        
        self.shadowImage = [[UIImage alloc] init];
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self insertSubview:self.overlay atIndex:0];
    }
    self.overlay.backgroundColor = backgroundColor;
}

- (void)lt_setTranslationY:(CGFloat)translationY
{
    self.transform = CGAffineTransformMakeTranslation(0, translationY);
}

- (void)lt_setElementsAlpha:(CGFloat)alpha
{
    NSLog(@"alpha  %f", alpha);
    
    [[self valueForKey:@"_leftViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
        view.alpha = alpha;
    }];
    
    [[self valueForKey:@"_rightViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
        view.alpha = alpha;
    }];
    
    UIView *titleView = [self valueForKey:@"_titleView"];
    titleView.alpha = alpha;
    //    when viewController first load, the titleView maybe nil
    [[self subviews] enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:NSClassFromString(@"UINavigationItemView")]) {
            obj.alpha = alpha;
            *stop = YES;
        }
    }];
}

- (void)lt_reset
{
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.overlay removeFromSuperview];
    self.overlay = nil;
}

@end
