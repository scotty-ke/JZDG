//
//  LabelTextFieldCell.h
//  easydoctor
//
//  Created by 刘星辰 on 2016/12/29.
//  Copyright © 2016年 easygroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormDetailsCell.h"
#import "DDTextField.h"

@protocol LabelTextFieldCellDelegate <NSObject>
// 具体方法
- (void)edittingTextField:(UITableViewCell *)cell textField:(UITextField *)textField;
- (void)beginTextField:(UITableViewCell *)cell textField:(UITextField *)textField;
- (void)endTextField:(UITableViewCell *)cell textField:(UITextField *)textField;

@end

@interface LabelTextFieldCell : FormDetailsCell<UITextFieldDelegate>

@property (nonatomic,strong)UILabel *title;//上面的文字

@property (nonatomic,strong) DDTextField *textField;//下面的文本输入框

@property (nonatomic,weak) id<LabelTextFieldCellDelegate> delegate;


/**
 设置文本文字

 @param text 文字
 */
- (void)titleLabText:(NSString *)text;


/**
 设置文本的字体和颜色

 @param font 字体
 @param color 颜色
 */
- (void)titleLabFont:(UIFont *)font textColor:(UIColor *)color;


/**
 输入框的 提示语

 @param placeholder 文字
 */
- (void)setPlaceholder:(NSString *)placeholder;


/**
 设置文字的的最大字符限制

 @param maxNum 数字
 */
- (void)setTextFieldMaxNum:(NSInteger)maxNum;


/**
 输入框的 字体 和 文字颜色

 @param font 字体
 @param color 颜色
 */
- (void)textFieldFont:(UIFont *)font textColor:(UIColor *)color;


/**
 更新约束

 @param left label的左边距 默认8
 @param top 上边距 默认8
 */
- (void)titleLabLeft:(CGFloat)left top:(CGFloat)top;


/**
 更新约束

 @param right 右边距
 */
- (void)textFieldRight:(CGFloat)right;


/**
 更新约束

 @param space 文本和输入的间距
 */
- (void)titleAndTextfieldSpace:(CGFloat)space;

/**
 激活文本输入
 */
- (void)activeField;

@end
