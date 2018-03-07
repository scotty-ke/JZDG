//
//  CommonChartCell.m
//  NagriHealth
//
//  Created by 丁东 on 16/8/29.
//  Copyright © 2016年 丁东. All rights reserved.
//

#import "CommonChartCell.h"

@implementation CommonChartCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self layoutIfNeeded];

    self.titleLabel.textColor = TEXT_COLOR_1;
    self.titleLabel.font = TEXT_FONT_15;
    
    self.contentLabel.textColor = TEXT_COLOR_3;
    self.contentLabel.font = TEXT_FONT_13;
    
    self.line.backgroundColor = LINE_COLOR;
}


-(void)setContentText:(id)text
{
    if ([text isKindOfClass:[NSString class]])
    {
        self.contentLabel.text = text;
    }
    else
    {
        self.contentLabel.attributedText = text;
    }
}


-(void)hiddenArrow
{
    self.arrowIcon.hidden = YES;
    
    self.leftMargin.constant = 8;
}

-(void)showArrow
{
    self.arrowIcon.hidden = NO;

    self.leftMargin.constant = 19;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
