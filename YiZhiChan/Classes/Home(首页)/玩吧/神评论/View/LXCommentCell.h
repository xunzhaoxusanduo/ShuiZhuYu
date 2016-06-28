//
//  LXCommentCell.h
//  YiZhiChan
//
//  Created by wuyaju on 16/4/30.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LXComment;

@interface LXCommentCell : UITableViewCell

@property (nonatomic, strong)LXComment *comment;
// 是否为最后一个cell
@property (nonatomic, assign, getter = isLastRowInSection) BOOL lastRowInSection;

@end
