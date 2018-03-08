//
//  LoginViewController.m
//  芥子帝国
//
//  Created by 纳里健康 on 2018/3/8.
//  Copyright © 2018年 songK. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "TabbarViewController.h"
#import "AppDelegate+function.h"


@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) IBOutlet UIView *registerBtn;
@property (strong, nonatomic) IBOutlet UIView *forgetBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.navigationController.navigationBarHidden = YES;
}

/**
 *  设置按钮颜色 边框
 */
-(void)setupUI
{

    [_loginBtn setBackgroundColor:TOPCAIL_COLOR];
    _loginBtn.showsTouchWhenHighlighted = YES;

    self.nameTF.delegate = self;

    self.pwdTF.delegate = self;

    //填写登陆数据
    NSString *loginId = [USER_DEFAULT objectForKey:DEFAULT_LoginId];
    if (loginId != nil) {
        _nameTF.text = loginId;
        NSString *pwd = [USER_DEFAULT objectForKey:DEFAULT_Pwd];
        _pwdTF.text = pwd;
    }

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
//    //登陆
//    [self cliclLogin:nil];

    return YES;
}
//
//
//#pragma mark -- BtnAction
///**
// * 登录
// */
- (IBAction)cliclLogin:(id)sender
{
    self.view.transform = CGAffineTransformIdentity;
    [_nameTF resignFirstResponder];
    [_pwdTF resignFirstResponder];

    NSString *loginId = _nameTF.text;
    NSString *pwd = _pwdTF.text;
    if (loginId.length != 11)
    {
        //  手机号错误提示
        if (loginId.length == 0)
        {
            [self showHint:@"请输入手机号" errorImage:nil];
        }
        else
        {
            [self showHint:@"请输入正确的手机号" errorImage:nil];
        }
        [_nameTF becomeFirstResponder];
        return;
    }
    // 密码错误提示
    if (pwd.length == 0)
    {
        [self showHint:@"请输入密码" errorImage:nil];
        [_pwdTF becomeFirstResponder];
        return;
    }
    //将用户输入的信息保存起来
    [USER_DEFAULT setValue:loginId forKey:DEFAULT_LoginId];
    [USER_DEFAULT setValue:pwd forKey:DEFAULT_Pwd];

    NSString *md5Pwd = [Public getMd5_32Bit:pwd];
    NSDictionary *bodyDic = @{@"uid":loginId,
                              @"pwd":md5Pwd,
                              @"rid":@"patient",
                              @"forAccessToken":[NSNumber numberWithBool:true]};

   
}


/**
 *  忘记密码
 */
- (IBAction)clickForgetBtn:(id)sender
{
    RegisterViewController *forgetPwdVc = [[RegisterViewController alloc] init];

    forgetPwdVc.type = forgetPwdViewController;

    [self.navigationController pushViewController:forgetPwdVc animated:YES];

}

/**
 *  注册
 */
- (IBAction)clickRegisterBtn:(id)sender {

    RegisterViewController *registerVC = [[RegisterViewController alloc] init];

    [self.navigationController pushViewController:registerVC animated:YES];
}

#pragma mark -- 取消登录
- (IBAction)cancleLogin:(id)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self.view endEditing:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSInteger length = textField == _nameTF ? 11 : 16;
    
    if (toBeString.length > length){
        textField.text = [toBeString substringToIndex:length];
        return NO;
        
    }
    return YES;
}

//
//- (void)dealloc
//{
//    [NS_NOTIFICATION_CENTER removeObserver:self name:kNotificationLogin object:nil];
//}



@end
