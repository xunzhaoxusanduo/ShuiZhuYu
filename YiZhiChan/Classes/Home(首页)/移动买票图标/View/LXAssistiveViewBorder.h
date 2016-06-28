//
//  LXAssistiveViewBorder.h
//  YiZhiChan
//
//  Created by wuyaju on 16/4/30.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LXAssistiveViewBorderType) {
    LXAssistiveViewBorderTypeLeft = 0,
    LXAssistiveViewBorderTypeRight,
    LXAssistiveViewBorderTypeTop,
    LXAssistiveViewBorderTypeBottom
};

typedef NS_ENUM(NSInteger, LXAssistiveViewBorderOrientation) {
    LXAssistiveViewBorderOrientationVertical = 0,
    LXAssistiveViewBorderOrientationHorizontal
};

@interface LXAssistiveViewBorder : NSObject

@property (nonatomic, assign)LXAssistiveViewBorderType borderType;
@property (nonatomic, assign)double value;

- (instancetype)initWithType:(LXAssistiveViewBorderType)borderType;
- (LXAssistiveViewBorderOrientation)orientation;
- (LXAssistiveViewBorderType)next;

@end
