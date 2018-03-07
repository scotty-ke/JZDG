//
//  LoginViewController.m
//  NagriHealth
//
//  Created by 纳里健康 on 16/8/22.
//  Copyright © 2016年 丁东. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
//#import "TabbarViewController.h"
//#import "AppDelegate+function.h"
//#import "CurrentArea.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self setupUI];
    
    //登录通知
//    [NS_NOTIFICATION_CENTER addObserver:self selector:@selector(loginNotification:) name:kNotificationLogin object:nil];
}
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//
//    self.navigationController.navigationBarHidden = YES;
//}
//
///**
// *  设置按钮颜色 边框
// */
//-(void)setupUI
//{
//
//    [_loginBtn setBackgroundColor:TOPCAIL_COLOR];
//    _loginBtn.showsTouchWhenHighlighted = YES;
//    [_loginBtn.layer setMasksToBounds:YES];
//    [_loginBtn.layer setCornerRadius:5.0];
//
//
//    [_registerBtn setTitleColor:TOPCAIL_COLOR forState:UIControlStateNormal];
//    _registerBtn.layer.borderColor = TOPCAIL_COLOR.CGColor;
//    _registerBtn.layer.borderWidth = 0.5f;
//    [_registerBtn.layer setMasksToBounds:YES];
//    [_registerBtn.layer setCornerRadius:5.0];
//
//    [_forgetBtn setTitleColor:TOPCAIL_COLOR forState:UIControlStateNormal];
//
//    self.nameTF.delegate = self;
//
//    self.pwdTF.delegate = self;
//
//    //填写登陆数据
//    NSString *loginId = [USER_DEFAULT objectForKey:DEFAULT_LoginId];
//    if (loginId != nil) {
//        _nameTF.text = loginId;
//        NSString *pwd = [USER_DEFAULT objectForKey:DEFAULT_Pwd];
//        _pwdTF.text = pwd;
//    }
//
//}
//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    if (CGAffineTransformIsIdentity(self.view.transform) == NO) {
//        self.view.transform = CGAffineTransformIdentity;
//    }
//    [_nameTF resignFirstResponder];
//    [_pwdTF resignFirstResponder];
//
//    //登陆
//    [self cliclLogin:nil];
//
//    return YES;
//}
//
//
//#pragma mark -- BtnAction
///**
// * 登录
// */
//- (IBAction)cliclLogin:(id)sender
//{
//
//    self.view.transform = CGAffineTransformIdentity;
//    [_nameTF resignFirstResponder];
//    [_pwdTF resignFirstResponder];
//
//    NSString *loginId = _nameTF.text;
//    NSString *pwd = _pwdTF.text;
//    if (loginId.length != 11)
//    {
//        //  手机号错误提示
//        if (loginId.length == 0)
//        {
//            [self showHint:@"请输入手机号" errorImage:APP_Image_WorkError];
//        }
//        else
//        {
//            [self showHint:@"请输入正确的手机号" errorImage:APP_Image_WorkError];
//        }
//        [_nameTF becomeFirstResponder];
//        return;
//    }
//    // 密码错误提示
//    if (pwd.length == 0)
//    {
//        [self showHint:@"请输入密码" errorImage:APP_Image_WorkError];
//        [_pwdTF becomeFirstResponder];
//        return;
//    }
//    //将用户输入的信息保存起来
//    [USER_DEFAULT setValue:loginId forKey:DEFAULT_LoginId];
//    [USER_DEFAULT setValue:pwd forKey:DEFAULT_Pwd];
//
//    NSString *md5Pwd = [Public getMd5_32Bit:pwd];
//    NSDictionary *bodyDic = @{@"uid":loginId,
//                              @"pwd":md5Pwd,
//                              @"rid":@"patient",
//                              @"forAccessToken":[NSNumber numberWithBool:true]};
//
//    [self uploadLogin:bodyDic];
//}
//
//#pragma mark 上传登录信息
//
///**
// 上传用户登录信息,如果返回结果中携带,患者信息则直接使用,如果没有则调用另一接口请求患者信息
//
// @param body 请求体
// */
//-(void)uploadLogin:(NSDictionary*)body
//{
//    CommandReq *req = [[CommandReq alloc] init];
//    req.bodyDic = body;
//    [self showHudInView:self.view hint:@"登录中..."];
//    [InterfaceManager loginWithParams:req onResponseBlock:^(id object) {
//        NSInteger code = [[object objectForKey:@"code"] integerValue];
//        if (code == COMMAND_CODE_SUCCESS) {
//            //保存token
//            NSString *token = [[object objectForKey:@"properties"] objectForKey:@"accessToken"];
//            if ([Public isNotBlankString:token])
//            {
//                [USER_DEFAULT setValue:token forKey:DEFAULT_AccessToken];
//            }
//            NSDictionary *dic = [object objectForKey:@"body"];
//
//            if (object[@"body"][@"properties"][@"patient"])
//            {
//                [self saveDataWithDic:dic];
//                AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//                [appdelegate changeRootViewcontroller];
//            }
//            else
//            {
//                [self downLoadPatientData];
//            }
//        }
//        else if (code == COMMAND_CODE_NOUSER)
//        {
//            //  没有此用户
//            [self showHint:@"系统中没有找到该用户，请输入正确的手机号"];
//        }
//        else if(code == COMMAND_CODE_PWDFAIL)
//        {
//            //  密码错误
//            [self showHint:@"密码错误"];
//        }
//        else if (code == COMMAND_CODE_SERVERMSG)
//        {
//            [self showHint:object[@"msg"]];
//        }
//        else
//        {
//            //  非200指令
//            [self showHint:APP_Text_SystemFailure];
//        }
//        [self hideHud];
//    } onError:^(NSError *error) {
//        [self hideHud];
//        [self showHint:APP_Text_NoNetwork];
//    }];
//
//
//}
//
//#pragma mark 根据手机号得到用户的患者信息
//-(void)downLoadPatientData
//{
//    CommandReq *req = [[CommandReq alloc] init];
//    req.serviceId = @"eh.unLoginSevice";
//    req.method = @"createPatientForRegisteredUser";
//    NSString *loginId = [USER_DEFAULT objectForKey:DEFAULT_LoginId];
//    req.bodyArray = @[loginId];
//
//    [self showHudInView:self.view hint:@"正在获取用户信息"];
//
//    [InterfaceManager postWithParams:req
//                     onResponseBlock:^(id object)
//    {
//        [self hideHud];
//        NSInteger code = [[object objectForKey:@"code"] integerValue];
//        if (code == COMMAND_CODE_SUCCESS)
//        {
//            [self saveDataWithDic:object[@"body"]];
//            AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//            [appdelegate changeRootViewcontroller];
//        }
//        else
//        {
//            [self showHint:APP_Text_SystemFailure];
//        }
//    }
//                             onError:^(NSError *error)
//     {
//         [self hideHud];
//         [self showHint:APP_Text_NoNetwork];
//
//    }];
//    [self showHudInView:self.view hint:@"登录中..."];
//
//}
//
//#pragma mark  存储用户信息
//- (void)saveDataWithDic:(NSDictionary *)dic
//{
//    //基本信息
//    NSString *uid = [dic objectForKey:@"id"];
//    NSString *manageUnit = [dic objectForKey:@"manageUnit"];
//    //详细信息
//    NSDictionary *patientDic = [[dic objectForKey:@"properties"] objectForKey:@"patient"];
//    NSString *mpiId = [patientDic objectForKey:@"mpiId"];
//    NSString *patientName = [patientDic objectForKey:@"patientName"];
//    NSString *userName = [patientDic objectForKey:@"patientName"];;
//    NSString *userAvatar = [patientDic objectForKey:@"photo"];
//
//    NSString *patientSex = [patientDic objectForKey:@"patientSex"];
//    NSString *patientType = [patientDic objectForKey:@"patientType"];
//    NSString *patientTypeText = [patientDic objectForKey:@"patientTypeText"];
//
//    NSString *rawIdcard = [patientDic objectForKey:@"rawIdcard"];
//    NSString *mobile = [patientDic objectForKey:@"mobile"];
//    NSString *homeAreaText = [patientDic objectForKey:@"homeAreaText"];
//    NSNumber *homeArea = [patientDic objectForKey:@"homeArea"];
//    NSString *birthday = [patientDic objectForKey:@"birthday"] ;
//    /**
//     *  基本信息
//     */
//    [USER_DEFAULT setValue:uid forKey:DEFAULT_Uid];
//    [USER_DEFAULT setValue:manageUnit forKey:DEFAULT_ManageUnit];
//    [USER_DEFAULT setValue:userName forKey:DEFAULT_UserName];
//    [USER_DEFAULT setValue:userAvatar forKey:DEFAULT_UserHeaderImage];
//
//
//    /**
//     *  详细信息
//     */
//    [USER_DEFAULT setValue:mpiId forKey:DEFAULT_MpiId];
//    [USER_DEFAULT setValue:patientName forKey:DEFAULT_PatientName];
//    [USER_DEFAULT setValue:patientSex forKey:DEFAULT_PatientSex];
//    [USER_DEFAULT setValue:patientType forKey:DEFAULT_PatientType];
//    [USER_DEFAULT setValue:patientTypeText forKey:DEFAULT_PatientTypeText];
//
//    [USER_DEFAULT setValue:rawIdcard forKey:DEFAULT_PatientIdCard];
//    [USER_DEFAULT setValue:mobile forKey:DEFAULT_Mobile];
//
//    [USER_DEFAULT setValue:homeArea forKey:DEFAULT_PatientAddress];
//    [USER_DEFAULT setValue:homeAreaText forKey:DEFAULT_PatientAddressText];
//
//
//    [USER_DEFAULT setValue:birthday forKey:DEFAULT_Patient];
//
//    [USER_DEFAULT setValue:patientDic forKey:DEFAULT_Patient];
//    [USER_DEFAULT setValue:birthday forKey:DEFAULT_Birthday];
//
//    //默认定位
//
//
//
//    if (![Public isNotBlankString:homeAreaText] || ![Public isNotBlankString:homeArea])
//    {
//        CurrentArea *model = [[CurrentArea alloc] init];
//        [model readLocationInfo];
//
//        NSString *text = [NSString stringWithFormat:@"%@ %@",model.provinceName,model.cityName];
//
//        [USER_DEFAULT setValue:model.cityCode forKey:DEFAULT_PatientAddress];
//        [USER_DEFAULT setValue:text forKey:DEFAULT_PatientAddressText];
//    }
//
//}
//
//
///**
// *  忘记密码
// */
//- (IBAction)clickForgetBtn:(id)sender
//{
//    RegisterViewController *forgetPwdVc = [[RegisterViewController alloc] init];
//
//    forgetPwdVc.type = forgetPwdViewController;
//
//    [self.navigationController pushViewController:forgetPwdVc animated:YES];
//
//}
//
//
///**
// *  注册
// */
//- (IBAction)clickRegisterBtn:(id)sender {
//
//    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
//
//    registerVC.type = registerViewController;
//
//    [self.navigationController pushViewController:registerVC animated:YES];
//}
//
//- (void)loginNotification:(NSNotification *)noti
//{
//    NSString *loginId = [USER_DEFAULT objectForKey:DEFAULT_LoginId];
//    NSString *pwd = [USER_DEFAULT objectForKey:DEFAULT_Pwd];
//
//    //更改登陆账号和密码的显示
//    _nameTF.text = loginId;
//    _pwdTF.text = pwd;
//
//
//    NSString *md5Pwd = [Public getMd5_32Bit:pwd];
//    NSDictionary *bodyDic = @{@"uid":loginId,
//                              @"pwd":md5Pwd,
//                              @"rid":@"patient",
//                              @"forAccessToken":[NSNumber numberWithBool:true]};
//
//    [self uploadLogin:bodyDic]; //d2d5db
//
//}
//
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    //判断是否恒等变换 CGAffineTransformIsIdentity(self.view.transform) 就是判断是否不变
//    if (CGAffineTransformIsIdentity(self.view.transform) == YES) {
//        self.view.transform = CGAffineTransformTranslate(self.view.transform, 0, -50);
//    }
//    return YES;
//}
//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//
//    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//
//    NSInteger length = textField == _nameTF ? 11 : 16;
//
//    if (toBeString.length > length){
//        textField.text = [toBeString substringToIndex:length];
//        return NO;
//
//    }
//    return YES;
//}
//
//
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    if (CGAffineTransformIsIdentity(self.view.transform) == NO) {
//            self.view.transform = CGAffineTransformIdentity;
//    }
//    [_nameTF resignFirstResponder];
//    [_pwdTF resignFirstResponder];
//}
//
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//
//    if (CGAffineTransformIsIdentity(self.view.transform) == NO) {
//        self.view.transform = CGAffineTransformIdentity;
//    }
//    [_nameTF resignFirstResponder];
//    [_pwdTF resignFirstResponder];
//
//}
//
//- (void)dealloc
//{
//    [NS_NOTIFICATION_CENTER removeObserver:self name:kNotificationLogin object:nil];
//}



@end
