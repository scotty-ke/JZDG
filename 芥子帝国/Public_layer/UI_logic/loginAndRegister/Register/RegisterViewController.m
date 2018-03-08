//
//  RegisterViewController.m
//  芥子帝国
//
//  Created by 纳里健康 on 2018/3/8.
//  Copyright © 2018年 songK. All rights reserved.
//

#import "RegisterViewController.h"
//#import "SetupPwdViewController.h"
//#import "PerfectDataViewController.h"
//#import "UIViewController+Judge.h"
#import "DDWebViewController.h"
#import "UIViewController+Judge.h"
#import "ZHPickView.h"

@interface RegisterViewController ()<UITextFieldDelegate,ZHPickViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *verifyTF;
@property (weak, nonatomic) IBOutlet UIButton *verifyBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (strong, nonatomic) IBOutlet UITextField *pwdTF;
@property (strong, nonatomic) IBOutlet UITextField *rePwdTF;
@property (weak, nonatomic) IBOutlet UITextField *adressTF;
@property (weak, nonatomic) IBOutlet UILabel *agreementLabel;

@end

@implementation RegisterViewController
{
    NSTimer *_verifyTimer;
    
    int second;
    
    NSString *_serviceCode;
    
    ZHPickView *_adressPicker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}


- (void)setupUI
{
    self.title = @"注册";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _nameTF.delegate = self;
    _verifyTF.delegate = self;
    _pwdTF.delegate = self;
    _rePwdTF.delegate = self;
    
    _verifyBtn.showsTouchWhenHighlighted = YES;
    _nextBtn.showsTouchWhenHighlighted = YES;
    _nextBtn.backgroundColor = TOPCAIL_COLOR;
    
    //协议label
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:@"注册即代表您同意《用户协议》"];
    [attributeStr addAttributes:@{NSForegroundColorAttributeName:TOPCAIL_COLOR} range:NSMakeRange(8, 6)];
    _agreementLabel.attributedText = attributeStr;
    _agreementLabel.userInteractionEnabled = YES;

    UITapGestureRecognizer *agreementTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAgreement:)];
    [_agreementLabel addGestureRecognizer:agreementTap];
    
    //倒计时按钮边框
    _verifyBtn.layer.borderWidth = 1.0f;
    _verifyBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _verifyBtn.layer.cornerRadius = 5.0f;
    _verifyBtn.layer.masksToBounds = YES;
    
}

#pragma mark - 查看协议
- (void)clickAgreement:(UIGestureRecognizer *)res
{
    NSLog(@"-------- 查看协议");
    
    DDWebViewController *webView = [[DDWebViewController alloc] init];
    
    webView.url = [NSURL URLWithString:@""];
    
    webView.title = @"";
    
    [self.navigationController pushViewController:webView animated:YES];
}


#pragma mark testFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSInteger length;

    if(textField == _pwdTF || textField == _rePwdTF)
    {
        length = 12;
    }else if (textField == _nameTF)
    {
        length = 11;
    }else if(textField == _verifyTF)
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



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self.view endEditing:YES];
}

#pragma mark -- 获取验证码
- (IBAction)getVerifyAction:(id)sender {

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
        [_verifyTF becomeFirstResponder];

        [self setVerifybtnStatus:2];

        second = 60;

        _verifyTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateVerify:) userInfo:nil repeats:YES];

        [self sendRegisterCode];
    }
}
- (void)setVerifybtnStatus:(NSInteger)status
{
    if (status == 1) {
        _verifyBtn.enabled = YES;
        _verifyBtn.userInteractionEnabled = YES;
        [_verifyBtn setTitle:@"重新发送" forState:UIControlStateNormal];
    }else{
        _verifyBtn.enabled = NO;
        _verifyBtn.userInteractionEnabled = NO;
    }
}

/**
 *  获取验证码 网络请求
 */
- (void)sendRegisterCode
{

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
        [_verifyBtn setTitle:[NSString stringWithFormat:@"(%ds)",second] forState:UIControlStateNormal];
    }
}


#pragma mark -- 下一步
- (IBAction)clickNext:(id)sender {

    if([self.verifyTF.text isEqualToString:_serviceCode])
    {
        
    }
}

#pragma mark 选择地址
- (IBAction)chooseAdressAction:(id)sender {
    //完善地址
    if(_adressPicker == nil)
    {
        _adressPicker = [[ZHPickView alloc] initPickviewWithPlistName:@"area" isHaveNavControler:NO];
        
        _adressPicker.delegate =self;
    }
    
    [_adressPicker show:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
