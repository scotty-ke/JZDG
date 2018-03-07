//
//  LxcStyleModel.h
//  easydoctor
//
//  Created by 刘星辰 on 2016/12/22.
//  Copyright © 2016年 easygroup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LxcStyleModel : NSObject

@property (nonatomic,strong)UIColor *textColor;//文本颜色

@property (nonatomic,strong)UIFont *font;

@property (nonatomic,strong)NSString *text;//文字


+ (instancetype)CSSWithText:(NSString *)text color:(UIColor *)color font:(UIFont *)font;

@end
