//
//  MJSettingViewControllerMJBaseSettingViewController00-ItcastLottery
//
//  Created by apple on 14-4-17.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MJBaseSettingViewController.h"
#import "MJSettingArrowItem.h"
#import "MJSettingSwitchItem.h"
#import "MJSettingGroup.h"
#import "MJSettingCell.h"
#import "LXWebViewController.h"
#import "LXUserInfo.h"
#import "LXMyFriendsController.h"
#import "Macros.h"
#import "TDBadgedCell.h"
#import "LXBadgedItem.h"

@interface MJBaseSettingViewController () <MJSettingCellDelegate>
@end

@implementation MJBaseSettingViewController

- (id)init
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSArray *)data
{
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MJSettingGroup *group = self.data[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MJSettingGroup *group = self.data[indexPath.section];
    MJSettingItem *item = group.items[indexPath.row];
    if ([item isKindOfClass:[LXBadgedItem class]]) {
        TDBadgedCell *cell = [TDBadgedCell cellWithTableView:tableView];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = RGB(50, 50, 50);
        cell.item = item;
        return cell;
    }else {
        // 1.创建cell
        MJSettingCell *cell = [MJSettingCell cellWithTableView:tableView];
        
        // 2.给cell传递模型数据
        cell.item = item;
        cell.lastRowInSection =  (group.items.count - 1 == indexPath.row);
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = RGB(50, 50, 50);
        cell.delegate = self;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.取消选中这行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 2.模型数据
    MJSettingGroup *group = self.data[indexPath.section];
    MJSettingItem *item = group.items[indexPath.row];
    
    if (item.option) { // block有值(点击这个cell,.有特定的操作需要执行)
        item.option();
    } else if ([item isKindOfClass:[MJSettingArrowItem class]]) { // 箭头
        MJSettingArrowItem *arrowItem = (MJSettingArrowItem *)item;
        
        // 如果没有需要跳转的控制器
        if (arrowItem.destVcClass == nil) return;
        
        // 要跳转的控制器需要登录
        if (arrowItem.isNeedLogin) {
            // 判断是否已经登录
            if (![[LXUserInfo user] isLogin:self]) {
                return;
            }
        }
        
        if (arrowItem.urlStr) {
            UIViewController *vc = [[arrowItem.destVcClass alloc] initWithUrl:[NSURL URLWithString:arrowItem.urlStr]];
            [self.navigationController pushViewController:vc  animated:YES];
        }else {
            UIViewController *vc = [[arrowItem.destVcClass alloc] init];
            vc.title = arrowItem.title;
            [self.navigationController pushViewController:vc  animated:YES];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    MJSettingGroup *group = self.data[section];
    return group.header;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    MJSettingGroup *group = self.data[section];
    return group.footer;
}

@end
