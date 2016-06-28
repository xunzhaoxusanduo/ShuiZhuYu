//
//  LXProgressView.h
//  YiZhiChan
//
//  Created by wuyaju on 16/6/2.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXProgressView : UIView

@property (nonatomic,assign) CGFloat progress;

@property (nonatomic,strong) UIColor *trackTintColor;
@property (nonatomic,strong) UIColor *progressTintColor;
@property (nonatomic, strong)UILabel *titleLbl;

@end
