//
//  MJSettingViewController.m
//  00-ItcastLottery
//
//  Created by apple on 14-4-17.
//  Copyright (c) 2014年 itcast. All rights reserved.
//  我的设置界面

#import "LXSettingViewController.h"
#import "MJSettingArrowItem.h"
#import "MJSettingSwitchItem.h"
#import "MJSettingLabelItem.h"
#import "LXClearCacheItem.h"
#import "MJSettingGroup.h"
#import "MBProgressHUD+MJ.h"
#import "UINavigationBar+Extend.h"
#import "Macros.h"
#import "LXUserFeedbackController.h"
#import "LXClearCache.h"
#import "LXWebViewController.h"
#import "LXCookie.h"
#import "LXUserInfo.h"
#import "UMessage.h"
#import "MBProgressHUD+MJ.h"
#import "LXPushTool.h"

@interface LXSettingViewController () <UIImagePickerControllerDelegate>

@property (nonatomic, strong)UIButton *logoutBtn;

@end

@implementation LXSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1.标题
    self.title = @"设置";
    
    // 3、添加gfootView
    [self setupLogoutBtn];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
}

- (void)viewWillAppear:(BOOL)animated {
    // 2.添加数据
    [self setupGroup];
    
    NSLog(@"设置界面viewWillAppear");
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:NavBarBackgroundColour];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self.tableView reloadData];
    
    if ([[LXUserInfo user] isLogin]) {
        self.logoutBtn.hidden = NO;
    }else {
        self.logoutBtn.hidden = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"设置界面viewDidAppear");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"设置界面viewWillDisappear");
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"设置界面viewDidDisappear");
}

#pragma mark -  私有方法

- (void)setupGroup
{
    [self.data removeAllObjects];
    
    MJSettingItem *systemNotification = [MJSettingSwitchItem itemWithIcon:nil title:@"系统通知"];
    MJSettingSwitchItem *systemNotificationSwitchItem = (MJSettingSwitchItem *)systemNotification;
    systemNotificationSwitchItem.state = ^(UISwitch *aSwitch) {
        // 能进入这个界面，可以保证键值对肯定存在
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        aSwitch.on = [[defaults objectForKey:LXSystemNotificationItemKey] boolValue];
    };
    
    MJSettingItem *movieNotification = [MJSettingSwitchItem itemWithIcon:nil title:@"影讯通知"];
    MJSettingSwitchItem *movieNotificationSwitchItem = (MJSettingSwitchItem *)movieNotification;
    movieNotificationSwitchItem.state = ^(UISwitch *aSwitch) {
        // 能进入这个界面，可以保证键值对肯定存在
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        aSwitch.on = [[defaults objectForKey:LXMovieNotificationItemKey] boolValue];
    };
    
    MJSettingItem *lowMode = [MJSettingSwitchItem itemWithIcon:nil title:@"低流量模式"];
    
    MJSettingGroup *group0 = [[MJSettingGroup alloc] init];
    // 如果登陆，则显示被赞提醒/评论回复提醒，否则不显示
    if ([[LXUserInfo user] isLogin]) {
        MJSettingItem *attitude = [MJSettingSwitchItem itemWithIcon:nil title:@"被赞提醒"];
        MJSettingSwitchItem *attitudeSwitchItem = (MJSettingSwitchItem *)attitude;
        attitudeSwitchItem.state = ^(UISwitch *aSwitch) {
            // 能进入这个界面，可以保证键值对肯定存在
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            aSwitch.on = [[defaults objectForKey:LXAttitudeItemKey] boolValue];
        };
        
        MJSettingItem *comment = [MJSettingSwitchItem itemWithIcon:nil title:@"评论回复提醒"];
        MJSettingSwitchItem *commentSwitchItem = (MJSettingSwitchItem *)comment;
        commentSwitchItem.state = ^(UISwitch *aSwitch) {
            // 能进入这个界面，可以保证键值对肯定存在
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            aSwitch.on = [[defaults objectForKey:LXCommentItemKey] boolValue];
        };
        
        group0.items = @[attitude, comment, systemNotification, movieNotification, lowMode];
    }else {
        group0.items = @[systemNotification, movieNotification, lowMode];
    }
    
    [self.data addObject:group0];
    
    MJSettingItem *userFeedback = [MJSettingArrowItem itemWithIcon:nil title:@"用户反馈" destVcClass:[LXUserFeedbackController class] isNeedLogin:NO];
    MJSettingItem *wipeCache = [LXClearCacheItem itemWithIcon:nil title:@"清空缓存"];
    wipeCache.option = ^{
        [self clearCache];
    };
    
    MJSettingItem *about = [MJSettingArrowItem itemWithIcon:nil title:@"关于水煮娱" destVcClass:[LXWebViewController class] isNeedLogin:NO
                                                     urlStr:[NSString stringWithFormat:@"%@/fashhtml/aboutUs.html?navbarstyle=1", LXBaseUrl]];
    MJSettingItem *resetPassword = [MJSettingArrowItem itemWithIcon:nil title:@"重置密码" destVcClass:[LXWebViewController class] isNeedLogin:YES
                                                             urlStr:[NSString stringWithFormat:@"%@/fashhtml/form/amendPassword.html?navbarstyle=1", LXBaseUrl]];
    
    MJSettingGroup *group1 = [[MJSettingGroup alloc] init];
    group1.items = @[userFeedback, wipeCache, about, resetPassword];
    [self.data addObject:group1];
}

