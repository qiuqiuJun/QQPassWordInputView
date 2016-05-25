//
//  QQPasswordInputView.h
//
//
//  Created by quanqi on 16/5/16.
//  Copyright © 2016年 quanqi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol QQPasswordInputViewDelegate;

@interface QQPasswordInputView : UIControl

@property (nonatomic, weak) id<QQPasswordInputViewDelegate> delegate;;/**< */
@property (nonatomic, copy) void (^inputFinishBlock)(QQPasswordInputView *inputView,NSString *password);/**< 密码输入结束block*/
//初始化
- (id)initWithFrame:(CGRect)frame passwordLength:(NSInteger)length;
/**
 *  @author wqq, 16-05-16 10:05:16
 *
 *  @brief 手动响应键盘事件
 */
- (void)inputViewBecomeFirstResponder;
/**
 *  @author wqq, 16-05-16 10:05:37
 *
 *  @brief 手动取消键盘响应事件
 */
- (void)inputViewResignFirstResponder;
/**
 *  @author wqq, 16-05-16 17:05:45
 *
 *  @brief 获取输入的密码
 *
 *  @return 
 */
- (NSString *)getPassword;
/**
 *  @author wqq, 16-05-16 19:05:01
 *
 *  @brief 设置键盘的 UIKeyboardType
 *
 *  @param type
 */
- (void)setInputViewReturnKeyType:(UIReturnKeyType)type;
@end

@protocol QQPasswordInputViewDelegate <NSObject>

@optional
//开始响应
-(void)inputViewBecomeFirstResponder:(QQPasswordInputView *)inputView;
//取消响应
-(void)inputViewResignFirstResponder:(QQPasswordInputView *)inputView;
//键盘return事件
-(void)inputViewReturn:(QQPasswordInputView *)inputView;
@end