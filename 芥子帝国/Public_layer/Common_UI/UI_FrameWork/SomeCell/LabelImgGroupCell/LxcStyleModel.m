//
//  LxcStyleModel.m
//  easydoctor
//
//  Created by 刘星辰 on 2016/12/22.
//  Copyright © 2016年 easygroup. All rights reserved.
//

#import "LxcStyleModel.h"

@implementation LxcStyleModel


- (instancetype)initWithText:(NSString *)text color:(UIColor *)color font:(UIFont *)font {
   self = [super init];
    if (self)
    {
        
        self.textColor = (color != nil)?(color):(TEXT_COLOR_1);
        self.font = (font != nil)?(font):(TEXT_FONT_15);
        self.text = (text != nil)?(text):(@"1");
    }
    return self;
}

+ (instancetype)CSSWithText:(NSString *)text color:(UIColor *)color font:(UIFont *)font
{
    return [[LxcStyleModel alloc] initWithText:text color:color font:font];
}


@end
