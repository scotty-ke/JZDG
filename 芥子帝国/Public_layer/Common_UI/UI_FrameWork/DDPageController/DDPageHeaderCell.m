//
//  DDPageHeaderCell.m
//  easydoctor
//
//  Created by 丁东 on 15/11/16.
//  Copyright © 2015年 easygroup. All rights reserved.
//

#import "DDPageHeaderCell.h"

@implementation DDPageHeaderCell

- (void)awakeFromNib {
    self.nameLabel.textColor = self.config.nomalColor;
    self.nameLabel.font = self.config.nomalFont;
    self.backgroundColor = self.config.backColor;
}

@end
