//
//  LXAssistiveViewBorder.m
//  YiZhiChan
//
//  Created by wuyaju on 16/4/30.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXAssistiveViewBorder.h"

@interface LXAssistiveViewBorder ()

@end

@implementation LXAssistiveViewBorder

- (instancetype)initWithType:(LXAssistiveViewBorderType)borderType {
    if (self = [super init]) {
        self.borderType = borderType;
    }
    
    return self;
}

- (LXAssistiveViewBorderOrientation)orientation {
    LXAssistiveViewBorderOrientation Orientation;
    
    switch (self.borderType) {
        case LXAssistiveViewBorderTypeLeft:
            Orientation = LXAssistiveViewBorderOrientationVertical;
            break;
        case LXAssistiveViewBorderTypeRight:
            Orientation = LXAssistiveViewBorderOrientationVertical;
            break;
        case LXAssistiveViewBorderTypeTop:
            Orientation = LXAssistiveViewBorderOrientationHorizontal;
            break;
        case LXAssistiveViewBorderTypeBottom:
            Orientation = LXAssistiveViewBorderOrientationHorizontal;
            break;
        default:
            break;
    }
    
    return Orientation;
}

- (LXAssistiveViewBorderType)next {
    switch (self.borderType) {
        case LXAssistiveViewBorderTypeLeft:
            self.borderType = LXAssistiveViewBorderTypeBottom;
            break;
        case LXAssistiveViewBorderTypeBottom:
            self.borderType = LXAssistiveViewBorderTypeRight;
            break;
        case LXAssistiveViewBorderTypeRight:
            self.borderType = LXAssistiveViewBorderTypeTop;
            break;
        case LXAssistiveViewBorderTypeTop:
            self.borderType = LXAssistiveViewBorderTypeLeft;
            break;
        default:
            break;
    }
    
    return self.borderType;
}

//- (int)stepToBorder:(LXAssistiveViewBorder *)border {
//    int step;
//    
//    if (self != border) {
//        do{
//            
//        }while (step);
//    }
//    
//    return 1;
//}

@end
