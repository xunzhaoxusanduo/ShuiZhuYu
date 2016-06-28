//
//  MJSettingCell.h
//  00-ItcastLottery
//
//  Created by apple on 14-4-17.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJSettingItem;

@protocol MJSettingCellDelegate <NSObject>

@optional
- (void)settingCellSwitchStateChange:(UISwitch *)aSwitch MJSettingItem:(MJSettingItem *)item;

@end

@interface MJSettingCell : UITableViewCell
@property (nonatomic, strong) MJSettingItem *item;
@property (nonatomic, assign, getter = isLastRowInSection) BOOL lastRowInSection;
@property (nonatomic, weak)id<MJSettingCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
