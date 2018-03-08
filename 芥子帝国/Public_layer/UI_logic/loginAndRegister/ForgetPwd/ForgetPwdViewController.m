//
//  ForgetPwdViewController.m
//  芥子帝国
//
//  Created by 纳里健康 on 2018/3/8.
//  Copyright © 2018年 songK. All rights reserved.
//

#import "ForgetPwdViewController.h"
#import "UIViewController+Judge.h"
#import "setPwdViewController.h"

@interface ForgetPwdViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *vertifyTF;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (strong, nonatomic) IBOutlet UIButton *vertifyBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation ForgetPwdViewController
{
    NSTimer *_verifyTimer;
    
    int second;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (void)setupUI
{
    self.title = @"忘记密码";
    
    _nameTF.delegate = self;
    _vertifyTF.delegate = self;
    
    _vertifyBtn.showsTouchWhenHighlighted = YES;
    _nextBtn.showsTouchWhenHighlighted = YES;
    _nextBtn.backgroundColor = TOPCAIL_COLOR;
    
    //倒计时按钮边框
    _vertifyBtn.layer.borderWidth = 1.0f;
    _vertifyBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _vertifyBtn.layer.cornerRadius = 5.0f;
    _vertifyBtn.layer.masksToBounds = YES;
    
    
    
}

#pragma mark testFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSInteger length;
    
    if (textField == _nameTF)
    {
        length = 11;
    }else if(textField == _vertifyTF)
    {
        length = 4;
    }else
    {
        length = 20;
    }
    
    if (toBeString.length > length){
        textField.text = [toBeString substringToIndex:length];
        return NO;
    }
    return YES;
}


- (IBAction)getVertifyCode:(id)sender {
    
    NSString *mobile = _nameTF.text;
    if (![Public isNotBlankString:mobile]) {
        [self showHint:@"请填写手机号" errorImage:APP_Image_WorkError];
        return;
    }
    if (mobile.length != 11) {
        [self showHint:@"手机号格式错误" errorImage:APP_Image_WorkError];
        return;
    }
    
    if([self isMobile:mobile])
    {
        [_vertifyTF becomeFirstResponder];
        
        [self setVerifybtnStatus:2];
        
        second = 60;
        
        _verifyTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateVerify:) userInfo:nil repeats:YES];
        
//        [self sendRegisterCode];
    }

}

- (void)setVerifybtnStatus:(NSInteger)status
{
    if (status == 1) {
        _vertifyBtn.enabled = YES;
        _vertifyBtn.userInteractionEnabled = YES;
        [_vertifyBtn setTitle:@"重新发送" forState:UIControlStateNormal];
    }else{
        _vertifyBtn.enabled = NO;
        _vertifyBtn.userInteractionEnabled = NO;
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
        _vertifyBtn.enabled = NO;
        [_vertifyBtn setTitle:[NSString stringWithFormat:@"(%ds)",second] forState:UIControlStateNormal];
    }
}



- (IBAction)nextStep:(id)sender {
    NSLog(@"开始下一步");
        
    if(_nameTF.text.length > 0 && _vertifyTF.text.length == 4)
    {
        setPwdViewController *setPwdVC = [[setPwdViewController alloc] init];
        
        [self.navigationController pushViewController:setPwdVC animated:YES];

    }else if (_vertifyTF.text.length < 4)
    {
        [self showHint:@"验证码格式错误"];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
