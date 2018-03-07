//
//  LabelTextViewCell.m
//  easydoctor
//
//  Created by 刘星辰 on 2016/12/22.
//  Copyright © 2016年 easygroup. All rights reserved.
//

#import "LabelTextViewCell.h"
#import "Masonry.h"
@interface LabelTextViewCell()
{
    CGFloat _x;
    NSInteger _maxNum;//最大字符限制
}
@end
@implementation LabelTextViewCell

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

    _x = 13;
    
    
    _maxNum = 150;
    
    self.title =  [[UILabel alloc] init];
    self.title.text = @" ";
    self.title.font = TEXT_FONT_15;
    self.title.textColor = TEXT_COLOR_3;
    self.title.textAlignment = NSTextAlignmentLeft;
    self.title.numberOfLines = 0;
    [self.bgView addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(_x);
        make.top.offset(8);
        make.right.mas_lessThanOrEqualTo(-_x);
    }];
    
    //<#UITextField#>
    self.textView = [[GCPlaceholderTextView alloc] init];
    self.textView.delegate = self;
    self.textView.placeholder = @" ";
    self.textView.font = TEXT_FONT_13;
    self.textView.textColor = TEXT_COLOR_3;
    self.textView.layer.borderWidth = 0.5;
    self.textView.layer.borderColor = TEXT_COLOR_4.CGColor;
    self.textView.layer.cornerRadius = 5;
    
    [self.bgView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title.mas_left);
        make.top.equalTo(self.title.mas_bottom).offset(8).priorityHigh();
        make.right.offset(-_x);
        make.height.offset(140);
        make.bottom.offset(-8);
    }];
    

}


// ------------------- 设置方法 ---------------------

- (void)setTextViewHeight:(CGFloat)height{
     [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
         make.height.offset(height);
     }];
}

- (void)setTitleTextColor:(UIColor *)textColor{
    if (textColor != nil)
    {
        self.title.textColor = textColor;
    }
    else
    {
        self.title.textColor = TEXT_COLOR_3;
    }
}

- (void)setTextViewTextColor:(UIColor *)textColor{
    if (textColor != nil)
    {
        self.textView.textColor = textColor;
    }
    else
    {
        self.textView.textColor = TEXT_COLOR_3;
    }
}

- (void)setTitleFont:(UIFont *)font{
    if (font != nil)
    {
        self.title.font = font;
    }
    else
    {
        self.title.font = TEXT_FONT_15;
    }
}

/**
 设置textview的字体
 
 @param font 传nil为默认字体
 */
- (void)setTextViewFont:(UIFont *)font{
    if (font != nil)
    {
        self.textView.font = font;
    }
    else
    {
        self.textView.font = TEXT_FONT_15;
    }
}


/**
 设置title的左 上距离
 
 @param left 默认为 8
 @param top 默认为 8
 */
- (void)setTitleLeft:(CGFloat)left andTop:(CGFloat)top{
    _x = left;
    [self.title mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.offset(_x);
        make.top.offset(top);
        make.right.mas_lessThanOrEqualTo(-_x);
    }];
}

- (void)setPlaceholder:(NSString *)text{
    self.textView.placeholder = text;
}

- (void)setBgViewLeft:(CGFloat)left andRight:(CGFloat)right{
    [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.offset(left);
        make.right.offset(-right);
    }];
}

- (void)setTextViewLeftAndRight:(CGFloat)space{
    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.offset(space);
        make.right.offset(-space);
    }];
}

- (void)hiddenTitle:(BOOL)hidden{
    if (hidden)
    {
        self.title.hidden = YES;
        [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.title.mas_top).offset(0).priorityHigh();
        }];
    }
    else
    {
        self.title.hidden = NO;
        [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.title.mas_bottom).offset(8).priorityHigh();
        }];
    }
    [self.textView updateConstraints];
    [self.bgView updateConstraints];
}

- (void)setTextViewMaxNum:(NSInteger)num{
    _maxNum = num;
}

// ------------------- end ---------------------


// ------------------- 代理 ---------------------
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(beginTextView:textView:)]) {
        [self.delegate beginTextView:self textView:self.textView];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position)
    {
        if (textView.text.length > _maxNum )
        {
            textView.text = [textView.text substringToIndex:_maxNum];
        }
        
    }
    if ([self.delegate respondsToSelector:@selector(edittingTextView:textView:)]) {
        [self.delegate edittingTextView:self textView:self.textView];
    }
}

//回车的处理方法
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(endTextView:textView:)]) {
        [self.delegate endTextView:self textView:self.textView];
    }
}


// ------------------- end ---------------------


- (void)activeField
{
    [self.textView becomeFirstResponder];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
