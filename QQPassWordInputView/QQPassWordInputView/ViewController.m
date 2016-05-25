//
//  ViewController.m
//  QQPasswordInputView
//
//  Created by quanqi on 16/5/25.
//  Copyright © 2016年 quanqi. All rights reserved.
//

#import "ViewController.h"
#import "QQPasswordInputView.h"

@interface ViewController ()<QQPasswordInputViewDelegate>

@property (nonatomic, strong) QQPasswordInputView *inputView;/**< */

@end

@implementation ViewController
- (void)dealloc
{
    self.inputView.delegate = nil;
    self.inputView = nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //密码输入框
    __weak ViewController *weakSelf = self;
    
    self.inputView = [[QQPasswordInputView alloc] initWithFrame:CGRectMake(13, 50, CGRectGetWidth(self.view.frame)-13*2, 45) passwordLength:6];
    self.inputView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.inputView.inputFinishBlock = ^(QQPasswordInputView *inputView,NSString *password)
    {
        [weakSelf inputFinishBlock:inputView password:password];
    };
    //设置键盘的return键（默认是数字键盘，没有return，但是第三方键盘如：搜狗，是有return键的）
    [self.inputView setInputViewReturnKeyType:UIReturnKeyDone];
    self.inputView.delegate = self;
    [self.view addSubview:self.inputView];
    
    //弹出键盘
    UIButton *showKeyboard = [UIButton buttonWithType:UIButtonTypeCustom];
    showKeyboard.frame = CGRectMake(13, CGRectGetMaxY(self.inputView.frame)+30, 80, 30);
    showKeyboard.backgroundColor = [UIColor lightGrayColor];
    [showKeyboard setTitle:@"弹出键盘" forState:UIControlStateNormal];
    [showKeyboard setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    showKeyboard.titleLabel.font = [UIFont systemFontOfSize:15];
    [showKeyboard addTarget:self action:@selector(showKeyboardAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showKeyboard];
    //取消键盘
    UIButton *hideKeyboard = [UIButton buttonWithType:UIButtonTypeCustom];
    hideKeyboard.frame = CGRectMake(CGRectGetWidth(self.view.frame)-13-80, CGRectGetMaxY(self.inputView.frame)+30, 80, 30);
    hideKeyboard.backgroundColor = [UIColor lightGrayColor];
    [hideKeyboard setTitle:@"隐藏键盘" forState:UIControlStateNormal];
    [hideKeyboard setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    hideKeyboard.titleLabel.font = [UIFont systemFontOfSize:15];
    [hideKeyboard addTarget:self action:@selector(hideKeyboardAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hideKeyboard];
    
}
//密码输入到达最大位数后，block回调
- (void)inputFinishBlock:(QQPasswordInputView *)inputView password:(NSString *)password
{
    NSLog(@"password===%@",password);
}
#pragma -mark QQPasswordInputViewDelegate
-(void)inputViewReturn:(QQPasswordInputView *)inputView
{
    NSLog(@"password===%@",[inputView getPassword]);
}
//显示键盘
-(void)showKeyboardAction
{
    [self.inputView inputViewBecomeFirstResponder];
}
//隐藏键盘
-(void)hideKeyboardAction
{
    [self.inputView inputViewResignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
