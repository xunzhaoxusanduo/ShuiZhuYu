//
//  LXMyFriendsController.m
//  YiZhiChan
//
//  Created by wuyaju on 16/5/16.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXMyFansController.h"
#import "LXMyFan.h"
#import "UINavigationBar+Extend.h"
#import "Macros.h"
#import "LXMyFanCell.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "LXUserInfo.h"
#import "LXWebViewController.h"
#import "LXBaseNavigationController.h"
#import "NSDictionary+NSNull.h"

@interface LXMyFansController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *fansArray;

@end

@implementation LXMyFansController

- (instancetype)initWithFanUrlStr:(NSString *)fanUrlStr {
    if (self = [super init]) {
        self.fanUrlStr = [fanUrlStr copy];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:NavBarBackgroundColour];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self.tableView.mj_header beginRefreshing];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma  mark - 私有方法
- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = RGB(240.0, 240.0, 240.0);
    UIView *view = [[UIView alloc] init];
    tableView.tableFooterView = view;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadFriendGroup];
    }];
}

- (void)loadFriendGroup {
    if (self.fanUrlStr != nil) {
        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
        
        [mgr GET:self.fanUrlStr parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             responseObject = [NSDictionary changeType:responseObject];
             if ([responseObject[@"state"] intValue] == 1) {
                 self.fansArray = (NSMutableArray *)[LXMyFan objectArrayWithKeyValuesArray:responseObject[@"data"]];
             }
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.tableView reloadData];
                 [self.tableView.mj_header endRefreshing];
             });
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
         }];
    }
}

/**
 *  根据用户ID删除好友
 *
 */
- (void)deleteFriend:(NSInteger)userId {
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSString *url = [NSString stringWithFormat:@"%@/fishapi/api/User/CancelFollow?UserId=1&FriendId=%ld", LXBaseUrl, userId];
    [mgr GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        responseObject = [NSDictionary changeType:responseObject];
         if ([responseObject[@"state"] intValue] == 1) {
             [self loadFriendGroup];
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
     }];
}

#pragma  mark - 懒加载
- (NSMutableArray *)fansArray {
    if (_fansArray == nil) {
        _fansArray = [NSMutableArray array];
    }
    
    return _fansArray;
}

#pragma mark - UITableViewDataSource数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fansArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LXMyFanCell *cell = [LXMyFanCell cellWithTableView:tableView];

    cell.fan = self.fansArray[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
