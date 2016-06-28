//
//  LXMyFriendCell.h
//  YiZhiChan
//
//  Created by wuyaju on 16/5/17.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LXMyFriend;

@interface LXMyFriendCell : UITableViewCell

@property (nonatomic, strong)LXMyFriend *friend;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
