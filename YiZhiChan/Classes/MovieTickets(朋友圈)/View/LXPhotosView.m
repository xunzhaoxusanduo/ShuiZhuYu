//
//  LXPhotosView.m
//  YiZhiChan
//
//  Created by wuyaju on 16/5/21.
//  Copyright © 2016年 吴亚举. All rights reserved.
//  发表的图片的View

#import "LXPhotosView.h"
#import "Masonry.h"
#import "Macros.h"
#import "LXPhotoView.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "LXFriendPhoto.h"
#import "HZPhotoBrowser.h"
#import "LXUserInfo.h"

#define PhotoViewWidth 80
#define PhotoViewHeight 80

@interface LXPhotosView () <HZPhotoBrowserDelegate>

@property (nonatomic, strong)NSMutableArray *constraintsArray;

@end

@implementation LXPhotosView

- (instancetype)init {
    if (self = [super init]) {
        [self setupSubViews];
        [self setupAutoLayout];
    }
    
    return self;
}

- (NSMutableArray *)constraintsArray {
    if (_constraintsArray == nil) {
        _constraintsArray = [NSMutableArray array];
    }
    
    return _constraintsArray;
}

- (void)setupSubViews {
    for (int i = 0; i < 9; i++) {
        LXPhotoView *photoView = [[LXPhotoView alloc] init];
        photoView.userInteractionEnabled = YES;
        photoView.tag = i;
        [photoView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTap:)]];
        [self addSubview:photoView];
    }
}

//- (void)photoTap:(UITapGestureRecognizer *)recognizer
//{
//    NSInteger count = self.photosArray.count;
//    
//    // 1.封装图片数据
//    NSMutableArray *myphotos = [NSMutableArray arrayWithCapacity:count];
//    for (int i = 0; i<count; i++) {
//        // 一个MJPhoto对应一张显示的图片
//        MJPhoto *mjphoto = [[MJPhoto alloc] init];
//        
//        mjphoto.srcImageView = self.subviews[i]; // 来源于哪个UIImageView
//        
//        LXFriendPhoto *photo = self.photosArray[i];
//        mjphoto.url = [NSURL URLWithString:photo.imgUrl]; // 图片路径
//        
//        [myphotos addObject:mjphoto];
//    }
//    
//    // 2.显示相册
//    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
//    browser.currentPhotoIndex = recognizer.view.tag; // 弹出相册时显示的第一张图片是？
//    browser.photos = myphotos; // 设置所有的图片
//    [browser show];
//}

- (void)photoTap:(UITapGestureRecognizer *)recognizer {
    //启动图片浏览器
    HZPhotoBrowser *browserVc = [[HZPhotoBrowser alloc] init];
    browserVc.sourceImagesContainerView = self; // 原图的父控件
    browserVc.imageCount = self.photosArray.count; // 图片总数
    browserVc.currentImageIndex = (int)recognizer.view.tag;
    browserVc.delegate = self;
    [browserVc show];
    [LXUserInfo user].shouldLoadNewData = NO;
}

#pragma mark - photobrowser代理方法
- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    LXPhotoView *photoView = self.subviews[index];
    return photoView.image;
}

- (NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    LXFriendPhoto *photo = self.photosArray[index];
    NSString *urlStr = photo.imgUrl;
    return [NSURL URLWithString:urlStr];
}

- (NSString *)photoBrowser:(HZPhotoBrowser *)browser subTitle:(NSInteger)index {
    LXFriendPhoto *photo = self.photosArray[index];
    return photo.text;
}

- (void)setupAutoLayout {
}

- (void)setPhotosArray:(NSArray *)photosArray {
    _photosArray = photosArray;
    
    for (int i = 0; i < self.photosArray.count; i++) {
        LXPhotoView *photoView = self.subviews[i];
        photoView.photo = self.photosArray[i];
    }
    
    // tell constraints they need updating
    [self setNeedsUpdateConstraints];
    
    // update constraints now so we can animate the change
    [self updateConstraintsIfNeeded];
}

/**
 *  为计算行高
 *
 */
- (void)setPhotosArrayAutoLayout:(NSArray *)photosArrayAutoLayout {
    _photosArrayAutoLayout = photosArrayAutoLayout;
    

}

- (void)updateConstraints {
    NSLog(@"---------------------------------------------updateConstraints");
    
    for (MASConstraint *constraint in self.constraintsArray) {
        [constraint uninstall];
    }
    
    NSInteger count = self.photosArray.count;
    
    switch (count) {
        case 1:
            [self constraints1];
            break;
        case 2:
        case 3:
            [self constraints2To3];
            break;
        case 4:
            [self constraints4];
            break;
        case 5:
        case 6:
            [self constraints5To6];
            break;
        case 7:
        case 8:
        case 9:
            [self constraints7To9];
            break;
            
        default:
            break;
    }
    
    for (int i = 0; i < self.subviews.count; i++) {
        LXPhotoView *photoView = self.subviews[i];
        if (i < self.photosArray.count) {
            photoView.photo = self.photosArray[i];
            photoView.hidden = NO;
        }else {
            photoView.hidden = YES;
        }
    }
    
    for (int i = 0; i < self.photosArray.count; i++) {

    }
    
    //according to apple super should be called at end of method
    [super updateConstraints];
}


+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

- (void)constraints1 {
    WS(weakSelf);
    int padding = 10;
    
    LXPhotoView *photoView = self.subviews[0];
    photoView.contentMode = UIViewContentModeScaleAspectFill;
    photoView.clipsToBounds = YES;
    NSArray *array = [photoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf).insets(UIEdgeInsetsMake(0, padding, padding, padding)).priorityLow();
        make.top.equalTo(weakSelf.mas_top);
        make.left.equalTo(weakSelf.mas_left).offset(padding);
        make.right.equalTo(weakSelf.mas_right).offset(-padding);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-padding).priorityLow();
        make.height.mas_equalTo(200);
    }];
    
    [self.constraintsArray addObjectsFromArray:array];
}

