//
//  LXFriendHeaderView.h
//  YiZhiChan
//
//  Created by wuyaju on 16/5/23.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXBaseHeaderView.h"

@class LXMyInfo;

@protocol LXFriendHeaderViewDelegate <NSObject>

@optional
- (void)dynamicDidSelectWithInfo:(LXMyInfo *)myInfo;
- (void)fanDidSelectWithInfo:(LXMyInfo *)myInfo;
- (void)followDidSelectWithInfo:(LXMyInfo *)myInfo;

@end

@interface LXFriendHeaderView : LXBaseHeaderView

@property (nonatomic, strong)LXMyInfo *myInfo;
@property (nonatomic, weak)id<LXFriendHeaderViewDelegate> delegate;

@end
