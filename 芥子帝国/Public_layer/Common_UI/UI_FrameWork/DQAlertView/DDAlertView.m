//
//  DDAlertView.m
//  NagriHealth
//
//  Created by 丁东 on 16/9/9.
//  Copyright © 2016年 丁东. All rights reserved.
//

#import "DDAlertView.h"

@interface DDAlertView()
{
    CGRect _oldAlertFrame;
    
    NSString *_phoneNumber;
}
@end

@implementation DDAlertView

-(instancetype)initWithTitle:(NSString *)title
                     message:(NSString *)message
             leftButtonTitle:(NSString *)leftButtonTitle
            rightButtonTitle:(NSString *)rightButtonTitle
                   leftBlock:(void (^)(void))leftBlock
                  rightBolck:(void (^)(void))rightBlock
{
    self = [super initWithTitle:title message:message cancelButtonTitle:leftButtonTitle otherButtonTitle:rightButtonTitle];
    if (self)
    {
        [self actionWithBlocksCancelButtonHandler:leftBlock
                               otherButtonHandler:rightBlock];
    }
    return self;
}

-(instancetype)initOneTextFieldWithTitle:(NSString *)title
                                 message:(NSString *)message
                         leftButtonTitle:(NSString *)leftButtonTitle
                        rightButtonTitle:(NSString *)rightButtonTitle
                               leftBlock:(__leftBlock)leftBlock
                              rightBolck:(__rightBlock)rightBlock{
    self = [super initWithTitle:title message:message cancelButtonTitle:leftButtonTitle otherButtonTitle:rightButtonTitle];
    if (self)
    {
        [self addTextFieldWithTitle:title message:message];
        [self actionWithBlocksCancelButtonHandler:leftBlock
                               otherButtonHandler:rightBlock];
        
    }
    return self;
    
}

- (void)addTextFieldWithTitle:(NSString *)title message:(NSString *)message{
    
    self.contentView = [self addSubViewForAlertType:oneTextField WithTitle:title message:message];
}

- (UIView *)addSubViewForAlertType:(alertViewType)type WithTitle:(NSString *)title message:(NSString *)message
{
    // 视图的宽 左边距
    CGFloat width = 270;
    CGFloat space = 15;

    UIView *contentView = [[UIView alloc] init];
    
    //title
    UILabel * titleLab =  [[UILabel alloc] init];
    titleLab.text = title;
    titleLab.font = TEXT_FONT_17;
    titleLab.textColor = [UIColor blackColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.numberOfLines = 0;
    
    //如果没有这个字符串的处理
    if ([title isEqualToString:@""]) {
        titleLab.frame = CGRectMake(0, 0, 0, 0);
    }else{
        CGFloat titleHeight = [Public countLabelHeightNoLineSpacing:title width:width - space*2 font:TEXT_FONT_17 minHeight:20];
        titleLab.frame = CGRectMake(space, 20, width - 20*2, titleHeight);
    }
    [contentView addSubview:titleLab];
    
    //message
    UILabel * messageLab =  [[UILabel alloc] init];
    messageLab.text = message;
    messageLab.font = TEXT_FONT_13;
    messageLab.textColor = [UIColor blackColor];
    messageLab.textAlignment = NSTextAlignmentCenter;
    
    //如果没有这个字符串的处理
    if ([message isEqualToString:@""]) {
        messageLab.frame = CGRectMake(0, 0, 0, 0);
    }else{
        CGFloat messageHeight = [Public countLabelHeightNoLineSpacing:message width:width - space*2 font:TEXT_FONT_13 minHeight:20];
        messageLab.frame = CGRectMake(space, CGRectGetMaxY(titleLab.frame) + 8, width - space*2, messageHeight);
    }
    messageLab.numberOfLines = 0;
    [contentView addSubview:messageLab];
    
    //文字输入框
    UITextField * textField = [[UITextField alloc]init];
    
    CGFloat textFieldW;
    if(type == oneTextField)
    {
        textFieldW = width - space * 2;
    }else
    {
        textFieldW = width - space * 2 - 110;
    }
    
    textField.frame = CGRectMake(space, CGRectGetMaxY(messageLab.frame) + 15, textFieldW, 30);
    textField.tintColor = [UIColor blueColor];
    textField.clearButtonMode = UITextFieldViewModeAlways;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.font = TEXT_FONT_13;
    textField.backgroundColor = [UIColor whiteColor];
    textField.secureTextEntry = NO; //密文输入
    textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 0)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.layer.borderWidth = 0.5;
    
    textField.layer.borderColor = [UIColor grayColor].CGColor;
    [contentView addSubview:textField];
    self.textField = textField;
    
    if(type == oneTextField)
    {
       contentView.frame = CGRectMake(0, 0, 270, CGRectGetMaxY(textField.frame) + 10);
    }else
    {
        //获取验证码按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(CGRectGetMaxX(textField.frame) + 10, CGRectGetMaxY(messageLab.frame) + 15, 100, 30);
        
        [button setTitle:@"获取验证码" forState:UIControlStateNormal];
        [button setBackgroundColor:TOPCAIL_COLOR];
        [button setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
        button.titleLabel.font = TEXT_FONT_15;
        [button addTarget:self action:@selector(GetCode) forControlEvents:UIControlEventTouchUpInside];
        [button setImageCircleWithImageWidth:5];
        _verifyBtn = button;
        [contentView addSubview:button];
        
        //提醒label
        UILabel *attentionLabel = [[UILabel alloc] init];
        NSString *attention = [NSString stringWithFormat:@"注：手机验证码将发送至您在医院记录中的手机号%@,如手机号变动，请前往医院进行修改",_phoneNumber];
        attentionLabel.text = attention;
        CGFloat attentionH = [Public countLabelHeightNoLineSpacing:attention width:width - space*2 font:TEXT_FONT_11 minHeight:20];
        attentionLabel.frame = CGRectMake(space, CGRectGetMaxY(textField.frame) + 8, width - space*2, attentionH);
        attentionLabel.numberOfLines = 0;
        attentionLabel.font = TEXT_FONT_11;
        attentionLabel.textColor = TEXT_COLOR_ORANGE;
        [contentView addSubview:attentionLabel];
        
        
        contentView.frame = CGRectMake(0, 0, 270, CGRectGetMaxY(attentionLabel.frame) + 10);
    }
    
    
    [NS_NOTIFICATION_CENTER addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [NS_NOTIFICATION_CENTER  addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];

    return contentView;
}



#pragma mark -- 
#pragma mark -- 带获取验证码功能的alertView
- (instancetype)initTextFieldAndButtonWithTitleTitle:(NSString *)title
                                             message:(NSString *)message
                                         phoneNumber:(NSString *)phoneNumber
                                     leftButtonTitle:(NSString *)leftButtonTitle
                                    rightButtonTitle:(NSString *)rightButtonTitle
                                           leftBlock:(__leftBlock)leftBlock
                                          rightBolck:(__rightBlock)rightBlock
{
    self = [super initWithTitle:title message:message cancelButtonTitle:leftButtonTitle otherButtonTitle:rightButtonTitle];
    if (self)
    {
        _phoneNumber = phoneNumber;
        
        self.contentView = [self addSubViewForAlertType:textFieldAndBtn WithTitle:title message:message];
        [self actionWithBlocksCancelButtonHandler:leftBlock
                               otherButtonHandler:rightBlock];
        
        [self GetCode];
    }
    return self;
}

- (void)GetCode
{
    [self setVerifybtnStatus:2];
    
    second = 60;
    
    _verifyTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateVerify:) userInfo:nil repeats:YES];
    
    //来获取验证码的网络请求
    if([self.codeDelegate respondsToSelector:@selector(getAlertCode)])
    {
        [self.codeDelegate getAlertCode];
    }
}

