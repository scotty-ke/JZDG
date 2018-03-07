//
//  DoubleLabelCell.m
//  easydoctor
//
//  Created by 刘星辰 on 2016/12/13.
//  Copyright © 2016年 easygroup. All rights reserved.
//

#import "DoubleLabelCell.h"
#import "Masonry.h"

@implementation DoubleLabelCell

- (instancetype )initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    
    //
    self.title =  [[UILabel alloc] init];
    self.title.font = TEXT_FONT_15;
    self.title.textColor = TEXT_COLOR_3;
    self.title.textAlignment = NSTextAlignmentLeft;
    self.title.numberOfLines = 1;
    [self.bgView addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(8);
        make.top.offset(8);
        make.bottom.mas_lessThanOrEqualTo(-8);
        make.width.offset(95);
    }];
    
    
    //
    self.detail =  [[UILabel alloc] init];
    self.detail.text = @" ";
    self.detail.font = TEXT_FONT_15;
    self.detail.textColor = TEXT_COLOR_1;
    self.detail.textAlignment = NSTextAlignmentLeft;
    self.detail.numberOfLines = 2;
    [self.bgView addSubview:self.detail];
    [self.detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title.mas_right).offset(15);
        make.top.equalTo(self.title);
        make.right.offset(-8);
        make.bottom.offset(-8);
    }];

}




//设置两个文字的间的距离
- (void)setTextSpace:(CGFloat)textSpace{
    [self.detail mas_updateConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(self.title.mas_right).offset(textSpace);
    }];
}





- (void)setTop:(CGFloat)top andBottom:(CGFloat)bottom{
    
    [self.title mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.offset(top);
        make.bottom.mas_lessThanOrEqualTo(-bottom);
    }];
    [self.detail mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-bottom);
    }];
}



// 设置文本的颜色
- (void)textColor:(UIColor *)leftColor andRight:(UIColor *)rightColor{
    self.title.textColor = (leftColor)?(leftColor):(TEXT_COLOR_3);
    self.detail.textColor = (rightColor)?(rightColor):(TEXT_COLOR_1);
}


- (void)setTitle:(NSString *)title andDetail:(NSString *)detail{
    self.title.text = title;
    self.detail.text = ([Public isNotBlankString:detail])?(detail):(@" ");
}

- (void)setTitleLeft:(CGFloat)left DetailRight:(CGFloat)right
{
    [self.title mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.offset(left);
    }];
    [self.detail mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-right);
    }];
}

- (void)setTitleFont:(UIFont *)titleFont detailFont:(UIFont *)detailFont{
    self.title.font = (titleFont)?(titleFont):(TEXT_FONT_15);
    self.detail.font = (detailFont)?(detailFont):(TEXT_FONT_15);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
