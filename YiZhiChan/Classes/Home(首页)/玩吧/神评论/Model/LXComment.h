//
//  LXComment.h
//  YiZhiChan
//
//  Created by wuyaju on 16/4/30.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXComment : NSObject <NSCoding>

// 电影名
@property (nonatomic, copy)NSString *movieName;
// 评论内容
@property (nonatomic, copy)NSString *comment;
// 电影ID
@property (nonatomic, strong)NSNumber *movieInfoId;
// 里面存放的是LXPhoto模型
@property (nonatomic, strong)NSMutableArray *imagesList;
//
@property (nonatomic, copy)NSString *cover;
@end
