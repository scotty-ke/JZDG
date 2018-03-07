//
//  OneLabelCell.h
//  easydoctor
//
//  Created by 刘星辰 on 2016/12/15.
//  Copyright © 2016年 easygroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormDetailsCell.h"

@interface OneLabelCell : FormDetailsCell

//默认值 8
@property (nonatomic,assign)CGFloat detailLeft;//title 的左边距
@property (nonatomic,assign)CGFloat detailTop;//title 的上边距
@property (nonatomic,assign)CGFloat bottom;//detail 的下边距

@property (strong, nonatomic)  UILabel *detail;
@property (nonatomic, assign) NSTextAlignment detailAligment; //detail对齐方式，默认NSTextAlignmentLeft;

/**
 设置文本颜色

 @param textColor 传入nil的话就是用的默认
 */
- (void)setTextColor:(UIColor *)textColor;

/**
 设置文本大小
 
 @param textColor 传入nil的话就是用的默认
 */
- (void)setTextFont:(UIFont *)font;





@end
