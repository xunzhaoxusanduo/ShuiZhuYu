//
//  LXCellHeaderView.h
//  YiZhiChan
//
//  Created by wuyaju on 16/4/27.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LXCellHeader;
@class LXCellHeaderView;

@protocol LXCellHeaderViewDelegate <NSObject>

@optional
- (void)headerView:(LXCellHeaderView *)headerView diddidSelectSection:(NSInteger)section;

@end

@interface LXCellHeaderView : UIView

@property (nonatomic, strong)LXCellHeader *cellHeader;
@property (nonatomic, assign)NSInteger section;
@property (nonatomic, weak)id<LXCellHeaderViewDelegate>delegate;

@end
