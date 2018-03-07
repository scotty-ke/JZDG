//
//  UIViewController+Judge.h
//  NagriHealth
//
//  Created by 刘星辰 on 2016/10/25.
//  Copyright © 2016年 丁东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Judge)

/**
 身份证正则表达式
 
 @param string 要判断的身份证号
 
 @return 是 或 否
 */
-(BOOL)idCardJude:(NSString*)string;


/**
 姓名正则表达式
 
 @param string 要判断的字符串
 
 @return 是 或 否
 */
-(BOOL)nameJude:(NSString*)string;


/**
 电话号码正则表达式
 
 @param mobileNumbel 要判断的手机号
 
 @return 是 或 否
 */
-(BOOL) isMobile:(NSString *)mobileNumbel;


/**
 正整数正则表达式

 @param string 要判断的字符串
 @return 是 或 否
 */
- (BOOL)isPositiveInteger:(NSString *)string;



/**
 数字表达式

 @param string 字符串
 @return 是 或 否
 */
- (BOOL)isNum:(NSString *)string;


/**
 数字和字母混排

 @param string 目标字符串
 @return 是 或 否
 */
- (BOOL)isNumAndAlphabet:(NSString *)string;

@end
