//
//  LXAdvertCell.h
//  YiZhiChan
//
//  Created by wuyaju on 16/4/27.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LXAdvert;

@protocol LXAdvertCellDelegate <NSObject>

@optional
- (void)advertCellHeightDidChanged:(UITableViewCell *)cell;

@end

@interface LXAdvertCell : UITableViewCell

@property (nonatomic, strong)LXAdvert *advert;
@property (nonatomic, weak)id<LXAdvertCellDelegate>delegate;

@end
