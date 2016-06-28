//
//  LXAssistiveView.m
//  YiZhiChan
//
//  Created by wuyaju on 16/4/30.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXAssistiveView.h"
#import "LXAssistiveViewBorder.h"

@interface LXAssistiveView ()

@property (nonatomic, strong)NSMutableDictionary *rotatingHandlers;
@property (nonatomic, strong)LXAssistiveViewBorder *originalBorder;

@property (nonatomic, assign)UIOffset centerOffset;
@property (nonatomic, assign)BOOL startAttachment;

@property (nonatomic, strong)UILabel *label;

@end

@implementation LXAssistiveView

- (NSMutableArray *)supportBorders {
    if (_supportBorders == nil) {
        _supportBorders = [NSMutableArray array];
        
    }
    
    return _supportBorders;
}

- (NSMutableDictionary *)rotatingHandlers {
    if (_rotatingHandlers == nil) {
        _rotatingHandlers = [NSMutableDictionary dictionary];
    }
    
    return _rotatingHandlers;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self prepareSettings];
    }
    
    return self;
}

- (void)prepareSettings {
    self.originalBorder = [[LXAssistiveViewBorder alloc] initWithType:LXAssistiveViewBorderTypeLeft];
    
    UIImage *image = [UIImage imageNamed:@"home_ticket"];
    CGSize size = CGSizeMake(self.frame.size.width * (image.size.width/image.size.height), self.frame.size.height);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = self.bounds;
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(10, 0, 20, self.frame.size.height);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"票";
    label.textColor = [UIColor whiteColor];
    [self addSubview:label];
    self.label = label;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = self.bounds;
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self addGestureRecognizer:panGestureRecognizer];
}

- (void)clicked {
    if ([self.delegate respondsToSelector:@selector(didSelectedAssistiveView)]) {
        [self.delegate didSelectedAssistiveView];
    }
}

/**
 *  移动手势处理
 *
 */
- (void)handlePanGesture:(UITapGestureRecognizer *)sender {
    if (self.startAttachment == NO) {
        return;
    }
    
    static CGPoint lastPoint;
    
    CGPoint point = [sender locationInView:self.superview];
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:{
            lastPoint = point;
            break;
        }
        case UIGestureRecognizerStateChanged:{
            float offX = point.x - lastPoint.x;
            float offY = point.y - lastPoint.y;
            [self setCenter:CGPointMake(self.center.x + offX, self.center.y + offY)];
            lastPoint = point;
            break;
        }
        case UIGestureRecognizerStateEnded:{
            [self endUpdatePosition];
            break;
        }
        case UIGestureRecognizerStateCancelled:{
            [self endUpdatePosition];
            break;
        }
        default:
            break;
    }
}

- (void)startAttachmentAtBorder:(LXAssistiveViewBorder *)border {
    self.transform = CGAffineTransformIdentity;
    self.startAttachment = true;
    self.originalBorder = border;
    [self placeAssistiveViewAtBorder:border];
}

- (void)stopstopAttachment {
    self.startAttachment = NO;
}

- (void)startMoveAnimation:(void (^)())additionalHandler {
    [UIView animateWithDuration:0.2 animations:^{
        if (additionalHandler) {
            additionalHandler();
        }
    }];
}

- (void)endMoveAnimation:(void (^)())additionalHandler {
    [UIView animateWithDuration:0.2 animations:^{
        if (additionalHandler) {
            additionalHandler();
        }
    }];
}

- (void)updatingPosture:(CGPoint)position {
    CGFloat horizontal = self.centerOffset.horizontal;
    CGFloat vertical = self.centerOffset.vertical;
    self.center = CGPointMake(position.x + horizontal, position.y + vertical);
}

- (void)addRotatingHandler:(nullable id)target rotatingHandler:(nullable LXAssistiveViewRotatingHandler)rotatingHandler {
    self.rotatingHandlers[target] = rotatingHandler;
}

- (void)removeRotatingHandler:(nullable id)target {
    [self.rotatingHandlers removeObjectForKey:target];
}

/**
 *  根据传入的位置，获取将要停靠的边缘
 *
 */
