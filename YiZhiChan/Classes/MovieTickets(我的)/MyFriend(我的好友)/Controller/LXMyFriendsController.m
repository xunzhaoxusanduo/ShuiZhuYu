//
//  LXMyFriendsController.m
//  YiZhiChan
//
//  Created by wuyaju on 16/5/16.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXMyFriendsController.h"
#import "LXMyFriend.h"
#import "UINavigationBar+Extend.h"
#import "Macros.h"
#import "LXMyFriend.h"
#import "LXMyFriendGroup.h"
#import "LXMyFriendCell.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "LXUserInfo.h"
#import "LXWebViewController.h"
#import "LXBaseNavigationController.h"
#import "LXSearchResultTableViewController.h"
#import "LXFriendViewController.h"
#import "NSDictionary+NSNull.h"
#import "MBProgressHUD+MJ.h"

@interface LXMyFriendsController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating>

@property (nonatomic, strong)UISearchController *searchController;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *friendsGroupArray;
@property (nonatomic, strong)NSMutableArray *friendsArray;
@property (nonatomic, strong)NSMutableArray *resultsArray;

@end

@implementation LXMyFriendsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSearchController];
    [self setupTableView];
    [self loadFriendGroup];
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
- (void)setupSearchController {
    LXSearchResultTableViewController *resultsTableController = [[LXSearchResultTableViewController alloc] init];
    resultsTableController.tableView.delegate = self;
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:resultsTableController];
    UISearchBar *searchBar = searchController.searchBar;
    searchBar.delegate = self;
    [searchBar setBackgroundImage:[UIImage imageNamed:@"ic_searchBar_bgImage"]];
    [searchBar sizeToFit];
    [searchBar setPlaceholder:@"输入好友名称"];
    NSLog(@"%@", NSStringFromCGRect(searchController.searchBar.frame));
//    [self.view addSubview:searchController.searchBar];
    searchController.searchResultsUpdater = self;
    searchController.dimsBackgroundDuringPresentation = YES;
    self.definesPresentationContext = YES;
    self.searchController = searchController;
}

- (void)setupTableView {
//    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchController.searchBar.frame.origin.y + 44,
//                                                                           self.view.frame.size.width, self.view.frame.size.height - 44) style:UITableViewStyleGrouped];
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.sectionIndexColor = RGB(54, 56, 56);
    tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    tableView.backgroundColor = RGB(240.0, 240.0, 240.0);
    UIView *view = [[UIView alloc] init];
    tableView.tableFooterView = view;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadFriendGroup];
    }];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
}

- (void)loadFriendGroup {
    if ([[LXUserInfo user] updateByCookieWithURL:nil]) {
        NSString *urlStr = [NSString stringWithFormat:@"%@/fishapi/api/User/UserFriend?UserId=%ld", LXBaseUrl, [[LXUserInfo user].userId integerValue]];
        
        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
        
        [mgr GET:urlStr parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             responseObject = [NSDictionary changeType:responseObject];
             if ([responseObject[@"state"] intValue] == 1) {
                 self.friendsGroupArray = (NSMutableArray *)[LXMyFriendGroup objectArrayWithKeyValuesArray:responseObject[@"data"]];
                 
                 if (self.friendsArray != nil) {
                     [self.friendsArray removeAllObjects];
                 }
                 
                 for (LXMyFriendGroup *friendGroup in self.friendsGroupArray) {
                     for (LXMyFriend *friend in friendGroup.userList) {
                         [self.friendsArray addObject:friend];
                         NSLog(@"%@", friend.nickNamePinYin);
                     }
                 }
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
- (void)deleteFriend:(NSIndexPath *)indexPath {
    LXMyFriendGroup *myFriendGroup = self.friendsGroupArray[indexPath.section];
    LXMyFriend *friend = myFriendGroup.userList[indexPath.row];
    NSInteger userId = [LXUserInfo user].userId.integerValue;
    NSInteger friendUserId = friend.userId.integerValue;
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"%@/fishapi/api/User/CancelFollow?UserId=%ld&FriendId=%ld", LXBaseUrl, userId, friendUserId];
    [mgr GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        responseObject = [NSDictionary changeType:responseObject];
         if ([responseObject[@"state"] intValue] == 1) {
             [self loadFriendGroup];
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     }];
}

#pragma  mark - 懒加载
- (NSMutableArray *)friendsGroupArray {
    if (_friendsGroupArray == nil) {
        _friendsGroupArray = [NSMutableArray array];
    }
    
    return _friendsGroupArray;
}

- (NSMutableArray *)friendsArray {
    if (_friendsArray == nil) {
        _friendsArray = [NSMutableArray array];
    }
    
    return _friendsArray;
}

- (NSMutableArray *)resultsArray {
    if (_resultsArray == nil) {
        _resultsArray = [NSMutableArray array];
    }
    
    return _resultsArray;
}

#pragma mark - UITableViewDataSource数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.friendsGroupArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    LXMyFriendGroup *myFriendGroup = self.friendsGroupArray[section];
    return myFriendGroup.userList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LXMyFriendCell *cell = [LXMyFriendCell cellWithTableView:tableView];
    
    LXMyFriendGroup *myFriendGroup = self.friendsGroupArray[indexPath.section];
    cell.friend = myFriendGroup.userList[indexPath.row];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    LXMyFriendGroup *myFriendGroup = self.friendsGroupArray[section];
    return myFriendGroup.firstPY;
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *titleArray = [NSMutableArray array];
    // 右侧索引字母增加一个搜索索引
    [titleArray addObject:UITableViewIndexSearch];
    for (LXMyFriendGroup *friendGroup in self.friendsGroupArray) {
        [titleArray addObject:friendGroup.firstPY];
    }
    return titleArray;
}

/**
 *  由于右侧的索引字母增加了一个搜索索引，所以点击索引与跳转到相应的section相差1
 *
 */
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index-1;
}

#pragma mark - UITableViewDelegate代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.searchController.active) {
        return 22.0;
    }else{
        return 22.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    LXMyFriend *friend = nil;
    if (self.searchController.isActive) {
        friend = self.resultsArray[indexPath.row];
    }else {
        LXMyFriendGroup *myFriendGroup = self.friendsGroupArray[indexPath.section];
        friend = myFriendGroup.userList[indexPath.row];
    }
    
    LXFriendViewController *vc = [[LXFriendViewController alloc] initWithFriendInfoUrl:LXPersonInfoUrl userId:friend.userId.integerValue statusUrl:LXOtherPersonDynamicUrl];
    [self.navigationController pushViewController:vc animated:YES];
    
    NSLog(@"didSelectRowAtIndexPath");
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.searchController.active) {
        return nil;
    }else {
        id label = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
        if (!label) {
            label = [[UILabel alloc] init];
            [label setFont:[UIFont systemFontOfSize:14.5f]];
            [label setTextColor:[UIColor grayColor]];
            [label setBackgroundColor:RGB(240.0, 240.0, 240.0)];
        }
        
        LXMyFriendGroup *myFriendGroup = self.friendsGroupArray[section];
        
        [label setText:[NSString stringWithFormat:@"  %@",myFriendGroup.firstPY]];
        return label;
    }
}

