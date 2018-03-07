//
//  LabelTextFieldCell.m
//  easydoctor
//
//  Created by 刘星辰 on 2016/12/29.
//  Copyright © 2016年 easygroup. All rights reserved.
//

#import "LabelTextFieldCell.h"
#import "Masonry.h"


@implementation LabelTextFieldCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setUI];
}

- (void)setUI{
    
    self.title =  [[UILabel alloc] init];
    self.title.font = TEXT_FONT_15;
    self.title.textColor = TEXT_COLOR_1;
    self.title.textAlignment = NSTextAlignmentLeft;
    self.title.numberOfLines = 1;
    [self.bgView addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(8);
        make.top.offset(8);
        make.width.offset(95);
        make.centerY.equalTo(self.bgView);
    }];
    
    //
    self.textField = [[DDTextField alloc]init];
    self.textField.maxNum = 15;
    self.textField.delegate = self;
    self.textField.font = TEXT_FONT_15;
    self.textField.tintColor = TOPCAIL_COLOR;
    self.textField.textColor = TEXT_COLOR_3;
    self.textField.placeholder = @""; //空白提示
    self.textField.text = @"";
    self.textField.secureTextEntry = NO; //密文输入
    self.textField.textAlignment = NSTextAlignmentRight;
    self.textField.returnKeyType = UIReturnKeyGo;//键盘的return效果
    [self.textField sizeToFit];
    [self.bgView addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title.mas_right).offset(8);
        make.top.offset(0);
        make.bottom.offset(0);
//        make.size.mas_equalTo(self.textField.size);
        make.right.offset(-8);
    }];
    
    [self.textField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
}

//-------------文本代理----------------

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if ([self.delegate respondsToSelector:@selector(beginTextField:textField:)]) {
        [self.delegate beginTextField:self textField:self.textField];
    }
    
}

- (void)textFieldDidChange{
    if ([self.delegate respondsToSelector:@selector(edittingTextField:textField:)]) {
        [self.delegate edittingTextField:self textField:self.textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([self.delegate respondsToSelector:@selector(endTextField:textField:)]) {
        [self.delegate endTextField:self textField:self.textField];
    }
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//
//    return YES;
//}

//------------- end ----------------

/**
 设置文本文字
 
 @param text 文字
 */
- (void)titleLabText:(NSString *)text{
    if ([Public isNotBlankString:text]) {
        self.title.text = text;
    }
    else{
        self.title.text = @" ";
    }
}


/**
 设置文本的字体和颜色
 
 @param font 字体
 @param color 颜色
 */
- (void)titleLabFont:(UIFont *)font textColor:(UIColor *)color{
    self.title.font = (font == nil)?(TEXT_FONT_15):(font);
    self.title.textColor = (color == nil)?(TEXT_COLOR_3):(color);
}


/**
 输入框的 提示语
 
 @param placeholder 文字
 */
- (void)setPlaceholder:(NSString *)placeholder{
    
    self.textField.placeholder = (placeholder)?(placeholder):(@" ");
}


/**
 设置文字的的最大字符限制
 
 @param maxNum 数字
 */
- (void)setTextFieldMaxNum:(NSInteger)maxNum{
    self.textField.maxNum = maxNum;
}


/**
 输入框的 字体 和 文字颜色
 
 @param font 字体
 @param color 颜色
 */
- (void)textFieldFont:(UIFont *)font textColor:(UIColor *)color{
    self.textField.font = (font == nil)?(TEXT_FONT_15):(font);
    self.textField.textColor = (color == nil)?(TEXT_COLOR_3):(color);
}


/**
 更新约束
 
 @param left label的左边距 默认8
 @param top 上边距 默认8
 */
- (void)titleLabLeft:(CGFloat)left top:(CGFloat)top{
    [self.title mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.offset(left);
        make.top.offset(top);
    }];
}

- (void)textFieldRight:(CGFloat)right{
    [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-right);
    }];
}

- (void)titleAndTextfieldSpace:(CGFloat)space{
    [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title.mas_right).offset(space);
    }];
}


- (void)activeField
{
    [self.textField becomeFirstResponder];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc{
    [NS_NOTIFICATION_CENTER removeObserver:self];
}

@end
