//
//  LXSuspenditemView.h
//  自定义collectionview
//
//  Created by wuyaju on 16/4/22.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LXSuspenditemView;

@protocol LXSuspenditemViewDelegate <NSObject>

- (void)checkLocationOfOthersWithButton:(LXSuspenditemView *)shakingButton;
- (void)longPressGestureEnd;

@end

@interface LXSuspenditemView : UIButton

@property (nonatomic, strong)UIView *superView;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, assign)CGPoint lastPoint;
@property (nonatomic, assign) id<LXSuspenditemViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)image inView:(UIView *)view;
- (void)startShake;
- (void)stopShake;

@end
