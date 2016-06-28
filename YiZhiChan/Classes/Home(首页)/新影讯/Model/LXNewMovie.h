//
//  LXNewMovie.h
//  YiZhiChan
//
//  Created by wuyaju on 16/4/27.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXNewMovie : NSObject <NSCoding>

//// 海报图片
//@property (nonatomic, copy)NSString *cover;
//// 电影名
//@property (nonatomic, copy)NSString *movieName;
//// 电影评分
//@property (nonatomic, copy)NSNumber *rating;
//// 电影类型
//@property (nonatomic, copy)NSNumber *movieType;
//// 导演名字
//@property (nonatomic, copy)NSString *director;
//// 上映日期
//@property (nonatomic, copy)NSString *releaseDate;
//// 电影简介
//@property (nonatomic, copy)NSString *remarks;
//// 跳转的链接
//@property (nonatomic, copy)NSString *url;
//@property (nonatomic, strong)NSNumber *movieInfoId;
//// 电影类型
//@property (nonatomic, copy)NSString *displayType;

// 海报图片
@property (nonatomic, copy)NSString *thumbUrl;
// 标题
@property (nonatomic, copy)NSString *title;
// 发表时间
@property (nonatomic, copy)NSString *addTime;
// 点赞
@property (nonatomic, strong)NSNumber *praiseCount;
// 评论
@property (nonatomic, strong)NSNumber *commentCount;
// 消息ID
@property (nonatomic, strong)NSNumber *movieMsgId;

@end
