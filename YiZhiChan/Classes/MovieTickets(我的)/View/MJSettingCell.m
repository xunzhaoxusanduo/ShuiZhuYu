//
//  MJSettingCell.m
//  00-ItcastLottery
//
//  Created by apple on 14-4-17.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MJSettingCell.h"
#import "MJSettingItem.h"
#import "MJSettingSwitchItem.h"
#import "MJSettingArrowItem.h"
#import "MJSettingLabelItem.h"
#import "Macros.h"
#import "LXClearCache.h"
#import "LXClearCacheItem.h"

@interface MJSettingCell()
/**
 *  箭头
 */
@property (nonatomic, strong) UIImageView *arrowView;
/**
 *  开关
 */
@property (nonatomic, strong) UISwitch *switchView;
/**
 *  标签
 */
@property (nonatomic, strong) UILabel *labelView;

@property (nonatomic, weak) UIView *divider;
@end

@implementation MJSettingCell

- (UIImageView *)arrowView
{
    if (_arrowView == nil) {
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"more"]];
    }
    return _arrowView;
}

- (UISwitch *)switchView
{
    if (_switchView == nil) {
        _switchView = [[UISwitch alloc] init];
        _switchView.onTintColor = LXYellowColor;
        [_switchView addTarget:self action:@selector(switchStateChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 初始化操作
        
        // 1.初始化背景
        [self setupBg];
        
        // 2.初始化子控件
        [self setupSubviews];
        
        // 3.初始化分割线
//        if (!iOS7) {
//            [self setupDivider];
//        }
    }
    return self;
}

/**
 *  初始化子控件
 */
- (void)setupSubviews
{
//    self.textLabel.backgroundColor = [UIColor clearColor];
//    self.detailTextLabel.backgroundColor = [UIColor clearColor];
}

/**
 *  初始化背景
 */
- (void)setupBg
{
    // 设置普通背景
//    UIView *bg = [[UIView alloc] init];
//    bg.backgroundColor = [UIColor whiteColor];
//    self.backgroundView = bg;
    
    // 设置选中时的背景
//    UIView *selectedBg = [[UIView alloc] init];
////    selectedBg.backgroundColor = MJColor(237, 233, 218);
//    self.selectedBackgroundView = selectedBg;
}

/**
 *  初始化分割线
 */
- (void)setupDivider
{
    UIView *divider = [[UIView alloc] init];
    divider.backgroundColor = [UIColor blackColor];
    divider.alpha = 0.2;
    [self.contentView addSubview:divider];
    self.divider = divider;
}

/**
 *  监听开关状态改变
 */
- (void)switchStateChange:(UISwitch *)aSwitch
{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
////    if (self.item.key) {
//    [defaults setBool:self.switchView.isOn forKey:self.item.title];
//    [defaults synchronize];
////    }
    
    if ([self.delegate respondsToSelector:@selector(settingCellSwitchStateChange: MJSettingItem:)]) {
        [self.delegate settingCellSwitchStateChange:aSwitch MJSettingItem:self.item];
    }
}

- (UILabel *)labelView
{
    if (_labelView == nil) {
        _labelView = [[UILabel alloc] init];
        _labelView.bounds = CGRectMake(0, 0, 100, 30);
        _labelView.backgroundColor = [UIColor redColor];
    }
    return _labelView;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"setting";
    MJSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MJSettingCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

/**
 *  拦截frame的设置
 */
- (void)setFrame:(CGRect)frame
{
//    if (!iOS7) {
//        CGFloat padding = 10;
//        frame.size.width += padding * 2;
//        frame.origin.x = -padding;
//    }
    [super setFrame:frame];
}

/**
 *  设置子控件的frame
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    if (iOS7) return;
//    
//    // 设置分割线的frame
//    CGFloat dividerH = 1;
//    CGFloat dividerW = [UIScreen mainScreen].bounds.size.width;
//    CGFloat dividerX = 0;
//    CGFloat dividerY = self.contentView.frame.size.height - dividerH;
//    self.divider.frame = CGRectMake(dividerX, dividerY, dividerW, dividerH);
}

- (void)setItem:(MJSettingItem *)item
{
    _item = item;
    
    // 1.设置数据
    [self setupData];
    
    // 2.设置右边的内容
    [self setupRightContent];
}

- (void)setLastRowInSection:(BOOL)lastRowInSection
{
    _lastRowInSection = lastRowInSection;
    
    self.divider.hidden = lastRowInSection;
}

/**
 *  设置右边的内容
 */
- (void)setupRightContent
{
    if ([self.item isKindOfClass:[MJSettingArrowItem class]]) { // 箭头
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    } else if ([self.item isKindOfClass:[MJSettingSwitchItem class]]) { // 开关
        self.accessoryView = self.switchView;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 设置开关的状态
        MJSettingSwitchItem *switchItem = (MJSettingSwitchItem *)self.item;
        if (switchItem.state != nil) {
            switchItem.state(self.switchView);
        }
    } else if ([self.item isKindOfClass:[MJSettingLabelItem class]]) { // 标签
        self.accessoryView = self.labelView;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    } else if ([self.item isKindOfClass:[LXClearCacheItem class]]) { // 清除缓存
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    } else {
        self.accessoryView = nil;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
}

/**
 *  设置数据
 */
- (void)setupData
{
    if (self.item.icon) {
        self.imageView.image = [UIImage imageNamed:self.item.icon];
    }
    self.textLabel.text = self.item.title;
    if ([self.item isKindOfClass:[LXClearCacheItem class]]) { // 标签
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
            double size = [LXClearCache sizeWithFilePath:cachePath];
            NSString *sizeText = [NSString stringWithFormat:@"%.1fMB", size / 1024 / 1024];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.detailTextLabel.text = sizeText;
            });
        });

    }else {
        self.detailTextLabel.text = self.item.subtitle;
    }
}

@end
