//
//  QQPasswordInputView.m
//  
//
//  Created by quanqi on 16/5/16.
//  Copyright © 2016年 quanqi. All rights reserved.
//

#import "QQPasswordInputView.h"
#define DevGetColorFromHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


static CGFloat const kLSTextFieldKeyboardSpace = 10;

@interface QQPasswordInputView()<UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *pointArray;/**< 圆点数组*/
@property (nonatomic, assign) NSInteger pointCount;/**< 圆点数*/
@property (nonatomic, strong) UITextField *passwordTf ;/**< */

@end
@implementation QQPasswordInputView
- (id)initWithFrame:(CGRect)frame passwordLength:(NSInteger)length
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //初始化view
        [self initView:length];
        //注册监听
        [self initNotification];
    }
    return self;
}
//注册监听
- (void)initNotification
{
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note){
        
        if ([note.object isEqual:self.passwordTf])
        {
            //显示圆点的数量
            [self setPointWithCount:self.passwordTf.text.length];
            //输入密码位数=最长的密码位数
            if (self.passwordTf.text.length == self.pointCount)
            {
                if (self.inputFinishBlock) self.inputFinishBlock(self,self.passwordTf.text);
            }
        }
        
    }];
}

//初始化view
- (void)initView:(NSInteger)length
{
    //
    [self addTarget:self action:@selector(controlAction) forControlEvents:UIControlEventTouchUpInside];
    //边框的颜色
    UIColor *borColor = DevGetColorFromHex(0xbfbfbf);
    UIColor *lineColor = DevGetColorFromHex(0xdedede);
    self.pointCount = length;
    //边框线和圆角
    self.layer.cornerRadius = 3.0;
    self.layer.borderColor = borColor.CGColor;
    self.layer.borderWidth = 1.0;
    self.layer.masksToBounds = YES;
    //分隔线
    CGFloat width = CGRectGetWidth(self.frame)/length;
    for (NSInteger i = 0; i < (length-1); i ++ )
    {
        UIView *line = [[UIView alloc] init];
        line.frame = CGRectMake((i+1)*width, 0, 1, CGRectGetHeight(self.frame));
        line.backgroundColor = lineColor;
        line.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:line];
    }
    //密码圆点
    CGFloat pointWidth = 10.0;
    self.pointArray = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger j = 0; j < length; j ++)
    {
        UIView *point = [[UIView alloc] init];
        point.backgroundColor = DevGetColorFromHex(0x333333);
        point.frame = CGRectMake(0, 0, pointWidth, pointWidth);
        CGPoint pointCenter = CGPointMake((0.5 + j)*width, CGRectGetHeight(self.frame)*0.5);
        point.center = pointCenter;
        point.layer.cornerRadius = 5.0;
        point.layer.masksToBounds = YES;
        point.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
        point.hidden = YES;
        [self addSubview:point];
        [self.pointArray addObject:point];
    }
    //tf
    self.passwordTf = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    self.passwordTf.hidden = YES;
    self.passwordTf.delegate = self;
    self.passwordTf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordTf.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:self.passwordTf];
}
//设置键盘的UIKeyboardType
- (void)setInputViewReturnKeyType:(UIReturnKeyType)type
{
    self.passwordTf.returnKeyType = type;
}
//点击事件
- (void)controlAction
{
    if (self.passwordTf)
    {
        [self.passwordTf becomeFirstResponder];
    }
}
//设置显示点的个数
- (void)setPointWithCount:(NSInteger)count
{
    for (UIView *pointView in self.pointArray)
    {
        pointView.hidden = YES;
    }
    
    for (int i = 0; i< count; i++)
    {
        ((UIView*)[self.pointArray objectAtIndex:i]).hidden = NO;
    }
}
//改编输入框颜色
- (void)changeColor:(UIColor *)color
{
    self.layer.borderColor = color.CGColor;
}
//获取输入的密码
- (NSString *)getPassword
{
    return self.passwordTf.text;
}
//响应
- (void)inputViewBecomeFirstResponder
{
    if (self.passwordTf)
    {
        [self.passwordTf becomeFirstResponder];
    }
}
//取消响应
- (void)inputViewResignFirstResponder
{
    if (self.passwordTf)
    {
        [self.passwordTf resignFirstResponder];
    }
}
#pragma -mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.passwordTf)
    {
        //改变边框颜色
        [self changeColor:DevGetColorFromHex(0x33a1fd)];
        //回调
        if (self.delegate && [self.delegate respondsToSelector:@selector(inputViewBecomeFirstResponder:)])
        {
            [self.delegate inputViewBecomeFirstResponder:self];
        }
    }

}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.passwordTf)
    {
        //改变边框颜色
        [self changeColor:DevGetColorFromHex(0xbfbfbf)];
        //回调
        if (self.delegate && [self.delegate respondsToSelector:@selector(inputViewResignFirstResponder:)])
        {
            [self.delegate inputViewResignFirstResponder:self];
        }
    }

}
//键盘的return事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputViewReturn:)])
    {
        [self.delegate inputViewReturn:self];
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.passwordTf)
    {
        if([string isEqualToString:@"\n"])
        {
            //按回车关闭键盘
            [textField resignFirstResponder];
            return NO;
        }
        else if(string.length == 0)
        {
            //判断是不是删除键
            
            return YES;
        }
        else if(textField.text.length >= self.pointCount)
        {            
            //输入的字符个数大于等于密码限制的位数，则无法继续输入，返回NO表示禁止输入
            return NO;
        }
        else
        {
            return YES;
        }
    }else
    {
        return YES;
    }
    
}
@end
