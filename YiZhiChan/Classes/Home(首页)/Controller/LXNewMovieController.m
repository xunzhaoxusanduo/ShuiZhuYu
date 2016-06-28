//
//  LXNewMovieController.m
//  YiZhiChan
//
//  Created by wuyaju on 16/5/14.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXNewMovieController.h"
#import "Macros.h"

@interface LXNewMovieController ()

@end

@implementation LXNewMovieController

- (void)viewDidLoad {
    [self setupSegment];
    [super viewDidLoad];
}

/**
 *  设置分段控件
 */
- (void)setupSegment {
    NSArray *segmentArray = [NSArray arrayWithObjects:@"推荐", @"热映电影", @"即将上映", nil];
    
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:segmentArray];
    segmentControl.frame = CGRectMake(0, 0, 100, 30);
    segmentControl.tintColor = LXYellowColor;
    
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [segmentControl setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [segmentControl setTitleTextAttributes:textAttrs forState:UIControlStateSelected];
//    [segmentControl setDividerImage:[UIImage imageNamed:@"456"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [segmentControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    segmentControl.selectedSegmentIndex = self.curIndex;
    [self segmentChanged:segmentControl];
    
    self.navigationItem.titleView = segmentControl;
}

/**
 *  分段控件选择值改变
 */
- (void)segmentChanged:(UISegmentedControl *)segmentedControl {
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:{
            self.carouselUrl = [NSString stringWithFormat:@"%@/fishapi/api/Movie/HotMovie?State=4", LXBaseUrl];
            self.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/fashhtml/movie/movie.html?State=4&navbarstyle=0&search=1", LXBaseUrl]];
            break;
        }
        case 1:{
            self.carouselUrl = [NSString stringWithFormat:@"%@/fishapi/api/Movie/HotMovie?State=2", LXBaseUrl];
            self.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/fashhtml/movie/movie.html?State=2&navbarstyle=0&search=1", LXBaseUrl]];
            break;
        }
        case 2:{
            self.carouselUrl = [NSString stringWithFormat:@"%@/fishapi/api/Movie/HotMovie?State=3", LXBaseUrl];
            self.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/fashhtml/movie/movie.html?State=3&navbarstyle=0&search=1", LXBaseUrl]];
            break;
        }
        default:
            break;
    }
}

@end
