//
//  ImageTextCell.m
//  easydoctor
//
//  Created by 刘星辰 on 2016/12/15.
//  Copyright © 2016年 easygroup. All rights reserved.
//

#import "ImageTextCell.h"
#import "Masonry.h"

@interface ImageTextCell()
{
    CGFloat _x;
}

@end

@implementation ImageTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    _x = 8.0000f;
    
    self.detail =  [[UILabel alloc] init];
    self.detail.text = @" ";
    self.detail.textColor = TEXT_COLOR_1;
    self.detail.font = TEXT_FONT_15;
    self.detail.textAlignment = NSTextAlignmentLeft;
    self.detail.numberOfLines = 3;
    [self.bgView addSubview:self.detail];
    [self.detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(_x);
        make.top.offset(8);
        make.right.mas_lessThanOrEqualTo(-_x);
    }];
    
    
    self.imgContainer = [[UIView alloc] init];
    self.imgContainer.backgroundColor = [UIColor clearColor];
    self.imgContainer.clipsToBounds = YES;
    [self.bgView addSubview:self.imgContainer];
    [self.imgContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.detail.mas_left);
        make.top.equalTo(self.detail.mas_bottom).offset(8).priorityHigh(99);
        make.right.equalTo(self.bgView.mas_right).offset(-_x);
        make.bottom.offset(0);
    }];
    
    //全文按钮
    self.fullText = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.fullText setTitle:@"全文" forState:UIControlStateNormal];
    self.fullText.titleLabel.font = self.detail.font;
    [self.fullText setTitleColor:TOPCAIL_COLOR forState:UIControlStateNormal];
    [self.fullText addTarget:self action:@selector(showOrHideText:) forControlEvents:UIControlEventTouchUpInside];
    [self.fullText sizeToFit];
    self.fullText.hidden = YES;
    self.fullText.selected = NO;
    [self.bgView addSubview:self.fullText];
    [self.fullText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.detail);
        make.top.equalTo(self.detail.mas_bottom);
        make.size.mas_equalTo(self.fullText.size);
    }];
    
}

//图片点击的回调
- (void)imageViewClick:(UITapGestureRecognizer *)tap{
    UIView *view = tap.view;
    if ([self.delegate respondsToSelector:@selector(jumpToPhotoPhotoBrowserPage:)]) {
        [self.delegate jumpToPhotoPhotoBrowserPage:view.tag - 999];
    }
}


- (void)setDetailTop:(CGFloat)top{
    
    [self.detail mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.offset(top);
    }];
    
}

- (void)setDetailLeft:(CGFloat )left{
    _x = left;
    [self.detail mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.offset(left);
    }];
}
#pragma mark 全文显示
- (void)showOrHideText:(UIButton *)btn{
    
    self.fullText.selected = YES;
    self.detail.numberOfLines = 0;
    
    if (_showOrHide)
    {
        _showOrHide(btn);
    }
    
}
#pragma mark 当前文字的行数
- (CGFloat)lineNum{
    NSNumber *count = @([self textHeight] / self.detail.font.lineHeight);
    NSInteger lines = [count integerValue];
    return lines;
}

- (CGFloat)textHeight{
    return [self heightForString:self.detail.text font:self.detail.font andWidth:SCREEN_WIDTH - _x * 2];
}

//获得字符串的高度
-(float) heightForString:(NSString *)value font:(UIFont*)font andWidth:(float)width
{
    NSDictionary *fontAttributesDict = @{NSFontAttributeName:font};
    CGRect sizeToFit = [value boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:fontAttributesDict context:nil];
    
    return sizeToFit.size.height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
