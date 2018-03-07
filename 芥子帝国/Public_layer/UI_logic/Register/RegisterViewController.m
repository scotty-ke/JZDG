//
//  RegisterViewController.m
//  NagriHealth
//
//  Created by 纳里健康 on 16/8/23.
//  Copyright © 2016年 丁东. All rights reserved.
//

#import "RegisterViewController.h"
//#import "SetupPwdViewController.h"
//#import "PerfectDataViewController.h"
//#import "UIViewController+Judge.h"
//#import "DDWebViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *verifyTF;
@property (weak, nonatomic) IBOutlet UILabel *AgreementLabel;
@property (weak, nonatomic) IBOutlet UIButton *verifyBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation RegisterViewController
{
    NSTimer *_verifyTimer;
    
    int second;
    
    NSString *_serviceCode;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    [self setupUI];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = NO;
//}
//
//
//- (void)setupUI
//{
//    _nameTF.delegate = self;
//    _verifyTF.delegate = self;
//
//    [_verifyBtn setCornerFrame];
//    [_verifyBtn setBackgroundColor:GRAY_UN_SELECTED];
//    _verifyBtn.showsTouchWhenHighlighted = YES;
//
//    [_nextBtn setCornerFrame];
//    _nextBtn.enabled = NO;
//    [_nextBtn setBackgroundColor:GRAY_UN_SELECTED];
//    _nextBtn.showsTouchWhenHighlighted = YES;
//
//
//    _AgreementLabel.font = TEXT_FONT_12;
//    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"注册即表示同意 纳里健康平台服务协议"];
//    [attStr addAttributes:@{NSForegroundColorAttributeName :  TOPCAIL_COLOR} range:NSMakeRange(8, 10)];
//    _AgreementLabel.attributedText = attStr;
//    _AgreementLabel.userInteractionEnabled = YES;
//
//    if(self.type == registerViewController)
//    {
//        _AgreementLabel.hidden = NO;
//
//        self.titleLabel.text = @"请填写注册手机号并进行验证";
//
//        self.title = @"注册";
//
//    }else
//    {
//        _AgreementLabel.hidden = YES;
//
//        self.titleLabel.text = @"请填写重置手机号并进行验证";
//
//        self.title = @"忘记密码";
//    }
//
//    [_nameTF addTarget:self
//                action:@selector(textFieldTextChange:)
//      forControlEvents:UIControlEventEditingChanged];
//    [_verifyTF addTarget:self action:@selector(verifyFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
//
//
//    UITapGestureRecognizer *agreementTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAgreement:)];
//    [_AgreementLabel addGestureRecognizer:agreementTap];
//
//}
//
//#pragma mark - 验证码编辑事件
//- (void)verifyFieldTextChange:(UITextField *)textField
//{
//    if(_verifyTF.text.length >=4){
//        _verifyTF.text = [_verifyTF.text substringToIndex:4];
//    }
//
//    if(_nameTF.text.length > 0 && _verifyTF.text.length > 0)
//    {
//        _nextBtn.enabled = YES;
//        [_nextBtn setBackgroundColor:TOPCAIL_COLOR];
//    }
//
//}
//
//-(void)textFieldTextChange:(UITextField*)textField
//{
//    UITextRange *selectedRange = [textField markedTextRange];
//    //获取高亮部分
//    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
//    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
//    if (!position)
//    {
//
//        if (_nameTF.text.length >= 11) {
//            _nameTF.text = [_nameTF.text substringToIndex:11];
//            if (_verifyBtn.userInteractionEnabled) {
//                _verifyBtn.enabled = YES;
//                [_verifyBtn setBackgroundColor:TOPCAIL_COLOR];
//            }
//        }else{
//            _verifyBtn.enabled = NO;
//            [_verifyBtn setBackgroundColor:GRAY_UN_SELECTED];
//        }
//    }
//
//}
//
//
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    if (CGAffineTransformIsIdentity(self.view.transform) == NO) {
//        self.view.transform = CGAffineTransformIdentity;
//    }
//    [_nameTF resignFirstResponder];
//    [_verifyTF resignFirstResponder];
//}
//
//
//
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    if(textField == _verifyTF)
//    {
//        if (CGAffineTransformIsIdentity(self.view.transform) == YES) {
//            self.view.transform = CGAffineTransformTranslate(self.view.transform, 0, -80);
//        }
//
//        return YES;
//    }
//
//    return YES;
//}
//
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
//{
//    if (CGAffineTransformIsIdentity(self.view.transform) == NO) {
//        self.view.transform =CGAffineTransformTranslate(self.view.transform, 0, 0);
//    }
//
//    return YES;
//}
//
//
//#pragma mark - 查看协议
//- (void)clickAgreement:(UIGestureRecognizer *)res
//{
//    NSLog(@"-------- 查看协议");
//
//    DDWebViewController *webView = [[DDWebViewController alloc] init];
//
//    webView.url = [NSURL URLWithString:@"http://ehealth.easygroup.net.cn/ehealth-base/upload/15967"];
//
//    webView.title = @"纳里健康平台服务协议";
//
//    [self.navigationController pushViewController:webView animated:YES];
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//
//    if (CGAffineTransformIsIdentity(self.view.transform) == NO) {
////        self.view.transform = CGAffineTransformIdentity;
//        self.view.transform =CGAffineTransformTranslate(self.view.transform, 0, 0);
//    }
//    [_nameTF resignFirstResponder];
//    [_verifyTF resignFirstResponder];
//
//}
//
//
//
////- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
////{
////    self.view.transform = CGAffineTransformIdentity;
////    [_nameTF resignFirstResponder];
////    [_verifyTF resignFirstResponder];
////}
//
//
//#pragma mark -- 获取验证码
//- (IBAction)getVerifyAction:(id)sender {
//
//    NSString *mobile = _nameTF.text;
//    if (![Public isNotBlankString:mobile]) {
//        [self showHint:@"请填写手机号" errorImage:APP_Image_WorkError];
//        return;
//    }
//    if (mobile.length != 11) {
//        [self showHint:@"手机号格式错误" errorImage:APP_Image_WorkError];
//        return;
//    }
//
//    if([self isMobile:mobile])
//    {
//        [_verifyTF becomeFirstResponder];
//
//        if (CGAffineTransformIsIdentity(self.view.transform) == YES) {
//            self.view.transform = CGAffineTransformTranslate(self.view.transform, 0, -80);
//        }
//
//        [self setVerifybtnStatus:2];
//
//        second = 60;
//
//        _verifyTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateVerify:) userInfo:nil repeats:YES];
//
//        [self sendRegisterCode];
//    }
//
//}
//
//- (void)setVerifybtnStatus:(NSInteger)status
//{
//    if (status == 1) {
//        _verifyBtn.enabled = YES;
//        _verifyBtn.userInteractionEnabled = YES;
//        [_verifyBtn setBackgroundColor:TOPCAIL_COLOR];
//        [_verifyBtn setTitle:@"重新发送" forState:UIControlStateNormal];
//    }else{
//        _verifyBtn.enabled = NO;
//        _verifyBtn.userInteractionEnabled = NO;
//        [_verifyBtn setBackgroundColor:GRAY_UN_SELECTED];
//    }
//}
//
///**
// *  获取验证码 网络请求
// */
//- (void)sendRegisterCode
//{
//
//    CommandReq *req = [[CommandReq alloc] init];
//
//    if(self.type == registerViewController)
//    {
//        req.serviceId = @"eh.unLoginSevice";
//
//        req.method = @"sendVCodeForNotRegisterPatient";
//
//        req.bodyArray = @[_nameTF.text];
//
//    }else
//    {
//        req.serviceId = @"eh.validateCode";
//
//        req.method = @"sendValidateCode";
//
//        req.bodyArray = @[_nameTF.text,@"patient"];
//
//    }
//
//    [InterfaceManager postWithParams:req onResponseBlock:^(id object) {
//
//        NSInteger code = [[object objectForKey:@"code"] integerValue];
//
//        if (code == COMMAND_CODE_SUCCESS)
//        {
//
//            [self showHint:@"验证码已成功发送"];
//            _serviceCode = [object objectForKey:@"body"];
//        }else if(code == COMMAND_CODE_NOREGIST)
//        {
//            [self showHint:object[@"msg"]];
//            [_verifyTimer invalidate];
//            [self setVerifybtnStatus:1];
//        }else{
//            [self showHint:@"验证码发送失败" errorImage:APP_Image_WorkError];
//            [_verifyTimer invalidate];
//            [self setVerifybtnStatus:1];
//        }
//
//    } onError:^(NSError *error) {
//
//    }];
//
//
//}
//
//#pragma mark  更新验证码BTN
//- (void)updateVerify:(NSTimer *)timer
//{
//    second--;
//    if (second == 0) {
//        [timer invalidate];
//        [self setVerifybtnStatus:1];
//    }else{
//        _verifyBtn.enabled = NO;
//        [_verifyBtn setTitle:[NSString stringWithFormat:@"(%ds)",second] forState:UIControlStateNormal];
//    }
//}
//
//
//#pragma mark -- 下一步
//- (IBAction)clickNext:(id)sender {
//
//    if([self.verifyTF.text isEqualToString:_serviceCode])
//    {
//        if(self.type == registerViewController)
//        {
//            PerfectDataViewController *organizingDataVC = [[PerfectDataViewController alloc] init];
//
//            organizingDataVC.codeString = self.verifyTF.text;
//
//            organizingDataVC.mobilString = self.nameTF.text;
//
//            [self.navigationController pushViewController:organizingDataVC animated:YES];
//
//        }else if(self.type == forgetPwdViewController)
//        {
//            SetupPwdViewController *setupPwd = [[SetupPwdViewController alloc] init];
//
//            setupPwd.code = self.verifyTF.text;
//
//            setupPwd.mobile = self.nameTF.text;
//
//            [self.navigationController pushViewController:setupPwd animated:YES];
//        }
//
//    }else
//    {
//        [self showHint:@"验证码不正确，请重新输入"];
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