/**
 *  如果实现了这个方法,就自动实现了滑动删除的功能
 *  点击了删除按钮就会调用
 *  提交了一个编辑操作就会调用(操作:删除\添加)
 *  @param editingStyle 编辑的行为
 *  @param indexPath    操作的行号
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) { // 提交的是删除操作
        [self deleteFriend:indexPath];
    }
}

/**
 *  当tableView进入编辑状态的时候会调用,询问每一行进行怎样的操作(添加\删除)
 */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

#pragma mark -searchBarDelegate代理方法
//searchBar开始编辑时改变取消按钮的文字
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"searchBarTextDidBeginEditing");
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    //取消
//    [searchBar resignFirstResponder];
//    searchBar.showsCancelButton = NO;
    NSLog(@"searchBarCancelButtonClicked");
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    // update the filtered array based on the search text
    NSString *searchText = searchController.searchBar.text;
    NSMutableArray *searchResults = [self.friendsArray mutableCopy];
    
    // strip out all the leading and trailing spaces
    NSString *strippedString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // break up the search terms (separated by spaces)
    NSArray *searchItems = nil;
    if (strippedString.length > 0) {
        searchItems = [strippedString componentsSeparatedByString:@" "];
    }
    
    for (NSString *searStr in searchItems) {
        NSLog(@"searStr  %@", searStr);
    }
    
    // build all the "AND" expressions for each value in the searchString
    //
    NSMutableArray *andMatchPredicates = [NSMutableArray array];
    
    for (NSString *searchString in searchItems) {
        // each searchString creates an OR predicate for: name, id
        //
        // example if searchItems contains "iphone 599 2007":
        //      name CONTAINS[c] "lanmaq"
        //      id CONTAINS[c] "1568689942"
        NSMutableArray *searchItemsPredicate = [NSMutableArray array];
        
        // use NSExpression represent expressions in predicates.
        // NSPredicate is made up of smaller, atomic parts: two NSExpressions (a left-hand value and a right-hand value)
        
        // friendName field matching
        NSExpression *lhs = [NSExpression expressionForKeyPath:@"nickName"];
        NSExpression *rhs = [NSExpression expressionForConstantValue:searchString];
        NSPredicate *finalPredicate = [NSComparisonPredicate
                                       predicateWithLeftExpression:lhs
                                       rightExpression:rhs
                                       modifier:NSDirectPredicateModifier
                                       type:NSContainsPredicateOperatorType
                                       options:NSCaseInsensitivePredicateOption];
        [searchItemsPredicate addObject:finalPredicate];
        
        // friendId field matching
        
        lhs = [NSExpression expressionForKeyPath:@"nickNamePinYin"];
        rhs = [NSExpression expressionForConstantValue:searchString];
        finalPredicate = [NSComparisonPredicate
                          predicateWithLeftExpression:lhs
                          rightExpression:rhs
                          modifier:NSDirectPredicateModifier
                          type:NSContainsPredicateOperatorType
                          options:NSCaseInsensitivePredicateOption];
        [searchItemsPredicate addObject:finalPredicate];
        
        // at this OR predicate to our master AND predicate
        NSCompoundPredicate *orMatchPredicates = [NSCompoundPredicate orPredicateWithSubpredicates:searchItemsPredicate];
        [andMatchPredicates addObject:orMatchPredicates];
    }
    
    // match up the fields of the Product object
    NSCompoundPredicate *finalCompoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:andMatchPredicates];
    searchResults = [[searchResults filteredArrayUsingPredicate:finalCompoundPredicate] mutableCopy];
    
    [self.resultsArray removeAllObjects];
    [self.resultsArray addObjectsFromArray:searchResults];
    
    if (searchItems.count > 0) {
        //刷新表格
        LXSearchResultTableViewController *tableController = (LXSearchResultTableViewController *)self.searchController.searchResultsController;
        tableController.filteredModels = searchResults;
        [tableController.tableView reloadData];
    }
}

@end
