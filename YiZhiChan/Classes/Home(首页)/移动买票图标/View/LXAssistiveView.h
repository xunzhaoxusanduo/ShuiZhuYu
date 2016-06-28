//
//  LXAssistiveView.h
//  YiZhiChan
//
//  Created by wuyaju on 16/4/30.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LXAssistiveViewRotatingHandler)(double augular);

@class LXAssistiveViewBorder;

@protocol LXAssistiveViewDelegate <NSObject>

@optional
- (void)didSelectedAssistiveView;

@end

@interface LXAssistiveView : UIView

@property (nonatomic ,strong)NSMutableArray *supportBorders;
@property (nonatomic, assign)UIEdgeInsets borderEdge;

- (void)startAttachmentAtBorder:(LXAssistiveViewBorder *)border;
- (void)addRotatingHandler:(nullable id)target rotatingHandler:(nullable LXAssistiveViewRotatingHandler)rotatingHandler;
- (void)removeRotatingHandler:(nullable id)target;

@property (nonatomic, weak)id<LXAssistiveViewDelegate> delegate;

@end
