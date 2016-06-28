//
//  LXMyMessageViewController.m
//  YiZhiChan
//
//  Created by wuyaju on 16/6/3.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXMyMessageViewController.h"
#import "Macros.h"
#import "LXRedDotRegister.h"
#import "GJRedDot.h"

@interface LXMyMessageViewController ()

@end

@implementation LXMyMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/fashhtml/myData/filmpublish.html?navbarstyle=0", LXBaseUrl]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.tabBarItem.badgeValue = nil;
    [self resetRedDotState:NO forKey:LXHomeMessage];
}

@end
