//
//  LXSearchResultTableViewController.m
//  YiZhiChan
//
//  Created by wuyaju on 16/5/20.
//  Copyright © 2016年 吴亚举. All rights reserved.
//  好友搜素结果显示控制器

#import "LXSearchResultTableViewController.h"
#import "LXMyFriendCell.h"
#import "LXMyFriendGroup.h"
#import "LXFriendViewController.h"
#import "LXMyFriend.h"
#import "Macros.h"

@implementation LXSearchResultTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *view = [[UIView alloc] init];
    self.tableView.tableFooterView = view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LXMyFriendCell *cell = [LXMyFriendCell cellWithTableView:tableView];
    
    cell.friend = self.filteredModels[indexPath.row];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"有%ld个搜索结果", self.filteredModels.count];
}

@end
