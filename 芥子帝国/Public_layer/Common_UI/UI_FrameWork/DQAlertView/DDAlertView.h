//
//  DDAlertView.h
//  NagriHealth
//
//  Created by 丁东 on 16/9/9.
//  Copyright © 2016年 丁东. All rights reserved.
//

#import "DQAlertView.h"

typedef enum : NSUInteger {
    oneTextField,
    textFieldAndBtn,
}alertViewType;

@protocol DDAlertGetCodeDelegate <NSObject>

- (void)getAlertCode;

@end


typedef void(^__leftBlock)(void);
typedef void(^__rightBlock)(void);

static int second;

@interface DDAlertView : DQAlertView

@property (nonatomic,copy)__leftBlock leftBlock;
@property (nonatomic,copy)__rightBlock rightBlock;
//2月8号 宋柯修改 添加获取验证码的alertView
@property (nonatomic,assign)alertViewType Type;
@property (nonatomic,strong)NSTimer *verifyTimer;

@property (nonatomic,assign)id<DDAlertGetCodeDelegate> codeDelegate;


@property (nonatomic,strong)UIButton *verifyBtn;//获取验证码的按钮
@property (nonatomic,strong)UITextField *textField;//文本框

-(instancetype)initWithTitle:(NSString *)title
                     message:(NSString *)message
             leftButtonTitle:(NSString *)leftButtonTitle
            rightButtonTitle:(NSString *)rightButtonTitle
                   leftBlock:(void (^)(void))leftBlock
                  rightBolck:(void (^)(void))rightBlock;

/**
 *  自带一个输入框
 *
 *  @param title            <#title description#>
 *  @param message          <#message description#>
 *  @param leftButtonTitle  <#leftButtonTitle description#>
 *  @param rightButtonTitle <#rightButtonTitle description#>
 *  @param leftBlock        <#leftBlock description#>
 *  @param rightBlock       <#rightBlock description#>
 *
 *  @return <#return value description#>
 */
-(instancetype)initOneTextFieldWithTitle:(NSString *)title
                                 message:(NSString *)message
                         leftButtonTitle:(NSString *)leftButtonTitle
                        rightButtonTitle:(NSString *)rightButtonTitle
                               leftBlock:(__leftBlock)leftBlock
                              rightBolck:(__rightBlock)rightBlock;



/**
 带输入框 按钮 描述

 @param title <#title description#>
 @param message <#message description#>
 @param detail <#detail description#>
 @param leftButtonTitle <#leftButtonTitle description#>
 @param rightButtonTitle <#rightButtonTitle description#>
 @param leftBlock <#leftBlock description#>
 @param rightBlock <#rightBlock description#>
 @return <#return value description#>
 */
- (instancetype)initTextFieldAndButtonWithTitleTitle:(NSString *)title
                                             message:(NSString *)message
                                         phoneNumber:(NSString *)phoneNumber
                                     leftButtonTitle:(NSString *)leftButtonTitle
                                    rightButtonTitle:(NSString *)rightButtonTitle
                                           leftBlock:(__leftBlock)leftBlock
                                          rightBolck:(__rightBlock)rightBlock;

@end
