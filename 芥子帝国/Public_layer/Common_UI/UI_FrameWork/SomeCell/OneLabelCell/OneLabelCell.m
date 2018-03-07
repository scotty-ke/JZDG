//
//  OneLabelCell.m
//  easydoctor
//
//  Created by 刘星辰 on 2016/12/15.
//  Copyright © 2016年 easygroup. All rights reserved.
//

#import "OneLabelCell.h"
#import "Masonry.h"

@implementation OneLabelCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{

    
    [self setHidenLine:YES];
    
    
    self.detail =  [[UILabel alloc] init];
    self.detail.text = @" ";
    self.detail.textColor = TEXT_COLOR_1;
    self.detail.font = TEXT_FONT_15;
    self.detail.textAlignment = NSTextAlignmentLeft;
    self.detail.numberOfLines = 0;
    [self.bgView addSubview:self.detail];
    [self.detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(8);
        make.top.offset(8);
        make.right.mas_lessThanOrEqualTo(-8);
        make.bottom.offset(-8);
    }];

}


- (void)setDetailTop:(CGFloat)detailTop
{
    [self.detail mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.offset(detailTop);
    }];
}

- (void)setDetailLeft:(CGFloat)detailLeft
{
    _detailLeft = detailLeft;
    
    [self.detail mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.offset(detailLeft);
        if (_detailAligment == NSTextAlignmentCenter) {
            make.right.mas_offset(-detailLeft);
        } else {
            make.right.mas_lessThanOrEqualTo(-detailLeft);
        }
    }];
}

- (void)setDetailAligment:(NSTextAlignment)detailAligment {
    _detailAligment = detailAligment;
    _detailLeft = 8;
    switch (detailAligment) {
        case NSTextAlignmentLeft: {
            self.detail.textAlignment = detailAligment;
            [self setDetailLeft:_detailLeft];
            break;
        }
        case NSTextAlignmentCenter: {
            self.detail.textAlignment = detailAligment;
            [self.detail mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.offset(-_detailLeft);
            }];
            break;
        }
        case NSTextAlignmentRight: {
            self.detailAligment = detailAligment;
            [self.detail mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.offset(_detailLeft);
            }];
            break;
        }
        default:
            break;
    }
}

/**
 <#Description#>

 @param bottom <#bottom description#>
 */
- (void)setBottom:(CGFloat)bottom{
    [self.detail mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-bottom);
    }];
}


- (void)setTextColor:(UIColor *)textColor{
    self.detail.textColor = (textColor != nil)?(textColor):(TEXT_COLOR_1);
}

- (void)setTextFont:(UIFont *)font{
    self.detail.font = (font != nil)?(font):(TEXT_FONT_15);
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
