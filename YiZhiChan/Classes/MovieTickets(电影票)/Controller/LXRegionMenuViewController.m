//
//  LXRegionMenuViewController.m
//  YiZhiChan
//
//  Created by wuyaju on 16/5/25.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXRegionMenuViewController.h"
#import "MJExtension.h"
#import "LXCity.h"
#import "LXRegion.h"
#import "YMCitySelect.h"
#import "LXCityCell.h"

#define CityCellId @"cityCellId"

@interface LXRegionMenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)NSMutableArray *cityGroupArray;
@property (nonatomic, assign)NSInteger curSection;

@end

@implementation LXRegionMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *cityName = [[NSUserDefaults standardUserDefaults] objectForKey:LXCurCityNameKey];
    self.curSection = [self fromCityName:cityName];
}

- (void)setupSubViews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 170) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LXCityCell" bundle:nil] forCellReuseIdentifier:CityCellId];
}

- (NSMutableArray *)cityGroupArray {
    if (_cityGroupArray == nil) {
        _cityGroupArray = [NSMutableArray array];
    }
    
    return _cityGroupArray;
}

#pragma mark - 私有方法
- (NSInteger)fromCityName:(NSString *)cityName {
    for (NSInteger i = 0; i < self.cityGroupArray.count; i++) {
        LXCity *city = self.cityGroupArray[i];
        if ([city.name isEqualToString:cityName]) {
            return i;
        }
    }
    
    return 0;
}

- (void)loadData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cities.plist" ofType:nil];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    self.cityGroupArray = [LXCity objectArrayWithKeyValuesArray:array];
}

#pragma mark - UITableViewDataSource代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    LXCity *city = self.cityGroupArray[self.curSection];
    return city.districts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LXCityCell *cell = [tableView dequeueReusableCellWithIdentifier:CityCellId];
    
    LXCity *city = self.cityGroupArray[self.curSection];
    LXRegion *region = city.districts[indexPath.row];
    cell.cityLbl.text = region.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didSelectRowAtIndexPath");
    LXCity *city = self.cityGroupArray[self.curSection];
    LXRegion *region = city.districts[indexPath.row];
    
    [[NSUserDefaults standardUserDefaults] setObject:region.name forKey:LXRegionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:LXSelectRegionNotification object:nil userInfo:nil];
}

@end
