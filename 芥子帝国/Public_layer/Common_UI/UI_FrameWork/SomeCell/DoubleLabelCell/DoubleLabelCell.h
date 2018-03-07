//
//  DoubleLabelCell.h
//  easydoctor
//
//  Created by 刘星辰 on 2016/12/13.
//  Copyright © 2016年 easygroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormDetailsCell.h"

@interface DoubleLabelCell : FormDetailsCell

//默认值 15
@property (nonatomic,assign)CGFloat textSpace;//两个文本间的距离

@property (strong, nonatomic)  UILabel *title;
@property (strong, nonatomic)  UILabel *detail;



/**
 设置cell的文字

 @param title 左
 @param detail 右
 */
- (void)setTitle:(NSString *)title andDetail:(NSString *)detail;


/**
 设置cell中文本的上和下边距

 @param top 上
 @param bottom 下
 */
- (void)setTop:(CGFloat)top andBottom:(CGFloat)bottom;


/**
 设置文本的颜色
 
 传nil 就 使用父类默认的颜色值
 
 @param leftColor 左颜色
 @param rightColor 右颜色
 */
- (void)textColor:(UIColor *)leftColor andRight:(UIColor *)rightColor;



/**
 设置title的左边距  detail的右边距

 @param left 左边距
 @param right 右边距
 */
- (void)setTitleLeft:(CGFloat)left DetailRight:(CGFloat)right;


/**
 设置title的左字体  detail的右字体

 @param titleFont 左字体
 @param detailFont 右字体
 */
- (void)setTitleFont:(UIFont *)titleFont detailFont:(UIFont *)detailFont;


@end
