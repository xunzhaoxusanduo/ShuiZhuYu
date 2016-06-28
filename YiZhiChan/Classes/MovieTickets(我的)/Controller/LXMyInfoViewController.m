//
//  LXMyInfoViewController.m
//  YiZhiChan
//
//  Created by wuyaju on 16/5/11.
//  Copyright © 2016年 吴亚举. All rights reserved.
//  我的信息界面

#import "LXMyInfoViewController.h"
#import "WebViewJavascriptBridge.h"
#import "Macros.h"

@implementation LXMyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.bridge registerHandler:@"handleUploadedPictureFromJS" handler:^(id data, WVJBResponseCallback responseCallback) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择头像" message:@"选择照片作为您的头像" preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *photoLibraryAction = [UIAlertAction actionWithTitle:@"选择相册照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alertController addAction:photoLibraryAction];
        [alertController addAction:cameraAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
    
    [self.bridge registerHandler:@"handleSaveMyInfoFromJS" handler:^(id data, WVJBResponseCallback responseCallback) {
        
    }];
    
    self.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/fashhtml/myData/baseMessage.html?navbarstyle=1", LXBaseUrl]];
}

@end
