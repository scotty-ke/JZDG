//
//  UIViewController+Judge.m
//  NagriHealth
//
//  Created by 刘星辰 on 2016/10/25.
//  Copyright © 2016年 丁东. All rights reserved.
//

#import "UIViewController+Judge.h"


@implementation UIViewController (Judge)
//身份正则表达式
-(BOOL)idCardJude:(NSString*)string
{
    BOOL flag;
    if (string.length <= 0)
    {
        flag = NO;
        [self showHint:@"身份证号格式有误,请重新输入" errorImage:nil];
        return flag;
    }
    NSString *regex = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    if ([identityCardPredicate evaluateWithObject:string])
    {
        return YES;
    }
    else
    {
        [self showHint:@"身份证号格式有误,请重新输入" errorImage:nil];
        return NO;
    }
}

//姓名正则表达
-(BOOL)nameJude:(NSString*)string
{
    if (string.length < 1 || string.length >10)
    {
        if ([string isEqualToString:@""] || !string)
        {
            [self showHint:@"姓名不能为空" errorImage:nil];
        }
        else
        {
            [self  showHint:@"姓名不能超过10个字" errorImage:nil];
        }
        return NO;
    }
    else
    {
        NSString *regex = @"^[A-Za-z\u4e00-\u9fa5]*$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        if (![pred evaluateWithObject:string])
        {
            [self  showHint:@"姓名不能包含数字和特殊字符" errorImage:nil];
        }
        
        return [pred evaluateWithObject: string];
    }
}
/**
 *  手机号码验证
 *
 *  @param mobileNumbel 传入的手机号码
 *
 *  @return 格式正确返回true  错误 返回fals
 */
-(BOOL) isMobile:(NSString *)mobileNumbel{
    
    //屏蔽手机号的正则 只限制手机号位数为11位
//    /**
//     * 手机号码
//     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//     * 联通：130,131,132,152,155,156,185,186
//     * 电信：133,1349,153,180,189,181(增加)
//     */
//    NSString * MOBIL = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
//    /**
//     10         * 中国移动：China Mobile
//     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//     12         */
//    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
//    /**
//     15         * 中国联通：China Unicom
//     16         * 130,131,132,152,155,156,185,186
//     17         */
//    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
//    /**
//     20         * 中国电信：China Telecom
//     21         * 133,1349,153,180,189,181(增加)
//     22         */
//    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
//    
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
//    
//    if (([regextestmobile evaluateWithObject:mobileNumbel]
//         || [regextestcm evaluateWithObject:mobileNumbel]
//         || [regextestct evaluateWithObject:mobileNumbel]
//         || [regextestcu evaluateWithObject:mobileNumbel])) {
//        return YES;
//        
//    }
    
    if(mobileNumbel.length == 11)
    {
        return YES;
    }
    
    [self showHint:@"手机号码输入有误,请重新输入" errorImage:nil];
    return NO;
}

- (BOOL)isPositiveInteger:(NSString *)string{
    
    if (string.length != 0)
    {
        NSString *regex = @"^[0-9]+(.[0-9]{0,2})?$";
        
        //根据正则表达式将NSPredicate的格式设置好
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        
        //判断正则表达式能否正确匹配_textFiedld.text的内容
        BOOL isMatch = [pred evaluateWithObject:string];
        
        if (isMatch)
        {
            NSArray *numArr = [string componentsSeparatedByString:@"."];
            if ([(NSString *)[numArr firstObject] length] > 7)
            {
                isMatch = NO;
            }
            else if ([[string substringFromIndex:string.length - 1] isEqualToString:@"."])
            {
                isMatch = NO;
            }
        }
        else
        {

        }
        
        return isMatch;
        
    }
    else
    {
//        [self showHint:@"输入为空" errorImage:APP_Image_WorkError];
        return NO;
    }
}


#pragma mark 是否为纯数字
- (BOOL)isNum:(NSString *)string{
    if (string.length != 0)
    {
        NSString *regex = @"^[0-9]*$";
        
        //根据正则表达式将NSPredicate的格式设置好
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        
        //判断正则表达式能否正确匹配_textFiedld.text的内容
        BOOL isMatch = [pred evaluateWithObject:string];
        
        
        return isMatch;
        
    }
    else
    {
//        [self showHint:@"输入为空" errorImage:APP_Image_WorkError];
        return NO;
    }

}

#pragma mark 数字和字母混排
- (BOOL)isNumAndAlphabet:(NSString *)string
{
    if (string.length != 0)
    {
        NSString *regex = @"^[A-Za-z0-9]+$";
        
        //根据正则表达式将NSPredicate的格式设置好
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        
        //判断正则表达式能否正确匹配_textFiedld.text的内容
        BOOL isMatch = [pred evaluateWithObject:string];
        
        return isMatch;
        
    }
    else
    {
        
        return NO;
    }
    
}

@end
