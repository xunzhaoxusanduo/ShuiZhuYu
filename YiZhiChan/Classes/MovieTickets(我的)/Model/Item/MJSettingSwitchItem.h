//
//  MJSettingSwitchItem.h
//  00-ItcastLottery
//
//  Created by apple on 14-4-17.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MJSettingItem.h"
#import <UIKit/UIKit.h>

typedef void(^switchState)(UISwitch *aSwitch);

@interface MJSettingSwitchItem : MJSettingItem

@property (nonatomic, copy)switchState state;

@end
