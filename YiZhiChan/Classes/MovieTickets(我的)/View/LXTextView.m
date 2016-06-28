//
//  LXTextView.m
//  YiZhiChan
//
//  Created by wuyaju on 16/5/11.
//  Copyright © 2016年 吴亚举. All rights reserved.
//

#import "LXTextView.h"
#import "Masonry.h"

static UIEdgeInsets const kPadding = {10, 10, 0, 10};

@interface LXTextView ()

@property (nonatomic, weak) UILabel *placeholderLabel;

@end

@implementation LXTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.添加提示文字
        UILabel *placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.textColor = [UIColor lightGrayColor];
        placeholderLabel.hidden = YES;
        placeholderLabel.numberOfLines = 0;
        placeholderLabel.backgroundColor = [UIColor clearColor];
        placeholderLabel.font = self.font;
        [self insertSubview:placeholderLabel atIndex:0];
        self.placeholderLabel = placeholderLabel;
        
        [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self).insets(kPadding);
        }];
        
        // 2.监听textView文字改变的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidBeginBegin) name:UITextViewTextDidBeginEditingNotification object:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidEndBegin) name:UITextViewTextDidEndEditingNotification object:self];
    }
    return self;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    
    self.placeholderLabel.text = placeholder;
    if (placeholder.length) { // 需要显示
        self.placeholderLabel.hidden = NO;
        
    } else {
        self.placeholderLabel.hidden = YES;
    }
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    self.placeholderLabel.textColor = placeholderColor;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    self.placeholderLabel.font = font;
    self.placeholder = self.placeholder;
}

//- (void)textDidChange
//{
//    self.placeholderLabel.hidden = (self.text.length != 0);
//}

- (void)textDidBeginBegin {
    self.placeholderLabel.hidden = YES;
}

- (void)textDidEndBegin {
    if (self.text.length == 0) {
        self.placeholderLabel.hidden = NO;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.placeholderLabel.preferredMaxLayoutWidth = self.frame.size.width - kPadding.left - kPadding.right;
    
    [super layoutSubviews];
}

@end