- (void)constraints2To3 {
    WS(weakSelf);
    int edgePad = 10;
    int padding = 5;
    __block LXPhotoView *lastPhotoView = nil;
    
    for (int i = 0; i < 3; i++) {
        LXPhotoView *photoView = self.subviews[i];
        photoView.contentMode = UIViewContentModeScaleAspectFill;
        photoView.clipsToBounds = YES;
        
        NSArray *array = [photoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            //当是左边一列的时候
            if (i == 0) {
                make.left.equalTo(weakSelf.mas_left).offset(edgePad);
            }else {
                make.width.equalTo(lastPhotoView.mas_width);
                make.left.equalTo(lastPhotoView.mas_right).offset(padding);
            }
            
            if (i == 2) {
                make.right.equalTo(weakSelf.mas_right).offset(-edgePad);
            }
            
            make.top.equalTo(weakSelf.mas_top).offset(0);
            make.bottom.equalTo(weakSelf.mas_bottom).offset(-edgePad);
            make.height.equalTo(photoView.mas_width);
        }];
        
        lastPhotoView = photoView;
        [self.constraintsArray addObjectsFromArray:array];
    }
}

- (void)constraints4 {
    WS(weakSelf);
    int edgePad = 10;
    int padding = 5;
    __block LXPhotoView *lastPhotoView = nil;
    
    for (int i = 0; i < 4; i++) {
        LXPhotoView *photoView = self.subviews[i];
        photoView.contentMode = UIViewContentModeScaleAspectFill;
        photoView.clipsToBounds = YES;
        
        NSArray *array = [photoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            //当是左边一列的时候
            if (i%2 == 0) {
                make.left.equalTo(weakSelf.mas_left).offset(edgePad);
            }else {
                make.width.equalTo(lastPhotoView.mas_width);
                make.left.equalTo(lastPhotoView.mas_right).offset(padding);
            }
            
            // 最右边一列
            if (i % 2 == 1) {
                make.right.equalTo(weakSelf.mas_right).offset(-edgePad);
            }
            
            // 第一行
            if (i / 2 == 0) {
                make.top.equalTo(weakSelf.mas_top).offset(0);
            }else if (i / 2 == 1) { // 第二行
                make.top.equalTo(weakSelf.subviews[i % 2].mas_bottom).offset(padding);
                make.bottom.equalTo(weakSelf.mas_bottom).offset(-edgePad);
            }
            
            make.height.equalTo(photoView.mas_width);
        }];
        
        lastPhotoView = photoView;
        [self.constraintsArray addObjectsFromArray:array];
    }
}

- (void)constraints5To6 {
    WS(weakSelf);
    int edgePad = 10;
    int padding = 5;
    __block LXPhotoView *lastPhotoView = nil;
    
    for (int i = 0; i < 6; i++) {
        LXPhotoView *photoView = self.subviews[i];
        photoView.contentMode = UIViewContentModeScaleAspectFill;
        photoView.clipsToBounds = YES;
        
        NSArray *array = [photoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            //当是左边一列的时候
            if (i%3 == 0) {
                make.left.equalTo(weakSelf.mas_left).offset(edgePad);
            }else {
                make.width.equalTo(lastPhotoView.mas_width);
                make.left.equalTo(lastPhotoView.mas_right).offset(padding);
            }
            
            // 最右边一列
            if (i % 3 == 2) {
                make.right.equalTo(weakSelf.mas_right).offset(-edgePad);
            }
            
            // 第一行
            if (i / 3 == 0) {
                make.top.equalTo(weakSelf.mas_top).offset(0);
            }else if (i / 3 == 1) { // 第二行
                make.top.equalTo(weakSelf.subviews[i % 3].mas_bottom).offset(padding);
                make.bottom.equalTo(weakSelf.mas_bottom).offset(-edgePad);
            }
            
            make.height.equalTo(photoView.mas_width);
        }];
        
        lastPhotoView = photoView;
        [self.constraintsArray addObjectsFromArray:array];
    }
}

- (void)constraints7To9 {
    WS(weakSelf);
    int edgePad = 10;
    int padding = 5;
    __block LXPhotoView *lastPhotoView = nil;
    
    for (int i = 0; i < 9; i++) {
        LXPhotoView *photoView = self.subviews[i];
        photoView.contentMode = UIViewContentModeScaleAspectFill;
        photoView.clipsToBounds = YES;
        
        NSArray *array = [photoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            //当是左边一列的时候
            if (i%3 == 0) {
                make.left.equalTo(weakSelf.mas_left).offset(edgePad);
            }else {
                make.width.equalTo(lastPhotoView.mas_width);
                make.left.equalTo(lastPhotoView.mas_right).offset(padding);
            }
            
            // 最右边一列
            if (i % 3 == 2) {
                make.right.equalTo(weakSelf.mas_right).offset(-edgePad);
            }
            
            // 第一行
            if (i / 3 == 0) {
                make.top.equalTo(weakSelf.mas_top).offset(0);
            }else if (i / 3 == 1) { // 第二行
                make.top.equalTo(weakSelf.subviews[i % 3].mas_bottom).offset(padding);
            }else if (i / 3 == 2) { // 第三行
                make.top.equalTo(weakSelf.subviews[i - 3].mas_bottom).offset(padding);
                make.bottom.equalTo(weakSelf.mas_bottom).offset(-edgePad);
            }
            
            make.height.equalTo(photoView.mas_width);
        }];
        
        lastPhotoView = photoView;
        [self.constraintsArray addObjectsFromArray:array];
    }
}

@end