- (void)setupLogoutBtn {
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    logoutBtn.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
    [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    logoutBtn.backgroundColor = [UIColor whiteColor];
    [logoutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    self.logoutBtn = logoutBtn;
//    [bgView addSubview:logoutBtn];
    self.tableView.tableFooterView = logoutBtn;
}

- (void)logout {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定要退出吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [LXCookie removeLoginSession];
        NSNumber *userId = [LXUserInfo user].userId;
        [[NSNotificationCenter defaultCenter] postNotificationName:LXWebViewLogoutSuccessNotification object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:userId, @"userId", nil]];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)clearCache {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定清除缓存吗？" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [MBProgressHUD showMessage:@"清理缓存"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
            [LXClearCache clearCachesFromDirectoryPath:cachePath];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
                [MBProgressHUD showSuccess:@"清理成功"];
                [self.tableView reloadData];
            });
        });
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark - UITableViewDelegate代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

#pragma mark - UIImagePickerControllerDelegate代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    NSString *imageBase64 = [imageData base64EncodedStringWithOptions:0];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MJSettingCellDelegate代理方法
- (void)settingCellSwitchStateChange:(UISwitch *)aSwitch MJSettingItem:(MJSettingItem *)item {
    if ([item.title isEqualToString:@"被赞提醒"]) {
        // 设置别名
        [self switchAlias:aSwitch type:LXMessageAliasTypePraise key:LXAttitudeItemKey];
    }else if ([item.title isEqualToString:@"评论回复提醒"]) {
        // 设置别名
        [self switchAlias:aSwitch type:LXMessageAliasTypeComment key:LXCommentItemKey];
    }else if ([item.title isEqualToString:@"系统通知"]) {
        // 设置别名
        [self switchAlias:aSwitch type:LXMessageAliasTypeSystem key:LXSystemNotificationItemKey];
        // 设置Tag
        [self switchTag:aSwitch tagName:LXMessageTagTypeSystem key:LXSystemNotificationItemKey];
    }else if ([item.title isEqualToString:@"影讯通知"]) {
        // 设置别名
        [self switchAlias:aSwitch type:LXMessageAliasTypeFilmNews key:LXMovieNotificationItemKey];
        // 设置Tag
        [self switchTag:aSwitch tagName:LXMessageTagTypeFilmNews key:LXMovieNotificationItemKey];
    }
}

/**
 *  切换远程推送别名
 *
 *  @param aSwitch   UISwitch控件
 *  @param aliasName 别名名字
 *  @param type      别名类型
 *  @param key       保存当前推送状态的Key
 */
- (void)switchAlias:(UISwitch *)aSwitch type:(NSString * __nonnull)type key:(NSString * __nonnull)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL curState = [[defaults objectForKey:key] boolValue];
    
    // 当前接收通知
    if (curState) {
        [LXPushTool removeAlias:aSwitch type:type key:key];
    } else { // 当前不接收通知
        [LXPushTool setAlias:aSwitch type:type key:key];
    }
}

/**
 *  切换远程推送Tag
 *
 *  @param aSwitch UISwitch控件
 *  @param tagName Tag名字
 *  @param key     保存当前推送状态的Key
 */
- (void)switchTag:(UISwitch *)aSwitch tagName:(NSString *)tagName key:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    BOOL curState = [[defaults objectForKey:key] boolValue];
    // 当前接收通知
    if (curState) {
        [LXPushTool removeTag:aSwitch tagName:tagName key:key];
    }else { // 当前不接收通知
        [LXPushTool setTag:aSwitch tagName:tagName key:key];
    }
}

//    about.option = ^{
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择头像" message:@"选择照片作为您的头像" preferredStyle:UIAlertControllerStyleActionSheet];
//
//        UIAlertAction *photoLibraryAction = [UIAlertAction actionWithTitle:@"选择相册照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//            if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
//                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//                imagePicker.sourceType = sourceType;
//                imagePicker.delegate = self;
//                imagePicker.allowsEditing = YES;
//                [self presentViewController:imagePicker animated:YES completion:nil];
//            }
//        }];
//
//        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
//            if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
//                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//                imagePicker.sourceType = sourceType;
//                imagePicker.delegate = self;
//                imagePicker.allowsEditing = YES;
//                [self presentViewController:imagePicker animated:YES completion:nil];
//            }
//        }];
//
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            [self dismissViewControllerAnimated:YES completion:nil];
//        }];
//
//        [alertController addAction:photoLibraryAction];
//        [alertController addAction:cameraAction];
//        [alertController addAction:cancelAction];
//        [self presentViewController:alertController animated:YES completion:nil];
//    };
//    about.option = ^{
//        [MBProgressHUD showMessage:@"正在拷贝"];
//        NSString *srcPath = [[NSBundle mainBundle] pathForResource:@"shuizhuyu.bundle" ofType:nil];
//        NSString *toPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
//        NSString *dstPath=[toPath stringByAppendingPathComponent:@"123"];
//        NSLog(@"%@", srcPath);
//        NSLog(@"%@", toPath);
//        NSError *error;
//        [[NSFileManager defaultManager] copyItemAtPath:srcPath toPath:dstPath error:&error];
//        NSLog(@"%@", error);
//        [MBProgressHUD hideHUD];
//        [MBProgressHUD showMessage:@"拷贝完成"];
//        [MBProgressHUD hideHUD];
//        [self.tableView reloadData];
//    };

@end