//
//  LXBaseViewController.m
//  YiZhiChan
//
//  Created by wuyaju on 16/4/26.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXBaseViewController.h"

@interface LXBaseViewController ()

@end

@implementation LXBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

@end
