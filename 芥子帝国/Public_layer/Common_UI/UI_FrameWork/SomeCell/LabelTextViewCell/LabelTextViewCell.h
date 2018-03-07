//
//  LabelTextViewCell.h
//  easydoctor
//
//  Created by 刘星辰 on 2016/12/22.
//  Copyright © 2016年 easygroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormDetailsCell.h"
#import "GCPlaceholderTextView.h"


@protocol LabelTextViewCellDelegate <NSObject>

// 具体方法
- (void)edittingTextView:(UITableViewCell *)cell textView:(UITextView *)textView;
- (void)beginTextView:(UITableViewCell *)cell textView:(UITextView *)textView;
- (void)endTextView:(UITableViewCell *)cell textView:(UITextView *)textView;
@end

@interface LabelTextViewCell : FormDetailsCell<UITextViewDelegate>

@property (nonatomic,strong)UILabel *title;//上面的文字

@property (nonatomic,strong) GCPlaceholderTextView *textView;//下面的文本输入框

@property (nonatomic,weak) id<LabelTextViewCellDelegate> delegate;

/**
 设置title的文字颜色

 @param textColor 传nil为默认颜色
 */
- (void)setTitleTextColor:(UIColor *)textColor;


/**
 设置textview的文字颜色

 @param textColor 传nil为默认颜色
 */
- (void)setTextViewTextColor:(UIColor *)textColor;


/**
 设置title的字体

 @param font 传nil为默认字体
 */
- (void)setTitleFont:(UIFont *)font;

/**
 设置textview的字体
 
 @param font 传nil为默认字体
 */
- (void)setTextViewFont:(UIFont *)font;


/**
 设置title的左 上距离

 @param left 默认为 16
 @param top 默认为 8
 */
- (void)setTitleLeft:(CGFloat)left andTop:(CGFloat)top;


/**
 设置textview的提示

 @param text 文本
 */
- (void)setPlaceholder:(NSString *)text;


/**
  设置textview的高

 @param height 高
 */
- (void)setTextViewHeight:(CGFloat)height;


/**
 设置textview的的左右边距

 @param space 间距
 */
- (void)setTextViewLeftAndRight:(CGFloat)space;

/**
 隐藏title

 @param hidden 隐藏
 */
- (void)hiddenTitle:(BOOL)hidden;


/**
 设置TextView最大字符限制

 @param num 数字
 */
- (void)setTextViewMaxNum:(NSInteger)num;

/**
 激活输入的方法
 */
- (void)activeField;

@end