- (LXAssistiveViewBorder *)borderOfPosition:(CGPoint)position {
    UIView *superView = self.superview;
    if (superView == nil) {
        return nil;
    }
    
    LXAssistiveViewBorder *left = [[LXAssistiveViewBorder alloc] initWithType:LXAssistiveViewBorderTypeLeft];
    LXAssistiveViewBorder *right = [[LXAssistiveViewBorder alloc] initWithType:LXAssistiveViewBorderTypeRight];
    LXAssistiveViewBorder *top = [[LXAssistiveViewBorder alloc] initWithType:LXAssistiveViewBorderTypeTop];
    LXAssistiveViewBorder *bottom = [[LXAssistiveViewBorder alloc] initWithType:LXAssistiveViewBorderTypeBottom];
    
    left.value = (double)(self.center.x - self.borderEdge.left);
    right.value = (double)(superView.frame.size.width - self.center.x - self.borderEdge.right);
    top.value = (double)(self.center.y - self.borderEdge.top);
    bottom.value = (double)(superView.frame.size.height - self.center.y - self.borderEdge.bottom);
    
    NSArray *array = [NSArray arrayWithObjects:left, right, top, bottom, nil];
    NSArray *sortArray = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        LXAssistiveViewBorder *border1 = (LXAssistiveViewBorder *)obj1;
        LXAssistiveViewBorder *border2 = (LXAssistiveViewBorder *)obj2;
        
        if (border1.value < border2.value) {
            return -1;
        }else {
            return 1;
        }
    }];
    
    LXAssistiveViewBorder *border = [[LXAssistiveViewBorder alloc] initWithType:LXAssistiveViewBorderTypeLeft];
    for (LXAssistiveViewBorder *sortBorder in sortArray) {
        for (LXAssistiveViewBorder *supportBorder in self.supportBorders) {
            if (sortBorder.borderType == supportBorder.borderType) {
                border = sortBorder;
                return border;
            }
        }
    }
    
    return border;
}

/**
 *  和当前停靠的边缘做比较，计算出将要停靠的边缘要旋转的角度
 *
 */
- (int)stepToBorder:(LXAssistiveViewBorder *)border {
    if (self.originalBorder.borderType != border.borderType) {
        
        int step = 0;
        LXAssistiveViewBorderType nextBorder = [self.originalBorder next];
        step++;
        
        while (nextBorder != border.borderType) {
            nextBorder = [self.originalBorder next];
            step++;
        }
        return step;
    }else {
        return 0;
    }
}

/**
 *  停靠到指定的边缘
 *
 */
- (void)placeAssistiveViewAtBorder:(LXAssistiveViewBorder *)border {
    int step = [self stepToBorder:border];
    NSLog(@"step = %d", step);
//     double augular = (double)(step * 90);
    double augular = -(double)((step * 90) % 360);
    while (augular > 0) {
        augular -= 360;
    }
    
    NSLog(@"%f", augular);
    
    self.transform = CGAffineTransformRotate(self.transform, augular * M_PI / 180);
    
    self.label.transform = CGAffineTransformRotate(self.label.transform, - (augular * M_PI / 180));
    
    CGRect frame = self.frame;
    switch (border.borderType) {
        case LXAssistiveViewBorderTypeLeft:
            frame.origin.x = 0 + self.borderEdge.left;
            break;
        case LXAssistiveViewBorderTypeRight:
            frame.origin.x = self.superview.frame.size.width - frame.size.width - self.borderEdge.right;
            break;
        case LXAssistiveViewBorderTypeTop:
            frame.origin.y = 0 + self.borderEdge.top;
            break;
        case LXAssistiveViewBorderTypeBottom:
            frame.origin.y = self.superview.frame.size.height - frame.size.height - self.borderEdge.bottom;
            break;
        default:
            break;
    }
    
    switch ([border orientation]) {
        case LXAssistiveViewBorderOrientationVertical:{
            frame.origin.y = MAX(frame.origin.y, self.borderEdge.top);
            frame.origin.y = MIN(frame.origin.y, self.superview.frame.size.height - self.borderEdge.bottom - frame.size.height);
            break;
        }
        case LXAssistiveViewBorderOrientationHorizontal:{
            frame.origin.x = MAX(frame.origin.x, self.borderEdge.left);
            frame.origin.x = MIN(frame.origin.x, self.superview.frame.size.width - self.borderEdge.right - frame.size.width);
            break;
        }
        default:
            break;
    }
    
    self.frame = frame;
    self.originalBorder = border;
}

/**
 *  结束移动，开始停靠
 */
- (void)endUpdatePosition{
    __block LXAssistiveViewBorder *supportBorder = [self borderOfPosition:self.center];
    [self endMoveAnimation:^{
        [self placeAssistiveViewAtBorder:supportBorder];
    }];
}

@end
