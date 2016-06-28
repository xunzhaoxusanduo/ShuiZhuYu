//
//  LXSuspenditemView.m
//  自定义collectionview
//
//  Created by wuyaju on 16/4/22.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXSuspenditemView.h"

#define ImageScale 0.7

@implementation LXSuspenditemView

- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)image inView:(UIView *)view
{
    self = [super initWithFrame:frame];
    if (self) {
        self.superView = view;
//        self.backgroundColor = [UIColor grayColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self setImage:image forState:UIControlStateNormal];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(drag:)];
        [self addGestureRecognizer:longPress];
    }
    return self;
}

- (void)drag:(UILongPressGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:self.superView];
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:{
            self.lastPoint = point;
            [self setAlpha:0.7];
            [self.layer setShadowColor:[UIColor grayColor].CGColor];
            [self.layer setShadowOpacity:1.0f];
            [self.layer setShadowRadius:10.0f];
            [self startShake];
            break;
        }
        case UIGestureRecognizerStateChanged:{
            float offX = point.x - self.lastPoint.x;
            float offY = point.y - self.lastPoint.y;
            [self setCenter:CGPointMake(self.center.x + offX, self.center.y + offY)];
            self.lastPoint = point;
            if ([self.delegate respondsToSelector:@selector(checkLocationOfOthersWithButton:)]) {
                [self.delegate checkLocationOfOthersWithButton:self];
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{
            [self stopShake];
            [self setAlpha:1];
            
            [UIView animateWithDuration:.3 animations:^{
                if ([self.delegate respondsToSelector:@selector(longPressGestureEnd)]) {
                    [self.delegate longPressGestureEnd];
                }
            } completion:^(BOOL finished) {
                [self.layer setShadowOpacity:0];
            }];
            break;
        }
        case UIGestureRecognizerStateCancelled:
            [self stopShake];
            [self setAlpha:1];
            break;
        case UIGestureRecognizerStateFailed:
            [self stopShake];
            [self setAlpha:1];
            break;
        default:
            break;
    }
}

- (void)startShake
{
    CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    shakeAnimation.duration = 0.08;
    shakeAnimation.autoreverses = YES;
    shakeAnimation.repeatCount = MAXFLOAT;
    shakeAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, -0.1, 0, 0, 1)];
    shakeAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, 0.1, 0, 0, 1)];
    
    [self.layer addAnimation:shakeAnimation forKey:@"shakeAnimation"];
}

- (void)stopShake
{
    [self.layer removeAnimationForKey:@"shakeAnimation"];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = contentRect.size.width;
    CGFloat height = contentRect.size.height * ImageScale;
    
    return CGRectMake(x, y, width, height);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat x = 0;
    CGFloat y = contentRect.size.height * ImageScale;
    CGFloat width = contentRect.size.width;
    CGFloat height = contentRect.size.height - y;
    
    return CGRectMake(x, y, width, height);
}

@end
