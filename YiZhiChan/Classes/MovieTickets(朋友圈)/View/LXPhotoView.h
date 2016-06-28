//
//  LXPhotoView.h
//  YiZhiChan
//
//  Created by wuyaju on 16/5/22.
//  Copyright © 2016年 吴亚举. All rights reserved.
//  显示单张图片的View

#import <UIKit/UIKit.h>

@class LXFriendPhoto;

@interface LXPhotoView : UIImageView

@property (nonatomic, strong)LXFriendPhoto *photo;

@end
