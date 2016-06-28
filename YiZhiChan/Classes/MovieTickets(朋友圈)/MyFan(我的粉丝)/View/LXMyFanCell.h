//
//  LXMyFriendCell.h
//  YiZhiChan
//
//  Created by wuyaju on 16/5/17.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LXMyFan;

@interface LXMyFanCell : UITableViewCell

@property (nonatomic, strong)LXMyFan *fan;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
