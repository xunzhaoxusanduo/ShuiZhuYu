//
//  LXBaseFriendTableViewCell.h
//  YiZhiChan
//
//  Created by wuyaju on 16/5/22.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXPersonInfoView.h"
#import "LXContentView.h"
#import "Masonry.h"
#import "Macros.h"

@interface LXBaseFriendTableViewCell : UITableViewCell

// 个人信息
@property (nonatomic, strong)LXPersonInfoView *personInfoView;

@end
