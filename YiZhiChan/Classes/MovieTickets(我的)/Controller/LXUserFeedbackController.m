//
//  LXUserFeedbackController.m
//  YiZhiChan
//
//  Created by wuyaju on 16/5/11.
//  Copyright © 2016年 吴亚举. All rights reserved.
//  用户反馈界面

#import "LXUserFeedbackController.h"
#import "Macros.h"
#import "Masonry.h"
#import "LXTextView.h"
#import "AFNetworking.h"

@interface LXUserFeedbackController () <UITextViewDelegate>

@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UIButton *submitBtn;
@property (nonatomic, strong)UIView *containerView;
@property (nonatomic, strong)LXTextView *curTextView;
@property (nonatomic, strong)LXTextView *adviceTextView;
@property (nonatomic, strong)LXTextView *contactTextView;

@end

@implementation LXUserFeedbackController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
    [self setupkeyBoardNotification];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupSubViews {
    WS(weakSelf);
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.bounces = YES;
    scrollView.backgroundColor = RGBA(237, 238, 240, 1);
    scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    UIView *containerView = [[UIView alloc] init];
    [scrollView addSubview:containerView];
    self.containerView = containerView;
    
    LXTextView *adviceTextView = [[LXTextView alloc] init];
    adviceTextView.placeholder = @"感谢您关注水煮娱电影，希望你能够多提意见，我们会用心改善！";
    adviceTextView.delegate = self;
    [containerView addSubview:adviceTextView];
    self.adviceTextView = adviceTextView;
    
    LXTextView *contactTextView = [[LXTextView alloc] init];
    contactTextView.placeholder = @"联系方式：邮箱";
    contactTextView.returnKeyType = UIReturnKeyDone;
    contactTextView.delegate = self;
    [containerView addSubview:contactTextView];
    self.contactTextView = contactTextView;
    
//    UITextField *contactTextField = [[UITextField alloc] init];
//    contactTextField.placeholder = @"联系方式：邮箱";
//    contactTextField.backgroundColor = [UIColor whiteColor];
//    contactTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    contactTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    [containerView addSubview:contactTextField];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    submitBtn.backgroundColor = LXYellowColor;
    submitBtn.layer.cornerRadius = 15;
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitClicked) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:submitBtn];
    self.submitBtn = submitBtn;
    
    // 添加约束
    int padding = 10;
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView.mas_width);
    }];
    
    [adviceTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(containerView).insets(UIEdgeInsetsMake(padding, padding, 0, padding));
        make.bottom.equalTo(contactTextView.mas_top).offset(-2*padding);
        make.height.mas_equalTo(200);
    }];
    
    [contactTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(containerView).insets(UIEdgeInsetsMake(0, padding, 0, padding));
        make.bottom.equalTo(submitBtn.mas_top).offset(-2*padding);
        make.height.mas_equalTo(40);
    }];
    
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(containerView).insets(UIEdgeInsetsMake(0, padding, 0, padding));
        make.height.mas_equalTo(50);
        make.bottom.equalTo(containerView.mas_bottom);
    }];
}

- (void)setupkeyBoardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)KeyboardWillShow:(NSNotification *)aNotification {
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    CGFloat offsetHeight = self.scrollView.frame.size.height - self.scrollView.contentSize.height;
    // submitBtn相对于view的坐标系
    CGFloat x = self.scrollView.frame.origin.x + self.submitBtn.frame.origin.x + self.scrollView.contentOffset.x;
    CGFloat y = self.scrollView.frame.origin.y + self.submitBtn.frame.origin.y - self.scrollView.contentOffset.y;
    CGRect submitFrame = CGRectMake(x, y, self.submitBtn.frame.size.width, self.submitBtn.frame.size.height);
    
    if (CGRectContainsRect(keyboardRect, submitFrame)) {
        CGFloat offsetY = submitFrame.origin.y - keyboardRect.origin.y;
        self.scrollView.contentInset = UIEdgeInsetsMake(64, 0, offsetHeight + offsetY + self.submitBtn.frame.size.height, 0);
        
        double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        [UIView animateWithDuration:duration animations:^{
            if (self.curTextView == self.contactTextView) {
                CGPoint offsetPoint = self.scrollView.contentOffset;
                offsetPoint.y += offsetY + self.submitBtn.frame.size.height;
                [self.scrollView setContentOffset:offsetPoint animated:NO];
            }
        }];
    }
    
    if (self.curTextView == self.adviceTextView) {
        [self.scrollView setContentOffset:CGPointMake(0, -64) animated:YES];
    }
}

- (void)KeyboardWillHide:(NSNotification *)aNotification {
    self.scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    [self.scrollView setContentOffset:CGPointMake(0, -64) animated:YES];
}

- (void)submitClicked {
    NSLog(@"CGRect %@", NSStringFromCGRect(self.scrollView.frame));
    NSLog(@"contentOffset %f", self.scrollView.contentOffset.y);
    NSLog(@"EdgeInsets %@", NSStringFromUIEdgeInsets(self.scrollView.contentInset));
    NSLog(@"self.submitBtn CGRect %@", NSStringFromCGRect(self.submitBtn.frame));
    NSLog(@"contentSize %@", NSStringFromCGSize(self.scrollView.contentSize));
    
    if (self.adviceTextView.text.length == 0) {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:@"您还没有填写意见" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertVc addAction:okAction];
        [self presentViewController:alertVc animated:YES completion:nil];
    }else {
        
        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
        [mgr.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        NSString *urlStr = [NSString stringWithFormat:@"%@/fishapi/api/Home/FeedBack", LXBaseUrl];
        NSString *value = [NSString stringWithFormat:@"{\"Content\": \"%@\", \"Email\": \"%@\"}", self.adviceTextView.text, self.contactTextView.text];
        NSDictionary *dic = [NSDictionary dictionaryWithObject:value forKey:@""];
        [mgr POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@", responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error.description);
        }];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UITextViewDelegate代理方法
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    self.curTextView = (LXTextView *)textView;
    return YES;
}

//- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
//    self.curTextView = nil;
//    return YES;
//}

@end
