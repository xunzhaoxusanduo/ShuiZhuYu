//
//  LXRegionMenuViewController.h
//  YiZhiChan
//
//  Created by wuyaju on 16/5/25.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXBaseViewController.h"

#define LXSelectRegionNotification  @"LXSelectRegionNotification"
#define LXRegionKey                 @"LXRegionKey"

@interface LXRegionMenuViewController : LXBaseViewController

@property (nonatomic, copy)NSString *curCity;
@property (nonatomic, strong)UITableView *tableView;

@end
