//
//  IconTitleValueCell.m
//  NagriHealth
//
//  Created by 丁东 on 2016/10/17.
//  Copyright © 2016年 丁东. All rights reserved.
//

#import "IconTitleValueCell.h"

@implementation IconTitleValueCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.titleLabel.textColor = TEXT_COLOR_1;
    self.titleLabel.font = TEXT_FONT_15;
    
    self.valueLabel.textColor = TEXT_COLOR_3;
    self.valueLabel.font = TEXT_FONT_13;
    self.valueLabel.lineBreakMode = NSLineBreakByCharWrapping;
        
    self.line.backgroundColor = LINE_COLOR;
}

-(void)setValueText:(NSString*)value withCellWidth:(CGFloat)width
{
    self.valueLabel.text = value;
    
    [self layoutIfNeeded];
    
    [self.titleLabel sizeToFit];
    
    self.valueLabel.preferredMaxLayoutWidth = width - CGRectGetWidth(self.titleLabel.frame) - 11 - 7.5 - 8 - CGRectGetWidth(self.titleLabel.frame);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