- (void)setVerifybtnStatus:(NSInteger)status
{
    if (status == 1) {
        _verifyBtn.enabled = YES;
        _verifyBtn.userInteractionEnabled = YES;
        [_verifyBtn setBackgroundColor:TOPCAIL_COLOR];
        [_verifyBtn setTitle:@"重新发送" forState:UIControlStateNormal];
    }else{
        _verifyBtn.enabled = NO;
        _verifyBtn.userInteractionEnabled = NO;
        [_verifyBtn setBackgroundColor:GRAY_UN_SELECTED];
    }
}

#pragma mark  更新验证码BTN
- (void)updateVerify:(NSTimer *)timer
{
    second--;
    if (second == 0) {
        [timer invalidate];
        [self setVerifybtnStatus:1];
    }else{
        _verifyBtn.enabled = NO;
        [_verifyBtn setTitle:[NSString stringWithFormat:@"(%d)重新获取",second] forState:UIControlStateNormal];
    }
}




- (void)show{
    [super show];
    //键盘通知
    _oldAlertFrame = self.frame;
    
    [self.textField becomeFirstResponder];
    
}

- (void)dismiss{
    
    [super dismiss];
    [_verifyTimer invalidate];
    _verifyTimer = nil;
    
    [self endEditing:YES];
}


//显示键盘
- (void)keyBoardShow:(NSNotification *)notification{
    NSValue *endFrameValue = notification.userInfo[UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect;
    [endFrameValue getValue:&keyboardRect];
    
    self.transform = CGAffineTransformMakeTranslation(0, -[self returnHeightWith:keyboardRect]);
        
    
}

//隐藏键盘
- (void)keyboardHide:(NSNotification *)notification{
    NSValue *endFrameValue = notification.userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect endFrame;
    [endFrameValue getValue:&endFrame];
    
    self.transform = CGAffineTransformTranslate(self.transform, 0, [self returnHeightWith:endFrame]);
}

//键盘高
- (CGFloat)returnHeightWith:(CGRect)keyboardRect{
    
    CGFloat height;
    CGFloat alertY = _oldAlertFrame.origin.y + _oldAlertFrame.size.height;
    CGFloat keyBoardY = SCREEN_HEIGHT - keyboardRect.size.height;
    if (alertY < keyBoardY) {
        height = 40;
    }else{
        height = alertY - keyBoardY + 8;
    }
    return height;
}

- (void)dealloc{
    [NS_NOTIFICATION_CENTER removeObserver:self];
    NSLog(@"delloc - %@",NSStringFromClass([self class]));
}

@end
